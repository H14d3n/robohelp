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
	"strings"

	"github.com/h14d3n/robohelp/internal/app/ui"
)

func runSSHSettings() int {
	if !checkIfInstalled("ssh") || !checkIfInstalled("ssh-keygen") {
		printError("SSH or ssh-keygen is not installed. Install with robohelp -pi openssh-client")
		return 1
	}

	options := []string{
		"Establish SSH connection",
		"Generate SSH Key Pair",
		"Copy SSH Key to Remote Host",
		"Edit SSH Config File",
		"Exit",
	}
	choice, ok := menuSelect("🔐 SSH Configuration", options)
	if !ok || choice == len(options)-1 {
		return 0
	}

	switch choice {
	case 0:
		sshConnect()
	case 1:
		generateSSHKey()
	case 2:
		copySSHKey()
	case 3:
		editSSHConfig()
	}

	return 0
}

func sshConnect() {
	if confirm("Do you want to use a previously used command?") {
		if reused := reuseSSHCommand(); reused {
			return
		}
		printWarning("Falling back to manual entry")
	}

	user, host, port, ok := promptSSHParts("Enter username, host and port (e.g. user host 22):")
	if !ok {
		return
	}

	sshDir := homePath(".ssh")
	_ = os.MkdirAll(sshDir, 0700)
	target := fmt.Sprintf("%s@%s", user, host)
	// Keep only the minimal reusable part of the command in history.
	historyEntry := fmt.Sprintf("%s -p %s", target, port)
	rc := runCommandLine("ssh", target, "-p", port)
	if rc == 0 {
		appendUniqueLine(filepath.Join(sshDir, ".robohelp_lsc.txt"), historyEntry)
	}
}

func reuseSSHCommand() bool {
	historyFile := homePath(".ssh", ".robohelp_lsc.txt")
	data, err := os.ReadFile(historyFile)
	if err != nil || strings.TrimSpace(string(data)) == "" {
		printWarning("No previous SSH commands found")
		return false
	}

	commands := strings.Split(strings.TrimSpace(string(data)), "\n")
	options := make([]ui.Option, 0, len(commands))
	for _, command := range commands {
		options = append(options, ui.Option{
			Label: "ssh " + command,
			Value: command,
		})
	}

	selectedCommand, ok := chooseValue("🔐 Previous SSH Commands", options)
	if !ok {
		return true
	}

	printInfo("Reusing command: ssh %s", selectedCommand)
	runShellCommandLogged("ssh " + selectedCommand)
	return true
}

func generateSSHKey() {
	printSection("⚙️  Generating SSH Key Pair")
	privateKey := homePath(".ssh", "id_rsa")
	publicKey := privateKey + ".pub"
	if _, err := os.Stat(privateKey); err == nil {
		printWarning("SSH key already exists at ~/.ssh/id_rsa. Showing public key")
		runShellCommandLogged("cat " + shellQuote(publicKey))
		return
	}

	rc := runCommandLine("ssh-keygen", "-t", "rsa", "-b", "4096")
	if rc == 0 {
		printSuccess("SSH key pair generated successfully")
		printInfo("Public and private keys are located at ~/.ssh/")
	}
}

func copySSHKey() {
	if !checkIfInstalled("ssh-copy-id") {
		printError("ssh-copy-id is not installed")
		return
	}

	user, host, port, ok := promptSSHParts("Enter username, host and port to copy key to (e.g. user host 22):")
	if !ok {
		return
	}

	runCommandLineLogged("ssh-copy-id", "-p", port, fmt.Sprintf("%s@%s", user, host))
}

func promptSSHParts(prompt string) (string, string, string, bool) {
	parts := strings.Fields(promptLine(prompt))
	if len(parts) < 2 {
		printError("Username and host are required")
		return "", "", "", false
	}

	port := "22"
	if len(parts) > 2 && parts[2] != "" {
		port = parts[2]
	}

	return parts[0], parts[1], port, true
}

func editSSHConfig() {
	configPath := homePath(".ssh", "config")
	_ = os.MkdirAll(filepath.Dir(configPath), 0700)
	editor := os.Getenv("EDITOR")

	if editor == "" {
		editor = "nano"
	}

	printInfo("Opening SSH config file")
	runShellCommandLogged(editor + " " + shellQuote(configPath))
}

func appendUniqueLine(path, line string) {
	data, err := os.ReadFile(path)
	if err == nil {
		for _, existing := range strings.Split(string(data), "\n") {
			if strings.TrimSpace(existing) == line {
				return
			}
		}
	}
	file, err := os.OpenFile(path, os.O_CREATE|os.O_APPEND|os.O_WRONLY, 0600)
	if err != nil {
		return
	}
	defer file.Close()
	_, _ = fmt.Fprintln(file, line)
}
