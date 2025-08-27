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

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color - Always put in the end of every message

# Function to print banner
show_banner() {
    echo "$title"
    echo "$bb8"
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
	    update_cmd="sudo apt update -y"
	    upgrade_cmd="sudo apt upgrade -y"
	    dist_upgrade_cmd="sudo apt dist-upgrade -y"
	    autoremove_cmd="sudo apt autoremove -y"
	    autoclean_cmd="sudo apt autoclean -y"
	    install_cmd="sudo apt install -y"
	    remove_cmd="sudo apt remove -y"
	    purge_cmd="sudo apt purge -y"
	    search_cmd="apt search"
	    ;;
	fedora)
	    update_cmd="sudo dnf check-update"
            upgrade_cmd="sudo dnf upgrade -y"
            dist_upgrade_cmd="sudo dnf system-upgrade download --releasever=$(($(rpm -E %fedora)+1))"
            autoremove_cmd="sudo dnf autoremove -y"
            autoclean_cmd="sudo dnf clean all"
	    install_cmd="sudo dnf install -y"
	    remove_cmd="sudo dnf remove -y"
            purge_cmd="sudo dnf remove -y"
            search_cmd="dnf search"
	    ;;
	centos|rhel)
	    update_cmd="sudo yum check-update"
            upgrade_cmd="sudo yum update -y"
            dist_upgrade_cmd="unknown" # Manual upgrade for major versions
            autoremove_cmd="sudo yum autoremove -y"
            autoclean_cmd="sudo yum clean all"
	    install_cmd="sudo yum install -y"
	    remove_cmd="sudo yum remove -y"
            purge_cmd="sudo yum remove -y"
            search_cmd="yum search"
	    ;;
	arch|manjarolinux)
	    update_cmd="sudo pacman -Syu"
            upgrade_cmd="sudo pacman -Syu"
            dist_upgrade_cmd="unknown" # Manual upgrade for major versions
            autoremove_cmd="sudo pacman -Rns $(pacman -Qdtq)"
            autoclean_cmd="sudo pacman -Sc"
	    install_cmd="sudo pacman -S --noconfirm"
	    remove_cmd="sudo pacman -R --noconfirm"
            purge_cmd="sudo pacman -Rns --noconfirm"
            search_cmd="pacman -Ss"
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

# Main Functions
check_installed() {
    if command -v "$1" &> /dev/null; then
        return 0
    else
	return 1
    fi
}

package_update() {
    echo -e "${CYAN}📦 Running APT Repository update...${NC}"
    $update_cmd
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Updated repositories successfully on $distro.${NC}"
    else
	echo -e "${RED}❌ Failed to update repositories on $distro. Exit code: $? ${NC}"
    fi
}

package_upgrade() {
    echo -e "${CYAN}📦 Upgrading installed packages...${NC}"
    $upgrade_cmd
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Installed updates successfully on $distro.${NC}"
    else
        echo -e "${RED}❌ Failed to update packages on $distro. Exit code: $? ${NC}"
    fi
}

dist_upgrade() {
    echo -e "${CYAN}📦 Upgrading distribution and dependencies...${NC}"

    if [ "$dist_upgrade_cmd" = "unknown" ]; then
	echo -e "${BLUE}🛑 This command is not available for your distribution${NC}"
	return 1
    else
	$dist_upgrade_cmd
    fi

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Upgraded distribution successfully.${NC}"
    else
        echo -e "${RED}❌ Failed to upgrade $distro. Exit code: $? ${NC}"
    fi
}

package_autorm() {
    echo -e "${CYAN}👁  Are you sure?\n🧹 Removing unnecessary packages...${NC}"
    $autoremove_cmd
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Autoremove completed successfully on $distro.${NC}"
    else
        echo -e "${RED}❌ Autoremove failed on $distro. Exit code: $? ${NC}"
    fi
}

package_autocls() {
    echo -e "${CYAN}🧼 Cleaning up local repository...${NC}"
    $autoclean_cmd
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Autoclean completed successfully on $distro.${NC}"
    else
        echo -e "${RED}❌ Autoclean failed on $distro. Exit code: $? ${NC}"
    fi
}

package_install() {
    local package="$1"
    echo
    echo -e "${CYAN}📦 Installing package: $package${NC}"
    $install_cmd "$package"
    if [ $? -eq 0 ]; then
	echo -e "${GREEN}✅ $package installed successfully!${NC}"
    else
	echo -e "${RED}❌ Failed to install $package.${NC}"
    fi
}

package_remove() {
    local package="$1"
    echo
    echo -e "${CYAN}📦 Removing package: $package${NC}"
    $remove_cmd "$package"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ $package removed successfully!${NC}"
    else
        echo -e "${RED}❌ Failed to remove $package.${NC}"
    fi
}

package_purge() {
    local package="$1"
    echo
    echo -e "${CYAN}📦 Purging package: $package${NC}"
    $purge_cmd "$package"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ $package purged successfully!${NC}"
    else
        echo -e "${RED}❌ Failed to purge $package.${NC}"
    fi
}

package_search() {
    local term="$1"
    echo -e "${BLUE}🔍 Searching for: $term${NC}"
    $search_cmd "$term"
}


full_upgrade() {
    echo -e "${CYAN}⚙  Running full upgrade...!${NC}"
    package_update && \
    package_upgrade && \
    package_autorm && \
    package_autocls && \
    echo -e "${GREEN}✅ Full upgrade completed successfully!${NC}" || \
    echo -e "${GREEN}❌ An error occurred during the upgrade. Exit code: $? ${NC}"
}

# Dev Automation
mv_robohelp() {
    sudo cp ~/clone/robohelp/src/robohelp.sh /usr/local/bin/robohelp && echo -e "${GREEN}👽 robohelp distributed${NC}" || "${RED}👹 robohelp distribution failed.${NC}"
}

find_playbook() {
    mapfile -t playbooks < <(find . -type f -name "*.yml")
    loop=-1
    for playbook in "${playbooks[@]}"; do
        ((loop++))
        dir_path=$(dirname "$playbook")
        file_name=$(basename "$playbook")
        printf '[%d] %s\n%s\n\n' "$loop" "$dir_path" "$file_name"
    done
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
    ansible all -i hosts.* -m ping && log_actions "ping" || log_actions "pingfail"
}

run_playbook() {
    echo -e "${CYAN} Which playbook would you like to run? [e.g. 1 remove]${NC}"
    echo -e "${CYAN}<----------------------------------------------------->${NC}"
    read -r selected_index additional_flags
    echo

    if ! [[ "$selected_index" =~ ^[0-9]+$ ]] || [ "$selected_index" -ge "${#playbooks[@]}" ]; then
	echo -e "${RED} Invalid playbook selection.${NC}"
	return 1
    fi

    echo -e "${CYAN} Do you use Ansible Vault? [Yes | No]${NC}"
    echo -e "${CYAN}<------------------------------------>${NC}"
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

    playbook="$(basename "${playbooks[$selected_index]}")"
    extra_vars=()

    # Only set extra_vars if flags are non-empty
    if [ -n "$additional_flags" ];  then
	extra_vars=(--extra-vars "action=$additional_flags")
    else
	extra_vars=""
    fi

    echo -e "${CYAN}🚀 Running playbook: $playbook${NC}"
    echo -e "${CYAN}🚩 Flags: ${vault_flag} $extra_vars${NC}"
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
    # Is always executed
    find_playbook

    if [ "$1" = "run" ]; then
        run_playbook
    fi
}

live_fire() {
    echo
    echo -e "${CYAN} Which Command would you like to Live-Fire?${NC}"
    echo -e "${CYAN}<------------------------------------------>${NC}"
    read -r live_fire_command
    echo

    echo -e "${CYAN} Which hosts should be targeted?${NC}"
    echo -e "${CYAN}<------------------------------->${NC}"
    echo -e "${YELLOW}> [1] All${NC}"
    echo -e "${YELLOW}> [2] Write Own (Single host or host groups)${NC}"
    echo

    read -r live_fire_target

    case "${live_fire_target}" in
	1)
	    ansible -i hosts.yml all -m shell -a "${live_fire_command}"
	    ;;
	2)
	    echo -e "${CYAN} Enter host or group (e.g. webservers, nagios):${NC}"
	    echo -e "${CYAN}<---------------------------------------------->${NC}"
	    echo
	    read -r custom_target

	    ansible -i hosts.yml "${custom_target}" -m shell -a "${live_fire_command}"
	    ;;
	*)
	    echo -e "${RED}Invalid option selected. Aborting.${NC}"
	    ;;
    esac
}

# Ansible Fast Management [AFM]
ansible_deploy() {
    check_installed "ansible" ||  { echo -e "${RED}❌ Ansible is not installed. Install with robohelp -pi ansible-core. Or via pip install ansible${NC}"; exit 1; }

    echo
    echo -e "${CYAN} Welcome to the AFM - Ansible Fast Management${NC}"
    echo -e "${CYAN}<-------------------------------------------->${NC}"
    echo
    echo -e "${YELLOW}> [1] Run Playbook (with Flags)${NC}"
    echo -e "${YELLOW}> [2] Test Connection (Ping Hosts)${NC}"
    echo -e "${YELLOW}> [3] Live-Fire Command${NC}"
    echo -e "${YELLOW}> [4] View Inventory${NC}"
    echo -e "${YELLOW}> [5] View Last Run Log${NC}"
    echo -e "${YELLOW}> [6] Exit${NC}"
    echo

    read -r option

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
		playbook_actions
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
    require_root
    echo

	# Parse command-line flags
	case "$1" in
	    -pud|--p-update)
		package_update
		;;
	    -pur|--p-upgrade)
		package_upgrade
		;;
	    -arm|--p-autoremove)
		package_autorm
		;;
	    -acl|--p-autoclean)
		package_autocls
		;;
	    -fu|--full-upgrade)
		full_upgrade
		;;
	    -dur|--dist-upgrade)
		dist_upgrade
		;;
	    -dx)
		mv_robohelp
		;;
        -pi|--p-install|-prm|--p-remove|-pp|--p-purge|-ps|--p-search)
        action="$1"
        shift
        if [ $# -eq 0 ]; then
            echo -e "${RED}❌ No packages specified to do ${action#--p-}.${NC}"
            exit 1
        fi

        for arg in "$@"; do
            case "$action" in
                -pi|--p-install) package_install "$arg" ;;
                -prm|--p-remove) package_remove "$arg" ;;
                -pp|--p-purge)   package_purge "$arg" ;;
                -ps|--p-search)  package_search "$arg" ;;
            esac
        done
        ;;
	    -A|--ansible)
		ansible_deploy
		;;
	    -h|--help)
		echo
		echo "Usage: robohelp [option]"
		echo "	-pud, --p-update	[1] Update Package Repositories"
		echo "	-pur, --p-upgrade 	[1] Upgrade installed packages"
		echo "	-arm, --p-autoremove  	[1] Remove unnecessary packages"
		echo "	-acl, --p-autoclean	[1] Clean up local repository"
		echo "	-fu,  --full-upgrade	Run full system upgrade with options from [1]"
		echo
		echo "	-dur, --dist-upgrade	Run distribution update for system"
		echo
		echo "	-pi,  --p-install 	<name>	Install package from repository"
		echo "	-ps,  --p-search 	<name>	Search package in repository"
		echo " 	-prm, --p-remove	<name>	Remove package from system"
		echo "	-pp,  --p-purge		<name>	Remove package with all its dependencies"
		echo
		echo "	-A,   --ansible		Ansible Fast Management"
		echo "	-h,   --help		Show this help message"
		;;
	    *)
		echo
		echo -e "${RED} ❌ Unknown or no flag provided. Try -h for help.${NC}"
		;;
	esac
}

# Call the main function
main "$@"
