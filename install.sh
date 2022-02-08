#!/bin/bash

SRC_DIR=$(cd $(dirname $0) && pwd)

AURORAE_DIR="$HOME/.local/share/aurorae/themes"
SCHEMES_DIR="$HOME/.local/share/color-schemes"
PLASMA_DIR="$HOME/.local/share/plasma/desktoptheme"
LOOKFEEL_DIR="$HOME/.local/share/plasma/look-and-feel"
KVANTUM_DIR="$HOME/.config/Kvantum"
WALLPAPER_DIR="$HOME/.local/share/wallpapers"

THEME_NAME=Graphite
THEME_VARIANTS=('' '-nord')
COLOR_VARIANTS=('-light' '-dark')

install() {
  local name=${1}
  local theme=${2}
  local color=${3}

  [[ ${color} == '-dark' ]] && local ELSE_COLOR='Dark'
  [[ ${color} == '-light' ]] && local ELSE_COLOR='Light'
  [[ ${theme} == '-nord' ]] && local ELSE_THEME='Nord'

  local AURORAE_THEME="${AURORAE_DIR}/${name}${color}"
  local PLASMA_THEME="${PLASMA_DIR}/${name}${theme}${color}"
  local LOOKFEEL_THEME="${LOOKFEEL_DIR}/com.github.vinceliuice.${name}${theme}${color}"
  local SCHEMES_THEME="${SCHEMES_DIR}/${name}${ELSE_COLOR}${ELSE_THEME}.colors"
  local KVANTUM_THEME="${KVANTUM_DIR}/${name}${ELSE_THEME}"
  local WALLPAPER_THEME="${WALLPAPER_DIR}/${name}${theme}${color}"

  mkdir -p                                                                           ${AURORAE_DIR}
  mkdir -p                                                                           ${SCHEMES_DIR}
  mkdir -p                                                                           ${PLASMA_DIR}
  mkdir -p                                                                           ${LOOKFEEL_DIR}
  mkdir -p                                                                           ${KVANTUM_DIR}
  mkdir -p                                                                           ${WALLPAPER_DIR}

  [[ -d ${AURORAE_THEME} ]] && rm -rf ${AURORAE_THEME}
  [[ -d ${PLASMA_THEME} ]] && rm -rf ${PLASMA_THEME}
  [[ -d ${LOOKFEEL_THEME} ]] && rm -rf ${LOOKFEEL_THEME}
  [[ -d ${SCHEMES_THEME} ]] && rm -rf ${SCHEMES_THEME}
  [[ -d ${KVANTUM_THEME} ]] && rm -rf ${KVANTUM_THEME}
  [[ -d ${WALLPAPER_THEME} ]] && rm -rf ${WALLPAPER_THEME}

  cp -r ${SRC_DIR}/aurorae/${name}${color}{'','-round'}                                      ${AURORAE_DIR}
  cp -r ${SRC_DIR}/color-schemes/${name}${ELSE_THEME}${ELSE_COLOR}.colors                    ${SCHEMES_DIR}
  cp -r ${SRC_DIR}/Kvantum/${name}${ELSE_THEME}                                              ${KVANTUM_DIR}
  cp -r ${SRC_DIR}/plasma/desktoptheme/${name}                                               ${PLASMA_DIR}
  cp -r ${SRC_DIR}/plasma/desktoptheme/${name}                                               ${PLASMA_THEME}
  cp -r ${SRC_DIR}/plasma/desktoptheme/${name}${theme}${color}/*                             ${PLASMA_THEME}
  cp -r ${SRC_DIR}/color-schemes/${name}${ELSE_THEME}${ELSE_COLOR}.colors                    ${PLASMA_THEME}/colors
  cp -r ${SRC_DIR}/plasma/look-and-feel/com.github.vinceliuice.${name}                       ${LOOKFEEL_DIR}
  cp -r ${SRC_DIR}/plasma/look-and-feel/com.github.vinceliuice.${name}${theme}${color}       ${LOOKFEEL_DIR}
  cp -r ${SRC_DIR}/wallpaper/${name}${theme}${color}                                         ${WALLPAPER_DIR}
}

echo "Installing '${THEME_NAME} kde themes'..."

for theme in "${themes[@]:-${THEME_VARIANTS[@]}}"; do
for color in "${colors[@]:-${COLOR_VARIANTS[@]}}"; do
  install "${name:-${THEME_NAME}}" "${theme}" "${color}"
done
done

echo "Install finished..."
