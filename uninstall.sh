#!/bin/bash

set -euo pipefail

CLONE_DIR="$HOME/.dotfiles"
AVAILABLE=("sway" "neovim" "tmux" "hyprland" "xfce" "vscodium")

echo -e "\n=== ❌ Dotfiles Uninstaller ==="
echo "📂 Folder dotfiles: $CLONE_DIR"
echo ""

# 🔍 Validasi dependensi
REQUIRED_CMDS=(git stow)
for cmd in "${REQUIRED_CMDS[@]}"; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "❌ The command '$cmd' was not found. Make sure it is installed."
    exit 1
  fi
done

# 🛑 Cek apakah folder .dotfiles ada
if [[ ! -d "$CLONE_DIR" ]]; then
  echo "⚠️  The $CLONE_DIR directory was not found. There is nothing to delete."
  exit 0
fi

# ➤ Tampilkan pilihan
clear
echo -e "\n🗂️  Select the dotfiles you want to delete:"
echo "Available:"
for item in "${AVAILABLE[@]}"; do
    echo "- $item"
done
read -rp "Type the options separated by spaces (eg: sway neovim): " -a SELECTED

# 🔍 Validasi pilihan
VALID_SELECTION=()
for dir in "${SELECTED[@]}"; do
  if printf '%s\n' "${AVAILABLE[@]}" | grep -qx "$dir"; then
    if [[ -d "$CLONE_DIR/$dir" ]]; then
      VALID_SELECTION+=("$dir")
    else
      echo "⚠️  Folder '$dir' does not exist in $CLONE_DIR. Skipped."
    fi
  else
    echo "⚠️  '$dir' is not a valid option. Skipped."
  fi
done

if [[ ${#VALID_SELECTION[@]} -eq 0 ]]; then
  echo "❌ There are no valid options to delete."
  exit 1
fi

# 🧹 Lepas symlink dengan stow
for dir in "${VALID_SELECTION[@]}"; do
  echo "🚫 Removing symlink for '$dir'..."
  stow -D "$dir" --dir="$CLONE_DIR" --target="$HOME"
done

# 📦 Hapus paket dari packages.txt
for dir in "${VALID_SELECTION[@]}"; do
  PKG_FILE="$CLONE_DIR/$dir/packages.txt"
  if [[ -f "$PKG_FILE" ]]; then
    echo -e "\n📦 Removing packages from '$dir'..."
    while IFS= read -r pkg; do
      [[ -z "$pkg" || "$pkg" == \#* ]] && continue
      if pacman -Q "$pkg" &>/dev/null; then
        echo "  ➜ Delete $pkg..."
        sudo pacman -Rns --noconfirm "$pkg"
      else
        echo "  ✓ $pkg no longer installed"
      fi
    done < "$PKG_FILE"
  else
    echo "⚠️  No 'packages.txt' for '$dir', skipped."
  fi
done

# 🗑️ Tawarkan penghapusan seluruh direktori .dotfiles
echo ""
read -rp "🗑️ Delete entire $CLONE_DIR directory? (y/n): " confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
  rm -rf "$CLONE_DIR"
  echo "✅ $CLONE_DIR directory deleted."
else
  echo "📁 $CLONE_DIR directory is preserved."
fi

echo -e "\n✅ Uninstall complete!"
