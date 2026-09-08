ssh_check_prereqs() {
    if ! check_installed "ssh" || ! check_installed "ssh-keygen"; then
        echo
        echo -e "${RED}❌ SSH or ssh-keygen is not installed. Install with robohelp -pi openssh-client${NC}"
        echo
        return 1
    fi
}

ssh_ask_use_previous() {
    if command -v dialog &>/dev/null; then
        dialog --backtitle "RoboHelp v$VERSION" \
            --title "SSH Connection" \
            --yesno "Do you want to use a previously used command?" 7 50
        use_previous=$?
    else
        write_subheader " Do you want to use a previously used Command?"
        echo -e "${YELLOW}> [1] Yes${NC}"
        echo -e "${YELLOW}> [2] No${NC}"
        echo
        read -r use_previous_input
        echo
        [ "$use_previous_input" = "1" ] && use_previous=0 || use_previous=1
    fi
}

ssh_load_history_commands() {
    if [ ! -f ~/.ssh/.robohelp_lsc.txt ]; then
        return 1
    fi

    mapfile -t ssh_commands < ~/.ssh/.robohelp_lsc.txt

    [ ${#ssh_commands[@]} -gt 0 ]
}

ssh_pick_history_command() {
    local prompt_title="$1"; shift
    local indices=("$@")
    local i selected_index valid=0
    chosen_command_index=""
    chosen_command_cancelled=0

    if command -v dialog &>/dev/null; then
        local menu_items=()
        for i in "${indices[@]}"; do
            menu_items+=("$i" "ssh ${ssh_commands[$i]}")
        done

        selected_index=$(dialog --backtitle "RoboHelp v$VERSION" \
            --title "🔐 Select SSH Command" \
            --menu "$prompt_title" 20 70 12 \
            "${menu_items[@]}" \
            2>&1 >/dev/tty)

        local dialog_exit=$?
        clear -x
        if [ $dialog_exit -ne 0 ]; then
            chosen_command_cancelled=1
            return
        fi
    else
        write_subheader " Available SSH commands:" "$CYAN" "──────────────────────"
        echo

        for i in "${indices[@]}"; do
            printf '[%d] ssh %s\n\n' "$i" "${ssh_commands[$i]}"
        done

        write_subheader " Which SSH command would you like to use? [e.g. ${indices[0]}]"
        read -r selected_index
        echo
    fi

    for i in "${indices[@]}"; do
        [ "$i" = "$selected_index" ] && valid=1 && break
    done

    if [ "$valid" -eq 1 ]; then
        chosen_command_index="$selected_index"
    else
        echo -e "${RED}Invalid SSH command selection.${NC}"
    fi
}

ssh_connect_previous() {
    if ! ssh_load_history_commands; then
        echo -e "${YELLOW}⚠️  No previous SSH commands found.${NC}"
        echo -e "${YELLOW}Falling back to manual entry...${NC}"
        echo
        return 1
    fi

    local i indices=()
    for i in "${!ssh_commands[@]}"; do indices+=("$i"); done

    ssh_pick_history_command "Choose a previous SSH connection:" "${indices[@]}"
    [ "$chosen_command_cancelled" = "1" ] && return 0
    [ -z "$chosen_command_index" ] && return 1

    local selected_command="${ssh_commands[$chosen_command_index]}"
    echo -e "${CYAN}Reusing command: ssh ${selected_command}${NC}"
    echo
    ssh ${selected_command}
    return 0
}

ssh_connect_by_search() {
    local search_term="$1"

    ssh_check_prereqs || return 1

    if [ -z "$search_term" ]; then
        echo -e "${RED}❌ No search term provided.${NC}"
        return 1
    fi

    if ! ssh_load_history_commands; then
        echo -e "${RED}❌ No previous SSH commands found. Connect once via 'robohelp -ssh' to build up history.${NC}"
        return 1
    fi

    local i matched_indices=()
    for i in "${!ssh_commands[@]}"; do
        [[ "${ssh_commands[$i]}" == *"$search_term"* ]] && matched_indices+=("$i")
    done

    if [ ${#matched_indices[@]} -eq 0 ]; then
        echo -e "${RED}❌ No previously used SSH command matching '${search_term}' found.${NC}"
        return 1
    fi

    local chosen_index
    if [ ${#matched_indices[@]} -eq 1 ]; then
        chosen_index="${matched_indices[0]}"
    else
        ssh_pick_history_command "Multiple hosts match '${search_term}', choose one:" "${matched_indices[@]}"
        [ "$chosen_command_cancelled" = "1" ] && return 0
        [ -z "$chosen_command_index" ] && return 1
        chosen_index="$chosen_command_index"
    fi

    local selected_command="${ssh_commands[$chosen_index]}"
    echo -e "${CYAN}Reusing command: ssh ${selected_command}${NC}"
    echo
    ssh ${selected_command}
    return 0
}

ssh_connect_manual() {
    local ssh_input ssh_user ssh_host ssh_port

    if command -v dialog &>/dev/null; then
        ssh_input=$(dialog --backtitle "RoboHelp v$VERSION" \
            --title "SSH Connection" \
            --inputbox "Enter username, host and port (e.g. user host 22):" 10 60 \
            2>&1 >/dev/tty)

        local dialog_exit=$?
        clear -x
        [ $dialog_exit -ne 0 ] && return 0
        read -r ssh_user ssh_host ssh_port <<< "$ssh_input"
    else
        write_subheader " Enter username, host and port (e.g. user host 22)"
        echo
        read -r "ssh_user" "ssh_host" "ssh_port"
    fi

    mkdir -p ~/.ssh
    local ssh_command="${ssh_user}@${ssh_host} -p ${ssh_port:-22}"

    if ssh "${ssh_user}@${ssh_host}" -p "${ssh_port:-22}"; then
        if ! grep -Fxq "$ssh_command" ~/.ssh/.robohelp_lsc.txt; then
            echo "$ssh_command" >> ~/.ssh/.robohelp_lsc.txt
        fi
    fi
}

ssh_establish_connection() {
    ssh_ask_use_previous

    if [ "${use_previous}" = "0" ] && ssh_connect_previous; then
        return 0
    fi

    ssh_connect_manual
}

ssh_generate_keypair() {
    write_subheader " ⚙️  Generating SSH Key Pair..." "$CYAN" "───────────────────────────────"
    if [ -f ~/.ssh/id_rsa ]; then
        echo
        echo -e "${YELLOW}⚠️  SSH key already exists at ~/.ssh/id_rsa. Showing public key:${NC}"
        cat ~/.ssh/id_rsa.pub
    else
        ssh-keygen -t rsa -b 4096

        echo -e "${GREEN}✅ SSH Key Pair generated successfully!${NC}"
        echo -e "${CYAN} Public- and Private Key located at ~/.ssh/ ${NC}"
    fi
}

ssh_copy_key() {
    local ssh_input ssh_user ssh_host ssh_port

    if command -v dialog &>/dev/null; then
        ssh_input=$(dialog --backtitle "RoboHelp v$VERSION" \
            --title "Copy SSH Key" \
            --inputbox "Enter username, host and port (e.g. user host 22):" 10 60 \
            2>&1 >/dev/tty)
        local dialog_exit=$?
        clear -x
        [ $dialog_exit -ne 0 ] && return 0
        read -r ssh_user ssh_host ssh_port <<< "$ssh_input"
    else
        write_subheader " Enter username, host and port to copy key to (e.g. user host 22):" "$CYAN" "─────────────────────────────────────────────────────────────────"
        echo
        read -r ssh_user ssh_host ssh_port
    fi

    ssh-copy-id -p "${ssh_port:-22}" "${ssh_user}@${ssh_host}"
}

ssh_edit_config_file() {
    echo -e "${CYAN} Opening SSH config file...${NC}"

    ${EDITOR:-nano} ~/.ssh/config
}

ssh_config() {
    ssh_check_prereqs || return 1

    if ! check_dialog; then
        # Fallback to old menu
        echo
        write_header " 🔐 Setting up SSH configuration..."
        echo
        echo -e "${YELLOW}  [1] Establish SSH connection${NC}"
        echo -e "${YELLOW}  [2] Generate SSH Key Pair${NC}"
        echo -e "${YELLOW}  [3] Copy SSH Key to Remote Host${NC}"
        echo -e "${YELLOW}  [4] Edit SSH Config File${NC}"
        echo -e "${YELLOW}  [5] Exit${NC}"
        echo
        read -r ssh_option
        echo
    else
        ssh_option=$(dialog --backtitle "RoboHelp v$VERSION" \
            --title "🔐 SSH Configuration" \
            --menu "Choose an option:" 12 60 4 \
            "1" "Establish SSH connection" \
            "2" "Generate SSH Key Pair" \
            "3" "Copy SSH Key to Remote Host" \
            "4" "Edit SSH Config File" \
            2>&1 >/dev/tty)
        dialog_exit=$?
        clear -x
        [ $dialog_exit -ne 0 ] && return 0
    fi

    case "${ssh_option}" in
        1)
            ssh_establish_connection
            return 0
            ;;
        2)
            ssh_generate_keypair
            ;;
        3)
            ssh_copy_key
            ;;
        4)
            ssh_edit_config_file
            ;;
        5)
            return 0
            ;;
        *)
            echo -e "${RED}Invalid option selected.${NC}"
            ;;
    esac
}
