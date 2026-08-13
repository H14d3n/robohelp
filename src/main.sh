show_main_menu() {
    if ! check_dialog; then
        # Fallback to old menu
        echo
        echo -e "${CYAN}🏠 RoboHelp Main Menu${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo
        echo -e "${YELLOW}  [1] 📦 Package Management${NC}"
        echo -e "${YELLOW}  [2] ⚙️ Service Management${NC}"
        echo -e "${YELLOW}  [3] 💾 Disk Management${NC}"
        echo -e "${YELLOW}  [4] 🔧 Troubleshooting Wizard${NC}"
        echo -e "${YELLOW}  [5] 🏥 Health Check${NC}"
        echo -e "${YELLOW}  [6] 🌐 Network Diagnostics${NC}"
        echo -e "${YELLOW}  [7] 🔐 SSH Configuration${NC}"
        echo -e "${YELLOW}  [8] 🤖 Ansible Management (AFM)${NC}"
        echo -e "${YELLOW}  [9] Exit${NC}"
        echo
        read -r main_option
    else
        main_option=$(dialog --backtitle "RoboHelp v$VERSION" \
            --title "🏠 RoboHelp Main Menu" \
            --menu "Choose a category:" 18 60 8 \
            "1" "📦 Package Management" \
            "2" "⚙️ Service Management" \
            "3" "💾 Disk Management" \
            "4" "🔧 Troubleshooting Wizard" \
            "5" "🏥 Health Check" \
            "6" "🌐 Network Diagnostics" \
            "7" "🔐 SSH Configuration" \
            "8" "🤖 Ansible Management (AFM)" \
            2>&1 >/dev/tty)
        clear -x
        [ $? -ne 0 ] && exit 0
    fi

    case "${main_option}" in
        1)
            require_root
            package_management
            ;;
        2)
            service_management
            ;;
        3)
            disk_management
            ;;
        4)
            troubleshooting_wizard
            ;;
        5)
            health_check
            ;;
        6)
            network_diagnostics
            ;;
        7)
            ssh_config
            ;;
        8)
            ansible_deploy
            ;;
        9)
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option selected. Exiting.${NC}"
            exit 1
            ;;
    esac
}

main() {
    show_banner
    det_release
    echo

    # Check for updates (pass all arguments to handle re-execution)
    check_and_update "$@"

    # Parse command-line flags
    case "$1" in
        "")
            show_main_menu
            ;;
        -pm|--package-management)
        	require_root
        	package_management
        	;;
        -pud|--p-update)
            require_root
            package_update
            ;;
        -pur|--p-upgrade)
            require_root
            package_upgrade
            ;;
        -arm|--p-autoremove)
            require_root
            package_autorm
            ;;
        -acl|--p-autoclean)
            require_root
            package_autocls
            ;;
        -fu|--full-upgrade)
            require_root
            full_upgrade
            ;;
        -dur|--dist-upgrade)
            require_root
            dist_upgrade
            ;;
        -dx)
            require_root
            mv_robohelp
            ;;
        -ssh|--ssh-settings)
            ssh_config
            ;;
        -pi|--p-install|-prm|--p-remove|-pp|--p-purge|-ps|--p-search)
            action="$1"
            shift
            if [ $# -eq 0 ]; then
                case "$action" in
                    -pi|--p-install) human_action="install" ;;
                    -prm|--p-remove) human_action="remove" ;;
                    -pp|--p-purge)   human_action="purge" ;;
                    -ps|--p-search)  human_action="search" ;;
                    *) human_action="operate" ;;
                esac
                echo -e "${RED}❌ No packages specified to ${human_action}.${NC}"
                exit 1
            fi

            # Require root only for install, remove, and purge operations
            case "$action" in
                -pi|--p-install|-prm|--p-remove|-pp|--p-purge)
                    require_root
                    ;;
            esac

            for arg in "$@"; do
                case "$action" in
                    -pi|--p-install) package_install "$arg" ;;
                    -prm|--p-remove) package_remove "$arg" ;;
                    -pp|--p-purge)   package_purge "$arg" ;;
                    -ps|--p-search)  package_search "$arg" ;;
                esac
            done
            ;;
        -hc|--health-check)
            health_check
            ;;
        -nd|--network-diag)
            network_diagnostics
            ;;
        -dm|--disk-management)
            disk_management
            ;;
        -tw|--troubleshoot)
            troubleshooting_wizard
            ;;
        -A|--ansible)
            ansible_deploy
            ;;
        -h|--help)
	        echo
	        echo "Usage: robohelp [option]"
	        echo
	        echo -e "${CYAN}🎯 Main Menus:${NC}"
	        echo "  	robohelp				Launch RoboHelp Main Menu"
	        echo "  	-pm,	--package-management		Interactive package management menu"
	        echo "  	-A,	--ansible			Ansible Fast Management (AFM)"
	        echo
	        echo -e "${CYAN}📦 Package Management (Quick Commands):${NC}"
	        echo "  	-pud,	--p-update			Update Package Repositories [1]"
	        echo "  	-pur,	--p-upgrade			Upgrade installed packages [1]"
	        echo "  	-arm,	--p-autoremove			Remove unnecessary packages [1]"
	        echo "  	-acl,	--p-autoclean			Clean up local repository [1]"
	        echo "  	-fu,	--full-upgrade			Run full system upgrade with options [1]"
	        echo "  	-dur,	--dist-upgrade			Run distribution upgrade"
	        echo "  	-pi,	--p-install <name>		Install package(s)"
	        echo "  	-ps,	--p-search <name>		Search package(s)"
	        echo "  	-prm,	--p-remove <name>		Remove package(s)"
	        echo "  	-pp,	--p-purge <name>		Purge package(s) with dependencies"
	        echo
	        echo -e "${CYAN}⚙️ System Tools ${NC}"
	        echo "  	-ssh,	--ssh-settings			SSH configuration menu"
	        echo "  	-hc,	--health-check			Run system health check"
	        echo "  	-nd,	--network-diag			Network diagnostics menu"
	        echo "  	-dm,	--disk-management		Disk management menu"
	        echo "  	-tw,	--troubleshoot			Troubleshooting wizard"
			echo
	        echo -e "${CYAN}ℹ️ Information:${NC}"
	        echo "  	-h,	--help				Show this help message"
	        echo
	        ;;
        *)
            echo
            echo -e "${RED} ❌ Unknown or no flag provided. Try -h for help.${NC}"
            ;;
    esac
}

# Call the main function
main "$@"

