#!/usr/bin/env bash
SetupYamlParser() {
  local _SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
  YAML_INC_FILE=$_SCRIPT_DIR/yamlparser.sh.inc
  if [[ ! -f "$YAML_INC_FILE" ]]; then
    wget -O $YAML_INC_FILE -q https://raw.githubusercontent.com/jasperes/bash-yaml/master/script/yaml.sh
  fi
  . $YAML_INC_FILE
}

SetupYamlParser