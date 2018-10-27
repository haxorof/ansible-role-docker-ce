#!/usr/bin/env bash
#
VAGRANT_TESTCASE_FILE=vagrant_testcase.yml

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
    Info "Windows Subsystem for Linux detected - assuming Vagrant is installed in Windows."
    VAGRANT_CMD=vagrant.exe
    VIRTUALBOX_CMD=VBoxManage.exe
  else
    VAGRANT_CMD=vagrant
    VIRTUALBOX_CMD=vboxmanage
  fi
}

VirtualBox() {
  if ! virtualbox_loc="$(type -p $VIRTUALBOX_CMD)" || [[ -z $virtualbox_loc ]]; then
    RedText "$VIRTUALBOX_CMD not found!"
    exit 2
  fi
  $VIRTUALBOX_CMD $@ 2>&1
  _exitCode=$?
  return $_exitCode
}

LogVirtualBoxVersion() {
  _output=$(VirtualBox --version)
  _exitCode=$?
  if [[ $_exitCode -eq 0 ]]; then
    Info "VirtualBox $_output"
  else
    Fail "$_output"
    exit $_exitCode
  fi
}

Vagrant() {
  if ! vagrant_loc="$(type -p $VAGRANT_CMD)" || [[ -z $vagrant_loc ]]; then
    RedText "$VAGRANT_CMD not found!"
    exit 2
  fi
  $VAGRANT_CMD $@ 2>&1
  _exitCode=$?
  return $_exitCode
}

LogVagrantVersion() {
  _output=$(Vagrant --version)
  _exitCode=$?
  if [[ $_exitCode -eq 0 ]]; then
    Info "$_output"
  else
    Fail "$_output"
    exit $_exitCode
  fi
}

VagrantUp() {
  Vagrant up
  return $?
}

VagrantHalt() {
  Vagrant halt
  return $?
}

VagrantProvision() {
  Vagrant provision
  return $?
}

VagrantDestroy() {
  Vagrant destroy -f
  _exitCode=$?
  if [[ -f $VAGRANT_TESTCASE_FILE ]]; then
    rm $VAGRANT_TESTCASE_FILE
  fi
  return $_exitCode
}

VagrantBoxAdd() {
  cmdOutput=$(Vagrant box add --provider=virtualbox $1)
  exitCode=$?
  if [[ "$cmdOutput" == *force* ]]; then
    return 0
  else
    if [[ "$exitCode" != "0" ]]; then
      RedText "$cmdOutput"
    fi
  fi
  return $exitCode
}

GenerateDoNothingConfig() {
  _box_index=$1
  _test_index=$2
          cat << EOF > $VAGRANT_TESTCASE_FILE
box: ${boxes__box[$_box_index]}
ide_ctl_name: ${boxes__ide_ctl_name[$_box_index]}
vbguest_update: ${boxes__vbguest_update[$_box_index]}
id: snapshot
prep_yml: test_nothing.yml
test_yml: test_nothing.yml
EOF
}

VagrantSaveSnapshot() {
  GenerateDoNothingConfig $1
  Vagrant up
  Vagrant halt
  Vagrant snapshot save default base
  return $?
}

VagrantRestoreSnapShot() {
  Vagrant snapshot restore base
  return $?
}

VagrantDeleteSnapshot() {
  Vagrant snapshot delete base
  return $?
}

DownloadBoxes() {
  Info "Downloading boxes..."
  exitCode=0
  for box in ${boxes__box[*]}; do
    if [[ "$box" != *"$LIMIT_BOX"* ]]; then
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

GenerateTestCaseConfig() {
  _box_index=$1
  _test_index=$2
          cat << EOF > $VAGRANT_TESTCASE_FILE
box: ${boxes__box[$_box_index]}
ide_ctl_name: ${boxes__ide_ctl_name[$_box_index]}
vbguest_update: ${boxes__vbguest_update[$_box_index]}
id: ${tests__id[$_test_index]}
prep_yml: ${tests__prep_yml[$_test_index]}
test_yml: ${tests__test_yml[$_test_index]}
EOF
}

ExecuteTests() {
  Info "Starting tests..."
  exitCode=0
  for box_index in $(seq 0 `expr ${#boxes__box[@]} - 1`); do
    box=${boxes__box[$box_index]}
    if [[ "$box" != *"$LIMIT_BOX"* ]]; then
      Skip "(code:1) Test: Skipping box [$box]"
      continue
    fi
    VagrantSaveSnapshot $box_index
    for index in $(seq 0 `expr ${#tests__name[@]} - 1`); do
      test_name=${tests__name[$index]}
      if [[ "${tests__id[$index]}" != *"$LIMIT_TEST"* ]]; then
        Skip "(code:2) Test: $test_name [$box]"
        continue
      fi
      if [[ "${tests__skip_boxes[$index]}" != "" ]]; then
        do_skip=0
        for skip_box in ${tests__skip_boxes[$index]//,/ }
        do
          if [[ "$box" == *"$skip_box"* ]]; then
            Skip "(code:3) Test: $test_name [$box]"
            do_skip=1
            break
          fi
        done
        if [[ "$do_skip" == "1" ]]; then
          continue
        fi
      fi
      GenerateTestCaseConfig $box_index $index
      Info "Test: ${tests__name[$index]} [$box]"
      export WSLENV CI VAGRANT_BOX VAGRANT_PREP_YML VAGRANT_TEST_YML
      if [[ "$PROVISION_ONLY" == "1" ]]; then
        VagrantProvision
      else
        VagrantRestoreSnapShot
      fi
      exitCode=$?
      if [[ "$exitCode" == "0" ]]; then
        VagrantHalt
        Pass "Test: $test_name [$box]"
      else
        Fail "Test: $test_name [$box]"
        break
      fi
    done
    VagrantDeleteSnapshot
    if [[ "$exitCode" == "0" ]]; then
      VagrantDestroy
    else
      if [[ "$ON_FAILURE_KEEP" == "1" ]]; then
        Info "VM is kept for debugging"
      else
        VagrantDestroy
      fi
      break
    fi
  done
  Info "Ended with exit code $exitCode"
  return $exitCode
}

SetupYamlParser
DetectWSL

create_variables vagrant_config.yml
if [[ "$DEBUG" != "" ]]; then
  parse_yaml vagrant_config.yml
fi

if [[ "$1" != "" ]]; then
  LIMIT_TEST=$1
  if [[ "$2" != "" ]]; then
    LIMIT_BOX=$2
  fi
fi

LogVagrantVersion
LogVirtualBoxVersion
if [[ "$PRE_DOWNLOAD_BOXES" != "" ]]; then
  DownloadBoxes
  downloadResult=$?
  Info "Download complete!"
fi

ExecuteTests
exit $?