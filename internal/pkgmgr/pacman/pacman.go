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

func init_pacman() {
	INSTALL_CMD = "sudo pacman -S --noconfirm"
	UPDATE_CMD = "sudo pacman -Sy"
	UPGRADE_CMD = "sudo pacman -Syu"
	DIST_UPGRADE_CMD = "unknown"
	AUTOREMOVE_CMD = "sudo pacman -Rns"
	AUTOCLEAN_CMD = "sudo pacman -Sc"
	REMOVE_CMD = "sudo pacman -R --noconfirm"
	PURGE_CMD = "sudo pacman -Rns --noconfirm"
	SEARCH_CMD = "pacman -Ss"
	CHECK_BROKEN_CMD = "pacman -Qk 2>&1 | grep -c 'warning' 2>/dev/null | xargs"
	CHECK_SECURITY_CMD = "checkupdates 2>/dev/null | wc -l"
}
