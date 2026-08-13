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
                    echo -e "${YELLOW}Press any key to continue...${NC}"
                    read -n 1 -s -r
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
                    echo -e "${YELLOW}Press any key to continue...${NC}"
                    read -n 1 -s -r
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
            echo -e "${RED}Invalid option selected.${NC}"
            ;;
    esac
}

