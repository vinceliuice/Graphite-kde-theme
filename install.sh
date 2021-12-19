#!/bin/bash

SRC_DIR=$(cd $(dirname $0) && pwd)

AURORAE_DIR="$HOME/.local/share/aurorae/themes"
SCHEMES_DIR="$HOME/.local/share/color-schemes"
PLASMA_DIR="$HOME/.local/share/plasma/desktoptheme"
LOOKFEEL_DIR="$HOME/.local/share/plasma/look-and-feel"
KVANTUM_DIR="$HOME/.config/Kvantum"
WALLPAPER_DIR="$HOME/.local/share/wallpapers"

THEME_NAME=Graphite
COLOR_VARIANTS=('-light' '-dark')

install() {
  local name=${1}
  local color=${2}

  [[ ${color} == '-dark' ]] && local ELSE_COLOR='Dark'
  [[ ${color} == '-light' ]] && local ELSE_COLOR='Light'

  local AURORAE_THEME="${AURORAE_DIR}/${name}${color}"
  local PLASMA_THEME="${PLASMA_DIR}/${name}"
  local LOOKFEEL_THEME="${LOOKFEEL_DIR}/com.github.vinceliuice.${name}${color}"
  local SCHEMES_THEME="${SCHEMES_DIR}/${name}${ELSE_COLOR}.colors"
  local KVANTUM_THEME="${KVANTUM_DIR}/${name}"
  local WALLPAPER_THEME="${WALLPAPER_DIR}/${name}${color}"

  mkdir -p                                                                           ${AURORAE_DIR}
  mkdir -p                                                                           ${SCHEMES_DIR}
  mkdir -p                                                                           ${PLASMA_DIR}
  mkdir -p                                                                           ${PLASMA_DIR}/${name}${color}
  mkdir -p                                                                           ${LOOKFEEL_DIR}
  mkdir -p                                                                           ${KVANTUM_DIR}
  mkdir -p                                                                           ${WALLPAPER_DIR}

  [[ -d ${AURORAE_THEME} ]] && rm -rf ${AURORAE_THEME}
  [[ -d ${PLASMA_THEME} ]] && rm -rf ${PLASMA_THEME}
  [[ -d ${LOOKFEEL_THEME} ]] && rm -rf ${LOOKFEEL_THEME}
  [[ -d ${SCHEMES_THEME} ]] && rm -rf ${SCHEMES_THEME}
  [[ -d ${KVANTUM_THEME} ]] && rm -rf ${KVANTUM_THEME}
  [[ -d ${WALLPAPER_THEME} ]] && rm -rf ${WALLPAPER_THEME}

  cp -r ${SRC_DIR}/aurorae/${name}${color}                                           ${AURORAE_DIR}
  cp -r ${SRC_DIR}/color-schemes/${name}${ELSE_COLOR}.colors                         ${SCHEMES_DIR}
  cp -r ${SRC_DIR}/Kvantum/${name}                                                   ${KVANTUM_DIR}
  cp -r ${SRC_DIR}/plasma/desktoptheme/${name}                                       ${PLASMA_DIR}
  cp -r ${SRC_DIR}/plasma/desktoptheme/${name}/*                                     ${PLASMA_DIR}/${name}${color}
  cp -r ${SRC_DIR}/plasma/desktoptheme/${name}${color}/*                             ${PLASMA_DIR}/${name}${color}
  cp -r ${SRC_DIR}/color-schemes/${name}${ELSE_COLOR}.colors                         ${PLASMA_DIR}/${name}${color}/colors
  cp -r ${SRC_DIR}/plasma/look-and-feel/com.github.vinceliuice.${name}               ${LOOKFEEL_DIR}
  cp -r ${SRC_DIR}/plasma/look-and-feel/com.github.vinceliuice.${name}${color}       ${LOOKFEEL_DIR}
  cp -r ${SRC_DIR}/wallpaper/${name}${color}                                         ${WALLPAPER_DIR}
}

echo "Installing '${THEME_NAME} kde themes'..."

for color in "${colors[@]:-${COLOR_VARIANTS[@]}}"; do
  install "${name:-${THEME_NAME}}" "${color}"
done

echo "Install finished..."
