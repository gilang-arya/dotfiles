#!/bin/bash

set -euo pipefail

REPO_URL="https://github.com/gilang-arya/dotfiles.git"
CLONE_DIR="$HOME/.dotfiles"
AVAILABLE=("sway" "neovim" "tmux" "hyprland" "xfce" "vscodium")

echo -e "\n=== 🌟 Dotfiles Installer ==="
echo "📁 Repository : $REPO_URL"
echo "📂 Folder     : $CLONE_DIR"
echo ""

# ✅ Pastikan pkg terpasang
check_or_install() {
  local cmd="$1"
  local pkg="$2"
  if ! command -v "$cmd" &> /dev/null; then
    echo "🔧 $cmd not found. Installing with pacman..."
    sudo pacman -Sy --noconfirm "$pkg"
  fi
}

check_or_install git git
check_or_install stow stow

# 🔄 Hapus direktori lama jika ada
if [[ -d "$CLONE_DIR" ]]; then
  echo "🧹 Deleting old directories..."
  rm -rf "$CLONE_DIR"
fi

# 🔽 Clone dengan sparse checkout
echo "⬇️ Partially clone the repository..."
git clone --filter=blob:none --no-checkout "$REPO_URL" "$CLONE_DIR"
cd "$CLONE_DIR"
git sparse-checkout init --cone

# 🔀 Deteksi branch utama secara otomatis
BRANCH=$(git remote show origin | awk '/HEAD branch/ {print $NF}')

if [[ -n "${AUTO_MODE:-}" ]]; then
  SELECTED=("${AVAILABLE[@]}")
else
  clear
  echo -e "\n🗂️  Select the dotfiles you want to install:"
  echo "Available:"
  for item in "${AVAILABLE[@]}"; do
      echo "- $item"
  done
  read -rp "Type the options separated by spaces (eg: sway neovim): " -a SELECTED
fi

# 🔍 Validasi pilihan
VALID_SELECTION=()
for dir in "${SELECTED[@]}"; do
  if printf '%s\n' "${AVAILABLE[@]}" | grep -qx "$dir"; then
    VALID_SELECTION+=("$dir")
  else
    echo "⚠️  '$dir' not available. Skipped."
  fi
done

if [[ ${#VALID_SELECTION[@]} -eq 0 ]]; then
  echo "❌ No valid dotfiles selected."
  exit 1
fi

# 🧪 Validasi direktori tersedia di repo
git ls-tree -d "$BRANCH" --name-only > .available_dirs

VALID_CHECKOUT=()
for dir in "${VALID_SELECTION[@]}"; do
  if grep -qx "$dir" .available_dirs; then
    VALID_CHECKOUT+=("$dir")
  else
    echo "❌ Folder '$dir' not found in repository. Skipped."
  fi
done

if [[ ${#VALID_CHECKOUT[@]} -eq 0 ]]; then
  echo "❌ There is no valid folder to checkout."
  exit 1
fi

# ⏬ Checkout hanya folder yang dipilih
echo ""
echo "📁 Checkout the selected folder"
git sparse-checkout set "${VALID_CHECKOUT[@]}"
git checkout "$BRANCH"

# 📦 Fungsi untuk menginstal paket
install_packages() {
  local dir="$1"
  local pkg_file="$CLONE_DIR/$dir/packages.txt"

  if [[ -f "$pkg_file" ]]; then
    echo -e "\n📦 Installing packages for '$dir'..."
    while IFS= read -r pkg; do
      [[ -z "$pkg" || "$pkg" == \#* ]] && continue
      if ! pacman -Q "$pkg" &>/dev/null; then
        echo "  ➜ Installing $pkg..."
        sudo pacman -S --noconfirm "$pkg"
      else
        echo "  ✓ $pkg already installed"
      fi
    done < "$pkg_file"
  else
    echo "⚠️  No 'packages.txt' for '$dir', skipped."
  fi
}

# 📦 Instalasi paket yang diperlukan
for dir in "${VALID_SELECTION[@]}"; do
  install_packages "$dir"
done

# 🔗 Fungsi untuk menautkan dotfiles
link_dotfiles() {
  local dir="$1"
  echo "🔗 Linking '$dir'..."

  stow "$dir" --dir="$CLONE_DIR" --target="$HOME"
}

# 🔗 Proses penautan
for dir in "${VALID_SELECTION[@]}"; do
  link_dotfiles "$dir"
done

# 🧹 Git cleanup opsional
git gc --prune=now

echo -e "\n✅ Installation complete!"
