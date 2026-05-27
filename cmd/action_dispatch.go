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
	"strings"

	"github.com/h14d3n/robohelp/internal/app/ui"
	"github.com/h14d3n/robohelp/internal/pkgmgr"
)

var rootRequiredActions = map[ui.Action]struct{}{
	ui.ActionPackageManagement:  {},
	ui.ActionPackageUpdate:      {},
	ui.ActionPackageUpgrade:     {},
	ui.ActionPackageFullUpgrade: {},
	ui.ActionPackageDistUpgrade: {},
	ui.ActionPackageAutoremove:  {},
	ui.ActionPackageAutoclean:   {},
	ui.ActionPackageInstall:     {},
	ui.ActionPackageRemove:      {},
	ui.ActionPackagePurge:       {},
}

func runAppAction(action ui.Action, value string) int {
	// Root checks stay centralized here so both menu and CLI modes behave the same.
	if actionRequiresRoot(action) {
		if err := requireRoot(); err != nil {
			printError("%s", err)
			return 1
		}
	}

	switch action {
	case ui.ActionNone, ui.ActionExit:
		return 0
	case ui.ActionPackageManagement:
		return runPackageManagement()
	case ui.ActionPackageUpdate:
		return packageUpdate(pkgmgr.UpdateCmd)
	case ui.ActionPackageUpgrade:
		return packageUpgrade(pkgmgr.UpgradeCmd)
	case ui.ActionPackageFullUpgrade:
		return runFullUpgrade(fullUpgradeCommands())
	case ui.ActionPackageDistUpgrade:
		return packageDistUpgrade(pkgmgr.DistUpgradeCmd)
	case ui.ActionPackageAutoremove:
		return packageAutoremove(pkgmgr.AutoremoveCmd)
	case ui.ActionPackageAutoclean:
		return packageAutoclean(pkgmgr.AutocleanCmd)
	case ui.ActionPackageInstall:
		return runPackageValues(pkgmgr.InstallCmd, value, packageInstall)
	case ui.ActionPackageRemove:
		return runPackageValues(pkgmgr.RemoveCmd, value, packageRemove)
	case ui.ActionPackagePurge:
		return runPackageValues(pkgmgr.PurgeCmd, value, packagePurge)
	case ui.ActionPackageSearch:
		term := strings.TrimSpace(value)
		if term != "" {
			return packageSearch(pkgmgr.SearchCmd, term)
		}
		return 0
	case ui.ActionServiceManagement:
		return runServiceManagement()
	case ui.ActionDiskManagement:
		runDiskManagement()
		return 0
	case ui.ActionTroubleshoot:
		runTroubleshoot()
		return 0
	case ui.ActionHealthCheck:
		runHealthCheck()
		return 0
	case ui.ActionNetworkDiagnostics:
		runNetworkDiagnostics()
		return 0
	case ui.ActionSSH:
		return runSSHSettings()
	case ui.ActionAnsible:
		return runAnsible()
	}

	return 0
}

func runAppActionValues(action ui.Action, values []string) int {
	if actionRequiresRoot(action) {
		if err := requireRoot(); err != nil {
			printError("%s", err)
			return 1
		}
	}

	switch action {
	case ui.ActionPackageInstall:
		return runPackageValueList(pkgmgr.InstallCmd, values, packageInstall)
	case ui.ActionPackageSearch:
		return runPackageValueList(pkgmgr.SearchCmd, values, packageSearch)
	case ui.ActionPackageRemove:
		return runPackageValueList(pkgmgr.RemoveCmd, values, packageRemove)
	case ui.ActionPackagePurge:
		return runPackageValueList(pkgmgr.PurgeCmd, values, packagePurge)
	default:
		return runAppAction(action, strings.Join(values, " "))
	}

	return 0
}

func actionRequiresRoot(action ui.Action) bool {
	_, required := rootRequiredActions[action]
	return required
}
