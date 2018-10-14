# How to test this role using Vagrant

If you have Vagrant and VirtualBox installed you can test this role in different Linux distributions.
The simplest way you can do this is just to run `vagrant up` in this directory.

If you would like to do different test that are specified in `vagrant_config.yml` under the `tests` then you can use the `test.sh` and you can limit the testing to a
certain test and/or box by specifying one or two arguments. The first argument limits by ID and the second limit by box.

Example to run `t_no_config` tests for all Ubuntu distributions:

```console
# ./test.sh t_no_config ubuntu
```

If you do not want to pre-download all the boxes specified in the `vagrant_config.yml` then you can this before running `test.sh`:

```console
# SKIP_DOWNLOAD=1 ./test.sh
```

Below is a table listing some environment variables you can set before running `test.sh`:

| Environment variable | Value | Description |
| --- | --- | --- |
| SKIP_DOWNLOAD | 1 | If you do not want to pre-download all the boxes specified in the `vagrant_config.yml` |
| ON_FAILURE_KEEP | 1 | If test fails and you do not want it to destroy the VM |
| PROVISION_ONLY | 1 | When you have a running VM and you just want to reprovision it |
