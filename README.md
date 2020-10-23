# Ansible Role for Docker CE (Community Edition)

[![Ansible Role](https://img.shields.io/ansible/role/38776)](https://galaxy.ansible.com/haxorof/docker_ce/)
[![GitHub tag](https://img.shields.io/github/tag/haxorof/ansible-role-docker-ce)](https://github.com/haxorof/ansible-role-docker-ce)
[![Ansible Quality](https://img.shields.io/ansible/quality/38776)](https://galaxy.ansible.com/haxorof/docker_ce/)
[![Downloads](https://img.shields.io/ansible/role/d/38776)](https://galaxy.ansible.com/haxorof/docker_ce/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow)](https://github.com/haxorof/ansible-role-docker-ce/blob/master/LICENSE)
[![Build Status](https://github.com/haxorof/ansible-role-docker-ce/workflows/CI/badge.svg?branch=master)](https://github.com/haxorof/ansible-role-docker-ce/actions?query=workflow%3ACI)

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
- Raspbian (based on Debian)
- RHEL<sup>†</sup>
- Ubuntu

<sup>†</sup> NB: Docker does _not_ officially support Docker CE on this distribution and some features might/will not work.

## Changelog

See changelog [here](https://github.com/haxorof/ansible-role-docker-ce/blob/master/CHANGELOG.md)

## Ansible Compatibility

- `2.9` or later

For this role to support multiple Ansible versions it is not possible to avoid all Ansible deprecation warnings. Read Ansible documentation if you want to disable [deprecation warnings](http://docs.ansible.com/ansible/latest/reference_appendices/config.html#deprecation-warnings).

This role tries to support the latest and previous major release of Ansible version. For supported Ansible versions see [here](https://docs.ansible.com/ansible/latest/reference_appendices/release_and_maintenance.html)

## Requirements

No additional requirements.

## Role Variables

Variables related to this role are listed [here](https://github.com/haxorof/ansible-role-docker-ce/blob/master/defaults/main.yml)

## Dependencies

None.

## Example Playbook

Following sub sections show different kind of examples to illustrate what this role supports.

### Simplest

```yaml
- hosts: docker
  roles:
    - role: haxorof.docker_ce
```

### Configure Docker daemon to use proxy

```yaml
- hosts: docker
  vars:
    docker_daemon_envs:
      HTTP_PROXY: http://localhost:3128/
      NO_PROXY: localhost,127.0.0.1,docker-registry.somecorporation.com
  roles:
    - haxorof.docker_ce
```

### Ensure Ansible can use Docker modules after install

```yaml
- hosts: test-host
  vars:
    docker_sdk: true
    docker_compose: true
  roles:
    - haxorof.docker_ce
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
      live-restore: true
      userland-proxy: false
      no-new-privileges: true
  roles:
    - haxorof.docker_ce
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

## Automated test matrix

Here is the latest test results of the automated test which is located in the tests directory:

Note! All distributions listed in test matrix below does not provided the latest released Docker CE version.

**Last run:** 2020-10-23 (Latest possible Docker CE release 19.03.13, Run with Ansible 2.9.14)

### Test Suites

| Suite | ID                     | Comment                                                                              |
|-------|------------------------|--------------------------------------------------------------------------------------|
| s-1   | t_config               |                                                                                      |
| s-2   | t_channel              | Fail sometime since it might not be any nightly Docker CE build available            |
| s-3   | t_postinstall          |                                                                                      |
| s-4   | t_devicemapper_config  |                                                                                      |
| s-5   | t_auditd               |                                                                                      |
| s-6   | t_docker_compatibility |

### Test Matrix

| Symbol | Definition |
| --- | --- |
| :heavy_check_mark: |  All tests passed |
| :x: | At least one test failed |
| :heavy_minus_sign: | No test done / Not yet tested |

| #                  | s-1                | s-2                | s-3                | s-5                | s-6                | s-7                |
|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|
| centos/7           | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_minus_sign: |
| centos/8           | :heavy_check_mark: | :x:                | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_minus_sign: |
| generic/ubuntu1604 | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| generic/ubuntu1804 | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_minus_sign: |
| generic/ubuntu2004 | :heavy_check_mark: | :x:                | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_minus_sign: |
| generic/debian8    | :heavy_check_mark: | :x:                | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_minus_sign: |
| generic/debian9    | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_minus_sign: |
| generic/debian10   | :heavy_check_mark: | :heavy_check_mark: | :x:                | :heavy_check_mark: | :heavy_check_mark: | :heavy_minus_sign: |
| generic/fedora30   | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_minus_sign: |
| generic/fedora31   | :heavy_check_mark: | :x:                | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_minus_sign: |
| rhel/7             | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_minus_sign: |
| rhel/8             | :heavy_check_mark: | :x:                | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_minus_sign: |

## License

This is an open source project under the [MIT](https://github.com/haxorof/ansible-role-docker-ce/blob/master/LICENSE) license.
