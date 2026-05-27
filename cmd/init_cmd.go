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
	"errors"
	"fmt"
	"os"
	"strings"

	"github.com/h14d3n/robohelp/internal/app/ui"
	"github.com/spf13/cobra"
	"github.com/spf13/pflag"
)

var errHandledCLI = errors.New("cli message already shown")

type cliFlags struct {
	packageManagement bool
	ansible           bool
	updatePackages    bool
	upgradePackages   bool
	autoremove        bool
	autoclean         bool
	fullUpgrade       bool
	distUpgrade       bool
	installPackage    string
	searchPackage     string
	removePackage     string
	purgePackage      string
	sshSettings       bool
	healthCheck       bool
	networkDiag       bool
	diskManagement    bool
	troubleshoot      bool
	devDistribute     bool
}

func InitCmd() {
	args := normalizeArgs(os.Args[1:])
	opts := cliFlags{}

	rootCmd := &cobra.Command{
		Use:           "robohelp [option] [values...]",
		Short:         "System maintenance helper",
		SilenceUsage:  true,
		SilenceErrors: true,
		Args:          cobra.ArbitraryArgs,
		RunE: func(cmd *cobra.Command, remaining []string) error {
			if len(args) == 0 {
				code := runUI()
				if code != 0 {
					os.Exit(code)
				}
				return nil
			}
			code, err := runSelectedAction(remaining, opts)
			if err != nil {
				return err
			}
			if code != 0 {
				os.Exit(code)
			}
			return nil
		},
	}
	rootCmd.SetOut(os.Stdout)
	rootCmd.SetErr(os.Stderr)
	rootCmd.SetUsageFunc(func(cmd *cobra.Command) error {
		help()
		return nil
	})
	rootCmd.SetHelpFunc(func(cmd *cobra.Command, args []string) {
		help()
	})
	rootCmd.SetFlagErrorFunc(func(cmd *cobra.Command, err error) error {
		printCLIError(flagErrorMessage(err))
		return errHandledCLI
	})

	registerCLIFlags(rootCmd.Flags(), &opts)

	rootCmd.SetArgs(args)
	if err := rootCmd.Execute(); err != nil {
		if errors.Is(err, errHandledCLI) {
			return
		}

		var cliErr cliInputError
		if errors.As(err, &cliErr) {
			printCLIError(cliErr.message)
			os.Exit(cliErr.code)
		}

		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}

func runSelectedAction(remaining []string, opts cliFlags) (int, error) {
	// Keep CLI usage predictable by allowing one primary action per command.
	if opts.selectedCount() > 1 {
		return 0, cliInputError{message: "❌ Please use only one action flag at a time.", code: 1}
	}

	if len(remaining) > 0 && !opts.hasValueAction() {
		return 0, cliInputError{message: "❌ Unknown or no flag provided. Try -h for help.", code: 1}
	}

	switch {
	case opts.packageManagement:
		if err := requireRoot(); err != nil {
			printCLIError(err.Error())
			return 1, nil
		}
		return runPackageManagement(), nil
	case opts.devDistribute:
		if err := requireRoot(); err != nil {
			printCLIError(err.Error())
			return 1, nil
		}
		return runDevDistribute(), nil
	case opts.installPackage != "":
		return runAppActionValues(ui.ActionPackageInstall, valuesFromFlagAndArgs(opts.installPackage, remaining)), nil
	case opts.searchPackage != "":
		return runAppActionValues(ui.ActionPackageSearch, valuesFromFlagAndArgs(opts.searchPackage, remaining)), nil
	case opts.removePackage != "":
		return runAppActionValues(ui.ActionPackageRemove, valuesFromFlagAndArgs(opts.removePackage, remaining)), nil
	case opts.purgePackage != "":
		return runAppActionValues(ui.ActionPackagePurge, valuesFromFlagAndArgs(opts.purgePackage, remaining)), nil
	case opts.ansible:
		return runAppAction(ui.ActionAnsible, ""), nil
	case opts.updatePackages:
		return runAppAction(ui.ActionPackageUpdate, ""), nil
	case opts.upgradePackages:
		return runAppAction(ui.ActionPackageUpgrade, ""), nil
	case opts.autoremove:
		return runAppAction(ui.ActionPackageAutoremove, ""), nil
	case opts.autoclean:
		return runAppAction(ui.ActionPackageAutoclean, ""), nil
	case opts.fullUpgrade:
		return runAppAction(ui.ActionPackageFullUpgrade, ""), nil
	case opts.distUpgrade:
		return runAppAction(ui.ActionPackageDistUpgrade, ""), nil
	case opts.sshSettings:
		return runAppAction(ui.ActionSSH, ""), nil
	case opts.healthCheck:
		return runAppAction(ui.ActionHealthCheck, ""), nil
	case opts.networkDiag:
		return runAppAction(ui.ActionNetworkDiagnostics, ""), nil
	case opts.diskManagement:
		return runAppAction(ui.ActionDiskManagement, ""), nil
	case opts.troubleshoot:
		return runAppAction(ui.ActionTroubleshoot, ""), nil
	default:
		return runUI(), nil
	}
}

func (opts cliFlags) selectedCount() int {
	return countSelected(
		opts.packageManagement,
		opts.ansible,
		opts.updatePackages,
		opts.upgradePackages,
		opts.autoremove,
		opts.autoclean,
		opts.fullUpgrade,
		opts.distUpgrade,
		opts.installPackage != "",
		opts.searchPackage != "",
		opts.removePackage != "",
		opts.purgePackage != "",
		opts.sshSettings,
		opts.healthCheck,
		opts.networkDiag,
		opts.diskManagement,
		opts.troubleshoot,
		opts.devDistribute,
	)
}

func (opts cliFlags) hasValueAction() bool {
	return opts.installPackage != "" ||
		opts.searchPackage != "" ||
		opts.removePackage != "" ||
		opts.purgePackage != ""
}

func valuesFromFlagAndArgs(value string, args []string) []string {
	values := strings.Fields(value)
	values = append(values, args...)
	return values
}

type cliInputError struct {
	message string
	code    int
}

func (e cliInputError) Error() string {
	return e.message
}

func flagErrorMessage(err error) string {
	message := err.Error()

	switch {
	case strings.Contains(message, "--p-install"):
		return "❌ No packages specified to install."
	case strings.Contains(message, "--p-remove"):
		return "❌ No packages specified to remove."
	case strings.Contains(message, "--p-purge"):
		return "❌ No packages specified to purge."
	case strings.Contains(message, "--p-search"):
		return "❌ No packages specified to search."
	default:
		return "❌ Unknown or no flag provided. Try -h for help."
	}
}

func registerCLIFlags(flags *pflag.FlagSet, opts *cliFlags) {
	addBoolFlag(flags, &opts.packageManagement, "package-management", "Interactive package management menu")
	addBoolFlag(flags, &opts.ansible, "ansible", "Ansible Fast Management")

	addBoolFlag(flags, &opts.updatePackages, "p-update", "Update package repositories")
	addBoolFlag(flags, &opts.upgradePackages, "p-upgrade", "Upgrade installed packages")
	addBoolFlag(flags, &opts.autoremove, "p-autoremove", "Remove unnecessary packages")
	addBoolFlag(flags, &opts.autoclean, "p-autoclean", "Clean package cache")
	addBoolFlag(flags, &opts.fullUpgrade, "full-upgrade", "Run update, upgrade, autoremove, and autoclean")
	addBoolFlag(flags, &opts.distUpgrade, "dist-upgrade", "Run distribution upgrade")

	addStringFlag(flags, &opts.installPackage, "p-install", "Install package(s)")
	addStringFlag(flags, &opts.searchPackage, "p-search", "Search package(s)")
	addStringFlag(flags, &opts.removePackage, "p-remove", "Remove package(s)")
	addStringFlag(flags, &opts.purgePackage, "p-purge", "Purge package(s)")

	addBoolFlag(flags, &opts.sshSettings, "ssh-settings", "SSH configuration menu")
	addBoolFlag(flags, &opts.healthCheck, "health-check", "Run system health check")
	addBoolFlag(flags, &opts.networkDiag, "network-diag", "Network diagnostics menu")
	addBoolFlag(flags, &opts.diskManagement, "disk-management", "Disk management menu")
	addBoolFlag(flags, &opts.troubleshoot, "troubleshoot", "Troubleshooting wizard")

	addHiddenBoolFlag(flags, &opts.devDistribute, "dev-distribute", "Copy the current binary to /usr/local/bin/robohelp")
}

func addBoolFlag(flags *pflag.FlagSet, target *bool, name, usage string) {
	flags.BoolVar(target, name, false, usage)
}

func addHiddenBoolFlag(flags *pflag.FlagSet, target *bool, name, usage string) {
	addBoolFlag(flags, target, name, usage)
	_ = flags.MarkHidden(name)
}

func addStringFlag(flags *pflag.FlagSet, target *string, name, usage string) {
	flags.StringVar(target, name, "", usage)
}

func countSelected(flags ...bool) int {
	count := 0
	for _, flag := range flags {
		if flag {
			count++
		}
	}
	return count
}
