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

# 🔍 Cek dependensi penting
REQUIRED_CMDS=(git stow pacman find)
for cmd in "${REQUIRED_CMDS[@]}"; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "❌ Perintah '$cmd' tidak ditemukan. Pastikan sudah terinstal."
    exit 1
  fi
done

# 🔽 Clone dengan sparse checkout
echo "⬇️  Meng-clone repository secara parsial..."
git clone --filter=blob:none --no-checkout "$REPO_URL" "$CLONE_DIR"
cd "$CLONE_DIR"
git sparse-checkout init --cone

# 🔀 Deteksi branch utama secara otomatis
BRANCH=$(git remote show origin | awk '/HEAD branch/ {print $NF}')

# ➤ Tampilkan pilihan
AVAILABLE=("sway" "neovim" "tmux" "hyprland" "xfce" "vscodium")

if [[ -n "${AUTO_MODE:-}" ]]; then
  SELECTED=("${AVAILABLE[@]}")
else
  clear
  echo -e "\n🗂️  Pilih dotfiles yang ingin di-install:"
  echo "Tersedia:"
  for item in "${AVAILABLE[@]}"; do
      echo "- $item"
  done
  read -rp "Ketik pilihan dipisah spasi (misal: sway neovim): " -a SELECTED
fi

# 🔍 Validasi pilihan
VALID_SELECTION=()
for dir in "${SELECTED[@]}"; do
  if printf '%s\n' "${AVAILABLE[@]}" | grep -qx "$dir"; then
    VALID_SELECTION+=("$dir")
  else
    echo "⚠️  '$dir' tidak tersedia. Dilewati."
  fi
done

if [[ ${#VALID_SELECTION[@]} -eq 0 ]]; then
  echo "❌ Tidak ada dotfiles valid yang dipilih. Keluar."
  exit 1
fi

# 🧪 Validasi direktori tersedia di repo
git ls-tree -d "$BRANCH" --name-only > .available_dirs

VALID_CHECKOUT=()
for dir in "${VALID_SELECTION[@]}"; do
  if grep -qx "$dir" .available_dirs; then
    VALID_CHECKOUT+=("$dir")
  else
    echo "❌ Folder '$dir' tidak ditemukan di repository. Dilewati."
  fi
done

if [[ ${#VALID_CHECKOUT[@]} -eq 0 ]]; then
  echo "❌ Tidak ada folder valid untuk checkout. Keluar."
  exit 1
fi

# ⏬ Checkout hanya folder yang dipilih
echo ""
echo "📁 Checkout folder yang dipilih"
git sparse-checkout set "${VALID_CHECKOUT[@]}"
git checkout "$BRANCH"

# 📦 Fungsi untuk menginstal paket
install_packages() {
  local dir="$1"
  local pkg_file="$CLONE_DIR/$dir/packages.txt"

  if [[ -f "$pkg_file" ]]; then
    echo -e "\n📦 Menginstal paket untuk '$dir'..."
    while IFS= read -r pkg; do
      [[ -z "$pkg" || "$pkg" == \#* ]] && continue
      if ! pacman -Q "$pkg" &>/dev/null; then
        echo "  ➜ Menginstal $pkg..."
        sudo pacman -S --noconfirm "$pkg"
      else
        echo "  ✓ $pkg sudah terpasang"
      fi
    done < "$pkg_file"
  else
    echo "⚠️  Tidak ada 'packages.txt' untuk '$dir', dilewati."
  fi
}

# 📦 Instalasi paket yang diperlukan
for dir in "${VALID_SELECTION[@]}"; do
  install_packages "$dir"
done

# 🔗 Fungsi untuk menautkan dotfiles
link_dotfiles() {
  local dir="$1"
  echo "🔗 Menautkan '$dir'..."

  stow "$dir" --dir="$CLONE_DIR" --target="$HOME"
}

# 🔗 Proses penautan
for dir in "${VALID_SELECTION[@]}"; do
  link_dotfiles "$dir"
done

# 🧹 Git cleanup opsional
git gc --prune=now

echo -e "\n✅ Instalasi selesai!"
