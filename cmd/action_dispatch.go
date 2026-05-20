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

func runAppAction(action ui.Action, value string) {
	// Root checks stay centralized here so both menu and CLI modes behave the same.
	if actionRequiresRoot(action) {
		requireRootOrExit()
	}

	switch action {
	case ui.ActionNone, ui.ActionExit:
		return
	case ui.ActionPackageUpdate:
		exitIfNonZero(packageUpdate(pkgmgr.UpdateCmd))
	case ui.ActionPackageUpgrade:
		exitIfNonZero(packageUpgrade(pkgmgr.UpgradeCmd))
	case ui.ActionPackageFullUpgrade:
		runFullUpgrade(fullUpgradeCommands())
	case ui.ActionPackageDistUpgrade:
		exitIfNonZero(packageDistUpgrade(pkgmgr.DistUpgradeCmd))
	case ui.ActionPackageAutoremove:
		exitIfNonZero(packageAutoremove(pkgmgr.AutoremoveCmd))
	case ui.ActionPackageAutoclean:
		exitIfNonZero(packageAutoclean(pkgmgr.AutocleanCmd))
	case ui.ActionPackageInstall:
		runPackageValues(pkgmgr.InstallCmd, value, packageInstall)
	case ui.ActionPackageRemove:
		runPackageValues(pkgmgr.RemoveCmd, value, packageRemove)
	case ui.ActionPackagePurge:
		runPackageValues(pkgmgr.PurgeCmd, value, packagePurge)
	case ui.ActionPackageSearch:
		term := strings.TrimSpace(value)
		if term != "" {
			exitIfNonZero(packageSearch(pkgmgr.SearchCmd, term))
		}
	case ui.ActionServiceManagement:
		runServiceManagement()
	case ui.ActionDiskManagement:
		runDiskManagement()
	case ui.ActionTroubleshoot:
		runTroubleshoot()
	case ui.ActionHealthCheck:
		runHealthCheck()
	case ui.ActionNetworkDiagnostics:
		runNetworkDiagnostics()
	case ui.ActionSSH:
		runSSHSettings()
	case ui.ActionAnsible:
		runAnsible()
	}
}

func runAppActionValues(action ui.Action, values []string) {
	if actionRequiresRoot(action) {
		requireRootOrExit()
	}

	switch action {
	case ui.ActionPackageInstall:
		runPackageValueList(pkgmgr.InstallCmd, values, packageInstall)
	case ui.ActionPackageSearch:
		runPackageValueList(pkgmgr.SearchCmd, values, packageSearch)
	case ui.ActionPackageRemove:
		runPackageValueList(pkgmgr.RemoveCmd, values, packageRemove)
	case ui.ActionPackagePurge:
		runPackageValueList(pkgmgr.PurgeCmd, values, packagePurge)
	default:
		runAppAction(action, strings.Join(values, " "))
	}
}

func actionRequiresRoot(action ui.Action) bool {
	_, required := rootRequiredActions[action]
	return required
}
