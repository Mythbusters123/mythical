#!/usr/bin/bash
# Must be run using Bash (sorry)
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
DOTFILES_DIR="$SCRIPT_DIR/dotfiles"

install_yay() {
    if ! command -v yay &> /dev/null; then
        echo "Installing yay..."
        pacman -Sy --noconfirm base-devel git ca-certificates dash
        sudo -u "$(id -nu)" bash -c "
        cd /tmp/
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        "
    fi
}

install_packages() {
    AUR_PKGS=()
    ARCH_PKGS=()

    while IFS= read -r pkg; do
        [[ -z "$pkg" || "$pkg" =~ ^# ]] && continue
        if [[ "$pkg" == aur/* ]]; then
            AUR_PKGS+=("${pkg#aur/}")
        else
            ARCH_PKGS+=("$pkg")
        fi
    done < $(cat $PACKAGE_LIST)

    echo "Installing official packages: ${ARCH_PKGS[*]}"
    pacman -Syu --noconfirm
    pacman -S --noconfirm "${ARCH_PKGS[@]}"

    echo "Installing AUR packages: ${AUR_PKGS[*]}"
    sudo -u "$(id -nu)" yay -S --noconfirm "${AUR_PKGS[@]}"

    echo "Enabling services:"
    systemctl enable --now NetworkManager
    systemctl enable sddm.service
}

setup_dotfiles() {
    sudo -u "$(id -nu)" bash -c "
    cd ~
    stow -d '$DOTFILES_DIR' -t ~ *
    "
}

install_yay
install_packages
setup_dotfiles

