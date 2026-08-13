ssh_config() {
    if ! check_installed "ssh" || ! check_installed "ssh-keygen"; then
        echo
        echo -e "${RED}❌ SSH or ssh-keygen is not installed. Install with robohelp -pi openssh-client${NC}"
        echo
        return 1
    fi

    if ! check_dialog; then
        # Fallback to old menu
        echo
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${CYAN} 🔐 Setting up SSH configuration...${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
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
            if command -v dialog &>/dev/null; then
                dialog --backtitle "RoboHelp v$VERSION" \
                    --title "SSH Connection" \
                    --yesno "Do you want to use a previously used command?" 7 50
                use_previous=$?
            else
                echo -e "${CYAN} Do you want to use a previously used Command?${NC}"
                echo -e "${CYAN}<─────────────────────────────────────────────>${NC}"
                echo -e "${YELLOW}> [1] Yes${NC}"
                echo -e "${YELLOW}> [2] No${NC}"
                echo
                read -r use_previous_input
                echo
                [ "$use_previous_input" = "1" ] && use_previous=0 || use_previous=1
            fi

            if [ "${use_previous}" = "0" ]; then
                # Check if commands file exists first
                if [ ! -f ~/.ssh/.robohelp_lsc.txt ]; then
                    echo -e "${RED}⚠️  No previous SSH commands found.${NC}"
                    echo
                    echo -e "${YELLOW}Falling back to manual entry...${NC}"
                    echo
                else
                    # Load commands into array
                    mapfile -t ssh_commands < ~/.ssh/.robohelp_lsc.txt
                    
                    if [ ${#ssh_commands[@]} -eq 0 ]; then
                        echo -e "${YELLOW}⚠️  No SSH commands found in history.${NC}"
                        echo -e "${YELLOW}Falling back to manual entry...${NC}"
                        echo
                    else
                        if command -v dialog &>/dev/null; then
                            # Build dialog menu items
                            menu_items=()
                            loop=0
                            for command in "${ssh_commands[@]}"; do
                                menu_items+=("$loop" "ssh $command")
                                ((loop++))
                            done
                            
                            selected_index=$(dialog --backtitle "RoboHelp v$VERSION" \
                                --title "🔐 Select SSH Command" \
                                --menu "Choose a previous SSH connection:" 20 70 12 \
                                "${menu_items[@]}" \
                                2>&1 >/dev/tty)
                            
                            dialog_exit=$?
                            clear -x
                            [ $dialog_exit -ne 0 ] && return 0
                        else
                            # Print header BEFORE the list
                            echo -e "${CYAN} Available SSH commands:${NC}"
                            echo -e "${CYAN}<──────────────────────>${NC}"
                            echo
                            
                            # Now print the list
                            loop=-1
                            for command in "${ssh_commands[@]}"; do
                                ((loop++))
                                printf '[%d] ssh %s\n\n' "$loop" "$command"
                            done
                            
                            echo -e "${CYAN} Which SSH command would you like to use? [e.g. 0]${NC}"
                            echo -e "${CYAN}<─────────────────────────────────────────────────>${NC}"
                            read -r selected_index
                            echo
                        fi

                        if ! [[ "$selected_index" =~ ^[0-9]+$ ]] || [ "$selected_index" -ge "${#ssh_commands[@]}" ]; then
                            echo -e "${RED}Invalid SSH command selection.${NC}"
                            return 1
                        fi

                        selected_command="${ssh_commands[$selected_index]}"
                        echo -e "${CYAN}Reusing command: ssh ${selected_command}${NC}"
                        echo
                        ssh ${selected_command}
                        return 0
                    fi
                fi
            fi

            if command -v dialog &>/dev/null; then
                ssh_input=$(dialog --backtitle "RoboHelp v$VERSION" \
                    --title "SSH Connection" \
                    --inputbox "Enter username, host and port (e.g. user host 22):" 10 60 \
                    2>&1 >/dev/tty)
                
                dialog_exit=$?
                clear -x
                [ $dialog_exit -ne 0 ] && return 0
                read -r ssh_user ssh_host ssh_port <<< "$ssh_input"
            else
                echo -e "${CYAN} Enter username, host and port (e.g. user host 22)${NC}"
                echo -e "${CYAN}<─────────────────────────────────────────────────>${NC}"
                echo
                read -r "ssh_user" "ssh_host" "ssh_port"
            fi

            mkdir -p ~/.ssh
            ssh_command="${ssh_user}@${ssh_host} -p ${ssh_port:-22}"

            if ssh "${ssh_user}@${ssh_host}" -p "${ssh_port:-22}"; then
                if ! grep -Fxq "$ssh_command" ~/.ssh/.robohelp_lsc.txt; then
                    echo "$ssh_command" >> ~/.ssh/.robohelp_lsc.txt
                fi
            fi
            return 0
            ;;
        2)
            echo -e "${CYAN} ⚙️  Generating SSH Key Pair...${NC}"
            echo -e "${CYAN}<───────────────────────────────>${NC}"
            if [ -f ~/.ssh/id_rsa ]; then
                echo
                echo -e "${YELLOW}⚠️  SSH key already exists at ~/.ssh/id_rsa. Showing public key:${NC}"
                cat ~/.ssh/id_rsa.pub
            else
                ssh-keygen -t rsa -b 4096

                echo -e "${GREEN}✅ SSH Key Pair generated successfully!${NC}"
                echo -e "${CYAN} Public- and Private Key located at ~/.ssh/ ${NC}"
            fi
            ;;
        3)
            if command -v dialog &>/dev/null; then
                ssh_input=$(dialog --backtitle "RoboHelp v$VERSION" \
                    --title "Copy SSH Key" \
                    --inputbox "Enter username, host and port (e.g. user host 22):" 10 60 \
                    2>&1 >/dev/tty)
                dialog_exit=$?
                clear -x
                [ $dialog_exit -ne 0 ] && return 0
                read -r ssh_user ssh_host ssh_port <<< "$ssh_input"
            else
                echo -e "${CYAN} Enter username, host and port to copy key to (e.g. user host 22):${NC}"
                echo -e "${CYAN}<─────────────────────────────────────────────────────────────────>${NC}"
                echo
                read -r ssh_user ssh_host ssh_port
            fi

            ssh-copy-id -p "${ssh_port:-22}" "${ssh_user}@${ssh_host}"
            ;;
        4)
            echo -e "${CYAN} Opening SSH config file...${NC}"

            ${EDITOR:-nano} ~/.ssh/config
            ;;
        5)
            return 0
            ;;
        *)
            echo -e "${RED}Invalid option selected.${NC}"
            ;;
    esac
}

