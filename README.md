<div align="center">
<pre>
     _____ ___________________   ___ __________________________      __ 
  /  _  \\______   \_   ___ \ /   |   \______   \__    ___/  \    /  \
 /  /_\  \|       _/    \  \//    ~    \    |  _/ |    |  \   \/\/   /
/    |    \    |   \     \___\    Y    /    |   \ |    |   \        / 
\____|__  /____|_  /\______  /\___|_  /|______  / |____|    \__/\  /  
        \/       \/        \/       \/        \/                 \/   
  
</pre>

**A fiercely forged Arch Linux development environment for the modern developer.**


</div>

--- 


**ArchBTW** is a meticulously crafted automation script that transforms a minimal Arch Linux installation into a complete, professional development powerhouse. It is not a bloated setup, but a sharp, responsive forge that provides a full IDE experience without sacrificing the speed and philosophy of Arch Linux.

It is built on a foundation of modern tools and a deep respect for the user's ability to customize their own environment.

</div>

---

### The Final Look
<div align="center">
<pre>
<img width="1600" height="900" alt="Screenshot 2025-09-19 160815" src="https://github.com/user-attachments/assets/04aa41fc-d809-4ae8-be4c-ed194a6b6b39" />
</pre>

</div>


---

### The ArchBTW Philosophy

ArchBTW is built upon four guiding principles. Every package, configuration, and design choice serves this philosophy.

*   **(Performance First):** ArchBTW must be imperceptibly fast to set up and blazingly quick to use. Modern CLI tools and efficient configurations are the standard.
*   **(Modularity):** The environment is built from strong, independent, and easily understood components. Each phase of the forge is designed for clarity and maintainability.
*   **(Intuitive Discovery):** Complexity is hidden until needed. The environment teaches you its features through discoverable aliases and a clear, consistent structure.
*   **(Malleable):** ArchBTW provides a powerful default setup but makes it trivial to override any setting, allowing you to forge it into your own perfect development environment.


---

## 🚀 Installation

### Prerequisites

**For WSL Users:**
*   **Windows 10 version 1903+** or **Windows 11**
*   **WSL2 enabled** ([Enable WSL Guide](https://docs.microsoft.com/en-us/windows/wsl/install))
*   **ArchWSL installed** ([ArchWSL Repository](https://github.com/yuk7/ArchWSL))

**For Bare Metal:**
*   **Minimal Arch Linux installation** ([Arch Installation Guide](https://wiki.archlinux.org/title/Installation_guide))
*   **Internet connection**
*   **Root access** (initial setup only)

### Forge Your Environment

Choose your path and run the commands in your terminal.

<details>
<summary><strong>🪟 WSL Users (Recommended Path)</strong></summary>

1.  **Install ArchWSL** following the [official ArchWSL documentation](https://github.com/yuk7/ArchWSL)

2.  **Launch ArchWSL** and forge your environment:
    ```bash
      pacman-key --init && pacman-key --populate archlinux && pacman -Sy --noconfirm git sudo && git clone https://github.com/shadowdevforge/archbtw.git && cd archbtw && sudo bash ./forge.sh

    ```

3.  **Restart your WSL instance** by running `wsl --terminate <YourDistroName>` in PowerShell

4.  **Complete dotfiles setup** - After restart, paste this command:
    ```bash
    curl -fsSL https://raw.githubusercontent.com/shadowdevforge/archbtw/main/dotfiles/.zshrc -o ~/.zshrc && curl -fsSL https://raw.githubusercontent.com/shadowdevforge/archbtw/main/dotfiles/.p10k.zsh -o ~/.p10k.zsh && curl -fsSL https://raw.githubusercontent.com/shadowdevforge/archbtw/main/dotfiles/.tmux.conf -o ~/.tmux.conf && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    ```
5. **[ESSENTIAL]** Restart your computer and click Shift+s+I on a new Arch session.


</details>

<details>
<summary><strong>🐧 Bare Metal Arch</strong></summary>

1.  **Complete a minimal Arch installation** following the [Arch Installation Guide](https://wiki.archlinux.org/title/Installation_guide)

2.  **Boot into your system as root** and run the forge:
    ```bash
      pacman-key --init && pacman-key --populate archlinux && pacman -Sy --noconfirm git sudo && git clone https://github.com/shadowdevforge/archbtw.git && cd archbtw && sudo bash ./forge.sh

    ```

3.  **Restart your system** to complete the setup

4.  **Complete dotfiles setup** - After restart, paste this command:
    ```bash
    curl -fsSL https://raw.githubusercontent.com/shadowdevforge/archbtw/main/dotfiles/.zshrc -o ~/.zshrc && curl -fsSL https://raw.githubusercontent.com/shadowdevforge/archbtw/main/dotfiles/.p10k.zsh -o ~/.p10k.zsh && curl -fsSL https://raw.githubusercontent.com/shadowdevforge/archbtw/main/dotfiles/.tmux.conf -o ~/.tmux.conf && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    ```
5. **[ESSENTIAL]** Restart your computer and click Shift+s+I on a new Arch session.

</details>

<br>

Finally, **configure your theme**. Run `p10k configure` to set up your Powerlevel10k prompt, and launch `nvim` to let NvShade complete its plugin installation.

---

## ⚙️ What Gets Forged

### 🔧 System Foundation
- **Complete system initialization** (pacman keyring, systemd configuration)
- **Smart user management** - creates user accounts with proper sudo access
- **Performance-optimized mirrors** - uses Arch's blazing-fast default mirrors instead of slower alternatives
- **Essential package installation** with robust error handling

### 🛠️ Development Toolchains
- **Rust** with `cargo`, `rustc`, and complete toolchain
- **Node.js** with `npm` for modern JavaScript development
- **Python** with `pip` development tools
- **Lua** with `luarocks` for configuration scripting
- **Build tools** including base-devel group

### 🖥️ Modern CLI Experience
- **Enhanced shell**: Zsh with Oh-My-Zsh and Powerlevel10k
- **Terminal multiplexer**: Custom tmux configuration with vim-style navigation
- **Better core tools**: `ripgrep`, `unzip`, `curl`, `fastfetch`
- **Git integration**: Ready for development workflows
- **Clean configuration**: Dotfiles deployed fresh from repository

### 📝 Editor Experience
- **NvShade**: Custom Neovim distribution optimized for development
- **Language servers** ready for multi-language development
- **Plugin ecosystem** pre-configured and ready to use
- **Modern editing experience** with intelligent defaults

---

## 🎨 Customization

### Two-Phase Installation
The forge uses an intelligent two-phase approach:

**Phase 1 (Root):** System setup, user creation, and essential packages
**Phase 2 (User):** Development tools, shell configuration, and editor setup

### Fresh Dotfiles Every Time
Instead of bundling potentially outdated configurations, ArchBTW pulls your dotfiles fresh from the repository on first login:

```bash
# This command is provided automatically after installation 
curl -fsSL https://raw.githubusercontent.com/shadowdevforge/archbtw/main/dotfiles/.zshrc -o ~/.zshrc && curl -fsSL https://raw.githubusercontent.com/shadowdevforge/archbtw/main/dotfiles/.p10k.zsh -o ~/.p10k.zsh && curl -fsSL https://raw.githubusercontent.com/shadowdevforge/archbtw/main/dotfiles/.tmux.conf -o ~/.tmux.conf && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    
```

### Manual Installation
For those who prefer step-by-step control:

```bash
# Download and review
wget https://raw.githubusercontent.com/shadowdevforge/archbtw/main/forge.sh
chmod +x forge.sh
less forge.sh  # Always review scripts!

# Run the forge
sudo bash forge.sh
```

### WSL-Specific Configuration
After installation, optimize your WSL experience:

```bash
# The forge automatically configures WSL for systemd and proper user login
# Additional optimizations in ~/.wslconfig:
[wsl2]
memory=4GB
processors=2
swap=0
```

---

## ⌨️ Key Features & Aliases

ArchBTW configures powerful aliases and keybindings that transform your CLI experience:

### Shell Aliases
| Category | Command | Action |
| :------- | :------ | :----- |
| **Navigation** | `ls` → Enhanced listing | Modern file display |
| | `ll` → Detailed listing | Long format view |
| **Development** | `c` → `cargo` | Rust package manager |
| | `nv` → `nvim` | Launch NvShade |
| | `lg` → `lazygit` | Visual git interface |
| **System** | `bat` → Enhanced viewing | Syntax highlighted output |
| | `find` → Modern search | Faster file finding |
| | `grep` → `rg` | Lightning-fast text search |
| | `btop` → System monitor | Beautiful resource display |

### Tmux Configuration
ArchBTW includes a professionally configured tmux setup with vim-style navigation:

| Category | Key Binding | Action |
| :------- | :---------- | :----- |
| **Prefix** | `Ctrl-s` | Tmux prefix (instead of Ctrl-b) |
| **Pane Navigation** | `h/j/k/l` | Vim-style pane selection |
| | `Alt + Arrow Keys` | Quick pane switching (no prefix) |
| **Window Management** | `Shift + Left/Right` | Switch windows |
| | `Alt + H/L` | Vim-style window switching |
| **Copy Mode** | `v` | Begin selection (vi-mode) |
| | `y` | Copy selection |
| | `Ctrl-v` | Rectangle selection |
| **Splits** | `"` | Horizontal split (same directory) |
| | `%` | Vertical split (same directory) |
| **Features** | Mouse support | Click to focus panes/windows |
| | Status on top | Clean status bar positioning |

---

## 🩺 Troubleshooting

### Common Issues

**Internet connectivity issues:**
```bash
# The forge automatically checks connectivity before proceeding
ping -c 1 archlinux.org
```

**Permission errors:**
```bash
# The forge handles user creation and sudo configuration automatically
# If issues persist, verify wheel group membership:
groups $USER
```

**Mirror speed issues:**
```bash
# ArchBTW uses optimized default mirrors - no reflector needed
# Default Arch mirrors are faster and more reliable
```

**WSL networking issues:**
```bash
# Restart WSL
wsl --shutdown
# Then relaunch your distribution
```

**Package installation failures:**
```bash
# The forge includes robust error handling and continues on individual failures
# Check the debug output for specific package issues
```

### Getting Help

1. **Check the forge output** - comprehensive debug information is provided
2. **Verify prerequisites** - ensure your system meets requirements  
3. **Test components individually** - each phase is modular and debuggable
4. **Run health checks**: `:checkhealth` in Neovim
5. **Open an issue** with full error output and system information

---

## 🔧 Advanced Features

### Intelligent Performance Optimization
- **Skip slow mirror updates** - uses Arch's lightning-fast default mirrors
- **Optimized package installation** - installs only essential packages during setup
- **Fresh dotfiles delivery** - pulls configurations directly from repository
- **Streamlined user setup** - minimal overhead, maximum functionality

### Robust Error Handling
- **Internet connectivity verification** before attempting downloads
- **Graceful fallbacks** for failed operations
- **Comprehensive validation** of user inputs with regex checking
- **Safe configuration updates** with backup creation

### Modern Development Stack
- **NvShade Integration** - Custom Neovim distribution i made for professional development [GitHub](https://github.com/shadowdevforge/NvShade)
- **Rust-first approach** - Modern systems programming ready out of the box
- **Node.js ecosystem** - Frontend and backend JavaScript development ready
- **Multi-language support** - Python, Lua, and more configured automatically

### Security & Validation
- **Username validation** with proper Linux naming conventions
- **Password confirmation** with secure input handling
- **Sudoers validation** with automatic backup and restore
- **Permission verification** before making system changes

---

## 🤝 Contributing

We welcome contributions from fellow forge masters! Whether it's optimizations, new features, or documentation improvements:

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/amazing-forge-enhancement`
3. **Make your changes** with clear, documented code
4. **Test thoroughly** on both WSL and bare metal
5. **Submit a pull request** with detailed description

### Development Setup

```bash
# Clone your fork
git clone https://github.com/yourusername/archbtw.git
cd archbtw

# Create test branch
git checkout -b test/my-enhancements

# Test your changes in a VM or container
```

### Testing Guidelines
- **Test on fresh Arch installations** (both minimal and full)
- **Verify WSL compatibility** across different Windows versions
- **Check error handling** by simulating network failures
- **Validate user input scenarios** including edge cases
- **Test dotfiles deployment** after restart

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

##  Special Thanks

*   **[Arch Linux Team](https://archlinux.org/):** For creating the foundation and maintaining blazing-fast mirrors
*   **[ArchWSL Project](https://github.com/yuk7/ArchWSL):** For bringing Arch to Windows seamlessly  
*   **[Oh-My-Zsh](https://ohmyz.sh/) & [Powerlevel10k](https://github.com/romkatv/powerlevel10k):** For revolutionizing the terminal experience
*   **Modern CLI tool creators:** `ripgrep`, `fastfetch`, and others that make development joyful
*   **NvShade contributors:** For creating an exceptional Neovim experience

And of course, to the entire open-source community that makes projects like this possible.

---

<div align="center">

⭐ **Star this repository** if ArchBTW helped you forge an amazing development environment!

***ArchBtw forged***

</div>
