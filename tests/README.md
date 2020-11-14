# How to test this role using Vagrant

If you have WSL1, Vagrant and VirtualBox installed you can test this role in different Linux distributions. This test directory contains both manual test cases and regression test to verify that role changes is working in the distributions as is should.

## Regression testing

To run all regression test in all distributions then you just run the command below in this directory:

```console
# ./test.sh
```

Note! Running through all test will take several hours and will at the end provide a summary of all failed and successful tests.

### Limit testing

If you would like to do different test that are specified in `vagrant_tests.yml` (all boxes in `vagrant_boxes.yml`) under the `tests` then you can use the `test.sh` and you can limit the testing to a certain test and/or box by specifying one or two arguments. The first argument limits by ID and the second limit by box.
It is based on a very simple mechanism by string comparison (contains text).

To run all tests on all CentOS distributions:

```console
# ./test.sh t_ centos
```

To run test `t_config` on all CentOS distributions:

```console
# ./test.sh t_config centos
```

### Stop test suite for debugging

Normal case for `test.sh` is that it run through all the tests and does not stop if something fails. If you want it to stop as soon as a test case fails
then instead run `debug_test.sh` with the same arguments if any. Then it will stop and keep the VM running.

When you are done you can destroy all running VMs by running `vagrant destroy -f`.

## Advanced

### Update downloaded boxes

To update the already downloaded boxes then you can run the following command when standing in this tests directory:

```console
# ./scripts/update-vagrant-boxes.sh
```

### Generate configuration and run specific tests

In the cases where you are interested to run a manual test which is not part of any regression test suite then you can run commands like below:

```console
# ./scripts/generateConf.sh 0 0
==> Generating config: box=[generic/centos7], test_yml=[test_config.yml]
# ./scripts/generateConf.sh 1 9 vagrant_manual_tests.yml
==> Generating config: box=[generic/centos8], test_yml=[experimental/cis/test_cis.yml]
```

After config has been generated it is possible to just use `vagrant up` to start VMs and running those tests.
