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

func init_apt() {
	INSTALL_CMD = "sudo apt install -y"
	UPDATE_CMD = "sudo apt update"
	UPGRADE_CMD = "sudo apt upgrade -y"
	DIST_UPGRADE_CMD = "sudo apt dist-upgrade -y"
	AUTOREMOVE_CMD = "sudo apt autoremove -y"
	AUTOCLEAN_CMD = "sudo apt autoclean -y"
	REMOVE_CMD = "sudo apt remove -y"
	PURGE_CMD = "sudo apt purge -y"
	SEARCH_CMD = "apt search"
	CHECK_BROKEN_CMD = "dpkg -l 2>/dev/null | grep -c '^iU\\|^iF' 2>/dev/null | xargs"
	CHECK_SECURITY_CMD = "apt list --upgradable 2>/dev/null | grep -i security | wc -l"
}