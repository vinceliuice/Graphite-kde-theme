#!/bin/bash

SRC_DIR=$(cd $(dirname $0) && pwd)

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

THEME_NAME=Graphite
THEME_VARIANTS=('' '-nord')
COLOR_VARIANTS=('-light' '-dark')

rimless=

# COLORS
CDEF=" \033[0m"                                     # default color
CCIN=" \033[0;36m"                                  # info color
CGSC=" \033[0;32m"                                  # success color
CRER=" \033[0;31m"                                  # error color
CWAR=" \033[0;33m"                                  # warning color
b_CDEF=" \033[1;37m"                                # bold default color
b_CCIN=" \033[1;36m"                                # bold info color
b_CGSC=" \033[1;32m"                                # bold success color
b_CRER=" \033[1;31m"                                # bold error color
b_CWAR=" \033[1;33m"                                # bold warning color

# Echo like ... with flag type and display message colors
prompt () {
  case ${1} in
    "-s"|"--success")
      echo -e "${b_CGSC}${@/-s/}${CDEF}";;          # print success message
    "-e"|"--error")
      echo -e "${b_CRER}${@/-e/}${CDEF}";;          # print error message
    "-w"|"--warning")
      echo -e "${b_CWAR}${@/-w/}${CDEF}";;          # print warning message
    "-i"|"--info")
      echo -e "${b_CCIN}${@/-i/}${CDEF}";;          # print info message
    *)
    echo -e "$@"
    ;;
  esac
}

usage() {
  cat << EOF
Usage: $0 [OPTION]...

OPTIONS:
  -n, --name NAME         Specify theme name (Default: $THEME_NAME)
  -t, --theme VARIANT     Specify theme color variant(s) [default|nord] (Default: All variants)s)
  -c, --color VARIANT     Specify color variant(s) [standard|light|dark] (Default: All variants)s)
  --rimless VARIANT       Specify rimless variant

  -h, --help              Show help
EOF
}

install() {
  local name=${1}
  local theme=${2}
  local color=${3}

  [[ ${color} == '-dark' ]] && local ELSE_COLOR='Dark'
  [[ ${color} == '-light' ]] && local ELSE_COLOR='Light'
  [[ ${theme} == '-nord' ]] && local ELSE_THEME='Nord'

  local AURORAE_THEME="${AURORAE_DIR}/${name}${color}"{'','-round'}
  local PLASMA_THEME="${PLASMA_DIR}/${name}${theme}${color}"
  local LOOKFEEL_THEME="${LOOKFEEL_DIR}/com.github.vinceliuice.${name}${theme}${color}"
  local SCHEMES_THEME="${SCHEMES_DIR}/${name}${ELSE_COLOR}${ELSE_THEME}.colors"
  local KVANTUM_THEME="${KVANTUM_DIR}/${name}${ELSE_THEME}"
  local WALLPAPER_THEME="${WALLPAPER_DIR}/${name}${theme}${color}"

  mkdir -p                                                                                   ${AURORAE_DIR}
  mkdir -p                                                                                   ${SCHEMES_DIR}
  mkdir -p                                                                                   ${PLASMA_DIR}
  mkdir -p                                                                                   ${LOOKFEEL_DIR}
  mkdir -p                                                                                   ${KVANTUM_DIR}
  mkdir -p                                                                                   ${WALLPAPER_DIR}

  [[ -d ${AURORAE_THEME} ]] && rm -rf ${AURORAE_THEME}
  [[ -d ${PLASMA_THEME} ]] && rm -rf ${PLASMA_THEME}
  [[ -d ${LOOKFEEL_THEME} ]] && rm -rf ${LOOKFEEL_THEME}
  [[ -f ${SCHEMES_THEME} ]] && rm -rf ${SCHEMES_THEME}
  [[ -d ${KVANTUM_THEME} ]] && rm -rf ${KVANTUM_THEME}
  [[ -d ${WALLPAPER_THEME} ]] && rm -rf ${WALLPAPER_THEME}
  [[ -d ${WALLPAPER_DIR}/${name}${theme} ]] && rm -rf ${WALLPAPER_DIR}/${name}${theme}

  cp -r ${SRC_DIR}/aurorae/${name}${color}{'','-round'}                                      ${AURORAE_DIR}

  if [[ "${rimless}" == 'true' ]]; then
    cp -r ${SRC_DIR}/aurorae/${name}${color}-rimless/*                                       ${AURORAE_DIR}/${name}${color}
    cp -r ${SRC_DIR}/aurorae/${name}${color}-round-rimless/*                                 ${AURORAE_DIR}/${name}${color}-round
  fi

  cp -r ${SRC_DIR}/color-schemes/${name}${ELSE_THEME}${ELSE_COLOR}.colors                    ${SCHEMES_DIR}
  cp -r ${SRC_DIR}/Kvantum/${name}${ELSE_THEME}                                              ${KVANTUM_DIR}

  if [[ "${rimless}" == 'true' ]]; then
    cp -r ${SRC_DIR}/Kvantum/${name}${ELSE_THEME}-rimless                                    ${KVANTUM_DIR}
  fi

  cp -r ${SRC_DIR}/plasma/desktoptheme/${name}                                               ${PLASMA_DIR}
  cp -r ${SRC_DIR}/plasma/desktoptheme/${name}                                               ${PLASMA_THEME}

  if [[ "${rimless}" == 'true' ]]; then
    cp -r ${SRC_DIR}/plasma/desktoptheme/${name}-rimless/*                                   ${PLASMA_THEME}
  fi

  cp -r ${SRC_DIR}/plasma/desktoptheme/${name}${theme}${color}/*                             ${PLASMA_THEME}
  cp -r ${SRC_DIR}/color-schemes/${name}${ELSE_THEME}${ELSE_COLOR}.colors                    ${PLASMA_THEME}/colors
  cp -r ${SRC_DIR}/plasma/look-and-feel/com.github.vinceliuice.${name}                       ${LOOKFEEL_DIR}
  cp -r ${SRC_DIR}/plasma/look-and-feel/com.github.vinceliuice.${name}${theme}${color}       ${LOOKFEEL_DIR}
  cp -r ${SRC_DIR}/wallpaper/${name}${theme}${color}                                         ${WALLPAPER_DIR}
  cp -r ${SRC_DIR}/wallpaper/${name}${theme}                                                 ${WALLPAPER_DIR}
}

while [[ "$#" -gt 0 ]]; do
  case "${1:-}" in
    -n|--name)
      name="${1}"
      shift
      ;;
    --rimless)
      rimless='true'
      prompt -i "Install rimless version."
      shift
      ;;
    -t|--theme)
      shift
      for theme in "$@"; do
        case "$theme" in
          default)
            themes+=("${THEME_VARIANTS[0]}")
            shift
            ;;
          nord)
            themes+=("${THEME_VARIANTS[1]}")
            shift
            ;;
          -*)
            break
            ;;
          *)
            prompt -e "ERROR: Unrecognized theme variant '$1'."
            prompt -i "Try '$0 --help' for more information."
            exit 1
            ;;
        esac
        prompt -w "${theme} version"
      done
      ;;
    -c|--color)
      shift
      for variant in "$@"; do
        case "$variant" in
          standard)
            colors+=("${COLOR_VARIANTS[0]}")
            shift
            ;;
          light)
            colors+=("${COLOR_VARIANTS[1]}")
            shift
            ;;
          dark)
            colors+=("${COLOR_VARIANTS[2]}")
            shift
            ;;
          -*)
            break
            ;;
          *)
            prompt -e "ERROR: Unrecognized color variant '$1'."
            prompt -i "Try '$0 --help' for more information."
            exit 1
            ;;
        esac
      done
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      prompt -e "ERROR: Unrecognized installation option '$1'."
      prompt -i "Try '$0 --help' for more information."
      exit 1
      ;;
  esac
done

prompt -w "Installing '${THEME_NAME} kde themes'..."

for theme in "${themes[@]:-${THEME_VARIANTS[@]}}"; do
  for color in "${colors[@]:-${COLOR_VARIANTS[@]}}"; do
    install "${name:-${THEME_NAME}}" "${theme}" "${color}"
  done
done

prompt -s "Install finished..."
