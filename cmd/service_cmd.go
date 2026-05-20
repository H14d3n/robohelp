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
	"os"
	"runtime"
	"strings"
)

type serviceBackend struct {
	name             string
	manager          string
	listAll          string
	listRunning      string
	listFailed       string
	listPreview      string
	serviceNameHelp  string
	startCommand     func(string) string
	stopCommand      func(string) string
	restartCommand   func(string) string
	statusCommand    func(string) string
	enableCommand    func(string) string
	disableCommand   func(string) string
	configHint       func(string) string
	resetFailedHint  func(string) string
	supportsEnable   bool
	supportsFailed   bool
	supportsRestart  bool
	systemdStyleName bool
}

func detectServiceBackend() serviceBackend {
	switch {
	case checkIfInstalled("systemctl"):
		return systemdServiceBackend()
	case runtime.GOOS == "darwin" && checkIfInstalled("launchctl"):
		return launchdServiceBackend()
	case checkIfInstalled("rc-service"):
		return openRCServiceBackend()
	case checkIfInstalled("service"):
		return sysVServiceBackend()
	default:
		return serviceBackend{}
	}
}

func systemdServiceBackend() serviceBackend {
	return serviceBackend{
		name:             "systemd",
		manager:          "systemctl",
		listAll:          "systemctl list-units --type=service --all --no-pager",
		listRunning:      "systemctl list-units --type=service --state=running --no-pager",
		listFailed:       "systemctl list-units --type=service --state=failed --no-pager",
		listPreview:      "systemctl list-units --type=service --all --no-pager | head -n 20",
		serviceNameHelp:  "Enter service name:",
		startCommand:     prefixedServiceCommand("sudo systemctl start"),
		stopCommand:      prefixedServiceCommand("sudo systemctl stop"),
		restartCommand:   prefixedServiceCommand("sudo systemctl restart"),
		statusCommand:    suffixedServiceCommand("systemctl status", "--no-pager"),
		enableCommand:    prefixedServiceCommand("sudo systemctl enable"),
		disableCommand:   prefixedServiceCommand("sudo systemctl disable"),
		configHint:       func(name string) string { return "systemctl cat " + shellQuote(name) },
		resetFailedHint:  func(name string) string { return "systemctl reset-failed " + shellQuote(name) },
		supportsEnable:   true,
		supportsFailed:   true,
		supportsRestart:  true,
		systemdStyleName: true,
	}
}

func launchdServiceBackend() serviceBackend {
	return serviceBackend{
		name:            "launchd",
		manager:         "launchctl",
		listAll:         "launchctl list",
		listRunning:     `launchctl list | awk 'NR == 1 || $1 != "-" {print}'`,
		listFailed:      `launchctl list | awk 'NR == 1 || $2 != "0" {print}'`,
		listPreview:     "launchctl list | head -n 20",
		serviceNameHelp: "Enter launchd label or domain/label:",
		startCommand: func(name string) string {
			return "sudo launchctl kickstart -k " + launchdTarget(name)
		},
		stopCommand: func(name string) string {
			return "sudo launchctl bootout " + launchdTarget(name)
		},
		restartCommand: func(name string) string {
			target := launchdTarget(name)
			return "sudo launchctl bootout " + target + " 2>/dev/null; sudo launchctl kickstart -k " + target
		},
		statusCommand: func(name string) string {
			return "launchctl print " + launchdTarget(name)
		},
		enableCommand: func(name string) string {
			return "sudo launchctl enable " + launchdTarget(name)
		},
		disableCommand: func(name string) string {
			return "sudo launchctl disable " + launchdTarget(name)
		},
		configHint:      func(name string) string { return "launchctl print " + launchdTarget(name) },
		supportsEnable:  true,
		supportsFailed:  true,
		supportsRestart: true,
	}
}

func openRCServiceBackend() serviceBackend {
	return serviceBackend{
		name:            "OpenRC",
		manager:         "rc-service",
		listAll:         "rc-status -a",
		listRunning:     "rc-status",
		listFailed:      "rc-status --crashed",
		listPreview:     "rc-status -a | head -n 20",
		serviceNameHelp: "Enter service name:",
		startCommand:    serviceActionCommand("sudo rc-service", "start"),
		stopCommand:     serviceActionCommand("sudo rc-service", "stop"),
		restartCommand:  serviceActionCommand("sudo rc-service", "restart"),
		statusCommand:   serviceActionCommand("rc-service", "status"),
		enableCommand:   suffixedServiceCommand("sudo rc-update add", "default"),
		disableCommand:  prefixedServiceCommand("sudo rc-update del"),
		configHint:      func(name string) string { return "rc-service " + shellQuote(name) + " describe" },
		supportsEnable:  true,
		supportsFailed:  true,
		supportsRestart: true,
	}
}

func sysVServiceBackend() serviceBackend {
	return serviceBackend{
		name:            "SysV init",
		manager:         "service",
		listAll:         "service --status-all",
		listRunning:     `service --status-all 2>&1 | grep '\[ + \]' || true`,
		listFailed:      `service --status-all 2>&1 | grep '\[ - \]' || true`,
		listPreview:     "service --status-all 2>&1 | head -n 20",
		serviceNameHelp: "Enter service name:",
		startCommand:    serviceActionCommand("sudo service", "start"),
		stopCommand:     serviceActionCommand("sudo service", "stop"),
		restartCommand:  serviceActionCommand("sudo service", "restart"),
		statusCommand:   serviceActionCommand("service", "status"),
		enableCommand:   sysVEnableCommand,
		disableCommand:  sysVDisableCommand,
		supportsEnable:  true,
		supportsFailed:  true,
		supportsRestart: true,
	}
}

func prefixedServiceCommand(parts ...string) func(string) string {
	return func(name string) string {
		all := append([]string{}, parts...)
		all = append(all, shellQuote(name))
		return strings.Join(all, " ")
	}
}

func suffixedServiceCommand(prefix, suffix string) func(string) string {
	return func(name string) string {
		return prefix + " " + shellQuote(name) + " " + suffix
	}
}

func serviceActionCommand(prefix, action string) func(string) string {
	return func(name string) string {
		return prefix + " " + shellQuote(name) + " " + action
	}
}

func launchdTarget(name string) string {
	name = strings.TrimSpace(name)
	if strings.Contains(name, "/") {
		return shellQuote(name)
	}

	return shellQuote("system/" + name)
}

func sysVEnableCommand(name string) string {
	quoted := shellQuote(name)
	return "sudo update-rc.d " + quoted + " defaults || sudo chkconfig " + quoted + " on"
}

func sysVDisableCommand(name string) string {
	quoted := shellQuote(name)
	return "sudo update-rc.d " + quoted + " disable || sudo chkconfig " + quoted + " off"
}

func serviceBackendAvailable(backend serviceBackend) bool {
	return backend.manager != "" && checkIfInstalled(backend.manager)
}

func serviceBackendOrWarn() (serviceBackend, bool) {
	backend := detectServiceBackend()
	if serviceBackendAvailable(backend) {
		return backend, true
	}

	printError("No supported service manager found. Supported managers: systemd, launchd, OpenRC, SysV init")
	return serviceBackend{}, false
}

func runServiceManagement() {
	backend, ok := serviceBackendOrWarn()
	if !ok {
		os.Exit(1)
	}

	switch menuChoice("⚙️  Service Management ("+backend.name+")", []string{
		"List All Services",
		"List Running Services",
		"List Failed Services",
		"Start/Stop/Restart Service",
		"Enable/Disable Service",
		"Check Service Status",
		"Exit",
	}) {
	case "1":
		printSection("📋 All Services")
		_ = runShellCommand(backend.listAll)
	case "2":
		printSection("▶️  Running Services")
		_ = runShellCommand(backend.listRunning)
	case "3":
		printSection("❌ Failed Services")
		if backend.supportsFailed {
			_ = runShellCommand(backend.listFailed)
		} else {
			printWarning("%s does not provide a failed-service listing", backend.name)
		}
	case "4":
		serviceControl(backend)
	case "5":
		serviceEnableDisable(backend)
	case "6":
		serviceStatus(backend)
	case "7", "":
		return
	default:
		printError("Invalid option selected")
	}
}

func serviceControl(backend serviceBackend) {
	serviceName := promptServiceName(backend, "📋 Current running services:", previewServiceCommand(backend.listRunning))
	if serviceName == "" {
		return
	}

	action := menuChoice("Action for "+serviceName, []string{"Start", "Stop", "Restart"})
	command := ""
	switch action {
	case "1":
		printInfo("Starting %s", serviceName)
		command = backend.startCommand(serviceName)
	case "2":
		printInfo("Stopping %s", serviceName)
		command = backend.stopCommand(serviceName)
	case "3":
		if !backend.supportsRestart {
			printWarning("%s does not support restart directly", backend.name)
			return
		}
		printInfo("Restarting %s", serviceName)
		command = backend.restartCommand(serviceName)
	default:
		printError("Invalid option selected")
		return
	}

	if runServiceOperation(command) == 0 {
		_ = runShellCommand(backend.statusCommand(serviceName))
	}
}

func serviceEnableDisable(backend serviceBackend) {
	if !backend.supportsEnable {
		printWarning("%s does not support enable/disable from RoboHelp yet", backend.name)
		return
	}

	serviceName := promptServiceName(backend, "📋 Current services:", backend.listPreview)
	if serviceName == "" {
		return
	}

	action := menuChoice("Action for "+serviceName, []string{"Enable (start on boot)", "Disable (do not start on boot)"})
	command := ""
	switch action {
	case "1":
		printInfo("Enabling %s", serviceName)
		command = backend.enableCommand(serviceName)
	case "2":
		printInfo("Disabling %s", serviceName)
		command = backend.disableCommand(serviceName)
	default:
		printError("Invalid option selected")
		return
	}

	runServiceOperation(command)
}

func serviceStatus(backend serviceBackend) {
	serviceName := promptServiceName(backend, "📋 Current services:", backend.listPreview)
	if serviceName == "" {
		return
	}

	printSection("📊 Status: " + serviceName)
	rc := exitCodeFromError(runShellCommand(backend.statusCommand(serviceName)))
	if rc != 0 {
		os.Exit(rc)
	}
}

func previewServiceCommand(command string) string {
	return "(" + command + ") | head -n 20"
}

func promptServiceName(backend serviceBackend, heading, listCommand string) string {
	// Reuse the same preview flow before any service-specific action.
	printSubsection(heading)
	_ = runShellCommand(listCommand)
	waitForEnter()
	return promptLine(backend.serviceNameHelp)
}

func runServiceOperation(command string) int {
	rc := exitCodeFromError(runShellCommand(command))
	if rc == 0 {
		printSuccess("Operation successful")
		return 0
	}

	printError("Operation failed")
	os.Exit(rc)
	return rc
}
