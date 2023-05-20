#!/bin/bash

REGULAR_TEXT='\033[0m'
RED_TEXT='\033[1;31m'
GREEN_TEXT='\033[1;32m' 

TEMP_FOLDER_NAME='DELETE_ME'

# Prints message with green color in console.
# First argument must be message string.
printMessage() {
  printf "${GREEN_TEXT}
$1
  ${REGULAR_TEXT}\n"
}

# Prints message with red color in console.
# First argument must be message string.
printError() {
  printf "${RED_TEXT}
$1
  ${REGULAR_TEXT}\n"
}

# Asks the user a yes/no question.
# First argument must be a question string.
# Returns:
#   - 0 if user has selected 'yes'
#   - 1 if user has selected 'no'
#   - 1 by default
askUser() {
  printMessage "$1"
  read answer
  if [[ ${answer^^} = "Y" || ${answer^^} = "YES" ]]; then 
    return 0
  fi

  return 1  
}

installYay() {
  sudo pacman -S --needed git base-devel

  if command -v yay &> /dev/null ; then
    echo 'Yay already installed.'
    return 0
  fi

  mkdir -p $TEMP_FOLDER_NAME/yay
  git clone https://aur.archlinux.org/yay.git $TEMP_FOLDER_NAME/yay
  cd $TEMP_FOLDER_NAME/yay
  makepkg -si
  yay -Y --gendb
  yay -Syu --devel
  cd ../../
}

installCorePackages() {
  yay -S --needed \
    pipewire wireplumber \
    wayland xwayland xdg-utils xdg-user-dirs linux-headers \
    alacritty \
    networkmanager \
    sddm-git hyprland-git waybar-hyprland-git \
    xdg-desktop-portal-hyprland wl-copy \
    rofi-wayland rofi-calc \
    gvfs \
    ttf-hack ttf-hack-nerd ttf-font-awesome noto-fonts-emoji \
    alsa-utils alsa-firmware \
    grim slurp grimblast \
    playerctl \
    brightnessctl \
    blueman \
    swayidle udev-block-notify wlogout \
    dunst \
    polkit xfce-polkit \
    hyprpicker \
    tlpui \
    checkupdates+aur \
    swaybg \
    mocu-xcursor
}

importGSettings() {
  local config="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-3.0/settings.ini"
  if [ ! -f "$config" ]; then exit 1; fi

  local gnome_schema="org.gnome.desktop.interface"
  local gtk_theme="$(grep 'gtk-theme-name' "$config" | sed 's/.*\s*=\s*//')"
  local icon_theme="$(grep 'gtk-icon-theme-name' "$config" | sed 's/.*\s*=\s*//')"
  local cursor_theme="$(grep 'gtk-cursor-theme-name' "$config" | sed 's/.*\s*=\s*//')"
  local font_name="$(grep 'gtk-font-name' "$config" | sed 's/.*\s*=\s*//')"

  echo $icon_theme

  gsettings set "$gnome_schema" gtk-theme "$gtk_theme"
  gsettings set "$gnome_schema" icon-theme "$icon_theme"
  gsettings set "$gnome_schema" cursor-theme "$cursor_theme"
  gsettings set "$gnome_schema" font-name "$font_name"
}

copyConfigs() {
  sudo cp -ri usr/* /usr/
  sudo cp -ri etc/* /etc/sddm/
  cp -ri home/* ~/
  importGSettings
}

printMessage 'Installing yay:'
installYay || {
  printError 'Yay installing failed.'
  exit 1
}

printMessage 'Installing core packages:'
installCorePackages || {
  printError 'Core packages installing failed.'
  exit 1
}

printMessage 'Copying configuration files:'
copyConfigs || {
  printError 'Appearance customization failed.'
  exit 1
}

if askUser 'Do you want to install additional applicatons? (Y/n):' ; then 
  printMessage 'Installing applications:' 
  . install_applications.sh || {
    printError 'Installing applications failed.'
    exit 1
  }
fi

rm -rf $TEMP_FOLDER_NAME
