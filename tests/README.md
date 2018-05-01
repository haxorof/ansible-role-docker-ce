# How to test this role using Vagrant

If you have Vagrant and VirtualBox installed you can test this role in different Linux distributions.
The simplest way you can do this is just to run `vagrant up` in this directory.

If you would like to do different test then check out the `vagrant_config.yml` and you can select the different tests by setting the environment variable `CONFIG_KEY` to a key available in that file. After that you just run `vagrant up`.

Example to run test in an Ubuntu distributions:

```console
# export CONFIG_KEY=ubuntu_xenial
# vagrant up
```

To destroy it just run `vagrant destroy`.