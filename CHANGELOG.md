# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.1.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased](../../releases/tag/X.Y.Z)

## Fixed

- Failed to remove packages in Fedora when `docker_remove` and `docker_remove_all` are set to `true` due to package dependency.
- software-properties-common not available on debian 13 ([#183](../../issues/183))

## [6.2.0](../../releases/tag/6.2.0) - 2025-09-23

## Added

- Added support for Ubuntu 25 [@HRGCompany] ([#182](../../issues/182))

## [6.1.1](../../releases/tag/6.1.1) - 2025-09-01

## Fixed

- Docker removed nightly channel from repo-files ([#181](../../issues/181))

## [6.1.0](../../releases/tag/6.1.0) - 2024-12-08

## Added

- Support for DNF 5 in Fedora 41 and later [@wzzrd]
- Added `docker_install_setup_repos_dependencies` for user to disable/enable any handing of dependencies related to repo setup.

## Changed

- Improved handling between different package managers related to RedHat varity (e.g. yum, dnf, dnf5)

## Deprecated

- Support for Python 2
- Support for RHEL 7 and CentOS 7
- Support for ansible-core 2.16
- Linux Mint 18 and 19 in experimental variable `docker_x_mint_ubuntu_mapping`

## Internal

- Commented out and removed config related to testing with additional disk.

## [6.0.1](../../releases/tag/6.0.1) - 2024-09-07

## Fixed

- Change repository URL for RHEL to use "rhel" instead of "centos"

## [6.0.0](../../releases/tag/6.0.0) - 2024-08-21

## Added

- Added support for Amazon Linux [@palyla]
- Added support to bypass package manager GPG key verification [@palyla]
- Added Linux Mint 22 mapping

## Removed

- Removed support for devicemapper since it was removed from Docker Engine v25.
- Removed support to install Docker Compose via Pip.
- Remove tasks which uninstalls Docker versions before Docker CE
- Removed handling of old Ubuntu and Debian systems systems without SNI
- Removed tasks to handle older Docker CE versions 17 and 18
- Removed task related to compatibility for no longer officially supported distributions since Docker CE 18.09

## [5.1.0](../../releases/tag/5.1.0) - 2024-01-27

## Added

- Added support for ARM64 ([#170](../../issues/170)) 

## [5.0.3](../../releases/tag/5.0.2) - 2023-11-29

### Fixed

- Interpolation to determine channel does not work in ansible-core 2.16 ([#169](../../issues/169))

## [5.0.2](../../releases/tag/5.0.2) - 2023-09-08

### Fixed

- docker_version does not work as expected ([#168](../../issues/168))

## [5.0.1](../../releases/tag/5.0.1) - 2023-07-30

### Fixed

- Changed order of installing additional pip packages ([#166](../../issues/166))

## [5.0.0](../../releases/tag/5.0.0) - 2023-05-20

### Changed

- Docker Compose V1 is EOL and this role will no longer support that in general.
- Changed name of `docker_compose_no_pip` to `docker_compose_pip`, default set to `false`.
- `docker_compose` is `true` and `docker_compose_pip` is `false`, it will only create symbolic links (`docker-compose`) for backward compatibility. Docker compose CLI plugin is installed by default now.

### Removed

- Removed variables `docker_compose_no_pip_detect_version` and `docker_compose_no_pip_version`
- Removed Debian 8 bug tweaks.

### Internal

- Updated Vagrantfile for testing to works with AlmaLinux 9 as controller.
- Investigate impact of Docker Compose V2 ([#147](../../issues/147))

## [4.0.0](../../releases/tag/4.0.0) - 2022-12-05

### Changed

- Bumped minimal Ansible version to 5.0.0

## Fixed

- Unsupported parameters for (ansible.legacy.command) module: warn ([#160](../../issues/160))

## [3.8.0](../../releases/tag/3.8.0) - 2022-10-22

## Added

- Add Linux Mint 21 support. [@alexander-danilenko] ([#156](../../issues/156))
- Abort if podman in detected in the system

## Internal

- Added manuel test related to Docker SDK and PiP
- Added test of docker-compose not using PiP and auto detect version in regression suite

## [3.7.2](../../releases/tag/3.7.2) - 2022-04-24

## Fixed

- Docker daemon environment variables not set when SysVinit is used ([#152](../../issues/152))

## [3.7.1](../../releases/tag/3.7.1) - 2022-04-24

## Fixed

- Upgrade of docker-compose fails when fetching latest version from Github API ([#151](../../issues/151))
- Service module fail on WSL2 with Ubuntu 20.04 ([#150](../../issues/150))

## [3.7.0](../../releases/tag/3.7.0) - 2022-02-05

## Added

- Support for CentOS Stream 8

## Internal

- Update of test configuration.
- Updated Docker CE support matrix.

## [3.6.1](../../releases/tag/3.6.1) - 2021-12-29

## Fixed

- Fix broken Linux Mint 19 + 20 ([#144](../../pull/144))

## Internal

- Minor refactoring of test configuration.

## [3.6.0](../../releases/tag/3.6.0) - 2021-11-07

## Added

- Added support for Rocky Linux 8

## Fixed

- Docker restart fails after OPA authz plugin installation on Ubuntu 20.04 ([#143](../../issues/143))
- Docker plugin install seems to be missing "item.args" ([#142](../../issues/142))

## Internal

- Rocky Linux 8 included in regressiontesting.

## [3.5.0](../../releases/tag/3.5.0) - 2021-10-30

### Added

- Add support for RHEL7 ppc64le architecture [@DimaShmu] ([#140](../../issues/140))

## [3.4.1](../../releases/tag/3.4.1) - 2021-08-09

### Fixed

- Error when creating docker-compose symlink when file is present at path

## [3.4.0](../../releases/tag/3.4.0) - 2021-06-28

### Changed

- Add support to upgrade/downgrade docker-compose (binary version) ([#138](../../issues/138))
- Bumped minimum Ansible version to 2.10 in role meta information

### Fixed

- Bumped docker-compose version from 1.29.1 to 1.29.2 (`docker_compose_no_pip_version`)
- Failed execution during removal of Docker CE and related files

### Internal

- Restructure of test cases
- Bumped Ansible version to 2.10.7 meaning regression testing is no longer done on versions below 2.10

## [3.3.2](../../releases/tag/3.3.2) - 2021-04-17

### Fixed

- Python docker version 5 Drops support for Python 2 ([#136](../../issues/136))
- Bumped non-Python version of docker-compose from 1.27.4 to 1.29.1
- Fixed Ansible linting warnings related to rule 208

### Internal

- Bumped ansible version to 2.9.20 which is used for regression testing

## [3.3.1](../../releases/tag/3.3.1) - 2021-02-21

### Fixed

- Version 3.3.0 forces pip upgrades on RHEL8 ([#135](../../issues/135))

### Changed

- Cleaned out old compatibility check related to Debian 7

## [3.3.0](../../releases/tag/3.3.0) - 2021-02-16

### Added

- Add support for AlmaLinux 8 ([#133](../../issues/133))

### Fixed

- PiP upgrade no longer works for Python 2 ([#134](../../issues/134))

## [3.2.1](../../releases/tag/3.2.1) - 2020-12-21

### Changed

- Bumped docker-compose version to 1.27.4

## [3.2.0](../../releases/tag/3.2.0) - 2020-11-16

### Changed

- Review code around Docker plugin handling ([#132](../../issues/132))

### Fixed

- Docker daemon is not restarted on configuration change when already started. Fixed by changes in #132.

### Internal

- Readme file in tests directory updated
- Updated tests to use Ansible 2.9.15

## [3.1.2](../../releases/tag/3.1.2) - 2020-11-07

### Fixed

- Centos8: Issues when trying to install plugins ([#131](../../issues/131))

## [3.1.1](../../releases/tag/3.1.1) - 2020-10-23

### Fixed

- WSL2: Failing to check docker daemon status ([#127](../../issues/127))

## [3.1.0](../../releases/tag/3.1.0) - 2020-10-09

### Changed

- Pip install on RHEL 7 and 8 ([#125](../../issues/125))

### Fixed

- Fails on RHEL 7 because $releasever is set to 7Server ([#126](../../issues/126))
- Tasks related to removal uses yum instead of dnf for RHEL 8 ([#124](../../issues/124))

## [3.0.0](../../releases/tag/3.0.0) - 2020-10-07

### Changed

- Support for Ansible 2.8 dropped, increased to 2.9. Future changes might break compatibility.
- containerd for CentOS/RHEL 8 update to version 1.2.13-3.2
- Experimental switch `docker_x_redhat_centos_8_workaround` now defaults to `no`
  since it seems to now be available in CentOS/RHEL 8 repo: https://github.com/docker/for-linux/issues/873

### Fixed

- RHEL8 install fails due to missing docker-ce-edge repository ([#123](../../issues/123))

### Removed

- Remove handling of deprecated variable docker_pkg_name ([#85](../../issues/85))
- Remove handling of deprecated variable docker_enable_ce_edge ([#83](../../issues/83))

## [2.7.0](../../releases/tag/2.7.0) - 2020-08-09

### Changed

- Update default docker-compose version to 1.26.2
- Changed `docker_x_ssl_match_hostname` to true and detection if missing

### Fixed

- No module named shutil_get_terminal_size ([#121](../../issues/121))

### Added

- Add missing audit rules which are defined in CIS Docker Benchmark 1.2.0 ([#120](../../issues/120))

## [2.6.6](../../releases/tag/2.6.6) - 2020-07-19

### Fixed

- No package matching '' is available ([#119](../../issues/119))

## [2.6.5](../../releases/tag/2.6.5) - 2020-07-04

### Fixed

- Missing dependency zipp for installed docker-compose using PiP ([#112](../../issues/112))

## [2.6.4](../../releases/tag/2.6.4) - 2020-06-27

### Changed

- Updated default docker-compose version to 1.26.0

## [2.6.3](../../releases/tag/2.6.3) - 2020-05-02

### Changed

- Minimum supported Ansible version increased to 2.8.
- Update default docker-compose version to 1.25.5 ([#114](../../issues/114))
- Improve/Refactor handling related to postinstall steps and PiP ([#115](../../issues/115))

### Fixed

- Fix python3 reference in tasks/postinstall.yml ([#117](../../issues/117))

### Internal

- Improved testing to get it more stable when reboots are required
- Docker run throws error on Fedora 31 ([#116](../../issues/116))

## [2.6.2](../../releases/tag/2.6.2) - 2019-12-04

### Fixed

- Docker CE package fails to install on CentOS 8 ([#110](../../issues/110))

## [2.6.1](../../releases/tag/2.6.1) - 2019-08-13

### Fixed

- EPEL repo shall not be installed when docker_setup_repos is false

## [2.6.0](../../releases/tag/2.6.0) - 2019-08-10

### Added

- Add support to disable setup of apt/dnf/apt repos ([#109](../../issues/109))

## [2.5.2](../../releases/tag/2.5.2) - 2019-08-02

### Fixed

- Error in apt_repository on Ubuntu 19.04 (Disco Dingo) ([#108](../../issues/108))
- 19.03 fails on Fedora 28 - write /proc/self/attr/keycreate: permission denied ([#107](../../issues/107))
- Ubuntu 17.10 Artful is not handled correctly ([#104](../../issues/104))
- Updated default value for docker-compose version to 1.24.1

### Internal

- Added automated test for Ubuntu 19.04 Disco Dingo
- Removed Ubuntu 14.04 Trusty Tahr from automated tests
- Updated tests to not use deprecated configuration which was now removed in 19.03 ([#105](../../issues/105))

## [2.5.1](../../releases/tag/2.5.1) - 2019-07-16

### Fixed

- Major version comparison fails for some tasks due to non-numeric value ([#103](../../issues/103))
- Docker compose fails on Debian 10 (Buster) ([#102](../../issues/102))

## [2.5.0](../../releases/tag/2.5.0) - 2019-07-14

### Added

- Added initial basic support for Raspbian

### Fixed

- Migrating from with_X to loop ([#100](../../issues/100))
- Install of authz plugins does not update daemon config ([#99](../../issues/99))
- Failure on Fedora 30 ([#93](../../issues/93))

### Internal

- Updated experimental CIS test.

## [2.4.1](../../releases/tag/2.4.1) - 2019-06-06

### Fixed

- RHEL: subscription-manager uses network when docker_network_access is set to false ([#98](../../issues/98))

## [2.4.0](../../releases/tag/2.4.0) - 2019-06-05

### Added

- Experimental configuration (`docker_network_access`) to not access network during run

### Changed

- Many deprecation warnings in Ansible 2.8 ([#94](../../issues/94))
- Improve handling of Python 3 ([#95](../../issues/95))
- RHEL: handling repos NOT via subscription-manager ([#96](../../issues/96))
- Role name changed due to automatic conversion of hyphen to underscore in Ansible Galaxy

### Fixed

- api.github.com limits on number of requests causes the request to fail ([#87](../../issues/87))
- RHEL, role fails to remove "pre-docker-ce" packages ([#92](../../issues/92))
- Install of Docker SDK fails on RHEL (not supported by this role) ([#97](../../issues/97))

### Internal

- Preparations for doing automated tests with RHEL 7
- Increase Ansible version to 2.6.16
- Preparations for better handling of Python 3 in test suites
- Removed Debian 7 Wheezy from tests due to APT repository EOLs etc

## [2.3.0](../../releases/tag/2.3.0) - 2019-03-11

### Fixes

- APT repository setup fails on Debian Buster 10 ([#88](../../issues/88))

### Added

- Added `postinstall` tag

### Changed

- Deprecation warning about filters in Ansible 2.5 ([#40](../../issues/40))

### Internal

- Updated regression test baseline to Ansible 2.5
- Refactored setup of repository to reduce number of skipped tasks
- Refactored distribution check tasks
- Added regression tests

## [2.2.0](../../releases/tag/2.2.0) - 2019-02-10

### Added

- Support removal of Docker CE packages and related configuration ([#82](../../issues/82))
- Replace docker_pkg_name with docker_version ([#86](../../issues/86))

### Deprecated

- Variable `docker_remove_pre_ce` will be removed in future major release ([#80](../../issues/80))
- Variable `docker_pkg_name` will be removed in future major release ([#86](../../issues/86))

## [2.1.1](../../releases/tag/2.1.1) - 2019-02-01

### Fixed

- Changing Docker repository channel does not work ([#79](../../issues/79))

## [2.1.0](../../releases/tag/2.1.0) - 2019-01-19

### Added

- Initial support for installation of Docker plugins ([#78](../../issues/78))

### Internal

- Some adjustments to what is included in regression test suite
- Devicemapper regression tests fail with Docker 18.09 ([#69](../../issues/69))
- Docker CE matrix added to see distribution support

## [2.0.0](../../releases/tag/2.0.0) - 2019-01-03

### Added

- Improve use of --check ([#72](../../issues/72))
- Add more advanced options to control PiP package installation ([#73](../../issues/73))
- Flag to disable compatibility and distribution checks
- python-pip-whl is required in Debian 8 to install via PiP

### Changed

- Docker 18.09 fails to create containers when MountFlags=slave is set ([#76](../../issues/76))

### Fixed

- Non-systemd environment variables are not correctly set since version 1.11.0 of this role ([#74](../../issues/74))
- Some variables lives on between plays which cause unexpected behavior ([#75](../../issues/75))
- docker-compose does not work with sudo ([#77](../../issues/77))

### Internal

- Refactored automated tests to now execute Ansible from separate node due to issues
  with VirualBox guest additions from time to time.
- Fixed issues reported by Ansible-lint

## [1.11.3](../../releases/tag/1.11.3) - 2018-12-11

### Fixed

- python-pip is always installed ([#71](../../issues/71))

## [1.11.2](../../releases/tag/1.11.2) - 2018-12-11

### Fixed

- docker_compose_no_pip only works in Ansible 2.7 or later ([#68](../../issues/68))
- Pip not installed before use of pip module ([#70](../../issues/70))

## [1.11.1](../../releases/tag/1.11.1) - 2018-12-03

### Fixed

- Docker compose is installed via PiP even when docker_compose_no_pip is set to true ([#68](../../issues/68))

## [1.11.0](../../releases/tag/1.11.0) - 2018-12-01

### Added

- Identify systemd support even in check mode ([#66](../../issues/66))

### Internal

- Ansible-lint with Ansible Galaxy rules report problems ([#67](../../issues/67))
- Fixed issues with missing Fedora images at vagrantup.com

## [1.10.0](../../releases/tag/1.10.0) - 2018-11-05

### Added

- Add support for Debian 7 (Wheezy) ([#64](../../issues/64))

### Fixed

- Docker startup fails in Fedora 28 because it cannot find pvcreate ([#58](../../issues/58))
- LVM2 package is required to be installed when devicemapper is used ([#61](../../issues/61))
- docker-compose won't install ([#62](../../issues/62))
- Revisit install of docker-compose ([#63](../../issues/63))

### Internal

- Testing: Snapshotting used during testing by `test.sh` to speed up by avoiding unnecessary installs of Ansible and guest additions
- Add Fedora distributions to test suite ([#57](../../issues/57))
- Fails to install VirtualBox guest additions on Fedora 29 beta ([#59](../../issues/59))
- Replace currently used Vagrant boxes during testing with more official boxes ([#60](../../issues/60))

## [1.9.0](../../releases/tag/1.9.0) - 2018-10-24

### Added

- Add support to allow users to be added to the docker group ([#53](../../issues/53))
- Add support to select different Docker repository channels ([#55](../../issues/55))

### Deprecated

- Variable `docker_enable_ce_edge` will be removed because Docker no longer provide edge releases ([#54](../../issues/54))

## [1.8.0](../../releases/tag/1.8.0) - 2018-10-14

### Added

- Add support to install Docker Ansible module dependencies ([#48](../../issues/48))
- Add support to install packages after install via PiP or OS package manager ([#49](../../issues/49))

### Internal

- Testing: Improved structure in `vagrant_config.yml` for `test.sh`
- Testing: Improved `test.sh` with better limit functionality

### Fixed

- auditd is installed even if docker_enable_audit set to false ([#50](../../issues/50))
- Cannot use dm.directlvm_device in Debian 8 ([#51](../../issues/51))
- Update repository cache fails on Fedora ([#52](../../issues/52))

## [1.7.2](../../releases/tag/1.7.2) - 2018-09-27

### Fixed

- Python 3 forward compatibility ([#47](../../issues/47))

## [1.7.1](../../releases/tag/1.7.1) - 2018-07-08

### Fixed

- Ansible Galaxy linting report error during import  ([#45](../../issues/45))
- null written to /etc/docker/daemon.json ([#46](../../issues/46))

## [1.7.0](../../releases/tag/1.7.0) - 2018-07-08

### Added

- Add support to add environment variables to Docker daemon ([#43](../../issues/43))
- Add support to add systemd configuration options to Docker service ([#44](../../issues/44))

### Fixed

- systemctl daemon-reload is not run when toggling docker_enable_mount_flag_fix ([#39](../../issues/39))
- Role is not idempotent for Ubuntu and Debian distributions ([#41](../../issues/41))
- Cannot set hosts in daemon.json because of arguments to dockerd in Ubuntu/Debian ([#42](../../issues/42))

## [1.6.0](../../releases/tag/1.6.0) - 2018-06-07

### Changed

- Deprecation warning about include in Ansible 2.4 ([#12](../../issues/12))

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
