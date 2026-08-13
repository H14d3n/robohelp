service_management() {
    if ! command -v "$service_manager" &>/dev/null; then
        echo
        echo -e "${RED}❌ $service_manager not found. This feature requires systemd or compatible service manager.${NC}"
        echo
        return 1
    fi
    
    if ! check_dialog; then
        # Fallback to old menu
        echo
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${CYAN}⚙️  Service Management${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo
        echo -e "${YELLOW}  [1] List All Services${NC}"
        echo -e "${YELLOW}  [2] List Running Services${NC}"
        echo -e "${YELLOW}  [3] List Failed Services${NC}"
        echo -e "${YELLOW}  [4] Start/Stop/Restart Service${NC}"
        echo -e "${YELLOW}  [5] Enable/Disable Service${NC}"
        echo -e "${YELLOW}  [6] Check Service Status${NC}"
        echo -e "${YELLOW}  [7] Exit${NC}"
        echo
        read -r svc_option
    else
        svc_option=$(dialog --backtitle "RoboHelp v$VERSION" \
            --title "⚙️  Service Management" \
            --menu "Choose an option:" 15 60 6 \
            "1" "List All Services" \
            "2" "List Running Services" \
            "3" "List Failed Services" \
            "4" "Start/Stop/Restart Service" \
            "5" "Enable/Disable Service" \
            "6" "Check Service Status" \
            2>&1 >/dev/tty)
        dialog_exit=$?
        clear -x
        [ $dialog_exit -ne 0 ] && return 0
    fi
    
    case "${svc_option}" in
        1)
            echo
            echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo -e "${CYAN}📋 All Services${NC}"
            echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo
            $service_list_cmd --all --no-pager
            echo
            ;;
        2)
            echo
            echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo -e "${CYAN}▶️  Running Services${NC}"
            echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo
            $service_list_cmd --state=running --no-pager
            echo
            ;;
        3)
            echo
            echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo -e "${CYAN}❌ Failed Services${NC}"
            echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo
            $service_list_cmd --state=failed --no-pager
            echo
            ;;
        4)
            echo
            echo -e "${CYAN}📋 Current Services:${NC}"
            $service_list_cmd --state=running --no-pager | head -n 20
            echo
            
            if command -v dialog &>/dev/null; then
                service_name=$(dialog --backtitle "RoboHelp v$VERSION" \
                    --title "Service Control" \
                    --inputbox "Enter service name:" 10 50 \
                    2>&1 >/dev/tty)
                dialog_exit=$?
                clear -x
                [ $dialog_exit -ne 0 ] && return 0
                
                action=$(dialog --backtitle "RoboHelp v$VERSION" \
                    --title "Action for $service_name" \
                    --menu "Choose action:" 11 50 3 \
                    "1" "Start" \
                    "2" "Stop" \
                    "3" "Restart" \
                    2>&1 >/dev/tty)
                dialog_exit=$?
                clear -x
                [ $dialog_exit -ne 0 ] && return 0
            else
                echo -e "${CYAN}Enter service name:${NC}"
                read -r service_name
                echo
                echo -e "${YELLOW}Choose action:${NC}"
                echo "  [1] Start"
                echo "  [2] Stop"
                echo "  [3] Restart"
                read -r action
            fi
            
            [ -z "$service_name" ] && return 0
            
            echo
            case "$action" in
                1)
                    echo -e "${CYAN}Starting $service_name...${NC}"
                    $service_start_cmd "$service_name"
                    ;;
                2)
                    echo -e "${CYAN}Stopping $service_name...${NC}"
                    $service_stop_cmd "$service_name"
                    ;;
                3)
                    echo -e "${CYAN}Restarting $service_name...${NC}"
                    $service_restart_cmd "$service_name"
                    ;;
            esac
            
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✅ Operation successful${NC}"
                echo
                $service_status_cmd "$service_name" --no-pager
            else
                echo -e "${RED}❌ Operation failed${NC}"
            fi
            echo
            ;;
        5)
            echo
            echo -e "${CYAN}📋 Current Services:${NC}"
            $service_list_cmd --no-pager | head -n 20
            echo
            
            if command -v dialog &>/dev/null; then
                service_name=$(dialog --backtitle "RoboHelp v$VERSION" \
                    --title "Service Enable/Disable" \
                    --inputbox "Enter service name:" 10 50 \
                    2>&1 >/dev/tty)
                dialog_exit=$?
                clear -x
                [ $dialog_exit -ne 0 ] && return 0
                
                action=$(dialog --backtitle "RoboHelp v$VERSION" \
                    --title "Action for $service_name" \
                    --menu "Choose action:" 10 50 2 \
                    "1" "Enable (start on boot)" \
                    "2" "Disable (don't start on boot)" \
                    2>&1 >/dev/tty)
                dialog_exit=$?
                clear -x
                [ $dialog_exit -ne 0 ] && return 0
            else
                echo -e "${CYAN}Enter service name:${NC}"
                read -r service_name
                echo
                echo -e "${YELLOW}Choose action:${NC}"
                echo "  [1] Enable (start on boot)"
                echo "  [2] Disable (don't start on boot)"
                read -r action
            fi
            
            [ -z "$service_name" ] && return 0
            
            echo
            case "$action" in
                1)
                    echo -e "${CYAN}Enabling $service_name...${NC}"
                    $service_enable_cmd "$service_name"
                    ;;
                2)
                    echo -e "${CYAN}Disabling $service_name...${NC}"
                    $service_disable_cmd "$service_name"
                    ;;
            esac
            
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✅ Operation successful${NC}"
            else
                echo -e "${RED}❌ Operation failed${NC}"
            fi
            echo
            ;;
        6)
            echo
            echo -e "${CYAN}📋 Current Services:${NC}"
            $service_list_cmd --no-pager | head -n 20
            echo
            
            if command -v dialog &>/dev/null; then
                service_name=$(dialog --backtitle "RoboHelp v$VERSION" \
                    --title "Check Service Status" \
                    --inputbox "Enter service name:" 10 50 \
                    2>&1 >/dev/tty)
                dialog_exit=$?
                clear -x
                [ $dialog_exit -ne 0 ] && return 0
            else
                echo -e "${CYAN}Enter service name:${NC}"
                read -r service_name
            fi
            
            [ -z "$service_name" ] && return 0
            
            echo
            echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo -e "${CYAN}📊 Status: $service_name${NC}"
            echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo
            $service_status_cmd "$service_name" --no-pager
            echo
            ;;
        7)
            return 0
            ;;
        *)
            echo -e "${RED}Invalid option selected.${NC}"
            ;;
    esac
}

