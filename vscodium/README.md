# 🧩 **Code - OSS Configuration**

This directory contains my personal configuration for **[Code - OSS](https://github.com/microsoft/vscode)** (the open-source build of Visual Studio Code), managed as part of my dotfiles using [GNU Stow](https://www.gnu.org/software/stow/).

## 🛠 **Requirements**

Make sure you have `stow` installed on your system:

```bash
sudo pacman -S stow      # Arch-based
# or
sudo apt install stow    # Debian/Ubuntu
```

Also ensure that Code - OSS is installed:

```bash
# Arch
sudo pacman -S code

# Or using flatpak
flatpak install flathub com.vscodium.codium
```

## 📦 **Installing Extensions**

To install the extensions that I use, follow these steps:

1. **Ensure Code-OSS is installed.**

2. **Clone this repository and navigate to the extensions directory**:

   ```bash
   git clone https://github.com/garpra/code-oss.git ~/dotfiles/code-oss
   cd ~/dotfiles/code-oss
   ```

3. **Install the extensions listed in `extensions.txt`:**

   To automatically install the extensions that I use, you can run the following command:

   ```bash
   cat extensions.txt | xargs -L 1 code-oss --install-extension
   ```

   This will install all the extensions listed in `extensions.txt`.

> **Note**: If you haven't created the `extensions.txt` file yet, you can export your current extensions by running:
>
> ```bash
> code-oss --list-extensions > extensions.txt
> ```
