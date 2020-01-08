#! /usr/bin/env zsh

# exit on error
set -e

#
# Copy dotfiles to your home directory
#

SRC_DIR=$(cd "$(dirname "${0}")"; pwd)

if [ -z ${1+x} ]; then
  TARGET_DIR=${HOME}
  echo "Copies dotfiles to your home directory (${TARGET_DIR})."
else
  TARGET_DIR=${1}
  echo "Copies dotfiles to directory (${TARGET_DIR})."
fi

read -sk 1 "REPLY?Old files will be overwritten. Continue (y/n)? "
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  # create target dir
  if [ ! -d "${TARGET_DIR}" ]; then
    mkdir -p ${TARGET_DIR}
  fi
  # copy all files
  cp -f ${SRC_DIR}/home/zsh_additions ${TARGET_DIR}/.zsh_additions
  cp -f ${SRC_DIR}/home/nanorc ${TARGET_DIR}/.nanorc
  cp -f ${SRC_DIR}/home/vimrc ${TARGET_DIR}/.vimrc
  mkdir -p ${TARGET_DIR}/.vim/colors
  cp -f ${SRC_DIR}/vim/colors/molokai/molokai.vim ${TARGET_DIR}/.vim/colors/molokai.vim
  mkdir -p ${TARGET_DIR}/.config
  cp -fR ${SRC_DIR}/home/config/* ${TARGET_DIR}/.config/

  # write include for shell additions to default shell config
  if [ "${TARGET_DIR}" = "${HOME}" ]; then
    SHELL_ADDITIONS="~/.zsh_additions"
  else
    SHELL_ADDITIONS="${TARGET_DIR}/.zsh_additions"
  fi
  if [ -f "${TARGET_DIR}/.zshrc" ] && grep -Fxq ". ${SHELL_ADDITIONS}" ${TARGET_DIR}/.zshrc; then
      echo "Includes already present."
  else
      echo "Adding includes to ${TARGET_DIR}/.zshrc"
      echo ". ${SHELL_ADDITIONS}" >> ${TARGET_DIR}/.zshrc
  fi

  # Set git config
  if type git &>/dev/null; then
    echo "Git configuration (global)"
    read "GIT_USERNAME?Enter your name: " 
    echo "Your global Git username will be \"${GIT_USERNAME}\"."
    git config --global user.name ${GIT_USERNAME}
    read "GIT_EMAIL?Enter your email address: " 
    echo "Your global Git email address will be \"${GIT_EMAIL}\"."
    git config --global user.email ${GIT_EMAIL}
  else
    "Git is currently not installed. Remember to setup your name after installation."
  fi

  # install finished
  echo "Done."
else
  # install canceled
  echo "Canceled."
fi
