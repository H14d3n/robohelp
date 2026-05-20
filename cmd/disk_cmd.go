//┌──────────────────────────────────────────────────┐
//│               _           _          _           │
//│     _ __ ___ | |__   ___ | |__   ___| |____      │
//│    | '__/ _ \| '_ \ / _ \| '_ \ / _ \ | '_ \     │
//│    | | | (_) | |_) | (_) | | | |  __/ | |_) |    │
//│    |_|  \___/|_.__/ \___/|_| |_|\___|_| .__/     │
//│                                       |_|        │
//│                                                  │
//└──────────────────────────────────────────────────┘

// V 3.0.0
// H14d3n

package cmd

import (
	"fmt"
	"os"
	"path/filepath"

	"github.com/h14d3n/robohelp/internal/pkgmgr"
)

func runDiskManagement() {
	switch menuChoice("💽 Disk Management", []string{
		"Disk Usage by Directory",
		"Find Largest Files",
		"Clean Package Cache",
		"Clean Journal Logs",
		"Empty Trash",
		"Find Duplicate Files",
		"Mount/Unmount Drives",
		"Exit",
	}) {
	case "1":
		diskUsageByDirectory()
	case "2":
		findLargestFiles()
	case "3":
		cleanPackageCache()
	case "4":
		cleanJournalLogs()
	case "5":
		emptyTrash()
	case "6":
		findDuplicateFiles()
	case "7":
		mountUnmountDrives()
	case "8", "":
		return
	default:
		printError("Invalid option selected")
	}
}

func diskUsageByDirectory() {
	printSection("📊 Disk Usage by Directory")
	wd, _ := os.Getwd()
	targetDir := promptDefault("Enter directory path (default: current directory):", wd)
	if stat, err := os.Stat(targetDir); err != nil || !stat.IsDir() {
		printError("Directory not found: %s", targetDir)
		return
	}

	printInfo("Analyzing disk usage in: %s", targetDir)
	fmt.Println()
	if checkIfInstalled("du") {
		_ = runShellCommand("du -h --max-depth=1 " + shellQuote(targetDir) + " 2>/dev/null | sort -hr | head -20")
	} else {
		printError("'du' command not found")
	}
}

func findLargestFiles() {
	printSection("📁 Find Largest Files")
	wd, _ := os.Getwd()
	searchDir := promptDefault("Enter directory to search (default: current directory):", wd)
	numFiles := promptDefault("How many files to show? (default: 20):", "20")
	if stat, err := os.Stat(searchDir); err != nil || !stat.IsDir() {
		printError("Directory not found: %s", searchDir)
		return
	}

	printInfo("Searching for largest files in: %s", searchDir)
	printWarning("This may take a while")
	fmt.Println()

	if checkIfInstalled("find") {
		command := "find " + shellQuote(searchDir) + " -type f -exec du -h {} + 2>/dev/null"
		command += " | sort -hr | head -n " + shellQuote(numFiles)

		_ = runShellCommand(command)
	} else {
		printError("'find' command not found")
	}
}

func cleanPackageCache() {
	printSection("🧹 Clean Package Cache")
	printSubsection("Current cache usage:")
	_ = runShellCommand(`[ -d "/var/cache/apt/archives" ] && du -sh /var/cache/apt/archives 2>/dev/null | awk '{print "APT cache: "$1}'`)
	_ = runShellCommand(`[ -d "/var/cache/pacman/pkg" ] && du -sh /var/cache/pacman/pkg 2>/dev/null | awk '{print "Pacman cache: "$1}'`)
	_ = runShellCommand(`[ -d "/var/cache/dnf" ] && du -sh /var/cache/dnf 2>/dev/null | awk '{print "DNF cache: "$1}'`)
	waitForEnter()

	if !confirm("Do you want to clean the package cache?") {
		printWarning("Cancelled")
		return
	}

	if isAvailableCommand(pkgmgr.AutocleanCmd) {
		_ = runShellCommand(pkgmgr.AutocleanCmd)
	} else {
		if checkIfInstalled("apt-get") {
			_ = runShellCommand("sudo apt-get clean && sudo apt-get autoclean")
		}
		if checkIfInstalled("pacman") {
			_ = runShellCommand("sudo pacman -Sc --noconfirm")
		}
		if checkIfInstalled("dnf") {
			_ = runShellCommand("sudo dnf clean all")
		}
	}
	printSuccess("Package cache cleaned")
}

func cleanJournalLogs() {
	printSection("📝 Clean Journal Logs")
	if !checkIfInstalled("journalctl") {
		printError("journalctl not found (systemd not available)")
		return
	}
	printSubsection("Current journal size:")
	_ = runShellCommand("journalctl --disk-usage")
	waitForEnter()
	retention := menuChoice("Keep logs for how long?", []string{"2 days", "1 week", "2 weeks", "1 month", "Cancel"})
	time := ""
	switch retention {
	case "1":
		time = "2d"
	case "2":
		time = "1w"
	case "3":
		time = "2w"
	case "4":
		time = "1M"
	default:
		printWarning("Cancelled")
		return
	}

	printInfo("Cleaning logs older than %s", time)
	_ = runShellCommand("sudo journalctl --vacuum-time=" + shellQuote(time))
	printSuccess("Journal logs cleaned")
}

func emptyTrash() {
	printSection("🗑️  Empty Trash")
	trashDirs := []string{homePath(".local", "share", "Trash"), homePath(".Trash")}
	totalFound := false
	for _, trashDir := range trashDirs {
		if stat, err := os.Stat(trashDir); err == nil && stat.IsDir() {
			totalFound = true
			size := commandOutput("du -sh " + shellQuote(trashDir) + " 2>/dev/null | cut -f1")
			printInfo("Trash location: %s (%s)", trashDir, size)
		}
	}
	if !totalFound {
		printSuccess("Trash is already empty")
		return
	}
	waitForEnter()
	if !confirm("Do you want to empty the trash?") {
		printWarning("Cancelled")
		return
	}
	for _, trashDir := range trashDirs {
		if stat, err := os.Stat(trashDir); err == nil && stat.IsDir() {
			printInfo("Emptying: %s", trashDir)
			_ = runShellCommand("find " + shellQuote(trashDir) + " -mindepth 1 -maxdepth 1 -exec rm -rf -- {} +")
		}
	}
	printSuccess("Trash emptied")
}

func findDuplicateFiles() {
	printSection("🔍 Find Duplicate Files")
	if !checkIfInstalled("fdupes") {
		printWarning("'fdupes' is not installed")
		printInfo("Install with: robohelp -pi fdupes")
		return
	}
	searchDir := promptDefault("Enter directory to search (default: $HOME):", homePath())
	if stat, err := os.Stat(searchDir); err != nil || !stat.IsDir() {
		printError("Directory not found: %s", searchDir)
		return
	}

	printInfo("Searching for duplicate files in: %s", searchDir)
	printWarning("This may take a while")
	fmt.Println()
	_ = runCommandLine("fdupes", "-r", searchDir)
}

func mountUnmountDrives() {
	printSection("💾 Mount/Unmount Drives")
	switch menuChoice("Choose an action", []string{"List Mounted Drives", "Mount a Drive", "Unmount a Drive", "Cancel"}) {
	case "1":
		listMountedDrives()
	case "2":
		mountDrive()
	case "3":
		unmountDrive()
	default:
		printWarning("Cancelled")
	}
}

func listMountedDrives() {
	printSubsection("Currently Mounted Drives:")
	if checkIfInstalled("lsblk") {
		_ = runShellCommand("lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,FSTYPE")
	} else {
		_ = runShellCommand("mount | column -t")
	}
}

func mountDrive() {
	printSubsection("Available Block Devices:")
	if checkIfInstalled("lsblk") {
		_ = runShellCommand("lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,FSTYPE")
	} else {
		_ = runShellCommand("fdisk -l 2>/dev/null | grep -E '^/dev/'")
	}
	waitForEnter()
	device := promptLine("Enter device to mount (e.g., /dev/sdb1):")
	mountPoint := promptLine("Enter mount point (e.g., /mnt/usb):")
	if device == "" || mountPoint == "" {
		printError("Device and mount point cannot be empty")
		return
	}
	if _, err := os.Stat(device); err != nil {
		printError("Device not found: %s", device)
		return
	}
	if stat, err := os.Stat(mountPoint); err != nil || !stat.IsDir() {
		printInfo("Creating mount point: %s", mountPoint)
		_ = runCommandLine("sudo", "mkdir", "-p", filepath.Clean(mountPoint))
	}

	printInfo("Mounting %s to %s", device, mountPoint)
	if rc := runCommandLine("sudo", "mount", device, mountPoint); rc == 0 {
		printSuccess("Successfully mounted %s to %s", device, mountPoint)
	} else {
		printError("Failed to mount %s", device)
	}
}

func unmountDrive() {
	listMountedDrives()
	waitForEnter()
	target := promptLine("Enter device or mount point to unmount:")
	if target == "" {
		printError("Target cannot be empty")
		return
	}

	printInfo("Unmounting %s", target)
	if rc := runCommandLine("sudo", "umount", target); rc == 0 {
		printSuccess("Successfully unmounted %s", target)
	} else {
		printError("Failed to unmount %s", target)
		printWarning("Tip: check if any processes are using the mount point")
	}
}
