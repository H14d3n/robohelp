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

package cmd

func InitCmd() {
}


func help() {
	const (
		cyan = "\033[0;36m"
		nc   = "\033[0m"
	)

	out := os.Stdout

	fmt.Fprintln(out)
	fmt.Fprintln(out, "Usage: robohelp [option]")
	fmt.Fprintln(out)
	fmt.Fprintf(out, "%sMain Menus:%s\n", cyan, nc)
	fmt.Fprintln(out, "\trobohelp\t\t\tLaunch RoboHelp Main Menu")
	fmt.Fprintln(out, "\t-pm,  --package-management\tInteractive package management menu")
	fmt.Fprintln(out, "\t-A,   --ansible\t\t\tAnsible Fast Management (AFM)")
	fmt.Fprintln(out)
	fmt.Fprintf(out, "%sPackage Management (Quick Commands):%s\n", cyan, nc)
	fmt.Fprintln(out, "\t-pud, --p-update\t\tUpdate Package Repositories [1]")
	fmt.Fprintln(out, "\t-pur, --p-upgrade\t\tUpgrade installed packages [1]")
	fmt.Fprintln(out, "\t-arm, --p-autoremove\t\tRemove unnecessary packages [1]")
	fmt.Fprintln(out, "\t-acl, --p-autoclean\t\tClean up local repository [1]")
	fmt.Fprintln(out, "\t-fu,  --full-upgrade\t\tRun full system upgrade with options [1]")
	fmt.Fprintln(out, "\t-dur, --dist-upgrade\t\tRun distribution upgrade")
	fmt.Fprintln(out, "\t-pi,  --p-install <name>\tInstall package(s)")
	fmt.Fprintln(out, "\t-ps,  --p-search <name>\t\tSearch package(s)")
	fmt.Fprintln(out, "\t-prm, --p-remove <name>\t\tRemove package(s)")
	fmt.Fprintln(out, "\t-pp,  --p-purge <name>\t\tPurge package(s) with dependencies")
	fmt.Fprintln(out)
	fmt.Fprintf(out, "%sSystem Tools (Quick Commands):%s\n", cyan, nc)
	fmt.Fprintln(out, "\t-ssh, --ssh-settings\t\tSSH configuration menu")
	fmt.Fprintln(out, "\t-hc,  --health-check\t\tRun system health check")
	fmt.Fprintln(out, "\t-nd,  --network-diag\t\tNetwork diagnostics menu")
	fmt.Fprintln(out, "\t-dm,  --disk-management\t\tDisk management menu")
	fmt.Fprintln(out, "\t-tw,  --troubleshoot\t\tTroubleshooting wizard")
	fmt.Fprintf(out, "%sInformation:%s\n", cyan, nc)
	fmt.Fprintln(out, "\t-h,   --help\t\t\tShow this help message")
	fmt.Fprintln(out)

}