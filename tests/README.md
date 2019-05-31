# How to test this role using Vagrant

If you have Vagrant and VirtualBox installed you can test this role in different Linux distributions.
The simplest way you can do this is just to run `vagrant up` in this directory.

If you would like to do different test that are specified in `vagrant_tests.yml` (all boxes in `vagrant_boxes.yml`) under the `tests` then you can use the `test.sh` and you can limit the testing to a
certain test and/or box by specifying one or two arguments. The first argument limits by ID and the second limit by box.

To run all tests on all Ubuntu distributions:

```console
# ./test.sh t_ ubuntu
```

To run test `t_config` on all Ubuntu distributions:

```console
# ./test.sh t_config ubuntu
```

If you want to pre-download all the boxes specified in the `vagrant_boxes.yml` then you can this before running `test.sh`:

```console
# PRE_DOWNLOAD_BOXES=1 ./test.sh
```

Below is a table listing some environment variables you can set before running `test.sh`:

| Environment variable | Value | Description |
| --- | --- | --- |
| PRE_DOWNLOAD_BOXES | 1 | If you want to pre-download all the boxes specified in the `vagrant_boxes.yml` |
| ON_FAILURE_KEEP | 1 | If test fails and you do not want it to destroy the VM |
| FORCE_TEST | 1 | Overrides test limitation defined in `vagrant_test.yml` |
