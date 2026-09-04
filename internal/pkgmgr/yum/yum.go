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

package yum

const (
	InstallCmd       = "sudo yum install -y"
	UpdateCmd        = "sudo yum makecache -y"
	UpgradeCmd       = "sudo yum update -y"
	DistUpgradeCmd   = "unknown"
	AutoremoveCmd    = "sudo yum autoremove -y"
	AutocleanCmd     = "sudo yum clean all"
	RemoveCmd        = "sudo yum remove -y"
	PurgeCmd         = "sudo yum remove -y"
	SearchCmd        = "yum search"
	CheckBrokenCmd   = "package-cleanup --problems 2>/dev/null | grep -c 'Problem' 2>/dev/null | xargs"
	CheckSecurityCmd = "yum updateinfo list security 2>/dev/null | grep -c 'security'"
)
