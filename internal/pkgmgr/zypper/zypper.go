//┌──────────────────────────────────────────────────┐
//│               _           _          _           │
//│     _ __ ___ | |__   ___ | |__   ___| |____      │
//│    | '__/ _ \| '_ \ / _ \| '_ \ / _ \ | '_ \     │
//│    | | | (_) | |_) | (_) | | | |  __/ | |_) |    │
//│    |_|  \___/|_.__/ \___/|_| |_|\___|_| .__/     │
//│                                       |_|        │
//│                                                  │
//└──────────────────────────────────────────────────┘

// V 3.0.0 - 2026-05-06
// H14d3n

package pkgmgr

func initZypper() {
	INSTALL_CMD = "sudo zypper install -y"
	UPDATE_CMD = "sudo zypper refresh"
	UPGRADE_CMD = "sudo zypper update -y"
	DIST_UPGRADE_CMD = "sudo zypper dist-upgrade -y"
	AUTOREMOVE_CMD = "sudo zypper clean -a"
	AUTOCLEAN_CMD = "sudo zypper clean"
	REMOVE_CMD = "sudo zypper remove -y"
	PURGE_CMD = "sudo zypper remove -y"
	SEARCH_CMD = "zypper search"
	CHECK_BROKEN_CMD = "unknown"
	CHECK_SECURITY_CMD = "zypper list-updates 2>/dev/null | tail -n +5 | wc -l"
}
