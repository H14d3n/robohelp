package_management() {
    
    if ! check_dialog; then
        # Fallback to old menu
        echo
        write_header "📦 Package Management"
        echo
        echo -e "${YELLOW}  [1] Update Package Repositories${NC}"
        echo -e "${YELLOW}  [2] Upgrade Installed Packages${NC}"
        echo -e "${YELLOW}  [3] Full System Upgrade${NC}"
        echo -e "${YELLOW}  [4] Distribution Upgrade${NC}"
        echo -e "${YELLOW}  [5] Remove Unnecessary Packages${NC}"
        echo -e "${YELLOW}  [6] Clean Local Repository${NC}"
        echo -e "${YELLOW}  [7] Install Package${NC}"
        echo -e "${YELLOW}  [8] Remove Package${NC}"
        echo -e "${YELLOW}  [9] Purge Package${NC}"
        echo -e "${YELLOW}  [10] Search Package${NC}"
        echo -e "${YELLOW}  [11] Exit${NC}"
        echo
        read -r pkg_option
    else
        pkg_option=$(dialog --backtitle "RoboHelp v$VERSION" \
            --title "📦 Package Management" \
            --menu "Choose an option:" 17 60 10 \
            "1" "Update Package Repositories" \
            "2" "Upgrade Installed Packages" \
            "3" "Full System Upgrade" \
            "4" "Distribution Upgrade" \
            "5" "Remove Unnecessary Packages" \
            "6" "Clean Local Repository" \
            "7" "Install Package" \
            "8" "Remove Package" \
            "9" "Purge Package" \
            "10" "Search Package" \
            2>&1 >/dev/tty)
        dialog_exit=$?
        clear -x
        [ $dialog_exit -ne 0 ] && return 0
    fi

    case "${pkg_option}" in
        1)
            package_update
            ;;
        2)
            package_upgrade
            ;;
        3)
            full_upgrade
            ;;
        4)
            dist_upgrade
            ;;
        5)
            package_autorm
            ;;
        6)
            package_autocls
            ;;
        7)
            if command -v dialog &>/dev/null; then
                packages=$(dialog --backtitle "RoboHelp v$VERSION" \
                    --title "Install Package" \
                    --inputbox "Enter package name(s) to install (space-separated):" 10 60 \
                    2>&1 >/dev/tty)
                clear -x
                [ $? -ne 0 ] && return 0
            else
                echo
                echo -e "${CYAN}Enter package name(s) to install (space-separated):${NC}"
                echo -e "${CYAN}<─────────────────────────────────────────────────>${NC}"
                read -r packages
            fi
            for pkg in $packages; do
                package_install "$pkg"
            done
            ;;
        8)
            if command -v dialog &>/dev/null; then
                packages=$(dialog --backtitle "RoboHelp v$VERSION" \
                    --title "Remove Package" \
                    --inputbox "Enter package name(s) to remove (space-separated):" 10 60 \
                    2>&1 >/dev/tty)
                clear -x    
                [ $? -ne 0 ] && return 0
            else
                echo
                echo -e "${CYAN}Enter package name(s) to remove (space-separated):${NC}"
                echo -e "${CYAN}<─────────────────────────────────────────────────>${NC}"
                read -r packages
            fi
            for pkg in $packages; do
                package_remove "$pkg"
            done
            ;;
        9)
            if command -v dialog &>/dev/null; then
                packages=$(dialog --backtitle "RoboHelp v$VERSION" \
                    --title "Purge Package" \
                    --inputbox "Enter package name(s) to purge (space-separated):" 10 60 \
                    2>&1 >/dev/tty)
                clear -x
                [ $? -ne 0 ] && return 0
            else
                echo
                echo -e "${CYAN}Enter package name(s) to purge (space-separated):${NC}"
                echo -e "${CYAN}<────────────────────────────────────────────────>${NC}"
                read -r packages
            fi
            for pkg in $packages; do
                package_purge "$pkg"
            done
            ;;
        10)
            if command -v dialog &>/dev/null; then
                term=$(dialog --backtitle "RoboHelp v$VERSION" \
                    --title "Search Package" \
                    --inputbox "Enter search term:" 10 50 \
                    2>&1 >/dev/tty)
                dialog_exit=$?
                clear -x
                [ $dialog_exit -ne 0 ] && return 0
            else
                echo
                echo -e "${CYAN}Enter search term:${NC}"
                echo -e "${CYAN}<─────────────────>${NC}"
                read -r term
            fi
            package_search "$term"
            ;;
        11)
            return 0
            ;;
        *)
            echo -e "${RED}Invalid option selected. Aborting.${NC}"
            ;;
    esac
}

# Package Management Functions
package_update() {
    echo
    write_header "📦 Updating package metadata..."
    $update_cmd
    rc=$?
    if [ $rc -eq 0 ]; then
        echo -e "${GREEN}✅ Updated repositories successfully on $distro.${NC}"
    else
        echo -e "${RED}❌ Failed to update repositories on $distro. Exit code: $rc ${NC}"
    fi
    echo
    return $rc
}

package_upgrade() {
    echo
    write_header "📦 Upgrading installed packages..."
    $upgrade_cmd
    rc=$?
    if [ $rc -eq 0 ]; then
        echo -e "${GREEN}✅ Installed updates successfully on $distro.${NC}"
    else
        echo -e "${RED}❌ Failed to upgrade packages on $distro. Exit code: $rc ${NC}"
    fi
    echo
    return $rc
}

dist_upgrade() {
    echo
    write_header "📦 Upgrading distribution and dependencies..."

    if [ "$dist_upgrade_cmd" = "unknown" ]; then
	    echo -e "${BLUE}🛑 This command is not available for your distribution${NC}"
	    echo
	    return 1
    else
	    $dist_upgrade_cmd
    fi

    rc=$?
    if [ $rc -eq 0 ]; then
        echo -e "${GREEN}✅ Upgraded distribution successfully.${NC}"
    else
        echo -e "${RED}❌ Failed to upgrade $distro. Exit code: $rc ${NC}"
    fi
    echo
    return $rc
}

package_autorm() {
    echo
    echo -e "${CYAN}👁  Are you sure?${NC}"
    write_header "🧹 Removing unnecessary packages..."
    if [[ "$distro" == "arch" || "$distro" == "manjarolinux" ]]; then
        # Compute orphans at runtime to avoid command-substitution at assignment time
        orphans=$(pacman -Qdtq)
        if [ -z "$orphans" ]; then
            echo -e "${YELLOW}ℹ️  No orphaned packages found.${NC}"
            echo
            return 0
        fi
        $autoremove_cmd $orphans
        rc=$?
    else
        $autoremove_cmd
        rc=$?
    fi

    if [ $rc -eq 0 ]; then
        echo -e "${GREEN}✅ Autoremove completed successfully on $distro.${NC}"
    else
        echo -e "${RED}❌ Autoremove failed on $distro. Exit code: $rc ${NC}"
    fi
    echo
    return $rc
}

package_autocls() {
    echo
    write_header "🧼 Cleaning up local repository..."
    $autoclean_cmd
    rc=$?
    if [ $rc -eq 0 ]; then
        echo -e "${GREEN}✅ Autoclean completed successfully on $distro.${NC}"
    else
        echo -e "${RED}❌ Autoclean failed on $distro. Exit code: $rc ${NC}"
    fi
    echo
    return $rc
}

package_install() {
    local package="$1"
    echo
    write_header "📦 Installing package: ${YELLOW}$package${NC}"
    $install_cmd "$package"
    rc=$?
    if [ $rc -eq 0 ]; then
	    echo -e "${GREEN}✅ $package installed successfully!${NC}"
    else
        echo -e "${RED}❌ Failed to install $package. Exit code: $rc${NC}"
    fi
    return $rc
}

package_remove() {
    local package="$1"
    echo
    write_header "📦 Removing package: ${YELLOW}$package${NC}"
    $remove_cmd "$package"
    rc=$?
    if [ $rc -eq 0 ]; then
        echo -e "${GREEN}✅ $package removed successfully!${NC}"
    else
        echo -e "${RED}❌ Failed to remove $package. Exit code: $rc${NC}"
    fi
    return $rc
}

package_purge() {
    local package="$1"
    echo
    write_header "📦 Purging package: ${YELLOW}$package${NC}"
    $purge_cmd "$package"
    rc=$?
    if [ $rc -eq 0 ]; then
        echo -e "${GREEN}✅ $package purged successfully!${NC}"
    else
        echo -e "${RED}❌ Failed to purge $package. Exit code: $rc${NC}"
    fi
    return $rc
}

package_search() {
    local term="$1"
    echo
    write_header "🔍 Searching for: ${YELLOW}$term${NC}" "$BLUE"
    $search_cmd "$term"
    echo
}

full_upgrade() {
    echo
    write_header "⚙  Running full upgrade...!"
    package_update && \
    package_upgrade && \
    package_autorm && \
    package_autocls && \
    echo -e "${GREEN}✅ Full upgrade completed successfully!${NC}" && \
    write_header "" "$GREEN" || \
    echo -e "${RED}❌ An error occurred during the upgrade. Exit code: $? ${NC}"
    echo
}

