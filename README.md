# ESS DAQ: Simplified setup of the EFU-based data acquisition system

[![DOI](https://zenodo.org/badge/135150324.svg)](https://zenodo.org/badge/latestdoi/135150324)

This repository contains a set of scripts and config files for getting a neutron detector data acquisition system up and running. The functionality provided by these scripts is summarized below:

- Install and configure `conan` to provide dependencies for ESS projects.
- Install docker and configure the `grafana` service for data stream statistics.
- Install `kafka`, use provided scripts to easily start and stop it at will.
- Download and build the [Event Formation Unit](https://github.com/ess-dmsc/event-formation-unit).
- Download and build [DAQuiri](https://github.com/ess-dmsc/daquiri).
- Update `conan`, `EFU` and `DAQuiri` to latest versions.

A description of the contents of each directory in the root of the repository can be found in [documentation/directories.md](documentation/directories.md).

## Getting started

### Prerequisites

 * The only package you should need to install on a fresh system is `git`. If you intend to commit changes, now is also the time to configure your `ssh` to work with `github`.
 * If you can authenticate to github with ssh, the necessary projects will be cloned accordingly and you will be able to commit changes to those projects.

### Installing

#### Interactive builds
```
git clone https://github.com/ess-dmsc/essdaq.git
cd essdaq
./install.sh          # for Ubuntu
./install_centos7.sh  # for CentOS
```

The script *install.sh* and *install_centos7.sh* will ask you a few questions during the installation process.
In the `/config` directory, rename one of the `system_*.sh` files to `system.sh` and modify to your liking. The default one for everything running
on `localhost` is a good start for a single-machine configuration. You may need to specify the name of the network interface to be able
to run `efu/netstats.sh`.

#### Automatic mode

```
git clone https://github.com/ess-dmsc/essdaq.git
cd essdaq
./autoinstall.sh          # detect os and install
```
If Ubuntu is detected the install.sh script is run, if CentOS, then install_centos7.sh. Both scripts are given the 'auto' argument.

### Updating the software

Just run `./update.sh` and answer the simple questions (currently only for Ubuntu)

## Contributing

See the [CONTRIBUTING.md](CONTRIBUTING.md) file for details.

## Authors

* Morten Jagd Christensen
* Martin Shetty

See the list of contributors [on Github](https://github.com/ess-dmsc/essdaq/graphs/contributors).

## License

This project is licensed under the BSD-2 License - see the [LICENSE](LICENSE) file for details.
