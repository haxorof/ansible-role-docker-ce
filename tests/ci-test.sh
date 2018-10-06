#!/usr/bin/env bash
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

Info() {
  printf "%b\n" "${BLDBLU}[INFO]${TXTRST} $1"
}

SetupYamlParser() {
  YAML_INC_FILE=yamlparser.sh.inc
  if [[ ! -f "$YAML_INC_FILE" ]]; then
    Info "Fetching YAML parsing script..."
    wget -O $YAML_INC_FILE -q https://raw.githubusercontent.com/jasperes/bash-yaml/master/yaml.sh
  fi
  . $YAML_INC_FILE
}

DetectWSL() {
  UBUNTU_ON_WIN=$(uname -a | grep Microsoft)
  if [[ $? -eq 0 ]]; then
    Info "Ubuntu on Windows - assuming Vagrant is installed in Windows."
    VAGRANT_CMD=vagrant.exe
  else
    VAGRANT_CMD=vagrant
  fi
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
  Info "Downloading boxes..."
  exitCode=0
  for box in ${boxes[*]}; do
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
  Info "Starting tests..."
  exitCode=0
  for index in $(seq 0 `expr ${#tests__name[@]} - 1`); do
    for box in ${boxes[*]}; do
      test_name=${tests__name[$index]}
      WSLENV=CI:VAGRANT_BOX:VAGRANT_PREP_YML:VAGRANT_TEST_YML
      CI=1
      VAGRANT_BOX=$box
      VAGRANT_PREP_YML=${tests__prep_yml[$index]}
      VAGRANT_TEST_YML=${tests__test_yml[$index]}
      if [[ "$box" != *"$LIMIT_BOX"* ]]; then
        Skip "Test: $test_name [$box]"
        continue
      fi
      if [[ "${tests__id[$index]}" != *"$LIMIT_TEST"* ]]; then
        Skip "Test: $test_name [$box]"
        continue
      fi
      Info "Test: ${tests__name[$index]} [$box]"
      export WSLENV CI VAGRANT_BOX VAGRANT_PREP_YML VAGRANT_TEST_YML
      VagrantUp
      exitCode=$?
      VagrantDestroy
      if [[ "$exitCode" == "0" ]]; then
        Pass "Test: $test_name [$box]"
      else
        Fail "Test: $test_name [$box]"
        break
      fi
    done
    if [[ "$exitCode" != "0" ]]; then
      break
    fi
  done
  Info "Ended with exit code $exitCode"
  return $exitCode
}

SetupYamlParser
DetectWSL

create_variables vagrant_config.yml

if [[ "$1" != "" ]]; then
  LIMIT_TEST=$1
  if [[ "$2" != "" ]]; then
    LIMIT_BOX=$2
  fi
fi

if [[ "$SKIP_DOWNLOAD" == "" ]]; then
  DownloadBoxes
  downloadResult=$?
  Info "Download complete!"
  if [[ "$DOWNLOAD_ONLY" != "" ]]; then
    exit $downloadResult
  fi
fi

ExecuteTests
exit $?