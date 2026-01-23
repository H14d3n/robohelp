#!/bin/bash

read -r -d '' title <<'EOF'
┌──────────────────────────────────────────────────┐
│		_	    _	       _	   │
│     _ __ ___ | |__   ___ | |__   ___| |____      │
│    | '__/ _ \| '_ \ / _ \| '_ \ / _ \ | '_ \     │
│    | | | (_) | |_) | (_) | | | |  __/ | |_) |    │
│    |_|  \___/|_.__/ \___/|_| |_|\___|_| .__/     │
│                                       |_|        │
│						   │
└──────────────────────────────────────────────────┘
EOF

bb8='⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣀⣸⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠴⠾⠿⠿⠿⠛⠋⠁⠀⣠⣴⠆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣄⣀⣀⣀⣀⣀⣤⣤⣴⠶⠛⢋⣡⣴⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⣬⣉⣉⣉⣉⡟⣁⠀⠀⠈⠙⣿⣿⣿⣿⣿⣿⣿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⡀⠛⠀⠀⠀⠀⣿⣿⠋⠉⠙⢿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣷⣄⡀⠀⣀⣴⣿⣇⠀⠀⠀⣸⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣤⡴⠟⠛⣁⠤⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⠛⠛⣉⣡⠤⠒⠋⠁⢀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠤⠬⣉⣉⣉⣉⣠⠤⠤⠤⠴⠒⠚⠉⠁⠀⠀⠀⣤⣾⣿⣿⣿⣶⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣶⣦⣤⣤⣤⣤⣤⣤⣤⣤⣴⣶⣶⣦⡀⠀⠈⠙⢿⣿⠋⠛⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⠿⠛⠉⠉⠉⠉⠉⠛⠿⣿⣿⣿⣿⣿⣿⣿⣦⣄⠀⠀⠀⠀⠀⢿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⠟⠁⢀⣠⣤⣤⣤⣄⡀⠀⠀⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿⣶⣤⣀⠀⠀⠀⠉⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⠃⠀⣴⣿⣿⣿⣿⣿⠟⠀⢀⡀⠀⠀⠙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣦⣤⣀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⠇⠀⠀⢹⣿⣿⣿⣿⣿⣤⣴⣿⣿⡄⠀⠀⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⠀⣿⣦⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠟⠛⠻⠿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣧⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⢿⣿⡿⠀⠀⠀⣾⣿⣿⣿⣿⣿⣿⣿⣿⠟⠋⠀⠀⠀⠀⠀⠀⠘⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⡀⠸⣿⡿⢿⣿⣿⣿⣿⣿⣄⠀⠈⠁⠀⠀⢀⣿⣿⣿⣿⣿⣿⣿⠟⠁⠀⠀⠀⣠⣤⣶⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣧⠀⠙⠀⢰⣿⣿⣿⣿⣿⣿⡷⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⡟⠁⠀⠀⣠⡀⠀⢻⣿⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣷⡀⠀⠘⠛⠿⠿⠿⠛⠉⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⠏⠀⠀⢀⣴⣿⣷⣤⣼⣿⣿⣿⣠⠆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣦⣄⡀⠀⠀⠀⠀⠀⠀⣠⣴⣿⣿⣿⣿⣿⣿⡏⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⣿⣿⣿⣷⣶⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⣾⣿⣿⣿⣿⣿⣿⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠘⠛⠛⣹⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⢠⣶⣿⣿⣿⡿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠀⠀⠈⠻⠿⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠙⠛⠛⠛⠛⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀'

# Variable Declaration
VERSION="2.0.0"
GITHUB_REPO="h14d3n/robohelp"
GITHUB_RAW_URL="https://raw.githubusercontent.com/${GITHUB_REPO}/main/src/robohelp.sh"
INSTALL_PATH="/usr/local/bin/robohelp"
timestamp=$(date "+%Y-%m-%d %H:%M:%S")

install_cmd=""
update_cmd=""
upgrade_cmd=""
dist_upgrade_cmd=""
autoremove_cmd=""
autoclean_cmd=""
remove_cmd=""
purge_cmd=""
search_cmd=""
check_broken_cmd=""
check_security_cmd=""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[0;36m'
INVERT='\033[7m'
NC='\033[0m' # No Color - Always put in the end of every message

# Function to print banner
show_banner() {
    echo "$title"
    echo "$bb8"
    echo -e "${CYAN}Version: $VERSION${NC}"
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

# Configure dialog colors for a sleek black theme
setup_dialog_colors() {
    export DIALOGRC="${TMPDIR:-/tmp}/.robohelp_dialogrc"
    cat > "$DIALOGRC" <<'DIALOGEOF'
# RoboHelp Dialog Color Theme - Sleek Black
use_shadow = ON
use_colors = ON

# Screen colors (background)
screen_color = (CYAN,BLACK,ON)

# Shadow color
shadow_color = (BLACK,BLACK,ON)

# Dialog box
dialog_color = (WHITE,BLUE,ON)

# Dialog box title
title_color = (CYAN,BLUE,ON)

# Dialog box border
border_color = (CYAN,BLUE,ON)
border2_color = (CYAN,BLUE,ON)

# Button colors
button_active_color = (WHITE,CYAN,ON)
button_inactive_color = (CYAN,BLUE,ON)
button_key_active_color = (WHITE,CYAN,ON)
button_key_inactive_color = (RED,BLUE,ON)
button_label_active_color = (WHITE,CYAN,ON)
button_label_inactive_color = (CYAN,BLUE,ON)

# Input box colors
inputbox_color = (WHITE,BLUE,ON)
inputbox_border_color = (CYAN,BLUE,ON)
inputbox_border2_color = (CYAN,BLUE,ON)

# Search box
searchbox_color = (WHITE,BLUE,ON)
searchbox_title_color = (CYAN,BLUE,ON)
searchbox_border_color = (CYAN,BLUE,ON)
searchbox_border2_color = (CYAN,BLUE,ON)

# Position indicator
position_indicator_color = (CYAN,BLUE,ON)

# Menu box
menubox_color = (WHITE,BLUE,ON)
menubox_border_color = (CYAN,BLUE,ON)
menubox_border2_color = (CYAN,BLUE,ON)

# Menu item
item_color = (WHITE,BLUE,ON)
item_selected_color = (WHITE,CYAN,ON)

# Tag (menu item label)
tag_color = (CYAN,BLUE,ON)
tag_selected_color = (WHITE,CYAN,ON)
tag_key_color = (YELLOW,BLUE,ON)
tag_key_selected_color = (YELLOW,CYAN,ON)

# Check box
check_color = (WHITE,BLUE,ON)
check_selected_color = (WHITE,CYAN,ON)

# Up/down arrow
uarrow_color = (CYAN,BLUE,ON)
darrow_color = (CYAN,BLUE,ON)

# Item help text
itemhelp_color = (WHITE,BLUE,ON)

# Form
form_active_text_color = (WHITE,CYAN,ON)
form_text_color = (WHITE,BLUE,ON)
form_item_readonly_color = (CYAN,BLUE,ON)

# Gauge (progress bar)
gauge_color = (CYAN,BLACK,ON)
DIALOGEOF
}

# Check if dialog is installed and offer to install it
check_dialog() {
    if ! command -v dialog &>/dev/null; then
        echo
        echo -e "${YELLOW}⚠️  'dialog' is not installed. Interactive menus will look better!${NC}"
        echo -e "${CYAN}Would you like to install it now? [Y/n]${NC}"
        read -r install_choice
        
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
    fi
    setup_dialog_colors
    return 0
}

# Main Functions
check_installed() {
    if command -v "$1" &> /dev/null; then
        return 0
    else
	    return 1
    fi
}

package_management() {
    
    if ! check_dialog; then
        # Fallback to old menu
        echo
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${CYAN}📦 Package Management${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
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
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}📦 Updating package metadata...${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
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
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}📦 Upgrading installed packages...${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
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
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}📦 Upgrading distribution and dependencies...${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

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
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}👁  Are you sure?${NC}"
    echo -e "${CYAN}🧹 Removing unnecessary packages...${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
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
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}🧼 Cleaning up local repository...${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
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
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}📦 Installing package: ${YELLOW}$package${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
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
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}📦 Removing package: ${YELLOW}$package${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
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
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}📦 Purging package: ${YELLOW}$package${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
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
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}🔍 Searching for: ${YELLOW}$term${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    $search_cmd "$term"
    echo
}

full_upgrade() {
    echo
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}⚙  Running full upgrade...!${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    package_update && \
    package_upgrade && \
    package_autorm && \
    package_autocls && \
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" && \
    echo -e "${GREEN}✅ Full upgrade completed successfully!${NC}" && \
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" || \
    echo -e "${RED}❌ An error occurred during the upgrade. Exit code: $? ${NC}"
    echo
}

# Dev Automation
mv_robohelp() {
    if sudo cp ~/clone/robohelp/src/robohelp.sh /usr/local/bin/robohelp; then
      echo -e "${GREEN}👽 robohelp distributed${NC}"
    else
      echo -e "${RED}👹 robohelp distribution failed.${NC}"
    fi
}

system_config() {
    
    if ! check_dialog; then
        # Fallback to old menu
        echo
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${CYAN}⚙️  System Configuration${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo
        echo -e "${YELLOW}  [1] SSH Configuration${NC}"
        echo -e "${YELLOW}  [2] System Health Check${NC}"
        echo -e "${YELLOW}  [3] Network Diagnostics${NC}"
        echo -e "${YELLOW}  [4] Exit${NC}"
        echo
        read -r sys_option
    else
        sys_option=$(dialog --backtitle "RoboHelp v$VERSION" \
            --title "⚙️  System Configuration" \
            --menu "Choose an option:" 11 60 3 \
            "1" "SSH Configuration" \
            "2" "System Health Check" \
            "3" "Network Diagnostics" \
            2>&1 >/dev/tty)
        clear -x    
        [ $? -ne 0 ] && return 0
    fi

    case "${sys_option}" in
        1)
            ssh_config
            ;;
        2)
            health_check
            ;;
        3)
            network_diagnostics
            ;;
        4)
            return 0
            ;;
        *)
            echo -e "${RED}Invalid option selected. Aborting.${NC}"
            ;;
    esac
}

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
                if ! find_ssh_commands; then
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
                        echo -e "${CYAN} Available SSH commands:${NC}"
                        echo -e "${CYAN}<──────────────────────>${NC}"
                        echo
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
            echo -e "${RED}Invalid option selected. Aborting.${NC}"
            ;;
    esac
}

find_ssh_commands() {
    if [ ! -f ~/.ssh/.robohelp_lsc.txt ]; then
        echo -e "${RED}⚠️  No previous SSH commands found.${NC}"
        echo
        return 1
    fi

    mapfile -t ssh_commands < ~/.ssh/.robohelp_lsc.txt

    if [ ${#ssh_commands[@]} -eq 0 ]; then
        echo -e "${YELLOW}⚠️  No SSH commands found in history.${NC}"
        return 1
    fi

    loop=-1
    for command in "${ssh_commands[@]}"; do
        ((loop++))
        printf '[%d] ssh %s\n\n' "$loop" "$command"
    done
    return 0
}

# System Health Check
health_check() {
    echo
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}🏥 System Health Check${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
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

    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}✅ Health check completed${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo
}

network_diagnostics() {

    if ! check_dialog; then
        # Fallback to old menu
        echo
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
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
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
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
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
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
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
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
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
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
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
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
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
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

disk_management() {

    if ! check_dialog; then
        echo
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${CYAN} Welcome to Disk Management${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo
        echo -e "${YELLOW}  [1] Disk Usage by Directory${NC}"
        echo -e "${YELLOW}  [2] Find Largest Files${NC}"
        echo -e "${YELLOW}  [3] Clean Package Cache${NC}"
        echo -e "${YELLOW}  [4] Clean Journal Logs${NC}"
        echo -e "${YELLOW}  [5] Empty Trash${NC}"
        echo -e "${YELLOW}  [6] Find Duplicate Files${NC}"
        echo -e "${YELLOW}  [7] Mount/Unmount Drives${NC}"
        echo -e "${YELLOW}  [8] Exit${NC}"
        echo
        read -r disk_option
    else
        disk_option=$(dialog --clear --backtitle "RoboHelp v$VERSION" \
            --title "💽 Disk Management" \
            --menu "Choose an option:" 15 60 7 \
            "1" "Disk Usage by Directory" \
            "2" "Find Largest Files" \
            "3" "Clean Package Cache" \
            "4" "Clean Journal Logs" \
            "5" "Empty Trash" \
            "6" "Find Duplicate Files" \
            "7" "Mount/Unmount Drives" \
            2>&1 >/dev/tty)

        dialog_exit=$?
        clear -x    
        [ $dialog_exit -ne 0 ] && return 0
    fi

    disk_usage_by_directory() {
        echo
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${CYAN}📊 Disk Usage by Directory${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo
        
        if command -v dialog &>/dev/null; then
            target_dir=$(dialog --backtitle "RoboHelp v$VERSION" \
                --title "Disk Usage" \
                --inputbox "Enter directory path (default: current directory):" 10 60 "$PWD" \
                2>&1 >/dev/tty)
            dialog_exit=$?
            clear -x    
            [ $dialog_exit -ne 0 ] && return 0
        else
            echo -e "${YELLOW}Enter directory path (default: current directory):${NC}"
            read -r target_dir
            [ -z "$target_dir" ] && target_dir="$PWD"
        fi
        
        if [ ! -d "$target_dir" ]; then
            echo -e "${RED}❌ Directory not found: $target_dir${NC}"
            return 1
        fi
        
        echo -e "${CYAN}Analyzing disk usage in: $target_dir${NC}"
        echo
        
        if command -v du &>/dev/null; then
            du -h --max-depth=1 "$target_dir" 2>/dev/null | sort -hr | head -20
        else
            echo -e "${RED}❌ 'du' command not found${NC}"
        fi
        echo
    }

    find_largest_files() {
        echo
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${CYAN}📁 Find Largest Files${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo
        
        if command -v dialog &>/dev/null; then
            search_dir=$(dialog --backtitle "RoboHelp v$VERSION" \
                --title "Find Largest Files" \
                --inputbox "Enter directory to search (default: current directory):" 10 60 "$PWD" \
                2>&1 >/dev/tty)
            dialog_exit=$?
            clear -x
            [ $dialog_exit -ne 0 ] && return 0
            
            num_files=$(dialog --backtitle "RoboHelp v$VERSION" \
                --title "Find Largest Files" \
                --inputbox "How many files to show? (default: 20):" 10 60 "20" \
                2>&1 >/dev/tty)
            dialog_exit=$?
            clear -x
            [ $dialog_exit -ne 0 ] && return 0
        else
            echo -e "${YELLOW}Enter directory to search (default: current directory):${NC}"
            read -r search_dir
            [ -z "$search_dir" ] && search_dir="$PWD"
            
            echo -e "${YELLOW}How many files to show? (default: 20):${NC}"
            read -r num_files
            [ -z "$num_files" ] && num_files=20
        fi
        
        if [ ! -d "$search_dir" ]; then
            echo -e "${RED}❌ Directory not found: $search_dir${NC}"
            return 1
        fi
        
        echo -e "${CYAN}Searching for largest files in: $search_dir${NC}"
        echo -e "${YELLOW}This may take a while...${NC}"
        echo
        
        if command -v find &>/dev/null; then
            find "$search_dir" -type f -exec du -h {} + 2>/dev/null | sort -hr | head -n "$num_files"
        else
            echo -e "${RED}❌ 'find' command not found${NC}"
        fi
        echo
    }

    clean_package_cache() {
        echo
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${CYAN}🧹 Clean Package Cache${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo
        
        echo -e "${YELLOW}Current cache usage:${NC}"
        
        if [ -d "/var/cache/apt/archives" ]; then
            apt_cache=$(du -sh /var/cache/apt/archives 2>/dev/null | cut -f1)
            echo -e "${CYAN}APT cache: ${apt_cache:-Unknown}${NC}"
        fi
        
        if [ -d "/var/cache/pacman/pkg" ]; then
            pacman_cache=$(du -sh /var/cache/pacman/pkg 2>/dev/null | cut -f1)
            echo -e "${CYAN}Pacman cache: ${pacman_cache:-Unknown}${NC}"
        fi
        
        if [ -d "/var/cache/dnf" ]; then
            dnf_cache=$(du -sh /var/cache/dnf 2>/dev/null | cut -f1)
            echo -e "${CYAN}DNF cache: ${dnf_cache:-Unknown}${NC}"
        fi
        
        echo
        echo -e "${YELLOW}Do you want to clean the package cache? [y/N]${NC}"
        read -r confirm
        
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            if command -v apt-get &>/dev/null; then
                echo -e "${CYAN}Cleaning APT cache...${NC}"
                sudo apt-get clean
                sudo apt-get autoclean
            fi
            
            if command -v pacman &>/dev/null; then
                echo -e "${CYAN}Cleaning Pacman cache...${NC}"
                sudo pacman -Sc --noconfirm
            fi
            
            if command -v dnf &>/dev/null; then
                echo -e "${CYAN}Cleaning DNF cache...${NC}"
                sudo dnf clean all
            fi
            
            echo -e "${GREEN}✅ Package cache cleaned${NC}"
        else
            echo -e "${YELLOW}Cancelled${NC}"
        fi
        echo
    }

    clean_journal_logs() {
        echo
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${CYAN}📝 Clean Journal Logs${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo
        
        if command -v journalctl &>/dev/null; then
            echo -e "${YELLOW}Current journal size:${NC}"
            journalctl --disk-usage
            echo
            
            if command -v dialog &>/dev/null; then
                retention=$(dialog --backtitle "RoboHelp v$VERSION" \
                    --title "Clean Journal Logs" \
                    --menu "Keep logs for how long?" 14 60 5 \
                    "1" "2 days" \
                    "2" "1 week" \
                    "3" "2 weeks" \
                    "4" "1 month" \
                    2>&1 >/dev/tty)
                dialog_exit=$?
                clear -x    
                [ $dialog_exit -ne 0 ] && return 0
            else
                echo -e "${YELLOW}Keep logs for:${NC}"
                echo "  [1] 2 days"
                echo "  [2] 1 week"
                echo "  [3] 2 weeks"
                echo "  [4] 1 month"
                echo "  [5] Cancel"
                read -r retention
            fi
            
            case "$retention" in
                1) time="2d" ;;
                2) time="1w" ;;
                3) time="2w" ;;
                4) time="1M" ;;
                5|*) echo -e "${YELLOW}Cancelled${NC}"; return 0 ;;
            esac
            
            echo -e "${CYAN}Cleaning logs older than $time...${NC}"
            sudo journalctl --vacuum-time="$time"
            echo
            echo -e "${GREEN}✅ Journal logs cleaned${NC}"
        else
            echo -e "${RED}❌ journalctl not found (systemd not available)${NC}"
        fi
        echo
    }

    empty_trash() {
        echo
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${CYAN}🗑️  Empty Trash${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo
        
        trash_dirs=(
            "$HOME/.local/share/Trash"
            "$HOME/.Trash"
        )
        
        total_size=0
        for trash_dir in "${trash_dirs[@]}"; do
            if [ -d "$trash_dir" ]; then
                size=$(du -sb "$trash_dir" 2>/dev/null | cut -f1)
                if [ -n "$size" ] && [ "$size" -gt 0 ]; then
                    human_size=$(du -sh "$trash_dir" 2>/dev/null | cut -f1)
                    echo -e "${CYAN}Trash location: $trash_dir (${human_size})${NC}"
                    total_size=$((total_size + size))
                fi
            fi
        done
        
        if [ "$total_size" -eq 0 ]; then
            echo -e "${GREEN}✅ Trash is already empty${NC}"
            echo
            return 0
        fi
        
        echo
        echo -e "${YELLOW}Do you want to empty the trash? [y/N]${NC}"
        read -r confirm
        
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            for trash_dir in "${trash_dirs[@]}"; do
                if [ -d "$trash_dir" ]; then
                    echo -e "${CYAN}Emptying: $trash_dir${NC}"
                    rm -rf "${trash_dir:?}"/* 2>/dev/null
                fi
            done
            echo -e "${GREEN}✅ Trash emptied${NC}"
        else
            echo -e "${YELLOW}Cancelled${NC}"
        fi
        echo
    }

    find_duplicate_files() {
        echo
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${CYAN}🔍 Find Duplicate Files${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo
        
        if ! command -v fdupes &>/dev/null; then
            echo -e "${YELLOW}⚠️  'fdupes' is not installed${NC}"
            echo -e "${CYAN}Install with: robohelp -pi fdupes${NC}"
            echo
            return 1
        fi
        
        if command -v dialog &>/dev/null; then
            search_dir=$(dialog --backtitle "RoboHelp v$VERSION" \
                --title "Find Duplicates" \
                --inputbox "Enter directory to search:" 10 60 "$HOME" \
                2>&1 >/dev/tty)
            dialog_exit=$?
            clear -x    
            [ $dialog_exit -ne 0 ] && return 0
        else
            echo -e "${YELLOW}Enter directory to search (default: $HOME):${NC}"
            read -r search_dir
            [ -z "$search_dir" ] && search_dir="$HOME"
        fi
        
        if [ ! -d "$search_dir" ]; then
            echo -e "${RED}❌ Directory not found: $search_dir${NC}"
            return 1
        fi
        
        echo -e "${CYAN}Searching for duplicate files in: $search_dir${NC}"
        echo -e "${YELLOW}This may take a while...${NC}"
        echo
        
        fdupes -r "$search_dir"
        echo
    }

    mount_unmount_drives() {
        echo
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${CYAN}💾 Mount/Unmount Drives${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo
        
        if command -v dialog &>/dev/null; then
            mount_action=$(dialog --backtitle "RoboHelp v$VERSION" \
                --title "Mount/Unmount Drives" \
                --menu "Choose an action:" 12 60 4 \
                "1" "List Mounted Drives" \
                "2" "Mount a Drive" \
                "3" "Unmount a Drive" \
                2>&1 >/dev/tty)
            dialog_exit=$?
            clear -x
            [ $dialog_exit -ne 0 ] && return 0
        else
            echo -e "${YELLOW}Choose an action:${NC}"
            echo "  [1] List Mounted Drives"
            echo "  [2] Mount a Drive"
            echo "  [3] Unmount a Drive"
            echo "  [4] Cancel"
            echo
            read -r mount_action
        fi
        
        case "$mount_action" in
            1)
                echo -e "${CYAN}Currently Mounted Drives:${NC}"
                echo
                if command -v lsblk &>/dev/null; then
                    lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,FSTYPE
                else
                    mount | column -t
                fi
                echo
                ;;
            2)
                # Mount a drive
                echo -e "${CYAN}Available Block Devices:${NC}"
                echo
                if command -v lsblk &>/dev/null; then
                    lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,FSTYPE
                else
                    fdisk -l 2>/dev/null | grep -E '^/dev/'
                fi
                echo
                
                if command -v dialog &>/dev/null; then
                    device=$(dialog --backtitle "RoboHelp v$VERSION" \
                        --title "Mount Drive" \
                        --inputbox "Enter device to mount (e.g., /dev/sdb1):" 10 60 \
                        2>&1 >/dev/tty)
                    dialog_exit=$?
                    clear -x
                    [ $dialog_exit -ne 0 ] && return 0
                    
                    mount_point=$(dialog --backtitle "RoboHelp v$VERSION" \
                        --title "Mount Drive" \
                        --inputbox "Enter mount point (e.g., /mnt/usb):" 10 60 \
                        2>&1 >/dev/tty)
                    dialog_exit=$?
                    clear -x
                    [ $dialog_exit -ne 0 ] && return 0
                else
                    echo -e "${YELLOW}Enter device to mount (e.g., /dev/sdb1):${NC}"
                    read -r device
                    
                    echo -e "${YELLOW}Enter mount point (e.g., /mnt/usb):${NC}"
                    read -r mount_point
                fi
                
                if [ -z "$device" ] || [ -z "$mount_point" ]; then
                    echo -e "${RED}❌ Device and mount point cannot be empty${NC}"
                    return 1
                fi
                
                if [ ! -b "$device" ]; then
                    echo -e "${RED}❌ Device not found: $device${NC}"
                    return 1
                fi
                
                # Create mount point if it doesn't exist
                if [ ! -d "$mount_point" ]; then
                    echo -e "${CYAN}Creating mount point: $mount_point${NC}"
                    sudo mkdir -p "$mount_point"
                fi
                
                echo -e "${CYAN}Mounting $device to $mount_point...${NC}"
                if sudo mount "$device" "$mount_point"; then
                    echo -e "${GREEN}✅ Successfully mounted $device to $mount_point${NC}"
                else
                    echo -e "${RED}❌ Failed to mount $device${NC}"
                fi
                echo
                ;;
            3)
                # Unmount a drive
                echo -e "${CYAN}Currently Mounted Drives:${NC}"
                echo
                if command -v lsblk &>/dev/null; then
                    lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,FSTYPE | grep -v "^$"
                else
                    mount | column -t
                fi
                echo
                
                if command -v dialog &>/dev/null; then
                    unmount_target=$(dialog --backtitle "RoboHelp v$VERSION" \
                        --title "Unmount Drive" \
                        --inputbox "Enter device or mount point to unmount:" 10 60 \
                        2>&1 >/dev/tty)
                    dialog_exit=$?
                    clear -x
                    [ $dialog_exit -ne 0 ] && return 0
                else
                    echo -e "${YELLOW}Enter device or mount point to unmount:${NC}"
                    read -r unmount_target
                fi
                
                if [ -z "$unmount_target" ]; then
                    echo -e "${RED}❌ Target cannot be empty${NC}"
                    return 1
                fi
                
                echo -e "${CYAN}Unmounting $unmount_target...${NC}"
                if sudo umount "$unmount_target"; then
                    echo -e "${GREEN}✅ Successfully unmounted $unmount_target${NC}"
                else
                    echo -e "${RED}❌ Failed to unmount $unmount_target${NC}"
                    echo -e "${YELLOW}Tip: Check if any processes are using the mount point${NC}"
                fi
                echo
                ;;
            4|*)
                echo -e "${YELLOW}Cancelled${NC}"
                return 0
                ;;
        esac
    }

    case "${disk_option}" in
        1)
            disk_usage_by_directory
            ;;
        2)
            find_largest_files
            ;;
        3)
            clean_package_cache
            ;;
        4)
            clean_journal_logs
            ;;
        5)
            empty_trash
            ;;
        6)
            find_duplicate_files
            ;;
        7)
            mount_unmount_drives
            ;;
        8)
            exit 0
            ;;
        *)
            echo "Unsupported option"
            ;;
    esac
}

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

main() {
    show_banner
    det_release
    echo
    
    # Check for updates (pass all arguments to handle re-execution)
    # check_and_update "$@"

	# Parse command-line flags
	case "$1" in
	    -pm|--package-management)
        require_root
		package_management
		;;
	    -sc|--system-config)
		system_config
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
	    -A|--ansible)
		    ansible_deploy
		    ;;
	    -h|--help)
		    echo
		    echo "Usage: robohelp [option]"
		echo
		echo -e "${CYAN}🎯 Main Menus:${NC}"
		echo "	-pm,  --package-management	Interactive package management menu"
		echo "	-sc,  --system-config		Interactive system configuration menu"
		echo "	-A,   --ansible			Ansible Fast Management (AFM)"
		echo
		echo -e "${CYAN}📦 Package Management (Quick Commands):${NC}"
		echo "	-pud, --p-update		Update Package Repositories [1]"
		echo "	-pur, --p-upgrade		Upgrade installed packages [1]"
		echo "	-arm, --p-autoremove		Remove unnecessary packages [1]"
		echo "	-acl, --p-autoclean		Clean up local repository [1]"
		echo "	-fu,  --full-upgrade		Run full system upgrade with options [1]"
		echo "	-dur, --dist-upgrade		Run distribution upgrade"
		echo "	-pi,  --p-install <name>	Install package(s)"
		echo "	-ps,  --p-search <name>		Search package(s)"
		echo "	-prm, --p-remove <name>		Remove package(s)"
		echo "	-pp,  --p-purge <name>		Purge package(s) with dependencies"
		echo
		echo -e "${CYAN}⚙️  System Tools (Quick Commands):${NC}"
		echo "	-ssh, --ssh-settings		SSH configuration menu"
		echo "	-hc,  --health-check		Run system health check"
		echo "	-nd,  --network-diag		Network diagnostics menu"
		echo "	-dm,  --disk-management		Disk management menu"
		echo -e "${CYAN}ℹ️  Information:${NC}"
		echo "	-h,   --help			Show this help message"
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
