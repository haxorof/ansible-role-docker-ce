#!/usr/bin/env bash
VAGRANT_TESTCASE_FILE=vagrant_testcase.yml

SetupYamlParser() {
  YAML_INC_FILE=yamlparser.sh.inc
  if [[ ! -f "$YAML_INC_FILE" ]]; then
    wget -O $YAML_INC_FILE -q https://raw.githubusercontent.com/jasperes/bash-yaml/master/yaml.sh
  fi
  . $YAML_INC_FILE
}

GenerateTestCaseConfig() {
  local _box_index=$1
  local _test_index=$2
          cat << EOF > $VAGRANT_TESTCASE_FILE
box: ${boxes__box[$_box_index]}
storage_ctl: ${boxes__storage_ctl[$_box_index]}
storage_port: ${boxes__storage_port[$_box_index]}
vbguest_update: ${boxes__vbguest_update[$_box_index]}
id: ${tests__id[$_test_index]}
prep_yml: ${tests__prep_yml[$_test_index]}
test_yml: ${tests__test_yml[$_test_index]}
EOF
}

SetupYamlParser
create_variables vagrant_config.yml

GenerateTestCaseConfig $1 $2