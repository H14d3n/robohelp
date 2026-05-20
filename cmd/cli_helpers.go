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
	"bufio"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"
	"unicode"

	"github.com/charmbracelet/lipgloss"
	"github.com/h14d3n/robohelp/internal/app/ui"
)

const (
	colorRed    = "\033[0;31m"
	colorGreen  = "\033[0;32m"
	colorYellow = "\033[1;33m"
	colorCyan   = "\033[0;36m"
	colorNC     = "\033[0m"
)

var (
	outputTitleStyle = lipgloss.NewStyle().
				Bold(true).
				Foreground(lipgloss.Color("63")).
				Border(lipgloss.NormalBorder(), false, false, true, false).
				BorderForeground(lipgloss.Color("63")).
				Padding(0, 1).
				Width(48)

	outputSubtleStyle  = lipgloss.NewStyle().Foreground(lipgloss.Color("245"))
	outputSuccessStyle = lipgloss.NewStyle().Bold(true).Foreground(lipgloss.Color("42"))
	outputErrorStyle   = lipgloss.NewStyle().Bold(true).Foreground(lipgloss.Color("203"))
	outputWarnStyle    = lipgloss.NewStyle().Bold(true).Foreground(lipgloss.Color("214"))
	outputInfoStyle    = lipgloss.NewStyle().Foreground(lipgloss.Color("87"))

	stdinReader          = bufio.NewReader(os.Stdin)
	commandScreenVisible bool
	sudoCredentialsReady bool
)

var argAliases = map[string]string{
	"-pm":  "--package-management",
	"-A":   "--ansible",
	"-pud": "--p-update",
	"-pur": "--p-upgrade",
	"-arm": "--p-autoremove",
	"-acl": "--p-autoclean",
	"-fu":  "--full-upgrade",
	"-dur": "--dist-upgrade",
	"-pi":  "--p-install",
	"-ps":  "--p-search",
	"-prm": "--p-remove",
	"-pp":  "--p-purge",
	"-ssh": "--ssh-settings",
	"-hc":  "--health-check",
	"-nd":  "--network-diag",
	"-dm":  "--disk-management",
	"-tw":  "--troubleshoot",
	"-dx":  "--dev-distribute",
	"-h":   "--help",
}

func normalizeArgs(args []string) []string {
	normalized := make([]string, 0, len(args))
	for _, arg := range args {
		if translated, ok := argAliases[arg]; ok {
			normalized = append(normalized, translated)
			continue
		}

		if strings.HasPrefix(arg, "-") && strings.Contains(arg, "=") {
			// Support short aliases in --flag=value form too.
			name, value, found := strings.Cut(arg, "=")
			if found {
				if translated, ok := argAliases[name]; ok {
					normalized = append(normalized, translated+"="+value)
					continue
				}
			}
		}

		normalized = append(normalized, arg)
	}

	return normalized
}

func checkIfInstalled(command string) bool {
	_, err := exec.LookPath(command)
	return err == nil
}

func printSection(title string) {
	ensureCommandScreen()

	fmt.Println()
	fmt.Println(renderOutputTitle(title))
	fmt.Println()
}

func printSubsection(title string) {
	ensureCommandScreen()

	fmt.Println()
	fmt.Println(outputInfoStyle.Render("◆ " + title))
}

func printSuccess(message string, args ...any) {
	ensureCommandScreen()
	fmt.Println(outputSuccessStyle.Render("✓ " + fmt.Sprintf(message, args...)))
}

func printError(message string, args ...any) {
	ensureCommandScreen()
	fmt.Println(outputErrorStyle.Render("✗ " + fmt.Sprintf(message, args...)))
}

func printWarning(message string, args ...any) {
	ensureCommandScreen()
	fmt.Println(outputWarnStyle.Render("! " + fmt.Sprintf(message, args...)))
}

func printInfo(message string, args ...any) {
	ensureCommandScreen()
	fmt.Println(outputInfoStyle.Render("• " + fmt.Sprintf(message, args...)))
}

func printCommandHeader(title string) {
	printSection(title)
}

func renderOutputTitle(title string) string {
	icon, text, ok := strings.Cut(strings.TrimSpace(title), " ")
	if !ok {
		return outputTitleStyle.Render(title)
	}

	content := lipgloss.JoinHorizontal(
		lipgloss.Center,
		icon,
		lipgloss.NewStyle().MarginLeft(1).Render(text),
	)

	return outputTitleStyle.Render(content)
}

func promptLine(prompt string) string {
	return promptValue(prompt, "")
}

func promptDefault(prompt, fallback string) string {
	return promptValue(prompt, fallback)
}

func promptValue(prompt, initial string) string {
	prepareUIScreen()
	value, ok, err := ui.RunInput(prompt, initial)
	if err != nil || !ok {
		return ""
	}
	return strings.TrimSpace(value)
}

func confirm(prompt string) bool {
	prepareUIScreen()
	confirmed, err := ui.RunConfirm(prompt)
	return err == nil && confirmed
}

func waitForEnter() {
	fmt.Println()
	fmt.Print(outputSubtleStyle.Render("Press Enter to continue..."))
	_, _ = stdinReader.ReadString('\n')
}

func menuChoice(title string, items []string) string {
	value, ok := chooseValue(title, buildChoiceOptions(items))
	if !ok {
		return ""
	}
	return value
}

func buildChoiceOptions(items []string) []ui.Option {
	options := make([]ui.Option, 0, len(items))
	for i, item := range items {
		options = append(options, ui.Option{
			Label: item,
			Value: strconv.Itoa(i + 1),
		})
	}
	return options
}

func chooseValue(title string, options []ui.Option) (string, bool) {
	prepareUIScreen()
	value, ok, err := ui.RunChoice(title, options)
	return value, err == nil && ok
}

func prepareUIScreen() {
	fmt.Print("\033[H\033[2J")
	commandScreenVisible = false
}

func ensureCommandScreen() {
	if !commandScreenVisible {
		prepareCommandScreen()
	}
}

func prepareCommandScreen() {
	prepareUIScreen()
	ShowStartupBanner()
	commandScreenVisible = true
}

func runCommandLine(name string, args ...string) int {
	ensureCommandScreen()
	if commandLineRequiresSudo(name, args...) {
		if err := ensureSudoCredentials(); err != nil {
			printError("This tool must be run as root or with sudo rights.")
			return 1
		}
	}

	cmd := exec.Command(name, args...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin
	return exitCodeFromError(cmd.Run())
}

func commandOutput(command string) string {
	out, err := exec.Command("sh", "-c", command).Output()
	if err != nil {
		return ""
	}
	return strings.TrimSpace(string(out))
}

func firstExistingCommand(commands ...string) string {
	for _, command := range commands {
		if checkIfInstalled(command) {
			return command
		}
	}
	return ""
}

func homePath(parts ...string) string {
	home, err := os.UserHomeDir()
	if err != nil {
		return filepath.Join(parts...)
	}
	all := append([]string{home}, parts...)
	return filepath.Join(all...)
}

func parseInt(value string) int {
	parsed, err := strconv.Atoi(strings.TrimSpace(value))
	if err != nil {
		return 0
	}
	return parsed
}

func parseFloat(value string) float64 {
	parsed, err := strconv.ParseFloat(strings.Trim(strings.TrimSpace(value), ","), 64)
	if err != nil {
		return 0
	}
	return parsed
}

func runDevDistribute() {
	source, err := os.Executable()
	if err != nil {
		fmt.Printf("%srobohelp distribution failed: %v%s\n", colorRed, err, colorNC)
		os.Exit(1)
	}

	if rc := runCommandLine("sudo", "cp", source, "/usr/local/bin/robohelp"); rc != 0 {
		fmt.Printf("%srobohelp distribution failed.%s\n", colorRed, colorNC)
		os.Exit(rc)
	}

	fmt.Printf("%srobohelp distributed%s\n", colorGreen, colorNC)
}

func printCLIError(message string) {
	prepareCommandScreen()
	fmt.Println()
	fmt.Printf("%s%s%s\n", colorRed, message, colorNC)
}

func requireRootOrExit() {
	if err := ensureSudoCredentials(); err == nil {
		return
	}

	printCLIError("❌ This feature must be run as root or with sudo rights.")
	os.Exit(1)
}

func ensureSudoCredentials() error {
	if sudoCredentialsReady {
		return nil
	}
	if os.Geteuid() == 0 {
		sudoCredentialsReady = true
		return nil
	}

	ensureCommandScreen()
	// Cache sudo once so repeated operations don't re-prompt.
	check := exec.Command("sudo", "-v")
	check.Stdin = os.Stdin
	check.Stdout = os.Stdout
	check.Stderr = os.Stderr
	if err := check.Run(); err != nil {
		return err
	}

	sudoCredentialsReady = true
	return nil
}

func commandLineRequiresSudo(name string, args ...string) bool {
	if filepath.Base(name) != "sudo" {
		return false
	}

	return !sudoIsNonInteractive(args)
}

func shellCommandRequiresSudo(command string) bool {
	tokens := shellCommandTokens(command)
	for i, token := range tokens {
		if token == "sudo" && !sudoIsNonInteractive(tokens[i+1:]) {
			return true
		}
	}

	return false
}

func shellCommandTokens(command string) []string {
	return strings.FieldsFunc(command, func(r rune) bool {
		return unicode.IsSpace(r) || strings.ContainsRune(";&|()", r)
	})
}

func sudoIsNonInteractive(args []string) bool {
	for _, arg := range args {
		if arg == "--" {
			return false
		}
		if arg == "-n" || arg == "--non-interactive" {
			return true
		}
		if strings.HasPrefix(arg, "-") && !strings.HasPrefix(arg, "--") && strings.Contains(arg[1:], "n") {
			return true
		}
		if !strings.HasPrefix(arg, "-") {
			return false
		}
	}

	return false
}

func help() {
	const (
		sectionColor = "\033[38;5;63m"
		nc           = "\033[0m"
	)

	prepareCommandScreen()

	out := os.Stdout

	fmt.Fprintln(out)
	fmt.Fprintln(out, "Usage: robohelp [option]")
	fmt.Fprintln(out)
	fmt.Fprintf(out, "%s🎯 Main Menus:%s\n", sectionColor, nc)
	fmt.Fprintln(out, "\trobohelp\t\t\tLaunch RoboHelp Main Menu")
	fmt.Fprintln(out, "\t-pm,  --package-management\tInteractive package management menu")
	fmt.Fprintln(out, "\t-A,   --ansible\t\t\tAnsible Fast Management (AFM)")
	fmt.Fprintln(out)
	fmt.Fprintf(out, "%s📦 Package Management (Quick Commands):%s\n", sectionColor, nc)
	fmt.Fprintln(out, "\t-pud, --p-update\t\tUpdate Package Repositories [1]")
	fmt.Fprintln(out, "\t-pur, --p-upgrade\t\tUpgrade installed packages [1]")
	fmt.Fprintln(out, "\t-arm, --p-autoremove\t\tRemove unnecessary packages [1]")
	fmt.Fprintln(out, "\t-acl, --p-autoclean\t\tClean up local repository [1]")
	fmt.Fprintln(out, "\t-fu,  --full-upgrade\t\tRun full system upgrade with options [1]")
	fmt.Fprintln(out, "\t-dur, --dist-upgrade\t\tRun distribution upgrade")
	fmt.Fprintln(out, "\t-pi,  --p-install <name>\tInstall package(s)")
	fmt.Fprintln(out, "\t-ps,  --p-search <name>\t\tSearch package(s)")
	fmt.Fprintln(out, "\t-prm, --p-remove <name>\t\tRemove package(s)")
	fmt.Fprintln(out, "\t-pp,  --p-purge <name>\t\tPurge package(s) with dependencies")
	fmt.Fprintln(out)
	fmt.Fprintf(out, "%s⚙️  System Tools (Quick Commands):%s\n", sectionColor, nc)
	fmt.Fprintln(out, "\t-ssh, --ssh-settings\t\tSSH configuration menu")
	fmt.Fprintln(out, "\t-hc,  --health-check\t\tRun system health check")
	fmt.Fprintln(out, "\t-nd,  --network-diag\t\tNetwork diagnostics menu")
	fmt.Fprintln(out, "\t-dm,  --disk-management\t\tDisk management menu")
	fmt.Fprintln(out, "\t-tw,  --troubleshoot\t\tTroubleshooting wizard")
	fmt.Fprintf(out, "%sℹ️  Information:%s\n", sectionColor, nc)
	fmt.Fprintln(out, "\t-h,   --help\t\t\tShow this help message")
	fmt.Fprintln(out)
}
