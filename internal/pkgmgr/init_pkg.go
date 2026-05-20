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

package pkgmgr

import (
	"bufio"
	"fmt"
	"os"
	"os/exec"
	"strings"

	apt "github.com/h14d3n/robohelp/internal/pkgmgr/apt"
	brew "github.com/h14d3n/robohelp/internal/pkgmgr/brew"
	dnf "github.com/h14d3n/robohelp/internal/pkgmgr/dnf"
	pacman "github.com/h14d3n/robohelp/internal/pkgmgr/pacman"
	yum "github.com/h14d3n/robohelp/internal/pkgmgr/yum"
	zypper "github.com/h14d3n/robohelp/internal/pkgmgr/zypper"
)

// Install Commands
var (
	InstallCmd       = ""
	UpdateCmd        = ""
	UpgradeCmd       = ""
	DistUpgradeCmd   = ""
	AutoremoveCmd    = ""
	AutocleanCmd     = ""
	RemoveCmd        = ""
	PurgeCmd         = ""
	SearchCmd        = ""
	CheckBrokenCmd   = ""
	CheckSecurityCmd = ""
	DetectedDistro   = ""
)

func InitPkg() {
	release := detectRelease()
	DetectedDistro = release
	if release == "" {
		return
	}

	// Commands are looked up once during startup and reused by cmd package actions.
	if !setDistroCommands(release) {
		fmt.Fprintln(os.Stderr, "Unsupported distro: "+release+". Please edit the config manually.")
		os.Exit(1)
	}
}

func detectRelease() string {
	// Detect the Linux distro and set appropriate commands
	if out, err := exec.Command("lsb_release", "-si").Output(); err == nil {
		if val := strings.TrimSpace(string(out)); val != "" {
			return strings.ToLower(val)
		}
	}

	file, err := os.Open("/etc/os-release")
	if err != nil {
		return ""
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()
		if strings.HasPrefix(line, "ID=") {
			val := strings.TrimPrefix(line, "ID=")
			return strings.ToLower(strings.Trim(val, "\"'"))
		}
	}

	return ""
}

type commandSet struct {
	install       string
	update        string
	upgrade       string
	distUpgrade   string
	autoremove    string
	autoclean     string
	remove        string
	purge         string
	search        string
	checkBroken   string
	checkSecurity string
}

var (
	aptCommands = commandSet{
		install:       apt.InstallCmd,
		update:        apt.UpdateCmd,
		upgrade:       apt.UpgradeCmd,
		distUpgrade:   apt.DistUpgradeCmd,
		autoremove:    apt.AutoremoveCmd,
		autoclean:     apt.AutocleanCmd,
		remove:        apt.RemoveCmd,
		purge:         apt.PurgeCmd,
		search:        apt.SearchCmd,
		checkBroken:   apt.CheckBrokenCmd,
		checkSecurity: apt.CheckSecurityCmd,
	}
	dnfCommands = commandSet{
		install:       dnf.InstallCmd,
		update:        dnf.UpdateCmd,
		upgrade:       dnf.UpgradeCmd,
		distUpgrade:   dnf.DistUpgradeCmd,
		autoremove:    dnf.AutoremoveCmd,
		autoclean:     dnf.AutocleanCmd,
		remove:        dnf.RemoveCmd,
		purge:         dnf.PurgeCmd,
		search:        dnf.SearchCmd,
		checkBroken:   dnf.CheckBrokenCmd,
		checkSecurity: dnf.CheckSecurityCmd,
	}
	yumCommands = commandSet{
		install:       yum.InstallCmd,
		update:        yum.UpdateCmd,
		upgrade:       yum.UpgradeCmd,
		distUpgrade:   yum.DistUpgradeCmd,
		autoremove:    yum.AutoremoveCmd,
		autoclean:     yum.AutocleanCmd,
		remove:        yum.RemoveCmd,
		purge:         yum.PurgeCmd,
		search:        yum.SearchCmd,
		checkBroken:   yum.CheckBrokenCmd,
		checkSecurity: yum.CheckSecurityCmd,
	}
	pacmanCommands = commandSet{
		install:       pacman.InstallCmd,
		update:        pacman.UpdateCmd,
		upgrade:       pacman.UpgradeCmd,
		distUpgrade:   pacman.DistUpgradeCmd,
		autoremove:    pacman.AutoremoveCmd,
		autoclean:     pacman.AutocleanCmd,
		remove:        pacman.RemoveCmd,
		purge:         pacman.PurgeCmd,
		search:        pacman.SearchCmd,
		checkBroken:   pacman.CheckBrokenCmd,
		checkSecurity: pacman.CheckSecurityCmd,
	}
	zypperCommands = commandSet{
		install:       zypper.InstallCmd,
		update:        zypper.UpdateCmd,
		upgrade:       zypper.UpgradeCmd,
		distUpgrade:   zypper.DistUpgradeCmd,
		autoremove:    zypper.AutoremoveCmd,
		autoclean:     zypper.AutocleanCmd,
		remove:        zypper.RemoveCmd,
		purge:         zypper.PurgeCmd,
		search:        zypper.SearchCmd,
		checkBroken:   zypper.CheckBrokenCmd,
		checkSecurity: zypper.CheckSecurityCmd,
	}
	brewCommands = commandSet{
		install:       brew.InstallCmd,
		update:        brew.UpdateCmd,
		upgrade:       brew.UpgradeCmd,
		distUpgrade:   brew.DistUpgradeCmd,
		autoremove:    brew.AutoremoveCmd,
		autoclean:     brew.AutocleanCmd,
		remove:        brew.RemoveCmd,
		purge:         brew.PurgeCmd,
		search:        brew.SearchCmd,
		checkBroken:   brew.CheckBrokenCmd,
		checkSecurity: brew.CheckSecurityCmd,
	}
)

var distroCommandMap = map[string]commandSet{
	"ubuntu":              aptCommands,
	"debian":              aptCommands,
	"kali":                aptCommands,
	"fedora":              dnfCommands,
	"centos":              yumCommands,
	"rhel":                yumCommands,
	"arch":                pacmanCommands,
	"manjaro":             pacmanCommands,
	"manjarolinux":        pacmanCommands,
	"opensuse":            zypperCommands,
	"opensuse-tumbleweed": zypperCommands,
	"sles":                zypperCommands,
	"darwin":              brewCommands,
	"macos":               brewCommands,
	"macosx":              brewCommands,
	"osx":                 brewCommands,
}

func setDistroCommands(release string) bool {
	commands, ok := distroCommandMap[release]
	if !ok {
		return false
	}

	// Keep commands in package-level vars for the existing cmd package API.
	InstallCmd = commands.install
	UpdateCmd = commands.update
	UpgradeCmd = commands.upgrade
	DistUpgradeCmd = commands.distUpgrade
	AutoremoveCmd = commands.autoremove
	AutocleanCmd = commands.autoclean
	RemoveCmd = commands.remove
	PurgeCmd = commands.purge
	SearchCmd = commands.search
	CheckBrokenCmd = commands.checkBroken
	CheckSecurityCmd = commands.checkSecurity
	return true
}
