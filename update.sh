#!/bin/bash

set -euo pipefail

CLONE_DIR="$HOME/.dotfiles"
REPO_URL="https://github.com/gilang-arya/dotfiles.git"
AVAILABLE=("sway" "neovim" "tmux" "hyprland" "xfce" "vscodium")

echo -e "\n=== 🔄 Dotfiles Updater ==="
echo "📂 Folder dotfiles: $CLONE_DIR"

# 🔍 Validasi dependensi
REQUIRED_CMDS=(git stow pacman find)
for cmd in "${REQUIRED_CMDS[@]}"; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "❌ Perintah '$cmd' tidak ditemukan. Pastikan sudah terinstal."
    exit 1
  fi
done

# ❗ Pastikan direktori sudah di-clone sebelumnya
if [[ ! -d "$CLONE_DIR/.git" ]]; then
  echo "❌ Direktori $CLONE_DIR tidak valid atau belum di-clone."
  echo "💡 Jalankan skrip install terlebih dahulu."
  exit 1
fi

cd "$CLONE_DIR"
BRANCH=$(git remote show origin | awk '/HEAD branch/ {print $NF}')

# ➤ Tampilkan daftar dan tandai yang sudah ada
echo -e "\n🗂️  Pilih dotfiles tambahan yang ingin ditambahkan:"
echo "(Modul yang sudah diinstal akan ditandai)"
echo ""

INSTALLED=()
NOT_INSTALLED=()

for item in "${AVAILABLE[@]}"; do
  if [[ -d "$CLONE_DIR/$item" ]]; then
    INSTALLED+=("$item")
    echo "  [✓] $item (sudah diinstall)"
  else
    NOT_INSTALLED+=("$item")
    echo "  [ ] $item"
  fi
done

# 🔽 Jika semua sudah diinstal
if [[ ${#NOT_INSTALLED[@]} -eq 0 ]]; then
  echo -e "\n✅ Semua dotfiles sudah terinstal. Tidak ada yang bisa ditambahkan."
  exit 0
fi

# 🔽 Masukkan pilihan hanya dari yang belum terinstal
read -rp $'\nKetik pilihan tambahan (dipisah spasi): ' -a NEW_SELECTION

# 🔍 Validasi
VALID_SELECTION=()
for dir in "${NEW_SELECTION[@]}"; do
  if printf '%s\n' "${NOT_INSTALLED[@]}" | grep -qx "$dir"; then
    VALID_SELECTION+=("$dir")
  else
    echo "⚠️  '$dir' tidak valid atau sudah diinstal. Dilewati."
  fi
done

if [[ ${#VALID_SELECTION[@]} -eq 0 ]]; then
  echo "❌ Tidak ada pilihan baru yang valid. Keluar."
  exit 1
fi

# Validasi folder tersedia di repo
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
  echo "❌ Tidak ada folder valid untuk ditambahkan. Keluar."
  exit 1
fi

# Tambahkan ke sparse-checkout
echo ""
echo "📁 Menambahkan folder baru ke sparse checkout..."
git sparse-checkout add "${VALID_CHECKOUT[@]}"
git checkout "$BRANCH"

# 📦 Instalasi paket
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

# 🔗 Tautkan dotfiles baru
link_dotfiles() {
  local dir="$1"
  echo "🔗 Menautkan '$dir'..."

  stow "$dir" --dir="$CLONE_DIR" --target="$HOME"
}

# 🔄 Jalankan
for dir in "${VALID_SELECTION[@]}"; do
  install_packages "$dir"
  link_dotfiles "$dir"
done

echo -e "\n✅ Dotfiles berhasil diperbarui!"
