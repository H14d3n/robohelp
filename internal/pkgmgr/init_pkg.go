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

import (
	"bufio"
	"os"
	"os/exec"
	"strings"
)

// Install Commands
var (
	INSTALL_CMD string = ""
	UPDATE_CMD string = ""
	UPGRADE_CMD string = ""
	DIST_UPGRADE_CMD string = ""
	AUTOREMOVE_CMD string = ""
	AUTOCLEAN_CMD string = ""
	REMOVE_CMD string = ""
	PURGE_CMD string = ""
	SEARCH_CMD string = ""
	CHECK_BROKEN_CMD string = ""
	CHECK_SECURITY_CMD string = ""
)

func InitPkg() {
	release := detectRelease()
	if release == "" {
		return
	}
	setDistroCommands(release)
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

func setDistroCommands(release string) {
	switch release {
	case "ubuntu", "debian", "kali":
		init_apt()
	case "fedora":
		init_dnf()
	case "centos", "rhel":
		init_yum()
	case "arch", "manjaro", "manjarolinux":
		init_pacman()
	case "opensuse", "opensuse-tumbleweed", "sles":
		init_zypper()
	case "darwin", "macos", "macosx", "osx":
		init_brew()
	default:
		println("Unsupported distro: " + release + ". Please edit the config manually.")
		os.Exit(1)
	}
}