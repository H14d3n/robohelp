# Function to print banner
show_banner() {
    echo "$title"
    echo "$bb8"
    echo -e "${CYAN}Version: $VERSION${NC}"
}

write_header() {
    local text="$1"
    local color="${2:-$CYAN}" # Default to cyan if no color is provided
    echo -e "${color}${text}${NC}"
    echo -e "${color}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

write_subheader() {
    local text="$1"
    local color="${2:-$CYAN}" # Default to cyan if no color is provided
    local line="${3:-─────────────────────────────────────────────}"
    echo -e "${color}${text}${NC}"
    echo -e "${color}<${line}>${NC}"
}

# Function to get remote version from GitHub
get_remote_version() {
    if command -v curl &>/dev/null; then
        remote_version=$(curl -s "$GITHUB_RAW_URL" | sed -n 's/^VERSION="\(.*\)"/\1/p' | head -1)
    elif command -v wget &>/dev/null; then
        remote_version=$(wget -qO- "$GITHUB_RAW_URL" | sed -n 's/^VERSION="\(.*\)"/\1/p' | head -1)
    else
        echo ""
        return 1
    fi
    echo "$remote_version"
}

# Function to check and perform auto-update
check_and_update() {
    # Skip update check if no internet tool is available
    if ! command -v curl &>/dev/null && ! command -v wget &>/dev/null; then
        return 0
    fi

    echo -e "${CYAN}🔍 Checking for updates...${NC}"
    
    remote_version=$(get_remote_version)
    
    # If we couldn't fetch the remote version, skip silently
    if [ -z "$remote_version" ]; then
        echo -e "${YELLOW}⚠️  Could not check for updates (no connection to GitHub)${NC}"
        echo
        return 0
    fi
    
    if [ "$VERSION" != "$remote_version" ]; then
        echo -e "${YELLOW}📢 New version available: $remote_version (current: $VERSION)${NC}"
        echo -e "${CYAN}🔄 Updating robohelp...${NC}"
        
        # Create temporary file
        temp_file=$(mktemp)
        
        # Download new version
        if command -v curl &>/dev/null; then
            curl -s "$GITHUB_RAW_URL" -o "$temp_file"
        else
            wget -qO "$temp_file" "$GITHUB_RAW_URL"
        fi
        
        if [ $? -eq 0 ] && [ -s "$temp_file" ]; then
            # Make it executable
            chmod +x "$temp_file"
            
            # Move to install location (requires sudo)
            if sudo cp "$temp_file" "$INSTALL_PATH"; then
                echo -e "${GREEN}✅ Successfully updated to version $remote_version!${NC}"
                echo -e "${CYAN}🔄 Restarting with new version...${NC}"
                echo
                rm -f "$temp_file"
                # Re-execute with the same arguments
                exec "$INSTALL_PATH" "$@"
            else
                echo -e "${RED}❌ Failed to install update. Please run with sudo or manually update.${NC}"
                rm -f "$temp_file"
            fi
        else
            echo -e "${RED}❌ Failed to download update.${NC}"
            rm -f "$temp_file"
        fi
        echo
    else
        echo -e "${GREEN}✅ You are running the latest version ($VERSION)${NC}"
        echo
    fi
}

# Function to determine distro and set commands
det_release() {
    if command -v lsb_release &>/dev/null; then
	    distro=$(lsb_release -si)
    elif [ -f /etc/os-release ]; then
	    distro=$(grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"' )
    else
	    distro="unknown"
    fi

    # Convert to lowercase
    distro="${distro,,}"

    case "$distro" in
	ubuntu|debian|kali)
        update_cmd="sudo apt update"
	    upgrade_cmd="sudo apt upgrade -y"
	    dist_upgrade_cmd="sudo apt dist-upgrade -y"
	    autoremove_cmd="sudo apt autoremove -y"
	    autoclean_cmd="sudo apt autoclean -y"
	    install_cmd="sudo apt install -y"
	    remove_cmd="sudo apt remove -y"
	    purge_cmd="sudo apt purge -y"
	    search_cmd="apt search"
	    check_broken_cmd="dpkg -l 2>/dev/null | grep -c '^iU\|^iF' 2>/dev/null | xargs"
	    check_security_cmd="apt list --upgradable 2>/dev/null | grep -i security | wc -l"
	    service_manager="systemctl"
	    service_list_cmd="systemctl list-units --type=service"
	    service_start_cmd="sudo systemctl start"
	    service_stop_cmd="sudo systemctl stop"
	    service_restart_cmd="sudo systemctl restart"
	    service_status_cmd="systemctl status"
	    service_enable_cmd="sudo systemctl enable"
	    service_disable_cmd="sudo systemctl disable"
	    ;;
	fedora)
        update_cmd="sudo dnf makecache -y"
        upgrade_cmd="sudo dnf upgrade -y"
        dist_upgrade_cmd="unknown" # Manual upgrade for major versions
        autoremove_cmd="sudo dnf autoremove -y"
        autoclean_cmd="sudo dnf clean all"
	    install_cmd="sudo dnf install -y"
	    remove_cmd="sudo dnf remove -y"
        purge_cmd="sudo dnf remove -y"
        search_cmd="dnf search"
	    check_broken_cmd="package-cleanup --problems 2>/dev/null | grep -c 'Problem' 2>/dev/null | xargs"
	    check_security_cmd="dnf updateinfo list security 2>/dev/null | grep -c 'security'"
	    service_manager="systemctl"
	    service_list_cmd="systemctl list-units --type=service"
	    service_start_cmd="sudo systemctl start"
	    service_stop_cmd="sudo systemctl stop"
	    service_restart_cmd="sudo systemctl restart"
	    service_status_cmd="systemctl status"
	    service_enable_cmd="sudo systemctl enable"
	    service_disable_cmd="sudo systemctl disable"
	    ;;
	centos|rhel)
        update_cmd="sudo yum makecache -y"
        upgrade_cmd="sudo yum update -y"
        dist_upgrade_cmd="unknown" # Manual upgrade for major versions
        autoremove_cmd="sudo yum autoremove -y"
        autoclean_cmd="sudo yum clean all"
	    install_cmd="sudo yum install -y"
	    remove_cmd="sudo yum remove -y"
        purge_cmd="sudo yum remove -y"
        search_cmd="yum search"
	    check_broken_cmd="package-cleanup --problems 2>/dev/null | grep -c 'Problem' 2>/dev/null | xargs"
	    check_security_cmd="yum updateinfo list security 2>/dev/null | grep -c 'security'"
	    service_manager="systemctl"
	    service_list_cmd="systemctl list-units --type=service"
	    service_start_cmd="sudo systemctl start"
	    service_stop_cmd="sudo systemctl stop"
	    service_restart_cmd="sudo systemctl restart"
	    service_status_cmd="systemctl status"
	    service_enable_cmd="sudo systemctl enable"
	    service_disable_cmd="sudo systemctl disable"
	    ;;
	arch|manjarolinux)
        update_cmd="sudo pacman -Sy"
        upgrade_cmd="sudo pacman -Syu"
        dist_upgrade_cmd="unknown" # Manual upgrade for major versions
        autoremove_cmd="sudo pacman -Rns"
        autoclean_cmd="sudo pacman -Sc"
	    install_cmd="sudo pacman -S --noconfirm"
	    remove_cmd="sudo pacman -R --noconfirm"
        purge_cmd="sudo pacman -Rns --noconfirm"
        search_cmd="pacman -Ss"
	    check_broken_cmd="pacman -Qk 2>&1 | grep -c 'warning' 2>/dev/null | xargs"
	    check_security_cmd="checkupdates 2>/dev/null | wc -l"
	    service_manager="systemctl"
	    service_list_cmd="systemctl list-units --type=service"
	    service_start_cmd="sudo systemctl start"
	    service_stop_cmd="sudo systemctl stop"
	    service_restart_cmd="sudo systemctl restart"
	    service_status_cmd="systemctl status"
	    service_enable_cmd="sudo systemctl enable"
	    service_disable_cmd="sudo systemctl disable"
	    ;;
	opensuse*|sles)
	    update_cmd="sudo zypper refresh"
        upgrade_cmd="sudo zypper update -y"
        dist_upgrade_cmd="sudo zypper dist-upgrade -y"
        autoremove_cmd="sudo zypper clean -a"
        autoclean_cmd="sudo zypper clean"
	    install_cmd="sudo zypper install -y"
	    remove_cmd="sudo zypper remove -y"
        purge_cmd="sudo zypper remove -y"
        search_cmd="zypper search"
	    check_broken_cmd="unknown"
	    check_security_cmd="zypper list-updates 2>/dev/null | tail -n +5 | wc -l"
	    service_manager="systemctl"
	    service_list_cmd="systemctl list-units --type=service"
	    service_start_cmd="sudo systemctl start"
	    service_stop_cmd="sudo systemctl stop"
	    service_restart_cmd="sudo systemctl restart"
	    service_status_cmd="systemctl status"
	    service_enable_cmd="sudo systemctl enable"
	    service_disable_cmd="sudo systemctl disable"
	    ;;
	*)
	    echo -e "${RED} ❌ Unsupported distro: $distro. Please edit the script manually. ${NC}"
	    exit 1
	    ;;
    esac
}

# Check if user has sudo rights
require_root() {
    if sudo -l -U "$USER" &>/dev/null; then
	    return 0
    else
	    echo -e "${RED} ❌ This tool must be run as root or with sudo rights.${NC}"
	    exit 1
    fi
}

# Check if dialog is installed or if it was already asked, else offer to install it
check_dialog() {
    if ! command -v dialog &>/dev/null && [ "$dialog_install_asked" -eq 0 ]; then
        echo
        echo -e "${YELLOW}⚠️  'dialog' is not installed. Interactive menus will look better!${NC}"
        echo -e "${CYAN}Would you like to install it now? [Y/n]${NC}"
        read -r install_choice
	dialog_install_asked=1
        
        if [[ "$install_choice" =~ ^[Yy]$ ]] || [[ -z "$install_choice" ]]; then
            echo -e "${CYAN}Installing dialog...${NC}"
            $install_cmd dialog
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✅ Dialog installed successfully!${NC}"
                setup_dialog_colors
                return 0
            else
                echo -e "${RED}❌ Failed to install dialog.${NC}"
                return 1
            fi
	else
	    return 1
        fi
    elif command -v dialog &>/dev/null; then
    	setup_dialog_colors
    	return 0
    else
    	return 1
    fi
}

check_installed() {
    if command -v "$1" &> /dev/null; then
        return 0
    else
	    return 1
    fi
}

# Dev Automation
mv_robohelp() {
    if sudo install -m 0755 /tmp/robohelp/robohelp.sh /usr/local/bin/robohelp; then
      echo -e "${GREEN}👽 robohelp distributed${NC}"
    else
      echo -e "${RED}👹 robohelp distribution failed.${NC}"
    fi
}

