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
	options := []string{
		"Disk Usage by Directory",
		"Find Largest Files",
		"Clean Package Cache",
		"Clean Journal Logs",
		"Empty Trash",
		"Find Duplicate Files",
		"Mount/Unmount Drives",
		"Exit",
	}
	choice, ok := menuSelect("💽 Disk Management", options)
	if !ok || choice == len(options)-1 {
		return
	}

	switch choice {
	case 0:
		diskUsageByDirectory()
	case 1:
		findLargestFiles()
	case 2:
		cleanPackageCache()
	case 3:
		cleanJournalLogs()
	case 4:
		emptyTrash()
	case 5:
		findDuplicateFiles()
	case 6:
		mountUnmountDrives()
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
		runShellCommandLogged("du -h --max-depth=1 " + shellQuote(targetDir) + " 2>/dev/null | sort -hr | head -20")
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

		runShellCommandLogged(command)
	} else {
		printError("'find' command not found")
	}
}

func cleanPackageCache() {
	printSection("🧹 Clean Package Cache")
	printSubsection("Current cache usage:")
	runShellCommandLogged(`[ -d "/var/cache/apt/archives" ] && du -sh /var/cache/apt/archives 2>/dev/null | awk '{print "APT cache: "$1}'`)
	runShellCommandLogged(`[ -d "/var/cache/pacman/pkg" ] && du -sh /var/cache/pacman/pkg 2>/dev/null | awk '{print "Pacman cache: "$1}'`)
	runShellCommandLogged(`[ -d "/var/cache/dnf" ] && du -sh /var/cache/dnf 2>/dev/null | awk '{print "DNF cache: "$1}'`)
	waitForEnter()

	if !confirm("Do you want to clean the package cache?") {
		printWarning("Cancelled")
		return
	}

	if isAvailableCommand(pkgmgr.AutocleanCmd) {
		runShellCommandLogged(pkgmgr.AutocleanCmd)
	} else {
		if checkIfInstalled("apt-get") {
			runShellCommandLogged("sudo apt-get clean && sudo apt-get autoclean")
		}
		if checkIfInstalled("pacman") {
			runShellCommandLogged("sudo pacman -Sc --noconfirm")
		}
		if checkIfInstalled("dnf") {
			runShellCommandLogged("sudo dnf clean all")
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
	runShellCommandLogged("journalctl --disk-usage")
	waitForEnter()
	options := []string{"2 days", "1 week", "2 weeks", "1 month", "Cancel"}
	choice, ok := menuSelect("Keep logs for how long?", options)
	if !ok || choice == len(options)-1 {
		printWarning("Cancelled")
		return
	}

	time := ""
	switch choice {
	case 0:
		time = "2d"
	case 1:
		time = "1w"
	case 2:
		time = "2w"
	case 3:
		time = "1M"
	}

	printInfo("Cleaning logs older than %s", time)
	runShellCommandLogged("sudo journalctl --vacuum-time=" + shellQuote(time))
	printSuccess("Journal logs cleaned")
}

func emptyTrash() {
	printSection("🗑️  Empty Trash")
	trashDirs := []string{homePath(".local", "share", "Trash"), homePath(".Trash")}
	totalFound := false
	for _, trashDir := range trashDirs {
		if stat, err := os.Stat(trashDir); err == nil && stat.IsDir() {
			totalFound = true
			size, err := commandOutput("du -sh " + shellQuote(trashDir) + " 2>/dev/null | cut -f1")
			if err != nil {
				printWarning("Unable to read trash size for %s: %v", trashDir, err)
				size = "unknown"
			}
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
			runShellCommandLogged("find " + shellQuote(trashDir) + " -mindepth 1 -maxdepth 1 -exec rm -rf -- {} +")
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
	runCommandLineLogged("fdupes", "-r", searchDir)
}

func mountUnmountDrives() {
	printSection("💾 Mount/Unmount Drives")
	options := []string{"List Mounted Drives", "Mount a Drive", "Unmount a Drive", "Cancel"}
	choice, ok := menuSelect("Choose an action", options)
	if !ok || choice == len(options)-1 {
		printWarning("Cancelled")
		return
	}

	switch choice {
	case 0:
		listMountedDrives()
	case 1:
		mountDrive()
	case 2:
		unmountDrive()
	}
}

func listMountedDrives() {
	printSubsection("Currently Mounted Drives:")
	if checkIfInstalled("lsblk") {
		runShellCommandLogged("lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,FSTYPE")
	} else {
		runShellCommandLogged("mount | column -t")
	}
}

func mountDrive() {
	printSubsection("Available Block Devices:")
	if checkIfInstalled("lsblk") {
		runShellCommandLogged("lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,FSTYPE")
	} else {
		runShellCommandLogged("fdisk -l 2>/dev/null | grep -E '^/dev/'")
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
		runCommandLineLogged("sudo", "mkdir", "-p", filepath.Clean(mountPoint))
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
