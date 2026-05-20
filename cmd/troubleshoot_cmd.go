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
	switch menuChoice("🔧 Troubleshooting Wizard", []string{
		"System Won't Boot",
		"Network Issues",
		"High CPU Usage",
		"Out of Disk Space",
		"Service Won't Start",
		"SSH Connection Issues",
		"Exit",
	}) {
	case "1":
		troubleshootBoot()
	case "2":
		troubleshootNetwork()
	case "3":
		troubleshootCPU()
	case "4":
		troubleshootDisk()
	case "5":
		troubleshootService()
	case "6":
		troubleshootSSH()
	case "7", "":
		return
	default:
		fmt.Printf("%sInvalid option selected.%s\n", colorRed, colorNC)
	}
}

func troubleshootBoot() {
	printSection("🔧 System Boot Troubleshooting")
	printSubsection("Step 1: Checking system boot logs...")

	if checkIfInstalled("journalctl") {
		printSubsection("📋 Recent boot errors:")
		_ = runShellCommand("sudo journalctl -b -p err --no-pager | tail -n 20")
		printSubsection("📋 Failed services:")
		_ = runShellCommand("systemctl --failed --no-pager")
	} else {
		fmt.Printf("%s⚠️  journalctl not available, checking dmesg...%s\n", colorYellow, colorNC)
		_ = runShellCommand("dmesg | grep -i 'error\\|fail' | tail -n 20")
	}

	printSubsection("Step 2: Common boot issues and solutions:")
	fmt.Printf("%s• Check disk space:%s df -h\n", colorCyan, colorNC)
	fmt.Printf("%s• Check filesystem:%s sudo fsck (from recovery mode)\n", colorCyan, colorNC)
	fmt.Printf("%s• Check GRUB:%s sudo update-grub\n", colorCyan, colorNC)
	fmt.Printf("%s• Check fstab:%s cat /etc/fstab\n\n", colorCyan, colorNC)

	waitForEnter()

	if confirm("Would you like to check your /etc/fstab file?") {
		printSubsection("📋 Current /etc/fstab configuration:")
		_ = runShellCommand("cat /etc/fstab")
	}

	fmt.Printf("%s✅ Boot diagnostics complete.%s\n", colorGreen, colorNC)
}

func troubleshootNetwork() {
	printSection("🔧 Network Troubleshooting")
	fmt.Printf("%sRunning comprehensive network diagnostics...%s\n", colorYellow, colorNC)
	runNetworkDiagnostics()

	printSubsection("Additional troubleshooting steps:")
	printSubsection("Network-related services:")

	backend := detectServiceBackend()
	if serviceBackendAvailable(backend) {
		command := backend.listAll
		command += " | grep -E '(network|NetworkManager|networking|dhcp|resolved)'"
		command += " | head -n 10 || echo 'No network services found'"

		_ = runShellCommand(command)
	}

	fmt.Printf("%s• Restart network service:%s\n", colorCyan, colorNC)

	if serviceBackendAvailable(backend) {
		fmt.Println("  " + backend.restartCommand("NetworkManager"))
		fmt.Println("  " + backend.restartCommand("networking"))
	} else {
		fmt.Println("  sudo service network-manager restart")
		fmt.Println("  sudo service networking restart")
	}

	fmt.Printf("%s• Reset DNS:%s\n", colorCyan, colorNC)
	fmt.Println("  sudo systemd-resolve --flush-caches")
	fmt.Println("  sudo resolvectl flush-caches")

	fmt.Printf("%s• Check firewall:%s\n", colorCyan, colorNC)
	fmt.Println("  sudo ufw status")
	fmt.Println("  sudo firewall-cmd --list-all")

	waitForEnter()

	if serviceBackendAvailable(backend) && confirm("Would you like to restart NetworkManager now?") {
		fmt.Printf("%s🔄 Restarting NetworkManager...%s\n", colorCyan, colorNC)
		_ = runShellCommand(backend.restartCommand("NetworkManager") + " 2>/dev/null || sudo service network-manager restart 2>/dev/null")
	}
}

func troubleshootCPU() {
	printSection("🔧 High CPU Usage Troubleshooting")

	printSubsection("Step 1: Identifying high CPU processes...")
	printSubsection("📊 Current CPU usage:")
	_ = runShellCommand("top -bn1 | head -n 12")

	printSubsection("📊 Top 10 CPU-consuming processes:")
	_ = runShellCommand("ps aux --sort=-%cpu | head -n 11")

	printSubsection("Step 2: Common causes and solutions:")
	_ = runShellCommand("uptime")

	fmt.Printf("%s• Check for runaway processes in the list above%s\n", colorCyan, colorNC)
	fmt.Printf("%s• Use 'htop' for interactive monitoring (install with: robohelp -pi htop)%s\n", colorCyan, colorNC)
	fmt.Printf("%s• Kill a process: kill -9 <PID>%s\n", colorCyan, colorNC)
	fmt.Printf("%s• Renice a process: renice -n 10 -p <PID>%s\n\n", colorCyan, colorNC)

	waitForEnter()

	printSubsection("Top CPU processes:")
	_ = runShellCommand("ps aux --sort=-%cpu | head -n 11 | awk 'NR>1 {printf \"[%s] CPU:%s%% - %s\\n\", $2, $3, $11}'")
	pid := promptLine("Enter PID to kill (or press Enter to skip):")

	if pid != "" {
		fmt.Printf("%sAttempting to kill process %s...%s\n", colorYellow, pid, colorNC)
		if rc := runCommandLine("sudo", "kill", "-9", pid); rc == 0 {
			fmt.Printf("%s✅ Process %s killed successfully.%s\n", colorGreen, pid, colorNC)
		} else {
			fmt.Printf("%s❌ Failed to kill process %s. Check if PID is valid.%s\n", colorRed, pid, colorNC)
		}
	}

	fmt.Printf("%s✅ CPU diagnostics complete.%s\n", colorGreen, colorNC)
}

func troubleshootDisk() {
	printSection("🔧 Disk Space Troubleshooting")
	printSubsection("Step 1: Analyzing disk usage...")

	printSubsection("📊 Filesystem usage:")
	_ = runShellCommand("df -h")

	printSubsection("📊 Largest directories in /home:")
	_ = runShellCommand("du -h --max-depth=1 /home 2>/dev/null | sort -hr | head -n 10")

	printSubsection("📊 Largest directories in /var:")
	_ = runShellCommand("sudo du -h --max-depth=1 /var 2>/dev/null | sort -hr | head -n 10")

	printSubsection("Step 2: Cleanup options:")
	fmt.Printf("%s• Clean package cache:%s robohelp -acl\n", colorCyan, colorNC)
	fmt.Printf("%s• Remove old kernels/unneeded packages:%s robohelp -arm\n", colorCyan, colorNC)
	fmt.Printf("%s• Clean journal logs:%s robohelp -dm -> Clean Journal logs\n", colorCyan, colorNC)
	fmt.Printf("%s• Find large files:%s robohelp -dm -> Find Largest Files\n\n", colorCyan, colorNC)

	waitForEnter()

	if confirm("Clean package cache and remove unnecessary packages now?") {
		fmt.Printf("%s🧹 Cleaning package cache...%s\n", colorCyan, colorNC)
		exitIfNonZero(packageAutoclean(pkgmgr.AutocleanCmd))

		fmt.Printf("%s🧹 Removing unnecessary packages...%s\n", colorCyan, colorNC)
		exitIfNonZero(packageAutoremove(pkgmgr.AutoremoveCmd))

		fmt.Printf("%s✅ Cleanup complete. Check disk usage with: df -h%s\n", colorGreen, colorNC)
	}
	fmt.Printf("%s✅ Disk space diagnostics complete.%s\n", colorGreen, colorNC)
}

func troubleshootService() {
	backend, ok := serviceBackendOrWarn()
	if !ok {
		return
	}

	printSection("📋 Running Services")
	_ = runShellCommand(previewServiceCommand(backend.listRunning))

	printSection("❌ Failed Services")
	if backend.supportsFailed {
		_ = runShellCommand(backend.listFailed)
	} else {
		printWarning("%s does not provide a failed-service listing", backend.name)
	}

	serviceName := promptLine(backend.serviceNameHelp)
	if serviceName == "" {
		fmt.Printf("%s❌ No service name provided.%s\n", colorRed, colorNC)
		return
	}

	printSection("🔧 Troubleshooting: " + serviceName)

	printSubsection("Step 1: Checking service status...")
	_ = runShellCommand(backend.statusCommand(serviceName))

	printSubsection("Step 2: Checking service logs...")
	if backend.systemdStyleName && checkIfInstalled("journalctl") {
		_ = runShellCommand("sudo journalctl -u " + shellQuote(serviceName) + " -n 30 --no-pager")
	} else {
		printWarning("Service log lookup is not available for %s yet", backend.name)
	}

	printSubsection("Step 3: Common solutions:")
	fmt.Printf("%s• Restart service:%s %s\n", colorCyan, colorNC, backend.restartCommand(serviceName))
	if backend.supportsEnable {
		fmt.Printf("%s• Enable on boot:%s %s\n", colorCyan, colorNC, backend.enableCommand(serviceName))
	}
	if backend.configHint != nil {
		fmt.Printf("%s• Check config:%s %s\n", colorCyan, colorNC, backend.configHint(serviceName))
	}
	if backend.resetFailedHint != nil {
		fmt.Printf("%s• Reset failed state:%s %s\n", colorCyan, colorNC, backend.resetFailedHint(serviceName))
	}
	fmt.Println()

	waitForEnter()

	if confirm("Would you like to restart " + serviceName + " now?") {
		if rc := exitCodeFromError(runShellCommand(backend.restartCommand(serviceName))); rc == 0 {
			fmt.Printf("%s✅ Service restarted successfully.%s\n", colorGreen, colorNC)
			_ = runShellCommand(backend.statusCommand(serviceName))
		} else {
			fmt.Printf("%s❌ Failed to restart service. Check logs above.%s\n", colorRed, colorNC)
		}
	}

	fmt.Printf("%s✅ Service diagnostics complete.%s\n", colorGreen, colorNC)
}

func troubleshootSSH() {
	printSection("🔧 SSH Connection Troubleshooting")
	if !checkIfInstalled("sshd") && !checkIfInstalled("ssh") {
		fmt.Printf("%s❌ SSH is not installed.%s\n", colorRed, colorNC)
		fmt.Printf("%sInstall with: robohelp -pi openssh-server openssh-client%s\n", colorCyan, colorNC)
		return
	}

	printSubsection("Available SSH-related services:")
	backend := detectServiceBackend()
	if serviceBackendAvailable(backend) {
		_ = runShellCommand(backend.listAll + " | grep -E '(ssh|sshd)' || echo 'No SSH services found'")
	}

	printSubsection("Step 1: Checking SSH service status...")
	if serviceBackendAvailable(backend) {
		_ = runShellCommand(backend.statusCommand("ssh") + " 2>/dev/null || " + backend.statusCommand("sshd") + " 2>/dev/null")
	} else {
		_ = runShellCommand("service ssh status 2>/dev/null || service sshd status 2>/dev/null")
	}

	printSubsection("Step 2: Checking SSH configuration...")

	sshConfigCommand := `[ -f /etc/ssh/sshd_config ]`
	sshConfigCommand += ` && grep -E "^(Port|PermitRootLogin|PasswordAuthentication|PubkeyAuthentication)" /etc/ssh/sshd_config 2>/dev/null`
	sshConfigCommand += ` || echo "Default settings in use"`

	_ = runShellCommand(sshConfigCommand)

	printSubsection("Step 3: Checking network and firewall...")
	printSubsection("📊 Listening SSH ports:")
	_ = runShellCommand("ss -tlnp 2>/dev/null | grep -E '(:22|ssh)' || netstat -tlnp 2>/dev/null | grep -E '(:22|ssh)'")

	printSubsection("📊 Firewall status:")
	if checkIfInstalled("ufw") {
		_ = runShellCommand("sudo ufw status | grep -E '(Status|22|ssh)'")
	} else if checkIfInstalled("firewall-cmd") {
		_ = runShellCommand("sudo firewall-cmd --list-services | grep ssh && echo 'SSH is allowed' || echo 'SSH may be blocked'")
	} else {
		fmt.Println("No common firewall detected")
	}

	printSubsection("Step 4: Common solutions:")
	if serviceBackendAvailable(backend) {
		fmt.Printf("%s• Start SSH service:%s %s\n", colorCyan, colorNC, backend.startCommand("ssh"))
		if backend.supportsEnable {
			fmt.Printf("%s• Enable SSH on boot:%s %s\n", colorCyan, colorNC, backend.enableCommand("ssh"))
		}
	} else {
		fmt.Printf("%s• Start SSH service:%s sudo service ssh start\n", colorCyan, colorNC)
	}
	fmt.Printf("%s• Allow SSH through firewall:%s sudo ufw allow 22/tcp\n", colorCyan, colorNC)
	fmt.Println("  sudo firewall-cmd --add-service=ssh --permanent")
	fmt.Printf("%s• Check SSH logs:%s sudo journalctl -u ssh -n 50 (or sshd)\n", colorCyan, colorNC)
	fmt.Printf("%s• Test connection:%s ssh -v user@hostname\n\n", colorCyan, colorNC)

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
			fmt.Printf("%s✅ SSH service started.%s\n", colorGreen, colorNC)
		} else {
			fmt.Printf("%s❌ Failed to start SSH service.%s\n", colorRed, colorNC)
		}
	}

	fmt.Printf("%s✅ SSH diagnostics complete.%s\n", colorGreen, colorNC)
}
