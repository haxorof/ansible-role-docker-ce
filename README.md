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
# Setup Docker to devicemapper as storage driver. Require space to be available on LVM partition for new logical partition.
# Uses https://github.com/projectatomic/container-storage-setup
docker_setup_devicemapper: false
# If below variable is set to true it will remove older Docker installation before Docker CE.
docker_remove_pre_ce: false
```

## Dependencies

None.

## Example Playbook

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: localhost
      roles:
         - role: haxorof.docker-ce

## License

This is an open source project under the [MIT](LICENSE) license.

