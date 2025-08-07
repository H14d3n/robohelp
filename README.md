
```
█▄▄▄▄ ████▄ ███   ████▄  ▄  █ ▄███▄   █    █ ▄▄
█  ▄▀ █   █ █  █  █   █ █   █ █▀   ▀  █    █   █
█▀▀▌  █   █ █ ▀ ▄ █   █ ██▀▀█ ██▄▄    █    █▀▀▀
█  █  ▀████ █  ▄▀ ▀████ █   █ █▄   ▄▀ ███▄ █
  █         ███            █  ▀███▀       ▀ █
 ▀                        ▀                  ▀
```

**RoboHelp** is a user-friendly command-line tool for performing system maintenance on different Linux distributions.



## 🛠️ Features

- ✅ Full system upgrade with one flag
- 📦 Automatic package cleanup
- 🧹 Autoremove and autoclean handled automatically
- 🎨 Cool ASCII banner and BB-8 art on start
- 🖥️ Detects your Linux distro
- 📚 Easy to use with help command
- ⚡ **AFM (Ansible Fast Management):** Integrated menu for running Ansible playbooks, pinging hosts, viewing inventory, and checking logs
- 📝 Logging of Ansible playbook runs and actions




## 📖 Help (`robohelp -h`)

```
Usage: robohelp [option]
    -pud, --p-update	    [1] Update Package Repositories
    -pur, --p-upgrade 	    [1] Upgrade installed packages
    -arm, --p-autoremove    [1] Remove unnecessary packages
    -acl, --p-autoclean	    [1] Clean up local repository
    -fu,  --full-upgrade	Run full system upgrade with options from [1]

    -dur, --dist-upgrade	Run distribution update for system

    -pi,  --p-install 	<name>	Install package from repository
    -ps,  --p-search 	<name>	Search package in repository
    -prm, --p-remove	<name>	Remove package from system
    -pp,  --p-purge		<name>	Remove package with all its dependencies

    -A,   --ansible		Ansible Management
    -h,   --help		Show this help message
```

## 🤖 What is AFM (Ansible Fast Management)?

AFM is a built-in menu system for managing Ansible playbooks quickly and interactively. With AFM, you can:

- **Run Ansible playbooks** (with or without extra flags)
- **Test connection** to all hosts using Ansible ping
- **Live-Fire** is used to run commands on specific hosts without the need of a playbook.
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

### Option 1: Manual

1. Clone or copy the `robohelp` script to your system:

```bash
sudo cp robohelp.sh /usr/local/bin/robohelp
sudo chmod +x /usr/local/bin/robohelp
```
