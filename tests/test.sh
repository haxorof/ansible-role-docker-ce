#!/usr/bin/env bash
#
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

TEST_SUMMARY=()

VAGRANT_TEST_VM_NAME=test-host
VAGRANT_TESTCASE_FILE=vagrant_testcase.yml
VAGRANT_TESTS_FILE=vagrant_tests.yml
LOG_FILE=test_$(date +"%Y%m%d%H%M").log

source $SCRIPT_DIR/scripts/utils.sh.inc

VagrantUp() {
  local _input=${1:-""}
  Vagrant up $_input
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
  local _id=${1:-""}
  Vagrant destroy $_id -f
  local _exitCode=$?
  if [[ "$_id" == "" ]]; then
    if [[ -f $VAGRANT_TESTCASE_FILE ]]; then
      rm $VAGRANT_TESTCASE_FILE
    fi
  fi
  return $_exitCode
}

VagrantBoxRemove() {
  local cmdOutput=$(Vagrant box remove $1)
  local exitCode=$?
  if [[ "$cmdOutput" == *force* ]]; then
    return 0
  else
    if [[ "$exitCode" != "0" ]]; then
      RedText "$cmdOutput"
    fi
  fi
  return $exitCode
}

VagrantBoxAdd() {
  local cmdOutput=
  if [[ "$VAGRANT_LOCAL_BOXES" == "" ]]; then
    if [[ "$2" == "vagrantup" ]]; then
      cmdOutput=$(Vagrant box add --provider=virtualbox $1)
    else
      cmdOutput=$(Vagrant box add --provider=virtualbox --name $1 $2)
    fi
  else
    localUrl="${VAGRANT_LOCAL_BOXES}virtualbox-$(sed s/[\/]/-/g <<<$1).box"
    cmdOutput=$(Vagrant box add --provider=virtualbox --name $1 $localUrl)
  fi
  local exitCode=$?
  if [[ "$cmdOutput" == *force* ]]; then
    return 0
  else
    if [[ "$exitCode" == "0" ]]; then
      if [[ "$cmdOutput" == *error* ]]; then
        exitCode=1
      fi
    else
      RedText "$cmdOutput"
    fi
  fi
  return $exitCode
}

BeforeTests() {
  if [[ "$PRE_DOWNLOAD_BOXES" == "1" ]]; then
    DownloadBoxes
    downloadResult=$?
    if [[ "$downloadResult" == "0" ]]; then
      Info "Download complete!"
    else
      Fail "Download failed!"
      exit 1
    fi
  fi
  return 0
}

AfterTests() {
  local _testRunExitCode=$1  
  if [[ "$_testRunExitCode" == "0" ]]; then
    VagrantDestroy
  else
    if [[ "$ON_FAILURE_KEEP" == "1" ]]; then
      Info "VM is kept for debugging"
    else
      VagrantDestroy
    fi
  fi
  return 0
}

StartTest() {
  VagrantUp --provision
  return $?
}

EndTest() {
  local _testRunExitCode=$1
  if [[ "$_testRunExitCode" != "0" ]]; then
    if [[ "$ON_FAILURE_KEEP" == "1" ]]; then
      return $?
    fi
  fi
  VagrantDestroy $VAGRANT_TEST_VM_NAME
  return 0
}

DownloadBoxes() {
  Info "Downloading boxes..."
  local exitCode=0
  for box_index in $(seq 0 `expr ${#boxes__box[@]} - 1`); do
    local box=${boxes__box[$box_index]}
    local box_url=${boxes__box_url[$box_index]}
    if [[ "$box" != *"$LIMIT_BOX"* ]]; then
      Skip "Download $box"
      continue
    fi
    if [[ "$REMOVE_BEFORE_DOWNLOAD" != "" ]]; then
      VagrantBoxRemove $box
    fi
    VagrantBoxAdd $box $box_url
    if [[ "$?" == "0" ]]; then
      Done "Download $box"
    else
      Fail "Download $box"
      exitCode=1
    fi
  done
  return $exitCode
}

AddTestResult() {
  if [[ "$3" == "" ]]; then
    TEST_SUMMARY+=("$1 | $2")
  else
    if [[ "$4" == "" ]]; then
      TEST_SUMMARY+=("$1 | $2 - $3")
    else
      TEST_SUMMARY+=("$1 | $2 - $3 [$4]")
    fi
  fi
}

AddTestResultPassed() {
  AddTestResult "${BLDGRN}passed${TXTRST}" "$1" "$2" "$3"
}

AddTestResultFailed() {
  AddTestResult "${BLDRED}failed${TXTRST}" "$1" "$2" "$3"
}

AddTestResultSkipped() {
  AddTestResult "${BLDCYN}skipped${TXTRST}" "$1" "$2" "$3"
}

PrintTestSummary() {
  Info "Test Summary:"
  for ((i = 0; i < ${#TEST_SUMMARY[@]}; i++)); do
    Info "${TEST_SUMMARY[$i]}"
  done
}

ExecuteTests() {
  BeforeTests
  Info "Starting tests..."
  local exitCode=0
  local do_skip=0
  local finalExitCode=0
  for box_index in $(seq 0 `expr ${#boxes__box[@]} - 1`); do
    local box=${boxes__box[$box_index]}
    if [[ "$box" != *"$LIMIT_BOX"* ]]; then
      Skip "(code:1) Test: Skipping box [$box]"
      AddTestResultSkipped $box
      continue
    fi
    for index in $(seq 0 `expr ${#tests__name[@]} - 1`); do
      local test_name=${tests__name[$index]}
      local test_id=${tests__id[$index]}
      Info "Starting test: $test_name"
      if [[ "$test_id" != *"$LIMIT_TEST"* ]]; then
        Skip "(code:2) Test: $test_name [$box]"
        AddTestResultSkipped $box "$test_name" "$test_id"
        continue
      fi
      if [[ "${tests__skip_boxes[$index]}" != "none" ]]; then
        do_skip=0
        for skip_box in ${tests__skip_boxes[$index]//,/ }
        do
          if [[ "$box" == *"$skip_box"* ]]; then
            if [[ "$FORCE_TEST" == "" ]]; then
              do_skip=1
            fi
            break
          fi
        done
        if [[ "$do_skip" == "1" ]]; then
          Skip "(code:3) Test: $test_name [$box]"
          AddTestResultSkipped $box "$test_name" "$test_id"
          continue
        fi
      fi
      if [[ "${tests__only_boxes[$index]}" != "none" ]]; then
        if [[ "$FORCE_TEST" == "" ]]; then
          do_skip=1
        else
          do_skip=0
        fi
        for only_box in ${tests__only_boxes[$index]//,/ }
        do
          if [[ "$box" == *"$only_box"* ]]; then
            do_skip=0
            break
          fi
        done
        if [[ "$do_skip" == "1" ]]; then
          Skip "(code:4) Test: $test_name [$box]"
          AddTestResultSkipped $box "$test_name" "$test_id"
          continue
        fi
      fi
      bash $SCRIPT_DIR/scripts/generateConf.sh $box_index $index $VAGRANT_TESTS_FILE
      Info "Test: ${tests__name[$index]} [$box]"
      StartTest
      exitCode=$?
      EndTest $exitCode
      if [[ "$exitCode" == "0" ]]; then
        Pass "Test: $test_name [$box]"
        AddTestResultPassed $box "$test_name" "$test_id"
      else
        Fail "Test: $test_name [$box]"
        finalExitCode=$exitCode
        AddTestResultFailed $box "$test_name" "$test_id"
        if [[ "$ON_FAILURE_KEEP" == "1" ]]; then
          break
        fi
      fi
    done
    if [[ "$exitCode" != "0" ]]; then
      if [[ "$ON_FAILURE_KEEP" == "1" ]]; then
        break
      fi
    fi
  done
  AfterTests $finalExitCode
  PrintTestSummary
  Info "Ended with exit code $finalExitCode"
  return $finalExitCode
}

. $SCRIPT_DIR/scripts/fetchYamlParser.sh
DetectWSL

if [[ "$1" != "" ]]; then
  LIMIT_TEST=$1
  if [[ "$2" != "" ]]; then
    LIMIT_BOX=$2
    if [[ "$3" != "" ]]; then
      VAGRANT_TESTS_FILE=$3
    fi
  fi
fi

create_variables vagrant_boxes.yml
create_variables $VAGRANT_TESTS_FILE
if [[ "$DEBUG" != "" ]]; then
  parse_yaml vagrant_boxes.yml
  parse_yaml $VAGRANT_TESTS_FILE
fi

LogVagrantVersion
LogVirtualBoxVersion

ExecuteTests
exit $?