# ansible-role-docker-ce

[![Ansible Role](https://img.shields.io/ansible/role/17533.svg)](https://galaxy.ansible.com/haxorof/docker-ce/)
[![GitHub tag](https://img.shields.io/github/tag/haxorof/ansible-role-docker-ce.svg)](https://github.com/haxorof/ansible-role-docker-ce)
[![Build Status](https://travis-ci.org/haxorof/ansible-role-docker-ce.svg?branch=master)](https://travis-ci.org/haxorof/ansible-role-docker-ce)

Installs Docker CE (Community Edition) on CentOS/Fedora.

## Requirements

No additional requirements.


## Role Variables

Variables related to this role are listed below:

```yaml
# Daemon configuration (https://docs.docker.com/engine/reference/commandline/dockerd/)
# Example:
# docker_daemon_config:
#   experimental: true
docker_daemon_config:
# Enable auditing of Docker related files and directories
docker_enable_audit: false
# Enable Docker CE Edge
docker_enable_ce_edge: false
# Setup Docker to devicemapper as storage driver. Require space to be available on LVM partition for new logical partition.
# Uses https://github.com/projectatomic/container-storage-setup
docker_setup_devicemapper: false
# If below variable is set to true it will remove older Docker installation before Docker CE.
docker_remove_pre_ce: false
```

## Dependencies

None.

## Example Playbook

Following sub sections show different kind of examples to illustrate what this role supports.

### Simplest

    - hosts: localhost
      roles:
         - role: haxorof.docker-ce

### On the road to CIS security compliant Docker engine installation

This minimal example below show what kind of role configuration that is required to pass the [Docker bench](https://github.com/docker/docker-bench-security) checks.
However this configuration setup devicemapper in a certain way which will create logical volumes for the containers. Simplest is to have at least 3 GB of free space available in the partition.

    - hosts: localhost
      roles:
         - role: haxorof.docker-ce
           docker_enable_audit: true
           docker_setup_devicemapper: true
           docker_daemon_config:
             icc: false
             init: true
             userns-remap: default
             disable-legacy-registry: true
             live-restore: true
             userland-proxy: false
             log-driver: journald

## License

This is an open source project under the [MIT](LICENSE) license.

