#!/usr/bin/env bash
YAML_INC_FILE=yamlparser.sh.inc
if [[ ! -f "$YAML_INC_FILE" ]]; then
  echo "Fetching YAML parsing script..."
  wget -O $YAML_INC_FILE -q https://raw.githubusercontent.com/jasperes/bash-yaml/master/yaml.sh
fi
. $YAML_INC_FILE

UBUNTU_ON_WIN=$(uname -a | grep Microsoft)
if [[ $? -eq 0 ]]; then
  echo "Ubuntu on Windows - assuming Vagrant is installed in Windows."
  VAGRANT_CMD=vagrant.exe
  # To share CONFIG_KEY to Windows environment
  export CONFIG_KEY=
  export WSLENV=CONFIG_KEY/w
else
  VAGRANT_CMD=vagrant
fi

BLDRED='\033[1;31m'
BLDGRN='\033[1;32m'
BLDBLU='\033[1;34m'
BLDYLW='\033[1;33m' # Yellow
BLDMGT='\033[1;35m' # Magenta
BLDCYN='\033[1;36m' # Cyan
TXTRST='\033[0m'

Done () {
  printf "%b\n" "${BLDGRN}[DONE]${TXTRST} $1"
}

Pass () {
  printf "%b\n" "${BLDGRN}[PASS]${TXTRST} $1"
}

Fail () {
  printf "%b\n" "${BLDRED}[FAIL]${TXTRST} $1"
}

Skip() {
  printf "%b\n" "${BLDCYN}[SKIP]${TXTRST} $1"
}

RedText() {
  printf "%b\n" "${BLDRED}$1${TXTRST}"
}

VagrantExists() {
  if ! vagrant_loc="$(type -p $VAGRANT_CMD)" || [[ -z $vagrant_loc ]]; then
    echo "1"
  fi
  echo "0"
}

VagrantUp() {
  if [[ "$(VagrantExists)" == "0" ]]; then
    $VAGRANT_CMD up
    return $?
  else
    RedText "[VagrantUp] vagrant not found!"
  fi
}

VagrantDestroy() {
  if [[ "$(VagrantExists)" == "0" ]]; then
    $VAGRANT_CMD destroy -f
    return $?
  else
    RedText "[VagrantDestroy] vagrant not found!"
  fi
}

VagrantBoxAdd() {
  if [[ "$(VagrantExists)" == "0" ]]; then
    cmdOutput=$($VAGRANT_CMD box add $1 2>&1)
    exitCode=$?
    if [[ "$cmdOutput" == *force* ]]; then
      return 0
    else
      if [[ "$exitCode" != "0" ]]; then
        RedText "$cmdOutput"
      fi
      return $exitCode
    fi
  else
    RedText "[VagrantBoxAdd] vagrant not found!"
  fi
  return 0
}

DownloadBoxes() {
  echo "Downloading boxes..."
  boxes=$(parse_yaml vagrant_config.yml | grep _box | cut -d= -f2 | sed 's/[\(\"\)]//g' | sed "s/'//g" | sort | uniq)
  exitCode=0
  for box in $boxes; do
    if [[ "$box" != *"$LIMIT"* ]]; then
      Skip "Download $box"
      continue
    fi
    VagrantBoxAdd $box
    if [[ "$?" == "0" ]]; then
      Done "Download $box"
    else
      Fail "Download $box"
      exitCode=1
    fi
  done
  return $exitCode
}

ExecuteTests() {
  echo "Starting tests..."
  configs=$(parse_yaml vagrant_config.yml | grep _box | awk '{split($0,a,"_box"); $1=a[1]; split($1,b,"configs_"); $2=b[2];  print $2}')
  exitCode=0
  for config in $configs; do
    CONFIG_KEY=$config
    export CONFIG_KEY
    if [[ "$CONFIG_KEY" != *"$LIMIT"* ]]; then
      Skip "$CONFIG_KEY"
      continue
    fi
    VagrantUp
    exitCode=$?
    VagrantDestroy
    if [[ $exitCode == "0" ]]; then
      Pass "Test $CONFIG_KEY"
    else
      Fail "Test $CONFIG_KEY"
      break
    fi
  done
  echo "Ended with exit code $exitCode"
  return $exitCode
}

LIMIT=$1

if [[ "$SKIP_DOWNLOAD" == "" ]]; then
  DownloadBoxes
  downloadResult=$?
  echo "Download complete!"
  if [[ "$DOWNLOAD_ONLY" != "" ]]; then
    exit $downloadResult
  fi
fi

ExecuteTests
exit $?