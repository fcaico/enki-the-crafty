#!/usr/bin/env zsh

# -----------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 42):
# <bonecrusher@covenofchaos.com>  wrote this file.  As long as  you retain this
# notice you can do whatever you want with this stuff.  If we meet some day and
# you think this stuff is worth it, you can buy me a beer in return.
#  > BoneCrusher <
# -----------------------------------------------------------------------------
# [[ -z $1 ]] && { echo "You must specify a config file"; exit -1; }
# source $1

mydir=${(%):-%N}
mydir=`dirname $mydir`
mydir=${0:a:h}
echo $mydir

function setup_ohmyzsh {
  destination="${1}"
  if [[ ! -d "${destination}/.oh-my-zsh" ]]; then
	echo "Cloning oh-my-zsh from robbyrussel"
  	(cd "${destination}" && git clone https://github.com/robbyrussell/oh-my-zsh.git .oh-my-zsh)
  else
	echo "oh-my-zsh already exists.  Updating."
  	(cd "${destination}/.oh-my-zsh" && git pull origin master)
  fi
}

function setup_dotfiles ()
{
  dotfile_location="${1}"
  dotfiles=(`ls $dotfile_location`)
  destination="${2}"

  for dotfile in "${dotfiles[@]}"
  do
    fullpath_dest="${destination}"/."${dotfile}"
    fullpath_src="${dotfile_location}/${dotfile}"

    [[ -L "${fullpath_dest}" ]] && rm "${fullpath_dest}";
    if [[ -f "${fullpath_src}" ]]; then
      [[ -f "${fullpath_dest}" ]] && rm "${fullpath_dest}"
    fi

    ln -s "${fullpath_src}" "${fullpath_dest}"
	echo ".${dotfile} linked."

  done
}

echo "\nSetting up oh-my-zsh\n"
setup_ohmyzsh ${mydir}

echo "\nSetting up dotfiles\n"
setup_dotfiles ${mydir}/dotfiles ${mydir}/..
