#!/usr/bin/env bats

setup() {
    ORIGINAL_PATH="$PATH"

    # include.sh does `read -r -d '' title <<'EOF' ... EOF` to slurp the
    # banner into a variable. `read -d ''` reports failure once it hits the
    # heredoc's real EOF (a well-known bash quirk), which is harmless under
    # robohelp's normal execution (no `set -e` anywhere in src/*.sh) but
    # would abort sourcing here under bats' errexit. Disable it just for the
    # source step.
    set +e
    source "$BATS_TEST_DIRNAME/../src/include.sh"
    source "$BATS_TEST_DIRNAME/../src/helpers.sh"
    set -e
}

teardown() {
    # A few tests narrow PATH to simulate a missing curl/wget; restore it so
    # bats' own post-test cleanup (which shells out to rm) keeps working.
    PATH="$ORIGINAL_PATH"
}

# Prepends a fake lsb_release binary to PATH that prints $1 for `lsb_release -si`.
mock_lsb_release() {
    mkdir -p "$BATS_TEST_TMPDIR/bin"
    printf '#!/bin/sh\necho "%s"\n' "$1" > "$BATS_TEST_TMPDIR/bin/lsb_release"
    chmod +x "$BATS_TEST_TMPDIR/bin/lsb_release"
    PATH="$BATS_TEST_TMPDIR/bin:$PATH"
}

# --- check_installed ---

@test "check_installed succeeds for a command that exists" {
    run check_installed bash
    [ "$status" -eq 0 ]
}

@test "check_installed fails for a command that does not exist" {
    run check_installed definitely_not_a_real_command_xyz
    [ "$status" -eq 1 ]
}

# --- write_header / write_subheader ---

@test "write_header prints the given text" {
    run write_header "Section Title"
    [[ "$output" == *"Section Title"* ]]
}

@test "write_subheader prints the given text and custom line" {
    run write_subheader "Sub Title" "$CYAN" "---"
    [[ "$output" == *"Sub Title"* ]]
    [[ "$output" == *"<--->"* ]]
}

# --- det_release (via lsb_release) ---

@test "det_release recognizes ubuntu and sets apt commands" {
    mock_lsb_release "Ubuntu"
    det_release
    [ "$distro" = "ubuntu" ]
    [ "$install_cmd" = "sudo apt install -y" ]
    [ "$service_manager" = "systemctl" ]
}

@test "det_release recognizes debian and sets apt commands" {
    mock_lsb_release "Debian"
    det_release
    [ "$distro" = "debian" ]
    [ "$install_cmd" = "sudo apt install -y" ]
}

@test "det_release recognizes kali and sets apt commands" {
    mock_lsb_release "Kali"
    det_release
    [ "$distro" = "kali" ]
    [ "$install_cmd" = "sudo apt install -y" ]
}

@test "det_release recognizes fedora and sets dnf commands" {
    mock_lsb_release "Fedora"
    det_release
    [ "$distro" = "fedora" ]
    [ "$install_cmd" = "sudo dnf install -y" ]
}

@test "det_release recognizes arch and sets pacman commands" {
    mock_lsb_release "Arch"
    det_release
    [ "$distro" = "arch" ]
    [ "$install_cmd" = "sudo pacman -S --noconfirm" ]
}

@test "det_release recognizes manjaro and sets pacman commands" {
    mock_lsb_release "ManjaroLinux"
    det_release
    [ "$distro" = "manjarolinux" ]
    [ "$install_cmd" = "sudo pacman -S --noconfirm" ]
}

@test "det_release recognizes opensuse and sets zypper commands" {
    mock_lsb_release "openSUSE"
    det_release
    [ "$distro" = "opensuse" ]
    [ "$install_cmd" = "sudo zypper install -y" ]
}

@test "det_release exits 1 and prints an error for an unsupported distro" {
    mock_lsb_release "SomeWeirdOS"
    run det_release
    [ "$status" -eq 1 ]
    [[ "$output" == *"Unsupported distro"* ]]
}

# --- get_remote_version ---

mock_bin() {
    mkdir -p "$BATS_TEST_TMPDIR/bin"
    printf '#!/bin/sh\necho '"'"'VERSION="%s"'"'"'\n' "$2" > "$BATS_TEST_TMPDIR/bin/$1"
    chmod +x "$BATS_TEST_TMPDIR/bin/$1"
    PATH="$BATS_TEST_TMPDIR/bin:$PATH"
}

@test "get_remote_version parses the version reported by curl" {
    mock_bin curl "9.9.9"
    run get_remote_version
    [ "$status" -eq 0 ]
    [ "$output" = "9.9.9" ]
}

@test "get_remote_version falls back to wget when curl is unavailable" {
    # Build a minimal PATH that has no curl, but keeps sed/head (used by the
    # parsing pipeline) available via symlinks, so curl is genuinely absent
    # rather than just shadowed.
    mkdir -p "$BATS_TEST_TMPDIR/bin"
    ln -s "$(command -v sed)" "$BATS_TEST_TMPDIR/bin/sed"
    ln -s "$(command -v head)" "$BATS_TEST_TMPDIR/bin/head"
    printf '#!/bin/sh\necho '"'"'VERSION="8.8.8"'"'"'\n' > "$BATS_TEST_TMPDIR/bin/wget"
    chmod +x "$BATS_TEST_TMPDIR/bin/wget"
    PATH="$BATS_TEST_TMPDIR/bin"
    run get_remote_version
    [ "$status" -eq 0 ]
    [ "$output" = "8.8.8" ]
}

@test "get_remote_version fails when neither curl nor wget is available" {
    # A PATH with no curl/wget at all (not just shadowed - genuinely absent).
    mkdir -p "$BATS_TEST_TMPDIR/bin"
    PATH="$BATS_TEST_TMPDIR/bin"
    run get_remote_version
    [ "$status" -eq 1 ]
    [ -z "$output" ]
}
