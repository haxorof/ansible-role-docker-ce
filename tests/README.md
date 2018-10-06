# How to test this role using Vagrant

If you have Vagrant and VirtualBox installed you can test this role in different Linux distributions.
The simplest way you can do this is just to run `vagrant up` in this directory.

If you would like to do different test that are specified in `vagrant_config.yml` under the `tests` then you can use the `ci-test.sh` and you can limit the testing to a
certain test and/or box by specifying one or two arguments. The first argument limits by ID and the second limit by box.

Example to run `no_config` tests for all Ubuntu distributions:

```console
# ./ci-test.sh no_config ubuntu
```

If you do not want to pre-download all the boxes specified in the `vagrant_config.yml` then you can this before running `ci-test.sh`:

```console
# export SKIP_DOWNLOAD=1
# ./ci-test.sh
```
