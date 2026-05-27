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
	"os/exec"
	"strings"

	"github.com/h14d3n/robohelp/internal/pkgmgr"
)

func runPackageManagement() int {
	options := []string{
		"Update Package Repositories",
		"Upgrade Installed Packages",
		"Full System Upgrade",
		"Distribution Upgrade",
		"Remove Unnecessary Packages",
		"Clean Local Repository",
		"Install Package",
		"Remove Package",
		"Purge Package",
		"Search Package",
		"Exit",
	}

	choice, ok := menuSelect("📦 Package Management", options)
	if !ok || choice == len(options)-1 {
		return 0
	}

	switch choice {
	case 0:
		return packageUpdate(pkgmgr.UpdateCmd)
	case 1:
		return packageUpgrade(pkgmgr.UpgradeCmd)
	case 2:
		return runFullUpgrade(fullUpgradeCommands())
	case 3:
		return packageDistUpgrade(pkgmgr.DistUpgradeCmd)
	case 4:
		return packageAutoremove(pkgmgr.AutoremoveCmd)
	case 5:
		return packageAutoclean(pkgmgr.AutocleanCmd)
	case 6:
		value := promptLine("Enter package name(s) to install (space-separated):")
		if strings.TrimSpace(value) == "" {
			return 0
		}
		return runPackageValues(pkgmgr.InstallCmd, value, packageInstall)
	case 7:
		value := promptLine("Enter package name(s) to remove (space-separated):")
		if strings.TrimSpace(value) == "" {
			return 0
		}
		return runPackageValues(pkgmgr.RemoveCmd, value, packageRemove)
	case 8:
		value := promptLine("Enter package name(s) to purge (space-separated):")
		if strings.TrimSpace(value) == "" {
			return 0
		}
		return runPackageValues(pkgmgr.PurgeCmd, value, packagePurge)
	case 9:
		value := promptLine("Enter search term:")
		if strings.TrimSpace(value) == "" {
			return 0
		}
		return packageSearch(pkgmgr.SearchCmd, value)
	default:
		return 0
	}
}

func runFullUpgrade(commands []string) int {
	printSection("⚙  Running full upgrade")

	for _, command := range commands {
		if !isAvailableCommand(command) {
			continue
		}

		runner := fullUpgradeRunner(command)
		if runner == nil {
			continue
		}

		rc := runner(command)
		if rc != 0 {
			printError("An error occurred during the upgrade. Exit code: %d", rc)
			fmt.Println()
			return rc
		}
	}

	printSuccess("Full upgrade completed successfully!")
	fmt.Println()
	return 0
}

func fullUpgradeCommands() []string {
	return []string{
		pkgmgr.UpdateCmd,
		pkgmgr.UpgradeCmd,
		pkgmgr.AutoremoveCmd,
		pkgmgr.AutocleanCmd,
	}
}

func packageUpdate(command string) int {
	printSection("📦 Updating package metadata")
	return runAndReport(
		command,
		"Updated repositories successfully on %s.",
		"Failed to update repositories on %s. Exit code: %d",
		distroName(),
	)
}

func packageUpgrade(command string) int {
	printSection("📦 Upgrading installed packages")
	return runAndReport(
		command,
		"Installed updates successfully on %s.",
		"Failed to upgrade packages on %s. Exit code: %d",
		distroName(),
	)
}

func packageDistUpgrade(command string) int {
	printSection("📦 Upgrading distribution and dependencies")
	if !isAvailableCommand(command) {
		printWarning("This command is not available for your distribution")
		fmt.Println()
		return 1
	}

	return runAndReport(
		command,
		"Upgraded distribution successfully on %s.",
		"Failed to upgrade %s. Exit code: %d",
		distroName(),
	)
}

func packageAutoremove(command string) int {
	printSection("🧹 Removing unnecessary packages")

	if isPacmanDistro() {
		orphans := pacmanOrphans()
		if len(orphans) == 0 {
			printInfo("No orphaned packages found.")
			fmt.Println()
			return 0
		}

		fullCommand := command + " " + strings.Join(orphans, " ")
		return runAndReport(
			fullCommand,
			"Autoremove completed successfully on %s.",
			"Autoremove failed on %s. Exit code: %d",
			distroName(),
		)
	}

	return runAndReport(
		command,
		"Autoremove completed successfully on %s.",
		"Autoremove failed on %s. Exit code: %d",
		distroName(),
	)
}

func packageAutoclean(command string) int {
	printSection("🧼 Cleaning local repository")
	return runAndReport(
		command,
		"Autoclean completed successfully on %s.",
		"Autoclean failed on %s. Exit code: %d",
		distroName(),
	)
}

func packageInstall(command, value string) int {
	printSection("📦 Installing package: " + value)
	return runAndReport(
		command+" "+shellQuote(value),
		"%s installed successfully!",
		"Failed to install %s. Exit code: %d",
		value,
	)
}

func packageRemove(command, value string) int {
	printSection("📦 Removing package: " + value)
	return runAndReport(
		command+" "+shellQuote(value),
		"%s removed successfully!",
		"Failed to remove %s. Exit code: %d",
		value,
	)
}

func packagePurge(command, value string) int {
	printSection("📦 Purging package: " + value)
	return runAndReport(
		command+" "+shellQuote(value),
		"%s purged successfully!",
		"Failed to purge %s. Exit code: %d",
		value,
	)
}

func packageSearch(command, value string) int {
	printSection("🔍 Searching for: " + value)
	fullCommand := command + " " + shellQuote(value)
	err := runShellCommand(fullCommand)
	rc := exitCodeFromError(err)
	fmt.Println()
	return rc
}

func runPackageValues(command, value string, runner func(string, string) int) int {
	return runPackageValueList(command, strings.Fields(value), runner)
}

func runPackageValueList(command string, values []string, runner func(string, string) int) int {
	for _, pkg := range values {
		if strings.TrimSpace(pkg) == "" {
			continue
		}
		if rc := runner(command, pkg); rc != 0 {
			return rc
		}
	}
	return 0
}

func runAndReport(command, successMessage, failureMessage string, args ...any) int {
	// Keep package command output handling consistent across all operations.
	rc := exitCodeFromError(runShellCommand(command))
	if rc == 0 {
		printSuccess(successMessage, args...)
	} else {
		failureArgs := append(args, rc)
		printError(failureMessage, failureArgs...)
	}
	fmt.Println()
	return rc
}

func fullUpgradeRunner(command string) func(string) int {
	switch strings.TrimSpace(command) {
	case pkgmgr.UpdateCmd:
		return packageUpdate
	case pkgmgr.UpgradeCmd:
		return packageUpgrade
	case pkgmgr.AutoremoveCmd:
		return packageAutoremove
	case pkgmgr.AutocleanCmd:
		return packageAutoclean
	default:
		return nil
	}
}

func isAvailableCommand(command string) bool {
	command = strings.TrimSpace(command)
	return command != "" && command != "unknown"
}

func distroName() string {
	if pkgmgr.DetectedDistro == "" {
		return "unknown"
	}
	return pkgmgr.DetectedDistro
}

func isPacmanDistro() bool {
	distro := distroName()
	return distro == "arch" || distro == "manjarolinux" || distro == "manjaro"
}

func pacmanOrphans() []string {
	cmd := exec.Command("pacman", "-Qdtq")
	out, err := cmd.Output()
	if err != nil {
		return nil
	}

	lines := strings.Fields(string(out))
	return lines
}
