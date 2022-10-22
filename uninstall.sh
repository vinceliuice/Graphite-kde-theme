#! /usr/bin/env bash

SRC_DIR=$(cd $(dirname $0) && pwd)
THEME_NAME=Graphite
ROOT_UID=0

# Destination directory
if [ "$UID" -eq "$ROOT_UID" ]; then
  AURORAE_DIR="/usr/share/aurorae/themes"
  SCHEMES_DIR="/usr/share/color-schemes"
  PLASMA_DIR="/usr/share/plasma/desktoptheme"
  LOOKFEEL_DIR="/usr/share/plasma/look-and-feel"
  KVANTUM_DIR="/usr/share/Kvantum"
  WALLPAPER_DIR="/usr/share/wallpapers"
else
  AURORAE_DIR="$HOME/.local/share/aurorae/themes"
  SCHEMES_DIR="$HOME/.local/share/color-schemes"
  PLASMA_DIR="$HOME/.local/share/plasma/desktoptheme"
  LOOKFEEL_DIR="$HOME/.local/share/plasma/look-and-feel"
  KVANTUM_DIR="$HOME/.config/Kvantum"
  WALLPAPER_DIR="$HOME/.local/share/wallpapers"
fi


check_and_remove() {
  if ls $1 1> /dev/null 2>&1; then
    rm -rfv $1
  fi
}

uninstall() {
  local name=${1}

  check_and_remove "${AURORAE_DIR}/${name}*"
  check_and_remove "${PLASMA_DIR}/${name}*"
  check_and_remove "${SCHEMES_DIR}/${name}*"
  check_and_remove "${LOOKFEEL_DIR}/com.github.vinceliuice.${name}*"
  check_and_remove "${KVANTUM_DIR}/${name}*"
  check_and_remove "${WALLPAPER_DIR}/${name}*"
}

echo "Uninstalling '${THEME_NAME} kde themes'..."
uninstall "${name:-${THEME_NAME}}"

echo "Uninstall finished..."
