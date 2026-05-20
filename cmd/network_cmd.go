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

import "fmt"

func runNetworkDiagnostics() {
	switch menuChoice("🌐 Network Diagnostics", []string{
		"DNS Lookup",
		"Traceroute/Ping utilities",
		"Network interface info",
		"Bandwidth monitoring",
		"Firewall status (ufw/iptables/firewalld)",
		"Active connections",
		"Exit",
	}) {
	case "1":
		dnsLookup()
	case "2":
		traceroutePing()
	case "3":
		networkInfo()
	case "4":
		bandwidthMonitor()
	case "5":
		firewallStatus()
	case "6":
		activeConnections()
	case "7", "":
		return
	default:
		printError("Unsupported option")
	}
}

func dnsLookup() {
	printSection("🔍 DNS Lookup")
	domain := promptLine("Enter domain/hostname to lookup:")
	if domain == "" {
		return
	}

	// Prefer richer tools first, then fall back.
	switch tool := firstExistingCommand("dig", "nslookup", "host"); tool {
	case "dig":
		printInfo("Using dig")
		_ = runShellCommand("dig " + shellQuote(domain))
	case "nslookup":
		printInfo("Using nslookup")
		_ = runShellCommand("nslookup " + shellQuote(domain))
	case "host":
		printInfo("Using host")
		_ = runShellCommand("host " + shellQuote(domain))
	default:
		printError("No DNS tools available. Install dig, nslookup, or host")
	}
	fmt.Println()
}

func traceroutePing() {
	printSection("🛰️  Traceroute/Ping Utilities")
	choice := menuChoice("Choose utility", []string{"Ping", "Traceroute"})
	target := promptLine("Enter target host/IP:")
	if target == "" {
		return
	}

	switch choice {
	case "1":
		if !checkIfInstalled("ping") {
			printError("ping command not found")
			return
		}
		printInfo("Pinging %s", target)
		_ = runCommandLine("ping", "-c", "4", target)
	case "2":
		switch tool := firstExistingCommand("traceroute", "tracepath"); tool {
		case "traceroute":
			printInfo("Tracing route to %s", target)
			_ = runCommandLine("traceroute", target)
		case "tracepath":
			printInfo("Tracing route to %s", target)
			_ = runCommandLine("tracepath", target)
		default:
			printError("traceroute/tracepath not found")
		}
	default:
		printError("Invalid option")
	}

	fmt.Println()
}

func networkInfo() {
	printSection("🌐 Network Interface Information")
	if checkIfInstalled("ip") {
		printSubsection("IP Addresses:")
		_ = runShellCommand("ip -br addr show")

		printSubsection("Routing Table:")
		_ = runShellCommand("ip route")
	} else if checkIfInstalled("ifconfig") {
		printSubsection("Network Interfaces:")
		_ = runShellCommand("ifconfig")

		printSubsection("Routing Table:")
		_ = runShellCommand("route -n")
	} else {
		printError("No network tools available (ip or ifconfig)")
	}

	fmt.Println()
}

func bandwidthMonitor() {
	printSection("📊 Bandwidth Monitoring")
	// Interactive monitors first; basic interface stats as a last resort.
	switch tool := firstExistingCommand("iftop", "nethogs", "vnstat", "netstat"); tool {
	case "iftop":
		printInfo("Starting iftop (requires sudo, Ctrl+C to quit)")
		fmt.Println()
		_ = runCommandLine("sudo", "iftop")
	case "nethogs":
		printInfo("Starting nethogs (requires sudo, Ctrl+C to quit)")
		fmt.Println()
		_ = runCommandLine("sudo", "nethogs")
	case "vnstat":
		printInfo("Network statistics")
		_ = runCommandLine("vnstat")
	case "netstat":
		printWarning("No bandwidth monitoring tools found. Showing basic network statistics")
		_ = runShellCommand("netstat -i")
	default:
		printWarning("No bandwidth monitoring tools found")
		printInfo("Install one of: iftop, nethogs, vnstat")
		_ = runShellCommand("[ -f /proc/net/dev ] && cat /proc/net/dev")
	}

	fmt.Println()
}

func firewallStatus() {
	printSection("🔥 Firewall Status")
	seen := false
	if checkIfInstalled("ufw") {
		seen = true
		printSubsection("UFW Status:")
		_ = runShellCommand("sudo ufw status verbose")
	}
	if checkIfInstalled("iptables") {
		seen = true
		printSubsection("iptables Rules:")
		_ = runShellCommand("sudo iptables -L -n -v --line-numbers")
	}
	if checkIfInstalled("firewall-cmd") {
		seen = true
		printSubsection("Firewalld Status:")
		_ = runShellCommand("sudo firewall-cmd --list-all")
	}
	if !seen {
		printWarning("No firewall tools detected")
	}
	fmt.Println()
}

func activeConnections() {
	printSection("🔌 Active Network Connections")

	if checkIfInstalled("ss") {
		printSubsection("Listening ports:")
		_ = runShellCommand("ss -tulpn")

		printSubsection("Established connections:")
		_ = runShellCommand("ss -tn state established")
	} else if checkIfInstalled("netstat") {
		printSubsection("Listening ports:")
		_ = runShellCommand("netstat -tulpn")

		printSubsection("Established connections:")
		_ = runShellCommand("netstat -tn | grep ESTABLISHED")
	} else {
		printError("No network tools available (ss or netstat)")
	}

	fmt.Println()
}
