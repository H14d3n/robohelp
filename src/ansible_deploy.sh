# Ansible Fast Management [AFM]
ansible_deploy() {
    check_installed "ansible" ||  { echo; echo -e "${RED}❌ Ansible is not installed. Install with robohelp -pi ansible-core. Or via pip install ansible${NC}"; echo; exit 1; }

    if ! check_dialog; then
        # Fallback to old menu
        echo
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${CYAN} Welcome to the AFM - Ansible Fast Management${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo
        echo -e "${YELLOW}  [1] Run Playbook (with Flags)${NC}"
        echo -e "${YELLOW}  [2] Test Connection (Ping Hosts)${NC}"
        echo -e "${YELLOW}  [3] Live-Fire Command${NC}"
        echo -e "${YELLOW}  [4] View Inventory${NC}"
        echo -e "${YELLOW}  [5] View Last Run Log${NC}"
        echo -e "${YELLOW}  [6] Exit${NC}"
        echo
        read -r option
    else
        option=$(dialog --backtitle "RoboHelp v$VERSION" \
            --title "🤖 Ansible Fast Management (AFM)" \
            --menu "Choose an option:" 13 60 5 \
            "1" "Run Playbook (with Flags)" \
            "2" "Test Connection (Ping Hosts)" \
            "3" "Live-Fire Command" \
            "4" "View Inventory" \
            "5" "View Last Run Log" \
            2>&1 >/dev/tty)
        dialog_exit=$?
        clear -x
        [ $dialog_exit -ne 0 ] && return 0
    fi

    find_playbook() {
        mapfile -t playbooks < <(find . -type f -name "*.yml")

        if [ ${#playbooks[@]} -eq 0 ]; then
            echo -e "${RED}🛑 No playbook files (.yml) found in current directory.${NC}"
            return 1
        fi

        loop=-1
        for playbook in "${playbooks[@]}"; do
            ((loop++))
            dir_path=$(dirname "$playbook")
            file_name=$(basename "$playbook")
            printf '[%d] %s\n%s\n\n' "$loop" "$dir_path" "$file_name"
        done
        return 0
    }

    view_inventory() {
        local inv
        if [ -f hosts.yml ]; then
            inv="hosts.yml"
        elif ls hosts.* >/dev/null 2>&1; then
            # fallback to any hosts.* file, pick the first
            inv=$(ls hosts.* 2>/dev/null | head -n1)
        else
            echo -e "${RED}🛑 No inventory file found (expected hosts.yml).${NC}"
            return 1
        fi
        echo
        echo -e "${YELLOW}📄 Showing Ansible inventory: $inv${NC}"
        echo
        if [ -n "$PAGER" ]; then
            "$PAGER" "$inv" 2>/dev/null || cat "$inv"
        else
            cat "$inv"
        fi
    }

    log_exists() {
        log_path="$HOME/.log/afmrun.log"
        if [ -f "$log_path" ]; then
            return 0
        else
            mkdir -p "$(dirname "$log_path")"
            touch "$log_path"
        fi
    }

    log_write() {
        case "$1" in
        "scs")
            echo "$timestamp - Successfully ran playbook: ${playbooks[$selected_index]}" >> "$log_path"
            ;;
        "ping")
            echo "$timestamp - Ping ran successfully" >> "$log_path"
            ;;
        "fail")
            echo "$timestamp - Running playbook: ${playbooks[$selected_index]} failed" >> "$log_path"
            ;;
        "pingfail")
            echo "$timestamp - Running Ping with inventory file failed" >> "$log_path"
            ;;
        esac
    }

    log_actions() {
        log_exists && log_write "$1"
    }


    run_ping() {
        if ansible all -i hosts.* -m ping; then
            log_actions "ping"
        else
            log_actions "pingfail"
        fi
    }

    run_playbook() {
        if command -v dialog &>/dev/null; then
            # Build dialog menu items
            menu_items=()
            loop=0
            for playbook in "${playbooks[@]}"; do
                file_name=$(basename "$playbook")
                dir_path=$(dirname "$playbook")
                menu_items+=("$loop" "$dir_path/$file_name")
                ((loop++))
            done
            
            selected_index=$(dialog --backtitle "RoboHelp v$VERSION" \
                --title "📋 Select Playbook" \
                --menu "Choose a playbook to run:" 20 70 12 \
                "${menu_items[@]}" \
                2>&1 >/dev/tty)
            
            dialog_exit=$?
            clear -x
            [ $dialog_exit -ne 0 ] && return 0

            # Ask for additional flags
            additional_flags=$(dialog --backtitle "RoboHelp v$VERSION" \
                --title "Additional Flags" \
                --inputbox "Enter additional flags (e.g. remove) or leave empty:" 10 60 \
                2>&1 >/dev/tty)
            
            dialog_exit=$?
            clear -x
            [ $dialog_exit -ne 0 ] && return 0
                
        else
            echo -e "${CYAN} Which playbook would you like to run? [e.g. 1 remove]${NC}"
            echo -e "${CYAN}<─────────────────────────────────────────────────────>${NC}"
            read -r selected_index additional_flags
            echo
        fi

        if ! [[ "$selected_index" =~ ^[0-9]+$ ]] || [ "$selected_index" -ge "${#playbooks[@]}" ]; then
            echo -e "${RED} Invalid playbook selection.${NC}"
            return 1
        fi

        if command -v dialog &>/dev/null; then
            dialog --backtitle "RoboHelp v$VERSION" \
                --title "Ansible Vault" \
                --yesno "Do you use Ansible Vault?" 7 40
            vault_choice=$?
            clear -x
            
            if [ $vault_choice -eq 0 ]; then
                vault_flag="--ask-vault-pass"
            else
                vault_flag="--ask-become-pass"
            fi
        else
            echo -e "${CYAN} Do you use Ansible Vault? [Yes | No]${NC}"
            echo -e "${CYAN}<────────────────────────────────────>${NC}"
            read -r ansible_vault_val
            echo

            case "${ansible_vault_val,,}" in
                yes)
                    vault_flag="--ask-vault-pass"
                    ;;
                no)
                    vault_flag="--ask-become-pass"
                    ;;
                *)
                    echo -e "${RED}Invalid input - Please answer Yes or No${NC}"
                    return 1
                    ;;
            esac
        fi

        playbook="$(basename "${playbooks[$selected_index]}")"
        extra_vars=()

        # Only set extra_vars if flags are non-empty
        if [ -n "$additional_flags" ];  then
            extra_vars=(--extra-vars "action=$additional_flags")
        fi

        echo -e "${CYAN}🚀 Running playbook: $playbook${NC}"
        echo -e "${CYAN}🚩 Flags: ${vault_flag} ${extra_vars[*]}${NC}"
        echo
        echo -e "${YELLOW}🛑 5 seconds to stop process...${NC}"
        echo

        sleep 5

        if ansible-playbook -i hosts.yml "$playbook" "${extra_vars[@]}" $vault_flag -v; then
            log_actions "scs"
        else
            log_actions "fail"
        fi
    }

    playbook_actions() {
        if ! find_playbook; then
            return 1
        fi

        if [ "$1" = "run" ]; then
            run_playbook
        fi
    }

    live_fire() {
        if command -v dialog &>/dev/null; then
            live_fire_command=$(dialog --backtitle "RoboHelp v$VERSION" \
                --title "Live-Fire Command" \
                --inputbox "Which command would you like to Live-Fire?" 10 60 \
                2>&1 >/dev/tty)
            dialog_exit=$?
            clear -x    
            [ $dialog_exit -ne 0 ] && return 0
        else
            echo
            echo -e "${CYAN} Which Command would you like to Live-Fire?${NC}"
            echo -e "${CYAN}<──────────────────────────────────────────>${NC}"
            read -r live_fire_command
            echo
        fi

        if command -v dialog &>/dev/null; then
            live_fire_target=$(dialog --backtitle "RoboHelp v$VERSION" \
                --title "Target Hosts" \
                --menu "Which hosts should be targeted?" 11 60 2 \
                "1" "All" \
                "2" "Write Own (Single host or host groups)" \
                2>&1 >/dev/tty)
            dialog_exit=$?
            clear -x
            [ $dialog_exit -ne 0 ] && return 0
        else
            echo -e "${CYAN} Which hosts should be targeted?${NC}"
            echo -e "${CYAN}<───────────────────────────────────>${NC}"
            echo -e "${YELLOW}> [1] All${NC}"
            echo -e "${YELLOW}> [2] Write Own (Single host or host groups)${NC}"
            echo
            read -r live_fire_target
        fi

        case "${live_fire_target}" in
            1)
                ansible -i hosts.yml all -m shell -a "${live_fire_command}"
                ;;
            2)
                if command -v dialog &>/dev/null; then
                    custom_target=$(dialog --backtitle "RoboHelp v$VERSION" \
                        --title "Custom Target" \
                        --inputbox "Enter host or group (e.g. webservers, nagios):" 10 60 \
                        2>&1 >/dev/tty)
                    dialog_exit=$?
                    clear -x    
                    [ $dialog_exit -ne 0 ] && return 0
                else
                    echo -e "${CYAN} Enter host or group (e.g. webservers, nagios):${NC}"
                    echo -e "${CYAN}<──────────────────────────────────────────────>${NC}"
                    echo
                    read -r custom_target
                fi
            ansible -i hosts.yml "${custom_target}" -m shell -a "${live_fire_command}"
            ;;
        *)
            echo -e "${RED}Invalid option selected. Aborting.${NC}"
            ;;
        esac
    }

    if printf -- '%d' "${option}" > /dev/null 2>&1; then
	    case "${option}" in
	        1)
	    	    playbook_actions "run"
	    	    ;;
	        2)
	    	    run_ping
	    	    ;;
	        3)
	    	    live_fire
                ;;
	        4)
    	        view_inventory
	            ;;
	        5)
                log_file="$HOME/.log/afmrun.log"

	    	    if [ -f "$log_file" ]; then
	    	        echo
	    	        echo -e "${YELLOW}📄 Showing Ansible log: $log_file.${NC}"
	    	        echo
	    	        tail -n 50 "$log_file"
                else
                    echo -e "${RED}🛑 No Ansible log found at $log_file.${NC}"
                fi
                ;;
	        6)
	    	    exit 0
                ;;
	        *)
	    	    echo "Unsupported option"
	    	    ;;
	    esac
    else
	    echo "Unsupported option"
    fi
}

