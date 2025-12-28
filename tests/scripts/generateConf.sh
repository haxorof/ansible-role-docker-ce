#!/usr/bin/env bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

VAGRANT_TESTCASE_FILE=$SCRIPT_DIR/../vagrant_testcase.yml
VAGRANT_CNTCONF_FILE=$SCRIPT_DIR/../vagrant_ctlconf.yml

GenerateTestCaseConfig() {
  local _box_index=$1
  local _test_index=$2
  local _box_url=
  if [[ "${boxes__box_url[$_box_index]}" != "vagrantup" ]]; then
    _box_url=${boxes__box_url[$_box_index]}
  fi
  echo "==> Generating config: box=[${boxes__box[$_box_index]}], test_yml=[${tests__test_yml[$_test_index]}]"
  cat << EOF > $VAGRANT_TESTCASE_FILE
box: ${boxes__box[$_box_index]}
box_url: ${_box_url}
controller_box: ${controller_box}
storage_ctl: ${boxes__storage_ctl[$_box_index]}
storage_port: ${boxes__storage_port[$_box_index]}
vbguest_update: ${boxes__vbguest_update[$_box_index]}
id: ${tests__id[$_test_index]}
prep_yml: ${tests__prep_yml[$_test_index]}
test_yml: ${tests__test_yml[$_test_index]}
local_boxes: $VAGRANT_LOCAL_BOXES
reboot: ${boxes__reboot[$_box_index]}
EOF

  cat << EOF > $VAGRANT_CNTCONF_FILE
ansible_version: ${ansible_version}
galaxy_role_name: ${galaxy_role_name}
controller_box: ${controller_box}
controller_py3_install: ${controller_py3_install}
EOF

}

GenerateDoNothingConfig() {
  local _box_index=$1
  local _box_url=
  if [[ "${boxes__box_url[$_box_index]}" != "vagrantup" ]]; then
    _box_url=${boxes__box_url[$_box_index]}
  fi
  echo "==> Generating 'Do Nothing' config: box=[${boxes__box[$_box_index]}], box_url=[${_box_url}]"
  cat << EOF > $VAGRANT_TESTCASE_FILE
box: ${boxes__box[$_box_index]}
box_url: ${_box_url}
storage_ctl: ${boxes__storage_ctl[$_box_index]}
storage_port: ${boxes__storage_port[$_box_index]}
vbguest_update: ${boxes__vbguest_update[$_box_index]}
id: do_nothing
prep_yml: prepare.yml
test_yml: test_nothing.yml
EOF

  cat << EOF > $VAGRANT_CNTCONF_FILE
ansible_version: ${ansible_version}
galaxy_role_name: ${galaxy_role_name}
controller_box: ${controller_box}
controller_py3_install: ${controller_py3_install}
EOF
}

if [[ "$1" == "--help" ]]; then
  echo "Usage: $0 [option] <box-index> (<test-index>)"
  echo ""
  echo "Options:"
  echo "--nop   Generate 'Do Nothing' config for specified box."
  echo ""
  exit 0
fi

. $SCRIPT_DIR/fetchYamlParser.sh

arg_1=${1:-0}
arg_2=${2:-0}
arg_3=${3:-regression/test_cases.yml}

create_variables vagrant_testconfig.yml
create_variables $arg_3

if [[ "$arg_1" == "--nop" ]]; then
  GenerateDoNothingConfig $arg_2
else
  GenerateTestCaseConfig $arg_1 $arg_2
fi
