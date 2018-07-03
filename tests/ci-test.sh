#!/usr/bin/env bash

if [[ ! -f yaml.sh ]]; then
  echo "Fetching YAML parsing script..."
  wget -q https://raw.githubusercontent.com/jasperes/bash-yaml/master/yaml.sh
fi
. yaml.sh

BLDRED='\033[1;31m'
BLDGRN='\033[1;32m'
TXTRST='\033[0m'

pass () {
  printf "%b\n" "${BLDGRN}[PASS]${TXTRST} $1"
}

warn () {
  printf "%b\n" "${BLDRED}[FAIL]${TXTRST} $1"
}

echo "Starting tests..."
configs=$(parse_yaml vagrant_config.yml | grep _box | awk '{split($0,a,"_box"); $1=a[1]; split($1,b,"configs_"); $2=b[2];  print $2}')
exitCode=0
for config in $configs; do
  CONFIG_KEY=$config
  vagrant up
  exitCode=$?
  vagrant destroy -f
  if [[ $exitCode == "0" ]]; then
    pass "$CONFIG_KEY"
  else
    fail "$CONFIG_KEY"
    break
  fi
done
echo "Ended with exit code $exitCode"
exit $exitCode
