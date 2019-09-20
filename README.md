
# hub.docker.com/r/tiredofit/flarum

[![Build Status](https://img.shields.io/docker/build/tiredofit/flarum.svg)](https://hub.docker.com/r/tiredofit/flarum)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/flarum.svg)](https://hub.docker.com/r/tiredofit/flarum)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/flarum.svg)](https://hub.docker.com/r/tiredofit/flarum)
[![Docker Layers](https://images.microbadger.com/badges/image/tiredofit/flarum.svg)](https://microbadger.com/images/tiredofit/flarum)

# Introduction

This will build a container for [flarum](https://www.flarum.org) - A PHP Based forum software. Upon starting this image it will give you a turn-key message board for communicating to groups, peers, or the public. 

* Latest release Version 0.10 beta 10
* Supports Data Persistence
* Fail2Ban installed to block brute force attacks
* Automatically install and keep up to date plugins from Github/Flagrow/Elsewhere
* Automatically detect new version of Image/Flarum and upgrade it
* Log Roation
* Alpine 3.10 Base w/Nginx and PHP-FPM 7.3

This Container uses [tiredofit/alpine:3.10](https://hub.docker.com/r/tiredofit/alpine) as a base.
        
[Changelog](CHANGELOG.md)

# Authors

- [Dave Conroy](https://github.com/tiredofit)

# Table of Contents

- [Introduction](#introduction)
    - [Changelog](CHANGELOG.md)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
    - [Data Volumes](#data-volumes)
    - [Environment Variables](#environmentvariables)   
    - [Networking](#networking)
- [Maintenance](#maintenance)
    - [Shell Access](#shell-access)
   - [References](#references)

# Prerequisites

This image assumes that you are using a reverse proxy such as [jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy) and optionally the [Let's Encrypt Proxy Companion @ https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion) or [tiredofit/traefik](https://github.com/tiredofit/docker-traefik) in order to serve your pages. However, it will run just fine on it's own if you map appropriate ports.

You will also need an external MySQL/MariaDB Container

# Installation

Automated builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/flarum) and is the recommended method of installation.


```bash
docker pull tiredofit/flarum:(imagetag)
```
The following image tags are available:

* `latest` - Flarum 0.10beta

You can also visit the image tags section on Docker hub to pull a version that follows the CHANGELOG.


# Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this image.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.
* Make [networking ports](#networking) available for public access if necessary

*The first boot can take from 1 minutes - 10 minutes depending on your internet connection and processor to import database schemas*

Login to the web server and enter in your admin username, admin password, and email address and start configuring the system!

# Configuration

### Data-Volumes

The container supports data persistence and during Dockerfile Build creates symbolic links for `/www/html/composer.json`, `/www/html/public/assets`, `/www/html/storage`. Upon startup configuration files are copied and generated to support portability.

The following directories are used for configuration and can be mapped for persistent storage.

| Directory    | Description                                                 |
|--------------|-------------------------------------------------------------|
|  `/data`    | For Data Persistence, map this folder to somewhere on your host |
|  `/assets/custom` | *OPTIONAL* - If you would like to overwrite some files in the container, put them here following the same folder structure for anything underneath the /www/html directory |

### Environment Variables

Along with the Environment Variables from the [Base image](https://hub.docker.com/r/tiredofit/alpine) + [Web Image](https://hub.docker.com/r/tiredofit/nginx-php-fpm) below is the complete list of available options that can be used to customize your installation.

| Parameter        | Description                            |
|------------------|----------------------------------------|
| `ADMIN_EMAIL` | Email address for the Administrator - Default `admin@example.com` |
| `ADMIN_USER` | Username for the Administrator - Default `admin` |
| `ADMIN_PASS` | Password for the Administrator - Default `flarum` |
| `ADMIN_PATH` | What folder to access admin panel - Default `admin` |
| `API_PATH` | What folder to access API - Default `api` |
| `DB_HOST` | Host or container name of MySQL Server e.g. `flarum-db` |
| `DB_PORT` | MySQL Port - Default `3306` |
| `DB_NAME` | MySQL Database name e.g. `asterisk` |
| `DB_USER` | MySQL Username for above Database e.g. `asterisk` |
| `DB_PASS` | MySQL Password for above Database e.g. `password`|
| `DB_PREFIX` | MySQL Prefix for `DB_NAME` - Default `flarum_`|
| `DEBUG_MODE` | Enable Debug Mode (verbosity) for the container installation/startup and in application - `TRUE` / `FALSE` - Default `FALSE` |
| `SITE_TITLE` | The Title of the Website - Default `Flarum` |
| `SITE_URL` | The Full site URL of the installation e.g. `https://flarum.example.com` |

### Networking

The following ports are exposed.

| Port      | Description |
|-----------|-------------|
| `80`      | HTTP        |

### Installing Plugins and Extensions

* Make a file in your `/data/extensions` folder called `install` and place on each line the Github Repositories name. Upon startup, the container will fetch the source code via composer, save a cache of the install, and then install. Upon further restarts of the container, the image will check to see if there are any updates to the extension, and will proceed with upgrading to the latest.

Example:

````
[/var/local/data/flarum] 1 $ cd data
[/var/local/data/flarum/data] $ ls
assets  composer.json  extensions  storage
[/var/local/data/flarum/data] $ cd extensions/
[/var/local/data/flarum/data/extensions] $ ls
list
[/var/local/data/flarum/data/extensions] $ cat list
flagrow/upload
michaelbelgium/flarum-discussion-views
[/var/local/data/flarum/data/extensions] $ 
````

# Maintenance


#### Shell Access

For debugging and maintenance purposes you may want access the containers shell. 

```bash
docker exec -it (whatever your container name is e.g. flarum) bash
```

# References

* https://flarum.org/
