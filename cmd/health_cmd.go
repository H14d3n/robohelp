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
	"runtime"
	"strings"

	"github.com/h14d3n/robohelp/internal/pkgmgr"
)

func runHealthCheck() {
	printSection("🏥 System Health Check")

	checkDiskSpace()
	checkSystemLoad()
	checkBrokenPackages()
	checkSecurityUpdates()

	printSuccess("Health check completed")
	fmt.Println()
}

func checkDiskSpace() {
	printSubsection("📊 Disk Space:")

	if out := commandOutput("df -h / | tail -n 1 | awk '{printf \"   Root: %s / %s (%s used)\", $3, $2, $5}'"); out != "" {
		fmt.Println(out)
	}

	usage := parseInt(strings.TrimSuffix(commandOutput("df / | tail -n 1 | awk '{print $5}'"), "%"))

	switch {
	case usage > 90:
		printError("Disk usage is critically high (%d%%)", usage)
	case usage > 75:
		printWarning("Disk usage is getting high (%d%%)", usage)
	default:
		printSuccess("Disk usage is healthy (%d%%)", usage)
	}

	fmt.Println()
}

func checkSystemLoad() {
	printSubsection("⚙️ System Load:")

	loadAvg := commandOutput("uptime | awk -F'load average:' '{print $2}' | xargs")

	if loadAvg == "" {
		printWarning("Unable to check system load")
		fmt.Println()
		return
	}

	fmt.Printf("   Load Average: %s\n", loadAvg)
	cpuCores := runtime.NumCPU()
	firstLoad := parseFloat(strings.Fields(loadAvg)[0])

	if firstLoad > float64(cpuCores*2) {
		printError("System load is high")
	} else {
		printSuccess("System load is normal")
	}

	fmt.Printf("   %sCPU Cores: %d%s\n\n", colorCyan, cpuCores, colorNC)
}

func checkBrokenPackages() {
	printSubsection("📦 Broken Packages:")
	distro := distroName()

	if !isAvailableCommand(pkgmgr.CheckBrokenCmd) {
		printInfo("Package check not implemented for %s", distro)
		fmt.Println()
		return
	}

	broken := parseInt(commandOutput(pkgmgr.CheckBrokenCmd))

	if broken > 0 {
		printWarning("Found %d broken package(s)", broken)

		switch distro {
		case "ubuntu", "debian", "kali":
			printInfo("Run: sudo dpkg --configure -a")
		case "arch", "manjaro", "manjarolinux":
			printInfo("Run: sudo pacman -Qk to see details")
		}

	} else {
		printSuccess("No broken packages detected")
	}

	fmt.Println()
}

func checkSecurityUpdates() {
	printSubsection("🔒 Security Updates:")
	distro := distroName()

	if !isAvailableCommand(pkgmgr.CheckSecurityCmd) {
		printInfo("Security check not implemented for %s", distro)
		fmt.Println()
		return
	}

	switch distro {
	case "ubuntu", "debian", "kali":
		_ = runShellCommand("sudo -n apt update >/dev/null 2>&1 || true")

		securityUpdates := parseInt(commandOutput(pkgmgr.CheckSecurityCmd + " | xargs"))
		totalUpdates := parseInt(commandOutput("apt list --upgradable 2>/dev/null | tail -n +2 | wc -l | xargs"))

		switch {
		case securityUpdates > 0:
			printWarning("%d security update(s) available", securityUpdates)
			printInfo("Run: robohelp -pur")
		case totalUpdates > 0:
			printInfo("%d update(s) available", totalUpdates)
			printInfo("Run: robohelp -pur")
		default:
			printSuccess("System is up to date")
		}

	case "arch", "manjaro", "manjarolinux":
		if !checkIfInstalled("checkupdates") {
			printInfo("Install 'pacman-contrib' for update checking")
			break
		}

		updates := parseInt(commandOutput(pkgmgr.CheckSecurityCmd + " | xargs"))
		printUpdateCount(updates, false)

	case "fedora", "centos", "rhel", "opensuse", "opensuse-tumbleweed", "sles":
		updates := parseInt(commandOutput(pkgmgr.CheckSecurityCmd + " | xargs"))
		securityLabel := strings.Contains(distro, "fedora") || distro == "centos" || distro == "rhel"

		printUpdateCount(updates, securityLabel)

	default:
		printInfo("Security check not yet configured for %s", distro)
	}

	fmt.Println()
}

func printUpdateCount(updates int, securityLabel bool) {
	if updates > 0 {
		if securityLabel {
			printWarning("Security updates available")
		} else {
			printWarning("%d update(s) available", updates)
		}

		printInfo("Run: robohelp -pur")
	} else {
		printSuccess("System is up to date")
	}
}
