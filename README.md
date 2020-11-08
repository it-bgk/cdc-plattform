# Project: cdc-plattform
This plattform should help cyber security teams, cyber defense center and all other which want to improve their security incident processes with tools, but have to less man power to do this on their own.
All the tools I use are free to use and can be used without any dependencies of this project.

The goal of the project is to make the installation and maintenance easier to setup and use the tools listed in [contribution](#contribution).


[![Gitlab pipeline status](https://gitlab.com/it-bgk/docker/cdc-plattform/badges/master/pipeline.svg)](https://gitlab.com/it-bgk/docker/cdc-plattform/-/commits/master)
![GitHub License](https://img.shields.io/github/license/it-bgk/cdc-plattform?style=flat-square)

<!-- ToC start -->
# Table of Contents

- [Project: cdc-plattform](#project-cdc-plattform)
- [Table of Contents](#table-of-contents)
- [Installation](#installation)
  - [Hardware Requirements](#hardware-requirements)
  - [Software Requirements](#software-requirements)
  - [Firewall Requirements](#firewall-requirements)
    - [Github Repository](#github-repository)
    - [Docker Images](#docker-images)
    - [For Intelligence sources](#for-intelligence-sources)
  - [Configuration Requirements](#configuration-requirements)
- [Usage](#usage)
  - [Main plattform](#main-plattform)
  - [Optional: Watcher](#optional-watcher)
  - [Optional: OpenCTI](#optional-opencti)
- [Contribution](#contribution)
- [Credits](#credits)
- [License](#license)
<!-- ToC end -->

# Installation

## Hardware Requirements
if you create your sever you should use at least:
- 4 CPU cores
- 8 GB of RAM
- \>25 GB of disk space  (the faster the better), but it depends on your requirement
  - For MISP:
  - For TheHive:
  - For Cortex:
  - For Watcher:
  - For OpenCTI: 


## Software Requirements

1. Install docker: https://docs.docker.com/engine/install/
2. Install docker-compose: https://docs.docker.com/compose/install/
3. Install git
4. [Optional] Install make
5. Clone git repository: `git clone https://github.com/it-bgk/cdc-plattform.git /opt/cdc-plattform` (any other path can also choosen)

## Firewall Requirements

### Github Repository
- github.com, HTTPS, 443/tcp

### Docker Images
- io.docker.com, HTTPS, 443/tcp

### For Intelligence sources
It depends on what you onboard to OpenCTI, MISP, Cortex, ...

## Configuration Requirements
- For Elasticsearch:
  - https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html#_set_vm_max_map_count_to_at_least_262144

# Usage

## Main plattform
1. Copy .env.sample: `cp .env.sample .env`
2. Modify .env file to your requirements: `vi .env`
3. Pull images: `docker-compose pull` or `make install`
4. Start main plattform: `docker-compose up -d` or `make start`

## Optional: Watcher
To start watcher: `make install-watcher` or:
```
cd watcher
make download
make start
```
You can also start it manually please checkout the [makefile](/watcher/Makefile) for this.

## Optional: OpenCTI
To start OpenCTI: `make install-opencti` or:
```
cd opencti
make download
make start
```
You can also start it manually please checkout the [makefile](/opencti/Makefile) for this.


# Contribution
- Everyone is allowed to contribute to this project
- All communication and discussions should be made at the moment during Github issues
# Credits
This project thanks all contributors of the projects listed below, without them this project would never be possible:
- Case Management
  - [TheHive](https://github.com/TheHive-Project/TheHive)
- Threat Hunting
  - [Cortex](https://github.com/TheHive-Project/Cortex)
  - [Cortex-Analyzer](https://github.com/TheHive-Project/Cortex-Analyzers)
  - [MISP-Modules](https://github.com/misp/misp-modules)
  - [MISP](https://github.com/misp/misp)
  - [Open CTI](https://github.com/OpenCTI-Platform/opencti)
  - [Watcher](https://github.com/Felix83000/Watcher)
- Threat Intelligence Processing
  - [MineMeld](https://github.com/PaloAltoNetworks/minemeld/wiki)
- Sidekicks
  - [Traefik](https://docs.traefik.io/)
  - [Redis](https://hub.docker.com/_/redis)
  - [Janusgraph](https://hub.docker.com/r/janusgraph/janusgraph)
  - [Cassandra](https://hub.docker.com/_/cassandra/)
  - [Watchtower](http://github.com/containerr/watchtower)
  - [Elasticsearch](https://www.docker.elastic.co/)
<!--
- Management
  - [Cerebro](https://github.com/lmenezes/cerebro)
  - [Open Distro for Elasticsearch](https://opendistro.github.io/for-elasticsearch/)
-->

# License
We use the [BSD-3 license](LICENSE).