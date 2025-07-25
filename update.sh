#!/bin/bash

set -euo pipefail

CLONE_DIR="$HOME/.dotfiles"
REPO_URL="https://github.com/gilang-arya/dotfiles.git"
AVAILABLE=("sway" "neovim" "tmux" "hyprland" "xfce" "vscodium")

echo -e "\n=== 🔄 Dotfiles Updater ==="
echo "📂 Folder dotfiles: $CLONE_DIR"

# 🔍 Validasi dependensi
REQUIRED_CMDS=(git stow)
for cmd in "${REQUIRED_CMDS[@]}"; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "❌ The command '$cmd' was not found. Make sure it is installed."
    exit 1
  fi
done

# ❗ Pastikan direktori sudah di-clone sebelumnya
if [[ ! -d "$CLONE_DIR/.git" ]]; then
  echo "❌ The $CLONE_DIR directory is invalid or has not been cloned."
  echo "💡 Run the install script first."
  exit 1
fi

cd "$CLONE_DIR"
BRANCH=$(git remote show origin | awk '/HEAD branch/ {print $NF}')

# ➤ Tampilkan daftar dan tandai yang sudah ada
echo -e "\n🗂️  Select the additional dotfiles you want to add:"
echo "(Modules that have been installed will be marked)"
echo ""

INSTALLED=()
NOT_INSTALLED=()

for item in "${AVAILABLE[@]}"; do
  if [[ -d "$CLONE_DIR/$item" ]]; then
    INSTALLED+=("$item")
    echo "  [✓] $item (already installed)"
  else
    NOT_INSTALLED+=("$item")
    echo "  [ ] $item"
  fi
done

# 🔽 Jika semua sudah diinstal
if [[ ${#NOT_INSTALLED[@]} -eq 0 ]]; then
  echo -e "\n✅ All dotfiles are installed. There are no more to add."
  exit 0
fi

# 🔽 Masukkan pilihan hanya dari yang belum terinstal
read -rp $'\nType additional options (separated by spaces): ' -a NEW_SELECTION

# 🔍 Validasi
VALID_SELECTION=()
for dir in "${NEW_SELECTION[@]}"; do
  if printf '%s\n' "${NOT_INSTALLED[@]}" | grep -qx "$dir"; then
    VALID_SELECTION+=("$dir")
  else
    echo "⚠️  '$dir' invalid or already installed. Skipped."
  fi
done

if [[ ${#VALID_SELECTION[@]} -eq 0 ]]; then
  echo "❌ There are no valid new choices."
  exit 1
fi

# Validasi folder tersedia di repo
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
  echo "❌ There are no valid folders to add."
  exit 1
fi

# Tambahkan ke sparse-checkout
echo ""
echo "📁 Adding a new folder to the sparse checkout..."
git sparse-checkout add "${VALID_CHECKOUT[@]}"
git checkout "$BRANCH"

# 📦 Instalasi paket
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

# 🔗 Tautkan dotfiles baru
link_dotfiles() {
  local dir="$1"
  echo "🔗 Linking '$dir'..."

  stow "$dir" --dir="$CLONE_DIR" --target="$HOME"
}

# 🔄 Jalankan
for dir in "${VALID_SELECTION[@]}"; do
  install_packages "$dir"
  link_dotfiles "$dir"
done

echo -e "\n✅ Dotfiles updated successfully!"
