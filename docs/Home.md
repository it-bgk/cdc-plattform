# Welcome to the CDC Plattform wiki!
This wiki contains all information from CDC Plattform git repository.

<!-- ToC start -->
# Table of Contents

- [Welcome to the CDC Plattform wiki!](#welcome-to-the-cdc-plattform-wiki)
- [Table of Contents](#table-of-contents)
- [Quick Start](#quick-start)
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
  - [Backup / Restore](#backup--restore)
  - [Optional: Watcher](#optional-watcher)
  - [Optional: OpenCTI](#optional-opencti)
<!-- ToC end -->

# Quick Start
You want to start quick?
Sorry then you must use an other solution.


# Installation

## Hardware Requirements
If you create your sever you should use at least:
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
4. [Optional, but recommended] Install make
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
2. Modify .env file to your requirements: `sudo vi .env`
3. Pull images: `sudo docker-compose pull` or `make install`
4. Start main plattform: `docker-compose up -d` or `make start`
   Alternativ start only a part: `docker-compose up -d cortex`

## Backup / Restore
see [Backup](Backup.md) or [Restore](Restore.md)


## Optional: Watcher
see [Watcher](Watcher.md)

## Optional: OpenCTI
see [OpenCTI](OpenCTI.md)