# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased](../../releases/tag/X.Y.Z)

## [1.5.0](../../releases/tag/1.5.0) - 2018-05-02

### Added

- Add tags to either install or just configure Docker ([#37](../../issues/37))

## [1.4.0](../../releases/tag/1.4.0) - 2018-04-14

### Added

- Introduce flag to disable mount flag fix and addition of compatibility check [@jamiejackson] ([#35](../../issues/35))

## [1.3.2](../../releases/tag/1.3.2) - 2018-02-07

### Fixed

- RedHat: breaks when rhel-7-server-rt-beta-rpms isn't listed; check [@jamiejackson] ([#29](../../issues/29))

## [1.3.1](../../releases/tag/1.3.1) - 2018-02-01

### Fixed

- Install failed on CentOS because of newly added RedHat support ([#28](../../issues/28))

## [1.3.0](../../releases/tag/1.3.0) - 2018-01-28

### Added

- Support for RedHat [@jamiejackson] ([#26](../../issues/26))

## [1.2.0](../../releases/tag/1.2.0) - 2017-12-08

### Added

- Add support to specify specific Docker version ([#21](../../issues/21))
- Support for Linux Mint ([#24](../../issues/24))

## [1.1.0](../../releases/tag/1.1.0) - 2017-11-06

### Added

- Add support to ensure Docker is not upgraded ([#17](../../issues/17))
- Support for Ubuntu and Debian ([#20](../../issues/20))

### Changed

- Refactoring of tasks ([#19](../../issues/19))

### Fixed

- /proc/sys/fs/may_detach_mounts does not exists in all kernel 3.10 versions ([#18](../../issues/18))
- auditd does not apply all rules after reboot because of rule errors ([#16](../../issues/16))

## [1.0.1](../../releases/tag/1.0.1) - 2017-10-22

### Fixed

- Kernel parameter fs.may_detach_mounts is necessary even if mount flag is set to slave ([#13](../../issues/13))

## [1.0.0](../../releases/tag/1.0.0) - 2017-10-17

### Removed

- Removed support to setup devicemapper using container-storage-setup ([#10](../../issues/10))

## [0.4.3](../../releases/tag/0.4.3) - 2017-09-26

### Fixed

- MountFlags "slave" helps to prevent "device busy" errors on RHEL/CentOS 7.3 kernels [@jgagnon1] ([#11](../../issues/11)) 

## [0.4.2](../../releases/tag/0.4.2) - 2017-08-13

### Fixed

- Docker fails to setup subgid and subuid in CentOS 7.3.1611 ([#9](../../issues/9))

### Deprecated

- Functionallity related to `docker_setup_devicemapper`. Similar support now available in Docker v17.06.

## [0.4.1](../../releases/tag/0.4.1) - 2017-07-21

### Fixed

- Missing docker.service.d directory ([#6](../../issues/6))

## [0.4.0](../../releases/tag/0.4.0) - 2017-06-30

### Added

- Add configuration option for adding audit rules for Docker compliant with CIS 1.13 ([#5](../../issues/5))

## [0.3.0](../../releases/tag/0.3.0) - 2017-06-28

### Added

- Add configuration support to enable Docker CE Edge versions ([#3](../../issues/3))
- Add simple support to setup devicemapper using container-storage-setup ([#4](../../issues/4))

## [0.2.0](../../releases/tag/0.2.0) - 2017-05-25

### Fixed

- Task "Configure Docker daemon" fails because of missing directory ([#2](../../issues/2))

### Added

- Add support to specify daemon.json file to copy ([#1](../../issues/1))

## [0.1.0](../../releases/tag/0.1.0) - 2017-05-01

### Added

- Support to remove pre Docker CE versions
- Basic configuration support for Docker daemon
