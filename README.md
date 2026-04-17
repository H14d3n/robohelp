
```
           _           _          _
 _ __ ___ | |__   ___ | |__   ___| |_ __  
| '__/ _ \| '_ \ / _ \| '_ \ / _ \ | '_ \ 
| | | (_) | |_) | (_) | | | |  __/ | |_) |
|_|  \___/|_.__/ \___/|_| |_|\___|_| .__/ 
                                   |_|    
```

**RoboHelp** is a user-friendly command-line tool for performing system maintenance on different Linux distributions.



## 🛠️ Features

- ✅ Full system upgrade with one flag
- 📦 Automatic package cleanup and management
- 🧹 Autoremove and autoclean handled automatically
- 🎨 Cool ASCII banner and BB-8 art on start
- 🖥️ Detects your Linux distro
- 📚 Easy to use with help command and interactive menus
- 🔄 **Auto-Update:** Automatically checks and updates itself from GitHub
- ⚡ **AFM (Ansible Fast Management):** Integrated menu for running Ansible playbooks, pinging hosts, viewing inventory, and checking logs
- 🔁 **SSH Management:** Save SSH connections, distribute keys, and configure settings
- ⚙️ **Service Management:** Start, stop, restart, enable/disable system services
- 🏥 **Health Check:** Monitor disk space, system load, broken packages, and security updates
- 🌐 **Network Diagnostics:** DNS lookup, traceroute, ping, bandwidth monitoring, firewall status
- 💾 **Disk Management:** Find large files, clean caches, manage mounts, find duplicates
- 🔧 **Troubleshooting Wizard:** Guided diagnostics for boot, network, CPU, disk, and service issues





## 📖 Usage

Run `robohelp` without arguments to launch the interactive main menu, or use command-line flags for quick access:

```
🎯 Main Menus:
  robohelp                      Launch RoboHelp Main Menu
  -pm,  --package-management    Interactive package management menu
  -A,   --ansible               Ansible Fast Management (AFM)

📦 Package Management (Quick Commands):
  -pud, --p-update              Update Package Repositories [1]
  -pur, --p-upgrade             Upgrade installed packages [1]
  -arm, --p-autoremove          Remove unnecessary packages [1]
  -acl, --p-autoclean           Clean up local repository [1]
  -fu,  --full-upgrade          Run full system upgrade with options [1]
  -dur, --dist-upgrade          Run distribution upgrade
  -pi,  --p-install <name>      Install package(s)
  -ps,  --p-search <name>       Search package(s)
  -prm, --p-remove <name>       Remove package(s)
  -pp,  --p-purge <name>        Purge package(s) with dependencies

⚙️  System Tools (Quick Commands):
  -ssh, --ssh-settings          SSH configuration menu
  -hc,  --health-check          Run system health check
  -nd,  --network-diag          Network diagnostics menu
  -dm,  --disk-management       Disk management menu
  -tw,  --troubleshoot          Troubleshooting wizard

ℹ️  Information:
  -h,   --help                  Show this help message
```

## 🤖 What is AFM (Ansible Fast Management)?

AFM is a built-in menu system for managing Ansible playbooks quickly and interactively. With AFM, you can:

- **Run Ansible playbooks** with optional extra flags
- **Test connections** to all hosts using Ansible ping
- **Live-Fire:** Run commands on specific hosts without needing a playbook
- **View available playbooks** and inventory
- **View the last run log** for troubleshooting and auditing

To start AFM, use:
```bash
robohelp -A
```
or
```bash
robohelp --ansible
```

---

## 🏥 System Tools

### Health Check
Monitor your system's health including disk space, CPU load, broken packages, and available security updates.

### Network Diagnostics
Tools for DNS lookups, traceroute/ping, network interface information, bandwidth monitoring, firewall status, and viewing active connections.

### Disk Management
Find large files, analyze disk usage by directory, clean package caches, manage journal logs, empty trash, find duplicate files, and mount/unmount drives.

### Troubleshooting Wizard
Guided diagnostics for common issues including boot problems, network connectivity, high CPU usage, disk issues, service failures, and SSH connection problems.

### Service Management
Manage system services: list, start, stop, restart, enable, disable, and check status of services.

---

## 💻 Supported Distributions

- Debian 🌀
- Ubuntu 🔶
- Kali 🐉
- Fedora 🎩
- CentOS 🧭
- RHEL 🧱
- Arch 🗻
- Manjaro 🌲
- OpenSUSE 👽
- SLES 🧬

Maybe adding more distributions later!

---

## 🚀 Installation

### One-Time Installation

RoboHelp only needs to be installed once. After installation, it will automatically check for and install updates from GitHub each time you run it.

1. Clone or copy the `robohelp.sh` script to your system:

```bash
sudo cp robohelp.sh /usr/local/bin/robohelp
sudo chmod +x /usr/local/bin/robohelp
```
