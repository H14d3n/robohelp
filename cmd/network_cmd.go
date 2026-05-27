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
	options := []string{
		"DNS Lookup",
		"Traceroute/Ping utilities",
		"Network interface info",
		"Bandwidth monitoring",
		"Firewall status (ufw/iptables/firewalld)",
		"Active connections",
		"Exit",
	}
	choice, ok := menuSelect("🌐 Network Diagnostics", options)
	if !ok || choice == len(options)-1 {
		return
	}

	switch choice {
	case 0:
		dnsLookup()
	case 1:
		traceroutePing()
	case 2:
		networkInfo()
	case 3:
		bandwidthMonitor()
	case 4:
		firewallStatus()
	case 5:
		activeConnections()
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
		runShellCommandLogged("dig " + shellQuote(domain))
	case "nslookup":
		printInfo("Using nslookup")
		runShellCommandLogged("nslookup " + shellQuote(domain))
	case "host":
		printInfo("Using host")
		runShellCommandLogged("host " + shellQuote(domain))
	default:
		printError("No DNS tools available. Install dig, nslookup, or host")
	}
	fmt.Println()
}

func traceroutePing() {
	printSection("🛰️  Traceroute/Ping Utilities")
	choice, ok := menuSelect("Choose utility", []string{"Ping", "Traceroute"})
	if !ok {
		return
	}
	target := promptLine("Enter target host/IP:")
	if target == "" {
		return
	}

	switch choice {
	case 0:
		if !checkIfInstalled("ping") {
			printError("ping command not found")
			return
		}
		printInfo("Pinging %s", target)
		runCommandLineLogged("ping", "-c", "4", target)
	case 1:
		switch tool := firstExistingCommand("traceroute", "tracepath"); tool {
		case "traceroute":
			printInfo("Tracing route to %s", target)
			runCommandLineLogged("traceroute", target)
		case "tracepath":
			printInfo("Tracing route to %s", target)
			runCommandLineLogged("tracepath", target)
		default:
			printError("traceroute/tracepath not found")
		}
	}

	fmt.Println()
}

func networkInfo() {
	printSection("🌐 Network Interface Information")
	if checkIfInstalled("ip") {
		printSubsection("IP Addresses:")
		runShellCommandLogged("ip -br addr show")

		printSubsection("Routing Table:")
		runShellCommandLogged("ip route")
	} else if checkIfInstalled("ifconfig") {
		printSubsection("Network Interfaces:")
		runShellCommandLogged("ifconfig")

		printSubsection("Routing Table:")
		runShellCommandLogged("route -n")
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
		runCommandLineLogged("sudo", "iftop")
	case "nethogs":
		printInfo("Starting nethogs (requires sudo, Ctrl+C to quit)")
		fmt.Println()
		runCommandLineLogged("sudo", "nethogs")
	case "vnstat":
		printInfo("Network statistics")
		runCommandLineLogged("vnstat")
	case "netstat":
		printWarning("No bandwidth monitoring tools found. Showing basic network statistics")
		runShellCommandLogged("netstat -i")
	default:
		printWarning("No bandwidth monitoring tools found")
		printInfo("Install one of: iftop, nethogs, vnstat")
		runShellCommandLogged("[ -f /proc/net/dev ] && cat /proc/net/dev")
	}

	fmt.Println()
}

func firewallStatus() {
	printSection("🔥 Firewall Status")
	seen := false
	if checkIfInstalled("ufw") {
		seen = true
		printSubsection("UFW Status:")
		runShellCommandLogged("sudo ufw status verbose")
	}
	if checkIfInstalled("iptables") {
		seen = true
		printSubsection("iptables Rules:")
		runShellCommandLogged("sudo iptables -L -n -v --line-numbers")
	}
	if checkIfInstalled("firewall-cmd") {
		seen = true
		printSubsection("Firewalld Status:")
		runShellCommandLogged("sudo firewall-cmd --list-all")
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
		runShellCommandLogged("ss -tulpn")

		printSubsection("Established connections:")
		runShellCommandLogged("ss -tn state established")
	} else if checkIfInstalled("netstat") {
		printSubsection("Listening ports:")
		runShellCommandLogged("netstat -tulpn")

		printSubsection("Established connections:")
		runShellCommandLogged("netstat -tn | grep ESTABLISHED")
	} else {
		printError("No network tools available (ss or netstat)")
	}

	fmt.Println()
}
