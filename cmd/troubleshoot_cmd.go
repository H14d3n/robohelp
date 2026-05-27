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

	"github.com/h14d3n/robohelp/internal/pkgmgr"
)

func runTroubleshoot() {
	options := []string{
		"System Won't Boot",
		"Network Issues",
		"High CPU Usage",
		"Out of Disk Space",
		"Service Won't Start",
		"SSH Connection Issues",
		"Exit",
	}
	choice, ok := menuSelect("🔧 Troubleshooting Wizard", options)
	if !ok || choice == len(options)-1 {
		return
	}

	switch choice {
	case 0:
		troubleshootBoot()
	case 1:
		troubleshootNetwork()
	case 2:
		troubleshootCPU()
	case 3:
		troubleshootDisk()
	case 4:
		troubleshootService()
	case 5:
		troubleshootSSH()
	}
}

func troubleshootBoot() {
	printSection("🔧 System Boot Troubleshooting")
	printSubsection("Step 1: Checking system boot logs...")

	if checkIfInstalled("journalctl") {
		printSubsection("📋 Recent boot errors:")
		runShellCommandLogged("sudo journalctl -b -p err --no-pager | tail -n 20")
		printSubsection("📋 Failed services:")
		runShellCommandLogged("systemctl --failed --no-pager")
	} else {
		printWarning("journalctl not available, checking dmesg...")
		runShellCommandLogged("dmesg | grep -i 'error\\|fail' | tail -n 20")
	}

	printSubsection("Step 2: Common boot issues and solutions:")
	printInfo("Check disk space: df -h")
	printInfo("Check filesystem: sudo fsck (from recovery mode)")
	printInfo("Check GRUB: sudo update-grub")
	printInfo("Check fstab: cat /etc/fstab")
	fmt.Println()

	waitForEnter()

	if confirm("Would you like to check your /etc/fstab file?") {
		printSubsection("📋 Current /etc/fstab configuration:")
		runShellCommandLogged("cat /etc/fstab")
	}

	printSuccess("Boot diagnostics complete.")
}

func troubleshootNetwork() {
	printSection("🔧 Network Troubleshooting")
	printInfo("Running comprehensive network diagnostics...")
	runNetworkDiagnostics()

	printSubsection("Additional troubleshooting steps:")
	printSubsection("Network-related services:")

	backend := detectServiceBackend()
	if serviceBackendAvailable(backend) {
		command := backend.listAll
		command += " | grep -E '(network|NetworkManager|networking|dhcp|resolved)'"
		command += " | head -n 10 || echo 'No network services found'"

		runShellCommandLogged(command)
	}

	printInfo("Restart network service:")

	if serviceBackendAvailable(backend) {
		fmt.Println("  " + backend.restartCommand("NetworkManager"))
		fmt.Println("  " + backend.restartCommand("networking"))
	} else {
		fmt.Println("  sudo service network-manager restart")
		fmt.Println("  sudo service networking restart")
	}

	printInfo("Reset DNS:")
	fmt.Println("  sudo systemd-resolve --flush-caches")
	fmt.Println("  sudo resolvectl flush-caches")

	printInfo("Check firewall:")
	fmt.Println("  sudo ufw status")
	fmt.Println("  sudo firewall-cmd --list-all")

	waitForEnter()

	if serviceBackendAvailable(backend) && confirm("Would you like to restart NetworkManager now?") {
		printInfo("Restarting NetworkManager...")
		runShellCommandLogged(backend.restartCommand("NetworkManager") + " 2>/dev/null || sudo service network-manager restart 2>/dev/null")
	}
}

func troubleshootCPU() {
	printSection("🔧 High CPU Usage Troubleshooting")

	printSubsection("Step 1: Identifying high CPU processes...")
	printSubsection("📊 Current CPU usage:")
	runShellCommandLogged("top -bn1 | head -n 12")

	printSubsection("📊 Top 10 CPU-consuming processes:")
	runShellCommandLogged("ps aux --sort=-%cpu | head -n 11")

	printSubsection("Step 2: Common causes and solutions:")
	runShellCommandLogged("uptime")

	printInfo("Check for runaway processes in the list above")
	printInfo("Use 'htop' for interactive monitoring (install with: robohelp -pi htop)")
	printInfo("Kill a process: kill -9 <PID>")
	printInfo("Renice a process: renice -n 10 -p <PID>")
	fmt.Println()

	waitForEnter()

	printSubsection("Top CPU processes:")
	runShellCommandLogged("ps aux --sort=-%cpu | head -n 11 | awk 'NR>1 {printf \"[%s] CPU:%s%% - %s\\n\", $2, $3, $11}'")
	pid := promptLine("Enter PID to kill (or press Enter to skip):")

	if pid != "" {
		printInfo("Attempting to kill process %s...", pid)
		if rc := runCommandLine("sudo", "kill", "-9", pid); rc == 0 {
			printSuccess("Process %s killed successfully.", pid)
		} else {
			printError("Failed to kill process %s. Check if PID is valid.", pid)
		}
	}

	printSuccess("CPU diagnostics complete.")
}

func troubleshootDisk() {
	printSection("🔧 Disk Space Troubleshooting")
	printSubsection("Step 1: Analyzing disk usage...")

	printSubsection("📊 Filesystem usage:")
	runShellCommandLogged("df -h")

	printSubsection("📊 Largest directories in /home:")
	runShellCommandLogged("du -h --max-depth=1 /home 2>/dev/null | sort -hr | head -n 10")

	printSubsection("📊 Largest directories in /var:")
	runShellCommandLogged("sudo du -h --max-depth=1 /var 2>/dev/null | sort -hr | head -n 10")

	printSubsection("Step 2: Cleanup options:")
	printInfo("Clean package cache: robohelp -acl")
	printInfo("Remove old kernels/unneeded packages: robohelp -arm")
	printInfo("Clean journal logs: robohelp -dm -> Clean Journal logs")
	printInfo("Find large files: robohelp -dm -> Find Largest Files")
	fmt.Println()

	waitForEnter()

	if confirm("Clean package cache and remove unnecessary packages now?") {
		printInfo("Cleaning package cache...")
		if rc := packageAutoclean(pkgmgr.AutocleanCmd); rc != 0 {
			return
		}

		printInfo("Removing unnecessary packages...")
		if rc := packageAutoremove(pkgmgr.AutoremoveCmd); rc != 0 {
			return
		}

		printSuccess("Cleanup complete. Check disk usage with: df -h")
	}
	printSuccess("Disk space diagnostics complete.")
}

func troubleshootService() {
	backend, ok := serviceBackendOrWarn()
	if !ok {
		return
	}

	printSection("📋 Running Services")
	runShellCommandLogged(previewServiceCommand(backend.listRunning))

	printSection("❌ Failed Services")
	if backend.supportsFailed {
		runShellCommandLogged(backend.listFailed)
	} else {
		printWarning("%s does not provide a failed-service listing", backend.name)
	}

	serviceName := promptLine(backend.serviceNameHelp)
	if serviceName == "" {
		printError("No service name provided.")
		return
	}

	printSection("🔧 Troubleshooting: " + serviceName)

	printSubsection("Step 1: Checking service status...")
	runShellCommandLogged(backend.statusCommand(serviceName))

	printSubsection("Step 2: Checking service logs...")
	if backend.systemdStyleName && checkIfInstalled("journalctl") {
		runShellCommandLogged("sudo journalctl -u " + shellQuote(serviceName) + " -n 30 --no-pager")
	} else {
		printWarning("Service log lookup is not available for %s yet", backend.name)
	}

	printSubsection("Step 3: Common solutions:")
	printInfo("Restart service: %s", backend.restartCommand(serviceName))
	if backend.supportsEnable {
		printInfo("Enable on boot: %s", backend.enableCommand(serviceName))
	}
	if backend.configHint != nil {
		printInfo("Check config: %s", backend.configHint(serviceName))
	}
	if backend.resetFailedHint != nil {
		printInfo("Reset failed state: %s", backend.resetFailedHint(serviceName))
	}
	fmt.Println()

	waitForEnter()

	if confirm("Would you like to restart " + serviceName + " now?") {
		if rc := exitCodeFromError(runShellCommand(backend.restartCommand(serviceName))); rc == 0 {
			printSuccess("Service restarted successfully.")
			runShellCommandLogged(backend.statusCommand(serviceName))
		} else {
			printError("Failed to restart service. Check logs above.")
		}
	}

	printSuccess("Service diagnostics complete.")
}

func troubleshootSSH() {
	printSection("🔧 SSH Connection Troubleshooting")
	if !checkIfInstalled("sshd") && !checkIfInstalled("ssh") {
		printError("SSH is not installed.")
		printInfo("Install with: robohelp -pi openssh-server openssh-client")
		return
	}

	printSubsection("Available SSH-related services:")
	backend := detectServiceBackend()
	if serviceBackendAvailable(backend) {
		runShellCommandLogged(backend.listAll + " | grep -E '(ssh|sshd)' || echo 'No SSH services found'")
	}

	printSubsection("Step 1: Checking SSH service status...")
	if serviceBackendAvailable(backend) {
		runShellCommandLogged(backend.statusCommand("ssh") + " 2>/dev/null || " + backend.statusCommand("sshd") + " 2>/dev/null")
	} else {
		runShellCommandLogged("service ssh status 2>/dev/null || service sshd status 2>/dev/null")
	}

	printSubsection("Step 2: Checking SSH configuration...")

	sshConfigCommand := `[ -f /etc/ssh/sshd_config ]`
	sshConfigCommand += ` && grep -E "^(Port|PermitRootLogin|PasswordAuthentication|PubkeyAuthentication)" /etc/ssh/sshd_config 2>/dev/null`
	sshConfigCommand += ` || echo "Default settings in use"`

	runShellCommandLogged(sshConfigCommand)

	printSubsection("Step 3: Checking network and firewall...")
	printSubsection("📊 Listening SSH ports:")
	runShellCommandLogged("ss -tlnp 2>/dev/null | grep -E '(:22|ssh)' || netstat -tlnp 2>/dev/null | grep -E '(:22|ssh)'")

	printSubsection("📊 Firewall status:")
	if checkIfInstalled("ufw") {
		runShellCommandLogged("sudo ufw status | grep -E '(Status|22|ssh)'")
	} else if checkIfInstalled("firewall-cmd") {
		runShellCommandLogged("sudo firewall-cmd --list-services | grep ssh && echo 'SSH is allowed' || echo 'SSH may be blocked'")
	} else {
		fmt.Println("No common firewall detected")
	}

	printSubsection("Step 4: Common solutions:")
	if serviceBackendAvailable(backend) {
		printInfo("Start SSH service: %s", backend.startCommand("ssh"))
		if backend.supportsEnable {
			printInfo("Enable SSH on boot: %s", backend.enableCommand("ssh"))
		}
	} else {
		printInfo("Start SSH service: sudo service ssh start")
	}
	printInfo("Allow SSH through firewall: sudo ufw allow 22/tcp")
	fmt.Println("  sudo firewall-cmd --add-service=ssh --permanent")
	printInfo("Check SSH logs: sudo journalctl -u ssh -n 50 (or sshd)")
	printInfo("Test connection: ssh -v user@hostname")
	fmt.Println()

	waitForEnter()

	if confirm("Start/restart SSH service now?") {
		command := "sudo service ssh start 2>/dev/null"
		if serviceBackendAvailable(backend) {
			command = backend.startCommand("ssh") + " 2>/dev/null"
			command += " || " + backend.startCommand("sshd") + " 2>/dev/null"
		}
		command += " || sudo service ssh start 2>/dev/null"
		command += " || sudo service sshd start 2>/dev/null"

		rc := exitCodeFromError(runShellCommand(command))

		if rc == 0 {
			printSuccess("SSH service started.")
		} else {
			printError("Failed to start SSH service.")
		}
	}

	printSuccess("SSH diagnostics complete.")
}
