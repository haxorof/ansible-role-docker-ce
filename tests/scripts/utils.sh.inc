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
  if [[ "$LOG_FILE" != "" ]]; then
    printf "%b\n" "[DONE] $1" >> $LOG_FILE
  fi
}

Pass () {
  printf "%b\n" "${BLDGRN}[PASS]${TXTRST} $1"
  if [[ "$LOG_FILE" != "" ]]; then
    printf "%b\n" "[PASS] $1" >> $LOG_FILE
  fi
}

Fail () {
  printf "%b\n" "${BLDRED}[FAIL]${TXTRST} $1"
  if [[ "$LOG_FILE" != "" ]]; then
    printf "%b\n" "[FAIL] $1" >> $LOG_FILE
  fi
}

Skip() {
  printf "%b\n" "${BLDCYN}[SKIP]${TXTRST} $1"
  if [[ "$LOG_FILE" != "" ]]; then
    printf "%b\n" "[SKIP] $1" >> $LOG_FILE
  fi
}

RedText() {
  printf "%b\n" "${BLDRED}$1${TXTRST}"
  if [[ "$LOG_FILE" != "" ]]; then
    printf "%b\n" "$1" >> $LOG_FILE
  fi
}

Info() {
  printf "%b\n" "${BLDBLU}[INFO]${TXTRST} $1"
  if [[ "$LOG_FILE" != "" ]]; then
    printf "%b\n" "[INFO] $1" >> $LOG_FILE
  fi
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
  local _exitCode=$?
  return $_exitCode
}

LogVirtualBoxVersion() {
  local _output=$(VirtualBox --version)
  local _exitCode=$?
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
  $VAGRANT_CMD $@ 2>&1 | tee -a $LOG_FILE
  local _exitCode=${PIPESTATUS[0]}
  return $_exitCode
}

LogVagrantVersion() {
  local _output=$(Vagrant --version)
  local _exitCode=$?
  if [[ $_exitCode -eq 0 ]]; then
    Info "$_output"
  else
    Fail "$_output"
    exit $_exitCode
  fi
}
