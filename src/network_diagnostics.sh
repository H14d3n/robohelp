network_diagnostics() {

    if ! check_dialog; then
        # Fallback to old menu
        echo
        echo -e "${CYAN} Welcome to Network Diagnostics${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo
        echo -e "${YELLOW}  [1] DNS Lookup${NC}"
        echo -e "${YELLOW}  [2] Traceroute/Ping utilities${NC}"
        echo -e "${YELLOW}  [3] Network interface info${NC}"
        echo -e "${YELLOW}  [4] Bandwidth monitoring${NC}"
        echo -e "${YELLOW}  [5] Firewall status (ufw/iptables)${NC}"
        echo -e "${YELLOW}  [6] Active connections${NC}"
        echo -e "${YELLOW}  [7] Exit${NC}"
        echo
        read -r net_option
    else
        net_option=$(dialog --backtitle "RoboHelp v$VERSION" \
            --title "🌐 Network Diagnostics" \
            --menu "Choose an option:" 14 60 6 \
            "1" "DNS Lookup" \
            "2" "Traceroute/Ping utilities" \
            "3" "Network interface info" \
            "4" "Bandwidth monitoring" \
            "5" "Firewall status (ufw/iptables)" \
            "6" "Active connections" \
            2>&1 >/dev/tty)
        dialog_exit=$?
        clear -x
        [ $dialog_exit -ne 0 ] && return 0
    fi

    dns_lookup() {
        echo
        echo -e "${CYAN}🔍 DNS Lookup${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo
        
        if command -v dialog &>/dev/null; then
            domain=$(dialog --backtitle "RoboHelp v$VERSION" \
                --title "DNS Lookup" \
                --inputbox "Enter domain/hostname to lookup:" 10 50 \
                2>&1 >/dev/tty)
            dialog_exit=$?
            clear -x    
            [ $dialog_exit -ne 0 ] && return 0
        else
            echo -e "${YELLOW}Enter domain/hostname to lookup:${NC}"
            read -r domain
        fi
        
        if command -v dig &>/dev/null; then
            echo
            echo -e "${CYAN}Using dig:${NC}"
            dig "$domain"
        elif command -v nslookup &>/dev/null; then
            echo
            echo -e "${CYAN}Using nslookup:${NC}"
            nslookup "$domain"
        elif command -v host &>/dev/null; then
            echo
            echo -e "${CYAN}Using host:${NC}"
            host "$domain"
        else
            echo -e "${RED}❌ No DNS tools available. Install dig, nslookup, or host.${NC}"
        fi
        echo
    }

    traceroute_ping() {
        echo
        echo -e "${CYAN}🛰️  Traceroute/Ping Utilities${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo
        
        if command -v dialog &>/dev/null; then
            trace_option=$(dialog --backtitle "RoboHelp v$VERSION" \
                --title "Traceroute/Ping" \
                --menu "Choose utility:" 10 50 2 \
                "1" "Ping" \
                "2" "Traceroute" \
                2>&1 >/dev/tty)
            dialog_exit=$?
            clear -x    
            [ $dialog_exit -ne 0 ] && return 0
            
            target=$(dialog --backtitle "RoboHelp v$VERSION" \
                --title "Traceroute/Ping" \
                --inputbox "Enter target host/IP:" 10 50 \
                2>&1 >/dev/tty)
            dialog_exit=$?
            clear -x    
            [ $dialog_exit -ne 0 ] && return 0
        else
            echo -e "${YELLOW}  [1] Ping${NC}"
            echo -e "${YELLOW}  [2] Traceroute${NC}"
            echo
            read -r trace_option
            
            echo -e "${YELLOW}Enter target host/IP:${NC}"
            read -r target
            echo
        fi
        
        case "${trace_option}" in
            1)
                if command -v ping &>/dev/null; then
                    echo -e "${CYAN}Pinging $target (Ctrl+C to stop)...${NC}"
                    ping -c 4 "$target"
                else
                    echo -e "${RED}❌ ping command not found${NC}"
                fi
                ;;
            2)
                if command -v traceroute &>/dev/null; then
                    echo -e "${CYAN}Tracing route to $target...${NC}"
                    traceroute "$target"
                elif command -v tracepath &>/dev/null; then
                    echo -e "${CYAN}Tracing route to $target...${NC}"
                    tracepath "$target"
                else
                    echo -e "${RED}❌ traceroute/tracepath not found${NC}"
                fi
                ;;
            *)
                echo -e "${RED}Invalid option${NC}"
                ;;
        esac
        echo
    }

    network_info() {
        echo
        echo -e "${CYAN}🌐 Network Interface Information${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo
        
        if command -v ip &>/dev/null; then
            echo -e "${YELLOW}IP Addresses:${NC}"
            ip -br addr show
            echo
            echo -e "${YELLOW}Routing Table:${NC}"
            ip route
        elif command -v ifconfig &>/dev/null; then
            echo -e "${YELLOW}Network Interfaces:${NC}"
            ifconfig
            echo
            echo -e "${YELLOW}Routing Table:${NC}"
            route -n
        else
            echo -e "${RED}❌ No network tools available (ip or ifconfig)${NC}"
        fi
        echo
    }

    bandwidth_monitor() {
        echo
        echo -e "${CYAN}📊 Bandwidth Monitoring${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo
        
        if command -v iftop &>/dev/null; then
            echo -e "${CYAN}Starting iftop (requires sudo, Ctrl+C to quit)...${NC}"
            echo
            sudo iftop
        elif command -v nethogs &>/dev/null; then
            echo -e "${CYAN}Starting nethogs (requires sudo, Ctrl+C to quit)...${NC}"
            echo
            sudo nethogs
        elif command -v vnstat &>/dev/null; then
            echo -e "${CYAN}Network statistics:${NC}"
            vnstat
        else
            echo -e "${YELLOW}⚠️  No bandwidth monitoring tools found.${NC}"
            echo -e "${CYAN}Install one of: iftop, nethogs, vnstat${NC}"
            echo
            echo -e "${YELLOW}Showing basic network statistics:${NC}"
            if command -v netstat &>/dev/null; then
                netstat -i
            elif [ -f /proc/net/dev ]; then
                cat /proc/net/dev
            fi
        fi
        echo
    }

    firewall_status() {
        echo
        echo -e "${CYAN}🔥 Firewall Status${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo
        
        if command -v ufw &>/dev/null; then
            echo -e "${YELLOW}UFW Status:${NC}"
            sudo ufw status verbose
            echo
        fi
        
        if command -v iptables &>/dev/null; then
            echo -e "${YELLOW}iptables Rules:${NC}"
            sudo iptables -L -n -v --line-numbers
            echo
        fi
        
        if command -v firewall-cmd &>/dev/null; then
            echo -e "${YELLOW}Firewalld Status:${NC}"
            sudo firewall-cmd --list-all
            echo
        fi
        
        if ! command -v ufw &>/dev/null && ! command -v iptables &>/dev/null && ! command -v firewall-cmd &>/dev/null; then
            echo -e "${YELLOW}⚠️  No firewall tools detected${NC}"
        fi
        echo
    }

    active_connections() {
        echo
        echo -e "${CYAN}🔌 Active Network Connections${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo
        
        if command -v ss &>/dev/null; then
            echo -e "${YELLOW}Listening ports:${NC}"
            ss -tulpn
            echo
            echo -e "${YELLOW}Established connections:${NC}"
            ss -tn state established
        elif command -v netstat &>/dev/null; then
            echo -e "${YELLOW}Listening ports:${NC}"
            netstat -tulpn
            echo
            echo -e "${YELLOW}Established connections:${NC}"
            netstat -tn | grep ESTABLISHED
        else
            echo -e "${RED}❌ No network tools available (ss or netstat)${NC}"
        fi
        echo
    }

    case "${net_option}" in
        1)
            dns_lookup
            ;;
        2)
            traceroute_ping
            ;;
        3)
            network_info
            ;;
        4)
            bandwidth_monitor
            ;;
        5)
            firewall_status
            ;;
        6)
            active_connections
            ;;
        7)
            exit 0
            ;;
        *)
            echo "Unsupported option"
            ;;
    esac
}

