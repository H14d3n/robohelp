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
	"sort"
	"strings"
	"time"

	"github.com/h14d3n/robohelp/internal/app/ui"
)

func runAnsible() int {
	if !checkIfInstalled("ansible") {
		printError("Ansible is not installed. Install with robohelp -pi ansible-core or via pip install ansible")
		return 1
	}

	options := []string{
		"Run Playbook (with Flags)",
		"Test Connection (Ping Hosts)",
		"Live-Fire Command",
		"View Inventory",
		"View Last Run Log",
		"Exit",
	}
	choice, ok := menuSelect("🤖 Ansible Fast Management (AFM)", options)
	if !ok || choice == len(options)-1 {
		return 0
	}

	switch choice {
	case 0:
		return runAnsiblePlaybook()
	case 1:
		return runAnsiblePing()
	case 2:
		return runAnsibleLiveFire()
	case 3:
		return viewAnsibleInventory()
	case 4:
		return viewAnsibleLog()
	default:
		return 0
	}
}

func findPlaybooks() []string {
	var playbooks []string
	_ = filepath.WalkDir(".", func(path string, d os.DirEntry, err error) error {
		if err != nil || d.IsDir() {
			return nil
		}
		if strings.HasSuffix(path, ".yml") {
			playbooks = append(playbooks, path)
		}
		return nil
	})
	sort.Strings(playbooks)
	return playbooks
}

func runAnsiblePlaybook() int {
	printSection("🤖 Run Playbook")

	playbooks := findPlaybooks()
	if len(playbooks) == 0 {
		printError("No playbook files (.yml) found in the current directory")
		return 1
	}

	options := make([]ui.Option, 0, len(playbooks))
	for _, playbook := range playbooks {
		options = append(options, ui.Option{
			Label: filepath.Dir(playbook) + "/" + filepath.Base(playbook),
			Value: playbook,
		})
	}
	playbook, ok := chooseValue("📋 Select Playbook", options)
	if !ok {
		return 0
	}

	additionalFlags := promptLine("Enter additional action flag for extra-vars action=<value>, or leave empty:")
	vaultFlag := "--ask-become-pass"
	if confirm("Do you use Ansible Vault?") {
		vaultFlag = "--ask-vault-pass"
	}

	inventory := ansibleInventoryPath()
	if inventory == "" {
		printError("No inventory file found (expected hosts.yml or hosts.*)")
		return 1
	}

	args := []string{"-i", inventory, playbook}
	if additionalFlags != "" {
		args = append(args, "--extra-vars", "action="+additionalFlags)
	}
	args = append(args, vaultFlag, "-v")

	printInfo("Running playbook: %s", playbook)
	printInfo("Flags: %s", strings.Join(args, " "))
	fmt.Println()
	printWarning("Starting in 5 seconds")
	fmt.Println()
	time.Sleep(5 * time.Second)

	rc := runCommandLine("ansible-playbook", args...)
	if rc == 0 {
		writeAnsibleLog("Successfully ran playbook: " + playbook)
		return 0
	}
	writeAnsibleLog("Running playbook failed: " + playbook)
	return rc
}

func runAnsiblePing() int {
	printSection("🤖 Test Connection")

	inventory := ansibleInventoryPath()
	if inventory == "" {
		printError("No inventory file found (expected hosts.yml or hosts.*)")
		return 1
	}

	printInfo("Running Ansible ping against all hosts")

	rc := runCommandLine("ansible", "all", "-i", inventory, "-m", "ping")
	if rc == 0 {
		writeAnsibleLog("Ping ran successfully")
		return 0
	}
	writeAnsibleLog("Running Ping with inventory file failed")
	return rc
}

func runAnsibleLiveFire() int {
	printSection("🤖 Live-Fire Command")

	inventory := ansibleInventoryPath()
	if inventory == "" {
		printError("No inventory file found (expected hosts.yml or hosts.*)")
		return 1
	}

	command := promptLine("Which command would you like to Live-Fire?")
	if command == "" {
		return 0
	}
	choice, ok := menuSelect("Which hosts should be targeted?", []string{"All", "Write Own (single host or host groups)"})
	if !ok {
		return 0
	}

	target := "all"
	if choice == 1 {
		target = promptLine("Enter host or group (e.g. webservers, nagios):")
		if target == "" {
			return 0
		}
	}

	printInfo("Targeting: %s", target)
	printInfo("Command: %s", command)
	rc := runCommandLine("ansible", "-i", inventory, target, "-m", "shell", "-a", command)
	if rc != 0 {
		return rc
	}
	return 0
}

func viewAnsibleInventory() int {
	printSection("📄 Inventory")

	inventory := ansibleInventoryPath()
	if inventory == "" {
		printError("No inventory file found (expected hosts.yml or hosts.*)")
		return 1
	}

	printInfo("Showing inventory: %s", inventory)
	pager := os.Getenv("PAGER")
	if pager != "" {
		if rc := exitCodeFromError(runShellCommand(pager + " " + shellQuote(inventory))); rc == 0 {
			return 0
		}
	}
	runShellCommandLogged("cat " + shellQuote(inventory))
	return 0
}

func viewAnsibleLog() int {
	printSection("📄 Last Run Log")

	logFile := ansibleLogPath()
	if _, err := os.Stat(logFile); err != nil {
		printError("No Ansible log found at %s", logFile)
		return 1
	}

	printInfo("Showing log: %s", logFile)
	runShellCommandLogged("tail -n 50 " + shellQuote(logFile))
	return 0
}

func ansibleInventoryPath() string {
	if _, err := os.Stat("hosts.yml"); err == nil {
		return "hosts.yml"
	}
	matches, _ := filepath.Glob("hosts.*")
	sort.Strings(matches)
	if len(matches) > 0 {
		return matches[0]
	}
	return ""
}

func ansibleLogPath() string {
	return homePath(".log", "afmrun.log")
}

func writeAnsibleLog(message string) {
	logPath := ansibleLogPath()
	if err := os.MkdirAll(filepath.Dir(logPath), 0755); err != nil {
		return
	}
	file, err := os.OpenFile(logPath, os.O_CREATE|os.O_APPEND|os.O_WRONLY, 0644)
	if err != nil {
		return
	}
	defer file.Close()
	_, _ = fmt.Fprintf(file, "%s - %s\n", time.Now().Format("2006-01-02 15:04:05"), message)
}
