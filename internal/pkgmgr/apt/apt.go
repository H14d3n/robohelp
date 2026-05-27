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

package apt

const (
	InstallCmd       = "sudo apt install -y"
	UpdateCmd        = "sudo apt update"
	UpgradeCmd       = "sudo apt upgrade -y"
	DistUpgradeCmd   = "sudo apt dist-upgrade -y"
	AutoremoveCmd    = "sudo apt autoremove -y"
	AutocleanCmd     = "sudo apt autoclean -y"
	RemoveCmd        = "sudo apt remove -y"
	PurgeCmd         = "sudo apt purge -y"
	SearchCmd        = "apt search"
	CheckBrokenCmd   = "dpkg -l 2>/dev/null | grep -c '^iU\\|^iF' 2>/dev/null | xargs"
	CheckSecurityCmd = "apt list --upgradable 2>/dev/null | grep -i security | wc -l"
)
