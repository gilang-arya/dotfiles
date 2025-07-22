#!/bin/bash

set -euo pipefail

CLONE_DIR="$HOME/.dotfiles"
AVAILABLE=("sway" "neovim" "tmux" "hyprland" "xfce" "vscodium")

echo -e "\n=== ❌ Dotfiles Uninstaller ==="
echo "📂 Folder dotfiles: $CLONE_DIR"
echo ""

# 🔍 Validasi dependensi
REQUIRED_CMDS=(stow pacman find)
for cmd in "${REQUIRED_CMDS[@]}"; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "❌ Perintah '$cmd' tidak ditemukan. Pastikan sudah terinstal."
    exit 1
  fi
done

# 🛑 Cek apakah folder .dotfiles ada
if [[ ! -d "$CLONE_DIR" ]]; then
  echo "⚠️  Direktori $CLONE_DIR tidak ditemukan. Tidak ada yang perlu dihapus."
  exit 0
fi

# ➤ Tampilkan pilihan
clear
echo -e "\n🗂️  Pilih dotfiles yang ingin dihapus:"
echo "Tersedia:"
for item in "${AVAILABLE[@]}"; do
    echo "- $item"
done
read -rp "Ketik pilihan dipisah spasi (misal: sway neovim): " -a SELECTED

# 🔍 Validasi pilihan
VALID_SELECTION=()
for dir in "${SELECTED[@]}"; do
  if printf '%s\n' "${AVAILABLE[@]}" | grep -qx "$dir"; then
    if [[ -d "$CLONE_DIR/$dir" ]]; then
      VALID_SELECTION+=("$dir")
    else
      echo "⚠️  Folder '$dir' tidak ada di $CLONE_DIR. Dilewati."
    fi
  else
    echo "⚠️  '$dir' bukan pilihan yang valid. Dilewati."
  fi
done

if [[ ${#VALID_SELECTION[@]} -eq 0 ]]; then
  echo "❌ Tidak ada pilihan valid untuk dihapus. Keluar."
  exit 1
fi

# 🧹 Lepas symlink dengan stow
for dir in "${VALID_SELECTION[@]}"; do
  echo "🚫 Melepas symlink untuk '$dir'..."
  stow -D "$dir" --dir="$CLONE_DIR" --target="$HOME"
done

# 📦 Hapus paket dari packages.txt
for dir in "${VALID_SELECTION[@]}"; do
  PKG_FILE="$CLONE_DIR/$dir/packages.txt"
  if [[ -f "$PKG_FILE" ]]; then
    echo -e "\n📦 Menghapus paket dari '$dir'..."
    while IFS= read -r pkg; do
      [[ -z "$pkg" || "$pkg" == \#* ]] && continue
      if pacman -Q "$pkg" &>/dev/null; then
        echo "  ➜ Menghapus $pkg..."
        sudo pacman -Rns --noconfirm "$pkg"
      else
        echo "  ✓ $pkg sudah tidak terpasang"
      fi
    done < "$PKG_FILE"
  else
    echo "⚠️  Tidak ada 'packages.txt' untuk '$dir', dilewati."
  fi
done

# 🗑️ Tawarkan penghapusan seluruh direktori .dotfiles
echo ""
read -rp "🗑️  Hapus seluruh direktori $CLONE_DIR? (y/n): " confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
  rm -rf "$CLONE_DIR"
  echo "✅ Direktori $CLONE_DIR dihapus."
else
  echo "📁 Direktori $CLONE_DIR dipertahankan."
fi

echo -e "\n✅ Uninstall selesai!"
