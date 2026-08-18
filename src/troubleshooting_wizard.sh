# Troubleshooting Wizard Functions
troubleshooting_wizard() {

    if ! check_dialog; then
        # Fallback to old menu
        echo
        write_header "🔧 Troubleshooting Wizard"
        echo
        echo -e "${YELLOW}Select the problem you're experiencing:${NC}"
        echo
        echo -e "${YELLOW}  [1] System Won't Boot${NC}"
        echo -e "${YELLOW}  [2] Network Issues${NC}"
        echo -e "${YELLOW}  [3] High CPU Usage${NC}"
        echo -e "${YELLOW}  [4] Out of Disk Space${NC}"
        echo -e "${YELLOW}  [5] Service Won't Start${NC}"
        echo -e "${YELLOW}  [6] SSH Connection Issues${NC}"
        echo -e "${YELLOW}  [7] Exit${NC}"
        echo
        read -r ts_option
    else
        ts_option=$(dialog --backtitle "RoboHelp v$VERSION" \
            --title "🔧 Troubleshooting Wizard" \
            --menu "Select the problem you're experiencing:" 16 60 6 \
            "1" "System Won't Boot" \
            "2" "Network Issues" \
            "3" "High CPU Usage" \
            "4" "Out of Disk Space" \
            "5" "Service Won't Start" \
            "6" "SSH Connection Issues" \
            2>&1 >/dev/tty)
        dialog_exit=$?
        clear -x
        [ $dialog_exit -ne 0 ] && return 0
    fi

    troubleshoot_boot() {
        echo
        write_header "🔧 System Boot Troubleshooting"
        echo
        echo -e "${YELLOW}Step 1: Checking system boot logs...${NC}"
        echo
        
        if command -v journalctl &>/dev/null; then
            echo -e "${CYAN}📋 Recent boot errors:${NC}"
            sudo journalctl -b -p err --no-pager | tail -n 20
            echo
            echo -e "${CYAN}📋 Failed services:${NC}"
            systemctl --failed --no-pager
            echo
        else
            echo -e "${YELLOW}⚠️  journalctl not available, checking dmesg...${NC}"
            dmesg | grep -i "error\|fail" | tail -n 20
            echo
        fi
        
        echo -e "${YELLOW}Step 2: Common boot issues and solutions:${NC}"
        echo
        echo -e "${CYAN}• Check disk space:${NC} df -h"
        echo -e "${CYAN}• Check filesystem:${NC} sudo fsck (from recovery mode)"
        echo -e "${CYAN}• Check GRUB:${NC} sudo update-grub"
        echo -e "${CYAN}• Check fstab:${NC} cat /etc/fstab"
        echo
        
        if command -v dialog &>/dev/null; then
            echo -e "${YELLOW}Press any key to continue...${NC}"
            read -n 1 -s -r
            dialog --backtitle "RoboHelp v$VERSION" \
                --title "Boot Troubleshooting Actions" \
                --yesno "Would you like to check your /etc/fstab file now?" 8 50
            dialog_exit=$?
            if [ $dialog_exit -eq 0 ]; then
                clear -x
                echo
                echo -e "${CYAN}📋 Current /etc/fstab configuration:${NC}"
                echo
                cat /etc/fstab
                echo
            else
                clear -x
            fi
        else
            echo -e "${CYAN}Would you like to check your /etc/fstab file? [y/N]${NC}"
            read -r check_fstab
            if [[ "$check_fstab" =~ ^[Yy]$ ]]; then
                echo
                echo -e "${CYAN}📋 Current /etc/fstab configuration:${NC}"
                echo
                cat /etc/fstab
                echo
            fi
        fi
        
        echo -e "${GREEN}✅ Boot diagnostics complete.${NC}"
        echo
    }

    troubleshoot_network() {
        echo
        write_header "🔧 Network Troubleshooting"
        echo
        echo -e "${YELLOW}Running comprehensive network diagnostics...${NC}"
        echo
        
        # Use existing network diagnostics
        network_diagnostics
        
        echo
        echo -e "${YELLOW}Additional troubleshooting steps:${NC}"
        echo
        echo -e "${YELLOW}Network-related services:${NC}"
        if command -v "$service_manager" &>/dev/null; then
            $service_list_cmd --all --no-pager | grep -E "(network|NetworkManager|networking|dhcp|resolved)" | head -n 10 || echo "No network services found"
        fi
        echo
        write_header ""
        echo
        echo -e "${CYAN}• Restart network service:${NC}"
        if command -v "$service_manager" &>/dev/null; then
            echo -e "  $service_restart_cmd NetworkManager"
            echo -e "  $service_restart_cmd networking"
        else
            echo -e "  sudo service network-manager restart"
            echo -e "  sudo service networking restart"
        fi
        echo
        echo -e "${CYAN}• Reset DNS:${NC}"
        echo -e "  sudo systemd-resolve --flush-caches (systemd)"
        echo -e "  sudo resolvectl flush-caches (newer systems)"
        echo
        echo -e "${CYAN}• Check firewall:${NC}"
        echo -e "  sudo ufw status (Ubuntu/Debian)"
        echo -e "  sudo firewall-cmd --list-all (Fedora/RHEL)"
        echo
        
        if command -v dialog &>/dev/null; then
            echo -e "${YELLOW}Press any key to continue...${NC}"
            read -n 1 -s -r
            dialog --backtitle "RoboHelp v$VERSION" \
                --title "Network Actions" \
                --yesno "Would you like to restart NetworkManager now?" 8 50
            dialog_exit=$?
            if [ $dialog_exit -eq 0 ]; then
                clear -x
                echo
                echo -e "${CYAN}🔄 Restarting NetworkManager...${NC}"
                $service_restart_cmd NetworkManager 2>/dev/null || sudo service network-manager restart 2>/dev/null
                echo -e "${GREEN}✅ NetworkManager restarted.${NC}"
                echo
            else
                clear -x
            fi
        fi
    }

    troubleshoot_cpu() {
        echo
        write_header "🔧 High CPU Usage Troubleshooting"
        echo
        echo -e "${YELLOW}Step 1: Identifying high CPU processes...${NC}"
        echo
        
        echo -e "${CYAN}📊 Current CPU usage:${NC}"
        top -bn1 | head -n 12
        echo
        
        echo -e "${CYAN}📊 Top 10 CPU-consuming processes:${NC}"
        ps aux --sort=-%cpu | head -n 11
        echo
        
        echo -e "${YELLOW}Step 2: Common causes and solutions:${NC}"
        echo
        echo -e "${CYAN}• High system load:${NC}"
        uptime
        echo
        echo -e "${CYAN}• Check for runaway processes in the list above${NC}"
        echo -e "${CYAN}• Use 'htop' for interactive monitoring (install with: robohelp -pi htop)${NC}"
        echo -e "${CYAN}• Kill a process: kill -9 <PID>${NC}"
        echo -e "${CYAN}• Renice a process: renice -n 10 -p <PID>${NC}"
        echo
        
        if command -v dialog &>/dev/null; then
            echo -e "${YELLOW}Press any key to continue...${NC}"
            read -n 1 -s -r
            # Get top 15 CPU processes and format for dialog menu
        mapfile -t process_list < <(ps aux --sort=-%cpu | awk 'NR>1 && NR<=16 {printf "%s|%s|%s|%s\n", $2, $3, $11, $0}')
        
        if [ ${#process_list[@]} -gt 0 ]; then
            # Build dialog menu items
            menu_items=()
            for proc in "${process_list[@]}"; do
                IFS='|' read -r pid cpu cmd full_line <<< "$proc"
                # Truncate command if too long
                if [ ${#cmd} -gt 35 ]; then
                    cmd="${cmd:0:32}..."
                fi
                menu_items+=("$pid" "CPU:${cpu}% - $cmd")
            done
            
            selected_pid=$(dialog --backtitle "RoboHelp v$VERSION" \
                --title "Kill Process - Select from Top CPU Consumers" \
                --menu "Choose a process to kill (or Cancel to skip):" 20 75 12 \
                "${menu_items[@]}" \
                2>&1 >/dev/tty)
            dialog_exit=$?
            clear -x
            
            if [ $dialog_exit -eq 0 ] && [ -n "$selected_pid" ]; then
                # Get process details for confirmation
                proc_details=$(ps -p "$selected_pid" -o pid,pcpu,pmem,comm --no-headers 2>/dev/null)
                
                if [ -n "$proc_details" ]; then
                    echo
                    echo -e "${CYAN}📋 Process details:${NC}"
                    echo "  $proc_details"
                    echo
                    
                    dialog --backtitle "RoboHelp v$VERSION" \
                        --title "Confirm Kill Process" \
                        --yesno "Are you sure you want to kill process $selected_pid?\n\n$proc_details" 10 60
                    dialog_exit=$?                    
                    if [ $dialog_exit -eq 0 ]; then
                        clear -x
                        echo
                        echo -e "${YELLOW}Attempting to kill process $selected_pid...${NC}"
                        if sudo kill -9 "$selected_pid" 2>/dev/null; then
                            echo -e "${GREEN}✅ Process $selected_pid killed successfully.${NC}"
                        else
                            echo -e "${RED}❌ Failed to kill process $selected_pid. It may have already terminated.${NC}"
                        fi
                        echo
                    else
                        clear -x
                        echo
                        echo -e "${YELLOW}⚠️  Kill operation cancelled.${NC}"
                        echo
                    fi
                else
                    echo
                    echo -e "${RED}❌ Process $selected_pid no longer exists.${NC}"
                    echo
                fi
            fi
        else
            echo -e "${RED}❌ Could not retrieve process list.${NC}"
            echo
        fi
    else
        # Fallback for non-dialog systems
        echo
        echo -e "${CYAN}Top CPU processes:${NC}"
        ps aux --sort=-%cpu | head -n 11 | awk 'NR>1 {printf "[%s] CPU:%s%% - %s\n", $2, $3, $11}'
        echo
        echo -e "${CYAN}Enter PID to kill (or press Enter to skip):${NC}"
        read -r pid
        if [ -n "$pid" ]; then
            echo
            echo -e "${YELLOW}Attempting to kill process $pid...${NC}"
            if sudo kill -9 "$pid" 2>/dev/null; then
                echo -e "${GREEN}✅ Process $pid killed successfully.${NC}"
            else
                echo -e "${RED}❌ Failed to kill process $pid. Check if PID is valid.${NC}"
            fi
            echo
        fi
    fi
    
    echo -e "${GREEN}✅ CPU diagnostics complete.${NC}"
    echo
}

    troubleshoot_disk() {
        echo
        write_header "🔧 Disk Space Troubleshooting"
        echo
        echo -e "${YELLOW}Step 1: Analyzing disk usage...${NC}"
        echo
        
        echo -e "${CYAN}📊 Filesystem usage:${NC}"
        df -h
        echo
        
        echo -e "${CYAN}📊 Largest directories in /home:${NC}"
        du -h --max-depth=1 /home 2>/dev/null | sort -hr | head -n 10
        echo
        
        echo -e "${CYAN}📊 Largest directories in /var:${NC}"
        sudo du -h --max-depth=1 /var 2>/dev/null | sort -hr | head -n 10
        echo
        
        echo -e "${YELLOW}Step 2: Cleanup options:${NC}"
        echo
        echo -e "${CYAN}• Clean package cache:${NC}"
        echo -e "  robohelp -acl"
        echo -e "${CYAN}• Remove old kernels (Ubuntu/Debian):${NC}"
        echo -e "  robohelp -arm"
        echo -e "${CYAN}• Clean journal logs:${NC}"
        echo -e "  robohelp -dm -> Clean Journal logs"
        echo -e "${CYAN}• Find large files:${NC}"
        echo -e "  robohelp -dm -> Find Largest Files"
        echo
        
        if command -v dialog &>/dev/null; then
            echo -e "${YELLOW}Press any key to continue...${NC}"
            read -n 1 -s -r
            dialog --backtitle "RoboHelp v$VERSION" \
                --title "Disk Cleanup" \
                --yesno "Would you like to clean package cache and remove unnecessary packages now?" 8 60
            dialog_exit=$?
            if [ $dialog_exit -eq 0 ]; then
                clear -x
                echo
                echo -e "${CYAN}🧹 Cleaning package cache...${NC}"
                package_autocls
                echo
                echo -e "${CYAN}🧹 Removing unnecessary packages...${NC}"
                package_autorm
                echo
                echo -e "${GREEN}✅ Cleanup complete. Check disk usage with: df -h${NC}"
                echo
            else
                clear -x
            fi
        else
            echo -e "${CYAN}Clean package cache and remove unnecessary packages now? [y/N]${NC}"
            read -r do_cleanup
            if [[ "$do_cleanup" =~ ^[Yy]$ ]]; then
                echo
                echo -e "${CYAN}🧹 Cleaning package cache...${NC}"
                package_autocls
                echo
                echo -e "${CYAN}🧹 Removing unnecessary packages...${NC}"
                package_autorm
                echo
                echo -e "${GREEN}✅ Cleanup complete. Check disk usage with: df -h${NC}"
                echo
            fi
        fi
        
        echo -e "${GREEN}✅ Disk space diagnostics complete.${NC}"
        echo
    }

    troubleshoot_service() {
        if ! command -v "$service_manager" &>/dev/null; then
            echo
            echo -e "${RED}❌ $service_manager not found. This troubleshooter requires systemd or compatible service manager.${NC}"
            echo
            return 1
        fi
        
        echo
        write_header "📋 Running Services"
        echo
        $service_list_cmd --state=running --no-pager | head -n 20
        echo
        write_header "❌ Failed Services"
        echo
        $service_list_cmd --state=failed --no-pager
        echo

	echo -e "${YELLOW}Press any key to continue...${NC}"
	read -n 1 -s -r
        
        if command -v dialog &>/dev/null; then
            service_name=$(dialog --backtitle "RoboHelp v$VERSION" \
                --title "Service Troubleshooting" \
                --inputbox "Enter the service name to troubleshoot:" 10 50 \
                2>&1 >/dev/tty)
            dialog_exit=$?
            clear -x
            [ $dialog_exit -ne 0 ] && return 0
        else
            echo -e "${CYAN}Enter the service name to troubleshoot:${NC}"
            read -r service_name
        fi
        
        if [ -z "$service_name" ]; then
            echo -e "${RED}❌ No service name provided.${NC}"
            echo
            return 1
        fi
        
        echo
        write_header "🔧 Troubleshooting: $service_name"
        echo
        
        echo -e "${YELLOW}Step 1: Checking service status...${NC}"
        echo
        $service_status_cmd "$service_name" --no-pager
        echo
        
        echo -e "${YELLOW}Step 2: Checking service logs...${NC}"
        echo
        echo -e "${CYAN}📋 Recent logs for $service_name:${NC}"
        sudo journalctl -u "$service_name" -n 30 --no-pager
        echo
        
        echo -e "${YELLOW}Step 3: Common solutions:${NC}"
        echo
        echo -e "${CYAN}• Restart service:${NC} $service_restart_cmd $service_name"
        echo -e "${CYAN}• Enable on boot:${NC} $service_enable_cmd $service_name"
        echo -e "${CYAN}• Check config:${NC} $service_manager cat $service_name"
        echo -e "${CYAN}• Reset failed state:${NC} $service_manager reset-failed $service_name"
        echo
        
        if command -v dialog &>/dev/null; then
            echo -e "${YELLOW}Press any key to continue...${NC}"
            read -n 1 -s -r
            dialog --backtitle "RoboHelp v$VERSION" \
                --title "Service Actions" \
                --yesno "Would you like to restart $service_name now?" 8 50
            dialog_exit=$?
            if [ $dialog_exit -eq 0 ]; then
                clear -x
                echo
                echo -e "${CYAN}🔄 Restarting $service_name...${NC}"
                if $service_restart_cmd "$service_name"; then
                    echo -e "${GREEN}✅ Service restarted successfully.${NC}"
                    echo
                    $service_status_cmd "$service_name" --no-pager
                else
                    echo -e "${RED}❌ Failed to restart service. Check logs above.${NC}"
                fi
                echo
            else
                clear -x
            fi
        else
            echo -e "${CYAN}Restart $service_name now? [y/N]${NC}"
            read -r do_restart
            if [[ "$do_restart" =~ ^[Yy]$ ]]; then
                echo
                echo -e "${CYAN}🔄 Restarting $service_name...${NC}"
                if $service_restart_cmd "$service_name"; then
                    echo -e "${GREEN}✅ Service restarted successfully.${NC}"
                    echo
                    $service_status_cmd "$service_name" --no-pager
                else
                    echo -e "${RED}❌ Failed to restart service. Check logs above.${NC}"
                fi
                echo
            fi
        fi
        
        echo -e "${GREEN}✅ Service diagnostics complete.${NC}"
        echo
    }

    troubleshoot_ssh() {
        echo
        write_header "🔧 SSH Connection Troubleshooting"
        echo
        
        if ! command -v sshd &>/dev/null && ! command -v ssh &>/dev/null; then
            echo -e "${RED}❌ SSH is not installed.${NC}"
            echo -e "${CYAN}Install with: robohelp -pi openssh-server openssh-client${NC}"
            echo
            return 1
        fi
        
        echo -e "${YELLOW}Available SSH-related services:${NC}"
        echo
        $service_list_cmd --all --no-pager | grep -E "(ssh|sshd)" || echo "No SSH services found"
        echo
        write_header ""
        echo
        
        echo -e "${YELLOW}Step 1: Checking SSH service status...${NC}"
        echo
        
        if command -v "$service_manager" &>/dev/null; then
            $service_status_cmd ssh --no-pager 2>/dev/null || $service_status_cmd sshd --no-pager 2>/dev/null
        else
            service ssh status 2>/dev/null || service sshd status 2>/dev/null
        fi
        echo
        
        echo -e "${YELLOW}Step 2: Checking SSH configuration...${NC}"
        echo
        
        if [ -f /etc/ssh/sshd_config ]; then
            echo -e "${CYAN}📋 Key SSH settings:${NC}"
            grep -E "^(Port|PermitRootLogin|PasswordAuthentication|PubkeyAuthentication)" /etc/ssh/sshd_config 2>/dev/null || echo "Default settings in use"
            echo
        fi
        
        echo -e "${YELLOW}Step 3: Checking network and firewall...${NC}"
        echo
        echo -e "${CYAN}📊 Listening SSH ports:${NC}"
        ss -tlnp | grep -E "(:22|ssh)" || netstat -tlnp | grep -E "(:22|ssh)" 2>/dev/null
        echo
        
        echo -e "${CYAN}📊 Firewall status:${NC}"
        if command -v ufw &>/dev/null; then
            sudo ufw status | grep -E "(Status|22|ssh)"
        elif command -v firewall-cmd &>/dev/null; then
            sudo firewall-cmd --list-services | grep ssh && echo "SSH is allowed" || echo "SSH may be blocked"
        else
            echo "No common firewall detected"
        fi
        echo
        
        echo -e "${YELLOW}Step 4: Common solutions:${NC}"
        echo
        echo -e "${CYAN}• Start SSH service:${NC}"
        echo -e "  $service_start_cmd ssh (or sshd)"
        echo -e "${CYAN}• Enable SSH on boot:${NC}"
        echo -e "  $service_enable_cmd ssh (or sshd)"
        echo -e "${CYAN}• Allow SSH through firewall:${NC}"
        echo -e "  sudo ufw allow 22/tcp (Ubuntu/Debian)"
        echo -e "  sudo firewall-cmd --add-service=ssh --permanent (Fedora/RHEL)"
        echo -e "${CYAN}• Check SSH logs:${NC}"
        echo -e "  sudo journalctl -u ssh -n 50 (or sshd)"
        echo -e "${CYAN}• Test connection:${NC}"
        echo -e "  ssh -v user@hostname"
        echo
        
        if command -v dialog &>/dev/null; then
            echo -e "${YELLOW}Press any key to continue...${NC}"
            read -n 1 -s -r
            dialog --backtitle "RoboHelp v$VERSION" \
                --title "SSH Actions" \
                --yesno "Would you like to start/restart SSH service now?" 8 50
            dialog_exit=$?
            if [ $dialog_exit -eq 0 ]; then
                clear -x
                echo
                echo -e "${CYAN}🔄 Starting SSH service...${NC}"
                $service_start_cmd ssh 2>/dev/null || $service_start_cmd sshd 2>/dev/null || \
                sudo service ssh start 2>/dev/null || sudo service sshd start 2>/dev/null
                
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}✅ SSH service started.${NC}"
                else
                    echo -e "${RED}❌ Failed to start SSH service.${NC}"
                fi
                echo
            else
                clear -x
            fi
        else
            echo -e "${CYAN}Start/restart SSH service now? [y/N]${NC}"
            read -r do_start
            if [[ "$do_start" =~ ^[Yy]$ ]]; then
                echo
                echo -e "${CYAN}🔄 Starting SSH service...${NC}"
                $service_start_cmd ssh 2>/dev/null || $service_start_cmd sshd 2>/dev/null || \
                sudo service ssh start 2>/dev/null || sudo service sshd start 2>/dev/null
                
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}✅ SSH service started.${NC}"
                else
                    echo -e "${RED}❌ Failed to start SSH service.${NC}"
                fi
                echo
            fi
        fi
        
        echo -e "${GREEN}✅ SSH diagnostics complete.${NC}"
        echo
    }

    case "${ts_option}" in
        1)
            troubleshoot_boot
            ;;
        2)
            troubleshoot_network
            ;;
        3)
            troubleshoot_cpu
            ;;
        4)
            troubleshoot_disk
            ;;
        5)
            troubleshoot_service
            ;;
        6)
            troubleshoot_ssh
            ;;
        7)
            return 0
            ;;
        *)
            echo -e "${RED}Invalid option selected.${NC}"
            ;;
    esac
}

