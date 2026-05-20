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

package pacman

const (
	InstallCmd       = "sudo pacman -S --noconfirm"
	UpdateCmd        = "sudo pacman -Sy"
	UpgradeCmd       = "sudo pacman -Syu"
	DistUpgradeCmd   = "unknown"
	AutoremoveCmd    = "sudo pacman -Rns"
	AutocleanCmd     = "sudo pacman -Sc"
	RemoveCmd        = "sudo pacman -R --noconfirm"
	PurgeCmd         = "sudo pacman -Rns --noconfirm"
	SearchCmd        = "pacman -Ss"
	CheckBrokenCmd   = "pacman -Qk 2>&1 | grep -c 'warning' 2>/dev/null | xargs"
	CheckSecurityCmd = "checkupdates 2>/dev/null | wc -l"
)
