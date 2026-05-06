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

func init_yum() {
	INSTALL_CMD = "sudo yum install -y"
	UPDATE_CMD = "sudo yum makecache -y"
	UPGRADE_CMD = "sudo yum update -y"
	DIST_UPGRADE_CMD = "unknown"
	AUTOREMOVE_CMD = "sudo yum autoremove -y"
	AUTOCLEAN_CMD = "sudo yum clean all"
	REMOVE_CMD = "sudo yum remove -y"
	PURGE_CMD = "sudo yum remove -y"
	SEARCH_CMD = "yum search"
	CHECK_BROKEN_CMD = "package-cleanup --problems 2>/dev/null | grep -c 'Problem' 2>/dev/null | xargs"
	CHECK_SECURITY_CMD = "yum updateinfo list security 2>/dev/null | grep -c 'security'"
}
