#!/usr/bin/env bash
# Original: https://gist.github.com/sc250024/05a5aa1a1ee2db02080f8714226986e9
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source $SCRIPT_DIR/utils.sh.inc

DetectWSL

OLDIFS=$IFS
export IFS=$'\n'

# Find all boxes which have updates
AVAILABLE_UPDATES=$(Vagrant box outdated --global | grep outdated | tr -d "*'" | cut -d ' ' -f 2 2>/dev/null)

if [[ ${#AVAILABLE_UPDATES[@]} -ne 0 ]]; then
  for box in ${AVAILABLE_UPDATES}; do
      Info "Found an update for ${box}"
      # Find all current versions
      boxinfo=$(Vagrant box list | grep ${box})
      for boxtype in ${boxinfo}; do
          provider=$(echo ${boxtype} | awk -F\( '{print $2}' | awk -F\, '{print $1}')
          version=$(echo ${boxtype} | cut -d ',' -f 2 | tr -d ' )')
          # Add latest version
          Vagrant box add --clean ${box} --provider ${provider}
          BOX_UPDATED="TRUE"
      done
  done

  Info "All boxes are now up to date! Pruning..."
  # Remove all old versions
  Vagrant box prune -f
else
  Info "All boxes are already up to date!"
fi

Vagrant box outdated --global

export IFS=$OLDIFS