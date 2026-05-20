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

package dnf

const (
	InstallCmd       = "sudo dnf install -y"
	UpdateCmd        = "sudo dnf makecache -y"
	UpgradeCmd       = "sudo dnf upgrade -y"
	DistUpgradeCmd   = "unknown"
	AutoremoveCmd    = "sudo dnf autoremove -y"
	AutocleanCmd     = "sudo dnf clean all"
	RemoveCmd        = "sudo dnf remove -y"
	PurgeCmd         = "sudo dnf remove -y"
	SearchCmd        = "dnf search"
	CheckBrokenCmd   = "package-cleanup --problems 2>/dev/null | grep -c 'Problem' 2>/dev/null | xargs"
	CheckSecurityCmd = "dnf updateinfo list security 2>/dev/null | grep -c 'security'"
)
