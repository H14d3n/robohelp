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

func runServiceManagement() int {
	backend, ok := serviceBackendOrWarn()
	if !ok {
		return 1
	}

	options := []string{
		"List All Services",
		"List Running Services",
		"List Failed Services",
		"Start/Stop/Restart Service",
		"Enable/Disable Service",
		"Check Service Status",
		"Exit",
	}
	choice, ok := menuSelect("⚙️  Service Management ("+backend.name+")", options)
	if !ok || choice == len(options)-1 {
		return 0
	}

	switch choice {
	case 0:
		printSection("📋 All Services")
		return runShellCommandLogged(backend.listAll)
	case 1:
		printSection("▶️  Running Services")
		return runShellCommandLogged(backend.listRunning)
	case 2:
		printSection("❌ Failed Services")
		if backend.supportsFailed {
			return runShellCommandLogged(backend.listFailed)
		}
		printWarning("%s does not provide a failed-service listing", backend.name)
		return 0
	case 3:
		return serviceControl(backend)
	case 4:
		return serviceEnableDisable(backend)
	case 5:
		return serviceStatus(backend)
	default:
		return 0
	}
}

func serviceControl(backend serviceBackend) int {
	serviceName := promptServiceName(backend, "📋 Current running services:", previewServiceCommand(backend.listRunning))
	if serviceName == "" {
		return 0
	}

	choice, ok := menuSelect("Action for "+serviceName, []string{"Start", "Stop", "Restart"})
	if !ok {
		return 0
	}

	command := ""
	switch choice {
	case 0:
		printInfo("Starting %s", serviceName)
		command = backend.startCommand(serviceName)
	case 1:
		printInfo("Stopping %s", serviceName)
		command = backend.stopCommand(serviceName)
	case 2:
		if !backend.supportsRestart {
			printWarning("%s does not support restart directly", backend.name)
			return 0
		}
		printInfo("Restarting %s", serviceName)
		command = backend.restartCommand(serviceName)
	}

	rc := runServiceOperation(command)
	if rc == 0 {
		runShellCommandLogged(backend.statusCommand(serviceName))
	}
	return rc
}

func serviceEnableDisable(backend serviceBackend) int {
	if !backend.supportsEnable {
		printWarning("%s does not support enable/disable from RoboHelp yet", backend.name)
		return 0
	}

	serviceName := promptServiceName(backend, "📋 Current services:", backend.listPreview)
	if serviceName == "" {
		return 0
	}

	choice, ok := menuSelect("Action for "+serviceName, []string{"Enable (start on boot)", "Disable (do not start on boot)"})
	if !ok {
		return 0
	}

	command := ""
	switch choice {
	case 0:
		printInfo("Enabling %s", serviceName)
		command = backend.enableCommand(serviceName)
	case 1:
		printInfo("Disabling %s", serviceName)
		command = backend.disableCommand(serviceName)
	}

	return runServiceOperation(command)
}

func serviceStatus(backend serviceBackend) int {
	serviceName := promptServiceName(backend, "📋 Current services:", backend.listPreview)
	if serviceName == "" {
		return 0
	}

	printSection("📊 Status: " + serviceName)
	rc := exitCodeFromError(runShellCommand(backend.statusCommand(serviceName)))
	if rc != 0 {
		return rc
	}
	return 0
}

func previewServiceCommand(command string) string {
	return "(" + command + ") | head -n 20"
}

func promptServiceName(backend serviceBackend, heading, listCommand string) string {
	// Reuse the same preview flow before any service-specific action.
	printSubsection(heading)
	runShellCommandLogged(listCommand)
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
	return rc
}
