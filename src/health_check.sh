# System Health Check
health_check() {
    echo
    write_header "🏥 System Health Check"
    echo

    # Check Disk Space
    echo -e "${YELLOW}📊 Disk Space:${NC}"
    df -h / | tail -n 1 | awk '{printf "   Root: %s / %s (%s used)\n", $3, $2, $5}'
    
    disk_usage=$(df / | tail -n 1 | awk '{print $5}' | sed 's/%//')
    if [ "$disk_usage" -gt 90 ]; then
        echo -e "   ${RED}⚠️  WARNING: Disk usage is critically high (${disk_usage}%)${NC}"
    elif [ "$disk_usage" -gt 75 ]; then
        echo -e "   ${YELLOW}⚠️  Disk usage is getting high (${disk_usage}%)${NC}"
    else
        echo -e "   ${GREEN}✅ Disk usage is healthy (${disk_usage}%)${NC}"
    fi
    echo

    # Check System Load
    echo -e "${YELLOW}⚙️ System Load:${NC}"
    if command -v uptime &>/dev/null; then
        load_avg=$(uptime | awk -F'load average:' '{print $2}' | xargs)
        echo -e "   Load Average: $load_avg"
        
        cpu_cores=$(nproc 2>/dev/null || echo "1")
        load_1min=$(echo "$load_avg" | awk '{print $1}' | sed 's/,//')
        
        # Compare load to CPU cores (basic threshold)
        if command -v bc &>/dev/null; then
            high_load=$(echo "$load_1min > $cpu_cores * 2" | bc -l)
            if [ "$high_load" -eq 1 ]; then
                echo -e "   ${RED}⚠️  System load is high${NC}"
            else
                echo -e "   ${GREEN}✅ System load is normal${NC}"
            fi
        else
            # Fallback without bc
            load_1min_int=$(echo "$load_1min" | cut -d'.' -f1)
            threshold=$((cpu_cores * 2))
            if [ "$load_1min_int" -gt "$threshold" ]; then
                echo -e "   ${RED}⚠️  System load is high${NC}"
            else
                echo -e "   ${GREEN}✅ System load is normal${NC}"
            fi
        fi
        echo -e "   ${CYAN}CPU Cores: $cpu_cores${NC}"
    else
        echo -e "   ${YELLOW}⚠️  Unable to check system load${NC}"
    fi
    echo

    # Check for Broken Packages
    echo -e "${YELLOW}📦 Broken Packages:${NC}"
    if [ "$check_broken_cmd" = "unknown" ] || [ -z "$check_broken_cmd" ]; then
        echo -e "   ${YELLOW}ℹ️  Package check not implemented for $distro${NC}"
    else
        broken=$(eval "$check_broken_cmd" 2>/dev/null)
        broken=${broken:-0}
        if [ "$broken" -gt 0 ] 2>/dev/null; then
            echo -e "   ${RED}⚠️  Found $broken broken package(s)${NC}"
            case "$distro" in
                ubuntu|debian|kali)
                    echo -e "   ${CYAN}Run: sudo dpkg --configure -a${NC}"
                    ;;
                arch|manjarolinux)
                    echo -e "   ${CYAN}Run: sudo pacman -Qk to see details${NC}"
                    ;;
            esac
        else
            echo -e "   ${GREEN}✅ No broken packages detected${NC}"
        fi
    fi
    echo

    # Check for Security Updates
    echo -e "${YELLOW}🔒 Security Updates:${NC}"
    if [ "$check_security_cmd" = "unknown" ] || [ -z "$check_security_cmd" ]; then
        echo -e "   ${YELLOW}ℹ️  Security check not implemented for $distro${NC}"
    else
        case "$distro" in
            ubuntu|debian|kali)
                sudo -n apt update &>/dev/null 2>&1 || true
                security_updates=$(eval "$check_security_cmd" 2>/dev/null | xargs)
                total_updates=$(apt list --upgradable 2>/dev/null | tail -n +2 | wc -l | xargs)
                security_updates=${security_updates:-0}
                total_updates=${total_updates:-0}
                
                if [ "$security_updates" -gt 0 ] 2>/dev/null; then
                    echo -e "   ${RED}⚠️  $security_updates security update(s) available${NC}"
                    echo -e "   ${CYAN}Run: robohelp -pur${NC}"
                elif [ "$total_updates" -gt 0 ] 2>/dev/null; then
                    echo -e "   ${YELLOW}ℹ️  $total_updates update(s) available${NC}"
                    echo -e "   ${CYAN}Run: robohelp -pur${NC}"
                else
                    echo -e "   ${GREEN}✅ System is up to date${NC}"
                fi
                ;;
            arch|manjarolinux)
                if command -v checkupdates &>/dev/null; then
                    updates=$(eval "$check_security_cmd" 2>/dev/null | xargs)
                    updates=${updates:-0}
                    if [ "$updates" -gt 0 ] 2>/dev/null; then
                        echo -e "   ${YELLOW}⚠️  $updates update(s) available${NC}"
                        echo -e "   ${CYAN}Run: robohelp -pur${NC}"
                    else
                        echo -e "   ${GREEN}✅ System is up to date${NC}"
                    fi
                else
                    echo -e "   ${YELLOW}ℹ️  Install 'pacman-contrib' for update checking${NC}"
                fi
                ;;
            fedora|centos|rhel|opensuse*)
                updates=$(eval "$check_security_cmd" 2>/dev/null | xargs)
                updates=${updates:-0}
                if [ "$updates" -gt 0 ] 2>/dev/null; then
                    if [[ "$distro" == "fedora" || "$distro" == "centos" || "$distro" == "rhel" ]]; then
                        echo -e "   ${RED}⚠️  Security updates available${NC}"
                    else
                        echo -e "   ${YELLOW}⚠️  $updates update(s) available${NC}"
                    fi
                    echo -e "   ${CYAN}Run: robohelp -pur${NC}"
                else
                    echo -e "   ${GREEN}✅ System is up to date${NC}"
                fi
                ;;
            *)
                echo -e "   ${YELLOW}ℹ️  Security check not yet configured for $distro${NC}"
                ;;
        esac
    fi
    echo

    echo -e "${GREEN}✅ Health check completed${NC}"
    write_header ""
    echo
}

