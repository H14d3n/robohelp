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

package zypper

const (
	InstallCmd       = "sudo zypper install -y"
	UpdateCmd        = "sudo zypper refresh"
	UpgradeCmd       = "sudo zypper update -y"
	DistUpgradeCmd   = "sudo zypper dist-upgrade -y"
	AutoremoveCmd    = "sudo zypper clean -a"
	AutocleanCmd     = "sudo zypper clean"
	RemoveCmd        = "sudo zypper remove -y"
	PurgeCmd         = "sudo zypper remove -y"
	SearchCmd        = "zypper search"
	CheckBrokenCmd   = "unknown"
	CheckSecurityCmd = "zypper list-updates 2>/dev/null | tail -n +5 | wc -l"
)
