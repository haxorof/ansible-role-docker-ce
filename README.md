# ansible-role-docker-ce

[![Ansible Role](https://img.shields.io/ansible/role/17533.svg)](https://galaxy.ansible.com/haxorof/docker-ce/)
[![GitHub tag](https://img.shields.io/github/tag/haxorof/ansible-role-docker-ce.svg)](https://github.com/haxorof/ansible-role-docker-ce)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/haxorof/ansible-role-docker-ce/blob/master/LICENSE)
[![Build Status](https://travis-ci.com/haxorof/ansible-role-docker-ce.svg?branch=master)](https://travis-ci.com/haxorof/ansible-role-docker-ce)

This Ansible role installs and configures Docker CE (Community Edition) on several different Linux distributions. The goal is to let the
user of this role to just care about how Docker shall be installed and configured and hide the differences that exists in the
different distributions.

## Features

- One way to install and configure Docker CE across supported Linux distributions.
- Support install of Docker SDK and Docker Compose.
- Best effort support of installations of Docker plugins.
- Best effort uninstall of Docker CE and related configuration
- Do tweaks etc to avoid buggy or non-working configurations in some supported distributions.
- Ease handling of setting up Docker according to Center of Internet Security (CIS) documentation.

## Supported Distributions

- CentOS
- Debian
- Fedora
- Linux Mint<sup>†</sup> (based on Ubuntu).
- RHEL<sup>†</sup>
- Ubuntu

<sup>†</sup> NB: Docker does _not_ officially support Docker CE on this distribution.

## Changelog

See changelog [here](https://github.com/haxorof/ansible-role-docker-ce/blob/master/CHANGELOG.md)

## Ansible Compatibility

- `2.5` or later

For this role to support multiple Ansible versions it is not possible to avoid all Ansible deprecation warnings. Read Ansible documentation if you want to disable [deprecation warnings](http://docs.ansible.com/ansible/latest/reference_appendices/config.html#deprecation-warnings).

This role tries to support the lowest supported Ansible version to the most recent listed [here](https://docs.ansible.com/ansible/latest/reference_appendices/release_and_maintenance.html)

If you are using Ansible version `2.3` you cannot go higher than version `1.5.0` of this role.

## Requirements

No additional requirements.

## Role Variables

Variables related to this role are listed below:

```yaml
---
################################################################################
# Docker install configuration
################################################################################
# Docker repo channel: stable, nigthly, test (more info: https://docs.docker.com/install/)
docker_channel: stable
# Always ensure latest version of Docker CE
docker_latest_version: true
# Docker package to install. Change this if you want a specific version of Docker
# DEPRECATED! use docker_version instead
docker_pkg_name: docker-ce
# Docker version
# ex. 18.06.1.ce-3.el7
docker_version: ''
# If below variable is set to true it will remove older Docker installation before Docker CE.
# DEPRECATED! nothing replaces this feature
docker_remove_pre_ce: false
# Users to be part of the docker group
docker_users: []
# Docker plugins.
# Item fields:
# * type - Valid types: volumedriver,networkdriver,ipamdriver,authz,logdriver,metricscollector
# * alias - Alias of plugin
# * name - Name of plugin
# * args - Plugin arguments
#
# Example:
# docker_plugins:
#   - type: authz
#     alias: opa-docker-authz
#     name: openpolicyagent/opa-docker-authz-v2:0.4
#     args: opa_args="-policy-file /opa/policies/authz.rego"
docker_plugins: []

################################################################################
# Docker daemon configuration
################################################################################
# Daemon configuration (https://docs.docker.com/engine/reference/commandline/dockerd/)
# Example:
# docker_daemon_config:
#   experimental: true
docker_daemon_config: {}
# Map of environment variables to Docker daemon
docker_daemon_envs: {}
# Docker daemon options
#  Docker daemon is configured with '-H fd://' by default in Ubuntu/Debian which cause problems.
#  https://github.com/moby/moby/issues/25471
docker_daemon_opts: ''
# List of additional service configuration options for systemd
# Important! Configuring this can cause Docker to not start at all.
docker_systemd_service_config: []

################################################################################
# Audit configuration
################################################################################
# Enable auditing of Docker related files and directories
docker_enable_audit: false

################################################################################
# Configuration to handle bugs/deviations
################################################################################
# To compensate for situation where Docker daemon fails because of usermod incompatibility.
# Ensures that 'dockremap:500000:65536' is present in /etc/subuid and /etc/subgid.
# Note! If userns-remap is set to 'default' in docker_daemon_config this config will be unnecessary.
docker_bug_usermod: false
# Set `MountFlags=slave`
#  https://github.com/haxorof/ansible-role-docker-ce/issues/34
docker_enable_mount_flag_fix: no
# Do compatibility and distribution checks (can be disable for debugging etc if required)
docker_do_checks: yes

################################################################################
# Postinstall related configuration
################################################################################
# Ensures dependencies are installed so that most of the 'docker' Ansible modules will work.
docker_sdk: false
# Ensures dependencies are installed so that 'docker_service' Ansible module will work.
docker_compose: false
# Ensures that docker-compose is installed without pip, meaning 'docker_service' will NOT work.
# Important! This only has any affect when 'docker_compose' is set to true.
docker_compose_no_pip: false
# Ensures dependencies are installed so that 'docker_stack' Ansible module will work.
docker_stack: false
# Additional PiP packages to install after Docker is configured and started.
docker_additional_packages_pip: []
# Additional OS packages to install after Docker is configured and started.
docker_additional_packages_os: []
# Ensure PiP is upgraded before further use.
# IMPORTANT! Be carful to set this because it might cause dependecy problems.
docker_pip_upgrade: false
# Default python pip package to install if missing
docker_pip_package: python-pip
# PiP extra args
docker_pip_extra_args:
# PiP install packages using sudo
docker_pip_sudo: true

################################################################################
# Docker removal configuration
################################################################################
# CAUTION! If below variable is set to true it will remove Docker CE
# installation and all related configuation.
docker_remove: false
# CAUTION! If below variable and docker_remove is set to true it will also remove
# everything under for example /var/lib/docker
docker_remove_all: false
# Additional files or directories to be remove if for example non-standard locations
# was previously configured for data storage etc.
docker_remove_additional: []
```

## Dependencies

None.

## Example Playbook

Following sub sections show different kind of examples to illustrate what this role supports.

### Simplest

```yaml
- hosts: docker
  roles:
    - role: haxorof.docker-ce
```

### Configure Docker daemon to use proxy

```yaml
- hosts: docker
  vars:
    docker_daemon_envs:
      HTTP_PROXY: http://localhost:3128/
      NO_PROXY: localhost,127.0.0.1,docker-registry.somecorporation.com
  roles:
    - haxorof.docker-ce
```

### Ensure Ansible can use Docker modules after install

```yaml
- hosts: test-host
  vars:
    docker_sdk: true
    docker_compose: true
  roles:
    - haxorof.docker-ce
  post_tasks:
    - name: Test hello container
      become: yes
      docker_container:
        name: hello
        image: hello-world

    - name: Test hello service
      become: yes
      docker_service:
        project_name: hello
        definition:
          version: '3'
          services:
            hello:
              image: "hello-world"
```

### On the road to CIS security compliant Docker engine installation

This minimal example below show what kind of role configuration that is required to pass the [Docker bench](https://github.com/docker/docker-bench-security) checks.
However this configuration setup devicemapper in a certain way which will create logical volumes for the containers. Simplest is to have at least 3 GB of free space available in the partition. Since Docker v17.06 it is possible to just set the storage option `dm.directlvm_device` to make Docker create the necessary volumes:

```yaml
- hosts: docker
  vars:
    docker_plugins:
      - type: authz
        alias: opa-docker-authz
        name: openpolicyagent/opa-docker-authz-v2:0.4
        args: opa_args="-policy-file /opa/policies/authz.rego"
    docker_enable_audit: yes
    docker_daemon_config:
      icc: false
      log-driver: journald
      userns-remap: default
      disable-legacy-registry: true
      live-restore: true
      userland-proxy: false
      no-new-privileges: true
  roles:
    - haxorof.docker-ce
```

Because the configuration above requires Linux user namespaces to be enabled then additional GRUB arguments might be needed. Example below show one example what changes that might be needed and reboot of the host is required for the changes to take full affect.

```yaml
# https://success.docker.com/article/user-namespace-runtime-error

- hosts: docker
  roles:
    - role: jtyr.grub_cmdline
      vars:
        grub_cmdline_add_args:
          - namespace.unpriv_enable=1
          - user_namespace.enable=1
      become: yes
  tasks:
    - name: set user.max_user_namespaces
      sysctl:
        name: user.max_user_namespaces
        value: 15000
        sysctl_set: yes
        state: present
        reload: yes
      become: yes
```

For a more complete working example on CentOS 7 have a look [here](https://github.com/haxorof/ansible-role-docker-ce/blob/master/tests/experimental/cis).

## License

This is an open source project under the [MIT](https://github.com/haxorof/ansible-role-docker-ce/blob/master/LICENSE) license.
