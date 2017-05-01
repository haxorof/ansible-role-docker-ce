# ansible-role-docker-ce

Installs Docker CE (Community Edition) on CentOS/Fedora.

## Requirements

No additional requirements.


## Role Variables

Variables related to this role are listed below:

```yaml
# Define below variable to configure Docker daemon: https://docs.docker.com/engine/reference/commandline/dockerd/#daemon-configuration-file 
# Example:
# docker_daemon_config:
#   experimental: true

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

