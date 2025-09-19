#!/bin/bash

# ==================================================================================
# ===            The Arch BTW Forge - by shadowdevforge                          ===
# ==================================================================================
#
#  This script forges a pristine Arch Linux WSL instance into a complete,
#  professional-grade development environment.
#
#  Project Repository: https://github.com/shadowdevforge/archbtw
#
#  USAGE:
#  1. On a brand new Arch WSL instance, run as the default root user:
#
#     pacman -Syu --noconfirm && pacman -S --noconfirm git
#     git clone https://github.com/shadowdevforge/archbtw.git /root/arch-btw-forge
#     bash /root/arch-btw-forge/forge.sh
#
# ==================================================================================

# --- Script Safety ---
# Exit immediately if a command exits with a non-zero status.
set -e

# --- Helper Functions ---
info() {
    echo -e "\e[1;34m[INFO]\e[0m $1"
}
success() {
    echo -e "\e[1;32m[SUCCESS]\e[0m $1"
}
warning() {
    echo -e "\e[1;33m[WARNING]\e[0m $1"
}
debug() {
    echo -e "\e[1;35m[DEBUG]\e[0m $1"
}

# --- Validation Functions ---
validate_username() {
    if [[ ! "$1" =~ ^[a-z][a-z0-9_-]*$ ]] || [ ${#1} -gt 32 ]; then
        warning "Username must start with lowercase letter, contain only lowercase letters, numbers, hyphens, underscores, and be ≤32 characters."
        return 1
    fi
}

check_network() {
    debug "Checking network connectivity..."
    if ! ping -c 1 -W 5 archlinux.org &> /dev/null; then
        warning "No network connectivity detected. Please check your internet connection."
        exit 1
    fi
    debug "Network connectivity confirmed."
}

# ==================================================================================
# === PHASE 1: ROOT-LEVEL SYSTEM SETUP                                           ===
# ==================================================================================
info "Starting Phase 1: System Preparation (running as root)."

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    warning "This script must be run as root (Phase 1)."
    exit 1
fi

# Network connectivity check
check_network

# --- User Input with Validation ---
while true; do
    read -p "Enter your desired username: " USERNAME
    if [ -z "$USERNAME" ]; then
        warning "Username cannot be empty."
        continue
    fi
    if validate_username "$USERNAME"; then
        break
    fi
done

# Check if user already exists
if id "$USERNAME" &>/dev/null; then
    warning "User '$USERNAME' already exists. Please choose a different username."
    exit 1
fi

while true; do
    read -sp "Enter a password for $USERNAME: " PASSWORD
    echo
    if [ -z "$PASSWORD" ]; then
        warning "Password cannot be empty."
        continue
    fi
    read -sp "Confirm password: " PASSWORD_CONFIRM
    echo
    [ "$PASSWORD" = "$PASSWORD_CONFIRM" ] && break
    warning "Passwords do not match. Please try again."
done

debug "Initializing pacman keyring..."
pacman-key --init
pacman-key --populate archlinux

# REMOVED: Community repository configuration (no longer exists in modern Arch)
debug "Skipping community repository configuration (merged into extra repository)."

debug "Skipping reflector configuration - using default Arch mirrors for optimal performance."

info "Performing full system upgrade..."
pacman -Syu --noconfirm

info "Installing essential packages, development tools, and dependencies..."
# Added nodejs and npm for NvShade dependencies
if ! pacman -S --noconfirm base-devel sudo zsh git curl fastfetch neovim tmux btop bat ripgrep unzip nodejs npm; then
    warning "Some packages failed to install, continuing..."
fi

info "Creating user '$USERNAME' with Zsh as default shell..."
useradd -m -G wheel -s /bin/zsh "$USERNAME"
echo "$USERNAME:$PASSWORD" | chpasswd
success "User $USERNAME created."

info "Configuring sudo access for the 'wheel' group..."
# Backup sudoers before modification
cp /etc/sudoers /etc/sudoers.backup
# Uncomment the line that allows users in the 'wheel' group to use sudo
sed -i '/%wheel ALL=(ALL:ALL) ALL/s/^# //' /etc/sudoers

# Verify sudoers file is valid
if ! visudo -c -f /etc/sudoers; then
    warning "Sudoers configuration invalid, restoring backup..."
    mv /etc/sudoers.backup /etc/sudoers
    exit 1
fi

info "Configuring WSL to use systemd and login as '$USERNAME' by default..."
cat <<EOF > /etc/wsl.conf
[boot]
systemd=true

[user]
default = $USERNAME
EOF

# ==================================================================================
# === PHASE 2: HANDOFF TO USER-LEVEL SETUP                                       ===
# ==================================================================================
info "Starting Phase 2: User Environment Setup."

# Verify the dotfiles directory exists
if [ ! -d "/root/archbtw/dotfiles" ]; then
    warning "Dotfiles directory not found at /root/archbtw/dotfiles"
    debug "Contents of /root/archbtw/:"
    ls -la /root/archbtw/ || echo "Directory doesn't exist"
fi

# --- Create and execute a new script as the user ---
info "Creating user-level setup script..."
cat <<'USERSCRIPT' > /home/"$USERNAME"/setup_user.sh
#!/bin/bash
set -e # Exit on error

# Helper for this script
info_user() {
    echo -e "\e[1;32m[USER-SETUP]\e[0m $1"
}
debug_user() {
    echo -e "\e[1;35m[USER-DEBUG]\e[0m $1"
}

info_user "Changing to home directory..."
cd "$HOME"

info_user "Deploying dotfiles from the repository..."
# Ensure .config directory exists
mkdir -p ~/.config

# Check if dotfiles directory exists and copy files
if [ -d "/root/archbtw/dotfiles" ]; then
    debug_user "Copying dotfiles from /root/archbtw/dotfiles/ to $HOME"
    # Copy each dotfile explicitly to ensure proper permissions
    if [ -f "/root/archbtw/dotfiles/.zshrc" ]; then
        cp /root/archbtw/dotfiles/.zshrc "$HOME/.zshrc"
        debug_user "Copied .zshrc"
    fi
    if [ -f "/root/archbtw/dotfiles/.p10k.zsh" ]; then
        cp /root/archbtw/dotfiles/.p10k.zsh "$HOME/.p10k.zsh"
        debug_user "Copied .p10k.zsh"
    fi
    
    # Copy any other dotfiles that might exist
    for dotfile in /root/archbtw/dotfiles/.*; do
        if [ -f "$dotfile" ] && [[ "$(basename "$dotfile")" != "." ]] && [[ "$(basename "$dotfile")" != ".." ]]; then
            cp "$dotfile" "$HOME/"
            debug_user "Copied $(basename "$dotfile")"
        fi
    done
    
    # Fix ownership of copied files
    chown -R "$(whoami):$(whoami)" "$HOME"/.*  2>/dev/null || true
    
    info_user "Dotfiles deployed successfully."
else
    debug_user "Dotfiles directory not found at /root/archbtw/dotfiles, skipping dotfiles deployment."
    debug_user "Available directories in /root/:"
    ls -la /root/ 2>/dev/null || echo "Cannot list /root/ contents"
fi

info_user "Installing Oh My Zsh (unattended)..."
if curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh -s -- --unattended; then
    info_user "Oh My Zsh installed successfully."
    
    # Wait a moment for Oh My Zsh to fully initialize
    sleep 2
    
    # Ensure the custom themes directory exists
    mkdir -p "$HOME/.oh-my-zsh/custom/themes"
    
    info_user "Installing Powerlevel10k theme..."
    debug_user "ZSH_CUSTOM directory: ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    debug_user "Target directory: ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    
    if git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"; then
        info_user "Powerlevel10k installed successfully."
        debug_user "Powerlevel10k files:"
        ls -la "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" | head -5
    else
        debug_user "Powerlevel10k git clone failed, trying alternative approach..."
        # Try manual creation if git clone fails
        P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
        mkdir -p "$P10K_DIR"
        if wget -qO- https://github.com/romkatv/powerlevel10k/archive/v1.19.0.tar.gz | tar xz --strip-components=1 -C "$P10K_DIR"; then
            info_user "Powerlevel10k installed via wget/tar."
        else
            debug_user "Both git and wget methods failed for Powerlevel10k."
        fi
    fi
else
    debug_user "Oh My Zsh installation failed, skipping Powerlevel10k installation..."
fi

info_user "Installing NvShade - The Neovim Distro..."
# Ensure nvim config directory exists
mkdir -p ~/.config
if git clone https://github.com/shadowdevforge/NvShade.git ~/.config/nvim; then
    info_user "NvShade installed successfully."
else
    debug_user "NvShade installation failed, continuing..."
fi

info_user "Installing Rust via rustup (unattended)..."
if curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y; then
    info_user "Rust installed successfully."
    # Source cargo env for current session
    source "$HOME/.cargo/env"
else
    debug_user "Rust installation failed, continuing..."
fi

info_user "Installing additional development toolchains..."
# Test sudo access before using it
if sudo -n true 2>/dev/null; then
    if sudo pacman -S --noconfirm python-pip lua luarocks; then
        info_user "Additional toolchains installed successfully."
    else
        debug_user "Some toolchain packages failed to install."
    fi
else
    debug_user "Sudo access not available or requires password, skipping additional packages."
fi

info_user "Cleaning up..."
rm "$HOME/setup_user.sh"
USERSCRIPT

info "Setting permissions and ownership for user script..."
chown "$USERNAME:$USERNAME" /home/"$USERNAME"/setup_user.sh
chmod +x /home/"$USERNAME"/setup_user.sh

info "Executing user-level setup script as $USERNAME..."
if runuser -l "$USERNAME" -c "/home/$USERNAME/setup_user.sh"; then
    success "User setup completed successfully."
else
    warning "User setup encountered some errors, but continued."
fi

# ==================================================================================
# ===                        FINALIZATION                                        ===
# ==================================================================================
success "============================================================"
success "===                  SETUP COMPLETE!                     ==="
success "============================================================"
info "The system is now fully configured."
info "Please close this terminal and restart your WSL instance."
info "You can do this by running 'wsl --terminate <YourDistroName>' in PowerShell."
info ""
success "IMPORTANT: After restart, paste this command to complete dotfiles setup:"
echo ""
echo -e "\e[1;36mcurl -fsSL https://raw.githubusercontent.com/shadowdevforge/archbtw/main/dotfiles/.zshrc -o ~/.zshrc && curl -fsSL https://raw.githubusercontent.com/shadowdevforge/archbtw/main/dotfiles/.p10k.zsh -o ~/.p10k.zsh && curl -fsSL https://raw.githubusercontent.com/shadowdevforge/archbtw/main/dotfiles/.tmux.conf -o ~/.tmux.conf\e[0m"
echo ""
info "When you log back in, you'll be '$USERNAME' in your new environment."
info "The first time you run 'nvim', NvShade will finalize its installation."

debug "Setup completed at: $(date)"
