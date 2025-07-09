#!/bin/bash

set -euo pipefail

REPO_URL="https://github.com/gilang-arya/dotfiles.git"
CLONE_DIR="$HOME/.dotfiles"

echo -e "\n=== 🌟 Dotfiles Installer 🌟 ==="
echo "📁 Repository : $REPO_URL"
echo "📂 Folder     : $CLONE_DIR"
echo ""

# 🔄 Hapus direktori lama jika ada
if [[ -d "$CLONE_DIR" ]]; then
  echo "🧹 Menghapus direktori lama..."
  rm -rf "$CLONE_DIR"
fi

# ✅ Pastikan 'stow' terpasang
if ! command -v stow &> /dev/null; then
  echo "🔧 stow belum ditemukan. Menginstal dengan pacman..."
  sudo pacman -Sy --noconfirm stow
fi

# 🔽 Clone dengan sparse checkout
echo "⬇️  Meng-clone repository secara parsial..."
git clone --filter=blob:none --no-checkout "$REPO_URL" "$CLONE_DIR"
cd "$CLONE_DIR"
git sparse-checkout init --cone

# ➤ Tampilkan pilihan
echo -e "\n🗂️  Pilih dotfiles yang ingin di-install:"
AVAILABLE=("sway" "neovim" "tmux")
echo "Tersedia: ${AVAILABLE[*]}"
read -rp "Ketik pilihan dipisah spasi (misal: sway neovim): " -a SELECTED

# 🔍 Validasi pilihan
VALID_SELECTION=()
for dir in "${SELECTED[@]}"; do
  if [[ " ${AVAILABLE[*]} " == *" $dir "* ]]; then
    VALID_SELECTION+=("$dir")
  else
    echo "⚠️  '$dir' tidak tersedia. Dilewati."
  fi
done

if [[ ${#VALID_SELECTION[@]} -eq 0 ]]; then
  echo "❌ Tidak ada dotfiles valid yang dipilih. Keluar."
  exit 1
fi

# ⏬ Checkout hanya folder yang dipilih
git sparse-checkout set "${VALID_SELECTION[@]}"
git checkout main

# 📦 Instalasi paket yang diperlukan
for dir in "${VALID_SELECTION[@]}"; do
  PKG_FILE="$CLONE_DIR/$dir/packages.txt"
  if [[ -f "$PKG_FILE" ]]; then
    echo -e "\n📦 Menginstal paket untuk '$dir'..."
    while IFS= read -r pkg; do
      if [[ -n "$pkg" ]] && ! pacman -Q "$pkg" &>/dev/null; then
        echo "  ➜ Menginstal $pkg..."
        sudo pacman -S --noconfirm "$pkg"
      else
        echo "  ✓ $pkg sudah terpasang"
      fi
    done < "$PKG_FILE"
  else
    echo "⚠️  Tidak ada 'packages.txt' untuk '$dir', dilewati."
  fi
done

# 🔗 Menautkan dengan stow
for dir in "${VALID_SELECTION[@]}"; do
  echo "🔗 Menautkan '$dir'..."
  stow "$dir"
done

echo -e "\n✅ Instalasi selesai!"
