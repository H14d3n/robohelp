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

func init_dnf() {
	INSTALL_CMD = "sudo dnf install -y"
	UPDATE_CMD = "sudo dnf makecache -y"
	UPGRADE_CMD = "sudo dnf upgrade -y"
	DIST_UPGRADE_CMD = "unknown"
	AUTOREMOVE_CMD = "sudo dnf autoremove -y"
	AUTOCLEAN_CMD = "sudo dnf clean all"
	REMOVE_CMD = "sudo dnf remove -y"
	PURGE_CMD = "sudo dnf remove -y"
	SEARCH_CMD = "dnf search"
	CHECK_BROKEN_CMD = "package-cleanup --problems 2>/dev/null | grep -c 'Problem' 2>/dev/null | xargs"
	CHECK_SECURITY_CMD = "dnf updateinfo list security 2>/dev/null | grep -c 'security'"
}
