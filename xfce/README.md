# 🖥️ XFCE Configuration

This directory contains my minimalist configuration for the **[XFCE](https://www.xfce.org/)**. Managed using [GNU Stow](https://www.gnu.org/software/stow/) as part of my dotfiles setup.

## 📸 Screenshots

<table>
  <tr>
    <td align="center">
      <img src="./preview.png" alt="XFCE Screenshot" />
      <br />
      <strong>XFCE</strong>
    </td>
  </tr>
</table>

## 🛠 Requirements

Make sure the following packages are installed:

```bash
# Core XFCE
sudo pacman -S xfce4 xfce4-goodies thunar tumbler gvfs alacritty zsh

# Appearance
sudo pacman -S lxappearance

# Utilities
sudo pacman -S plank fastfetch micro xclip

# Optional XFCE tools
sudo pacman -S xfce4-power-manager xfce4-pulseaudio-plugin pavucontrol xfce4-screenshooter
```

## 💡 Tips

- Customize your panel layout in `~/.config/xfce4/panel/`
- Change GTK themes and icons using `lxappearance`
- Add custom scripts to `.scripts/` and run them via keybindings or on startup
