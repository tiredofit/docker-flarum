# github.com/tiredofit/docker-flarum

[![GitHub release](https://img.shields.io/github/v/tag/tiredofit/docker-flarum?style=flat-square)](https://github.com/tiredofit/docker-flarum/releases/latest)
[![Build Status](https://img.shields.io/github/actions/workflow/status/tiredofit/docker-flarummain.yml?branch=main&style=flat-square)](https://github.com/tiredofit/docker-flarum.git/actions)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/flarum.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/flarum/)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/flarum.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/flarum/)
[![Become a sponsor](https://img.shields.io/badge/sponsor-tiredofit-181717.svg?logo=github&style=flat-square)](https://github.com/sponsors/tiredofit)
[![Paypal Donate](https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square)](https://www.paypal.me/tiredofit)
## About

This will build a Docker Image for [Flarum](https://www.flarum.org/). A web based discussion forum. It will:

* Supports Data Persistence
* Automatically detect new version of Image/Flarum and upgrade it

## Maintainer

- [Dave Conroy](https://github.com/tiredofit/)

## Table of Contents

- [About](#about)
- [Maintainer](#maintainer)
- [Table of Contents](#table-of-contents)
- [Prerequisites and Assumptions](#prerequisites-and-assumptions)
- [Installation](#installation)
  - [Build from Source](#build-from-source)
  - [Prebuilt Images](#prebuilt-images)
    - [Multi Architecture](#multi-architecture)
- [Configuration](#configuration)
  - [Quick Start](#quick-start)
  - [Persistent Storage](#persistent-storage)
  - [Environment Variables](#environment-variables)
    - [Base Images used](#base-images-used)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
  - [Installing Plugins and Extensions](#installing-plugins-and-extensions)
- [Support](#support)
  - [Usage](#usage)
  - [Bugfixes](#bugfixes)
  - [Feature Requests](#feature-requests)
  - [Updates](#updates)
- [License](#license)
- [Maintenance](#maintenance-1)
  - [Shell Access](#shell-access-1)
- [References](#references)

## Prerequisites and Assumptions
*  Assumes you are using some sort of SSL terminating reverse proxy such as:
   *  [Traefik](https://github.com/tiredofit/docker-traefik)
   *  [Nginx](https://github.com/jc21/nginx-proxy-manager)
   *  [Caddy](https://github.com/caddyserver/caddy)

## Installation

### Build from Source
Clone this repository and build the image with `docker build <arguments> (imagename) .`

### Prebuilt Images
Builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/flarum) and is the recommended method of installation.

```bash
docker pull tiredofit/flarum:(imagetag)
```

The following image tags are available along with their tagged release based on what's written in the [Changelog](CHANGELOG.md):

| PHP Version | OS     | Tag       |
| ----------- | ------ | --------- |
| 8.1.x       | Alpine | `:latest` |

#### Multi Architecture
Images are built primarily for `amd64` architecture, and may also include builds for `arm/v7`, `arm64` and others. These variants are all unsupported. Consider [sponsoring](https://github.com/sponsors/tiredofit) my work so that I can work with various hardware. To see if this image supports multiple architecures, type `docker manifest (image):(tag)`


## Configuration
### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this image.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.

### Persistent Storage

The following directories are used for configuration and can be mapped for persistent storage.

| Directory   | Description                |
| ----------- | -------------------------- |
| `/data`     | Persistent Storage         |
| `/www/logs` | Nginx and php-fpm logfiles |

### Environment Variables

#### Base Images used

This image relies on an [Alpine Linux](https://hub.docker.com/r/tiredofit/alpine) base image that relies on an [init system](https://github.com/just-containers/s6-overlay) for added capabilities. Outgoing SMTP capabilities are handlded via `msmtp`. Individual container performance monitoring is performed by [zabbix-agent](https://zabbix.org). Additional tools include: `bash`,`curl`,`less`,`logrotate`,`nano`,`vim`.

Be sure to view the following repositories to understand all the customizable options:

| Image                                                         | Description                            |
| ------------------------------------------------------------- | -------------------------------------- |
| [OS Base](https://github.com/tiredofit/docker-alpine/)        | Customized Image based on Alpine Linux |
| [Nginx](https://github.com/tiredofit/docker-nginx/)           | Nginx webserver                        |
| [PHP-FPM](https://github.com/tiredofit/docker-nginx-php-fpm/) | PHP Interpreter                        |

| Parameter                | Description                                                                            | Default         |
| ------------------------ | -------------------------------------------------------------------------------------- | --------------- |
| `ADMIN_EMAIL`            | Email address for the Administrator - Needed to run                                    |                 |
| `ADMIN_USER`             | Username for the Administrator                                                         | `admin`         |
| `ADMIN_PASS`             | Password for the Administrator - Needed to run                                         |                 |
| `ADMIN_PATH`             | What folder to access admin panel                                                      | `admin`         |
| `API_PATH`               | What folder to access API                                                              | `api`           |
| `DB_HOST`                | MariaDB external container hostname (e.g. flarum-db)                                   |                 |
| `DB_NAME`                | MariaDB database name i.e. (e.g. flarum)                                               |                 |
| `DB_USER`                | MariaDB username for database (e.g. flarum)                                            |                 |
| `DB_PASS`                | MariaDB password for database (e.g. userpassword)                                      |                 |
| `DB_PREFIX`              | MariaDB Prefix for `DB_NAME`                                                           | `flarum_`       |
| `EXTENSIONS_AUTO_UPDATE` | Automatically update extensions on container startup `TRUE` / `FALSE`                  | `TRUE`          |
| `SITE_TITLE`             | The title of the Website                                                               | `Docker Flarum` |
| `SITE_URL`               | The Full site URL of the installation e.g. `flarum.example.com` - Required for Install |                 |


* * *
## Maintenance

### Shell Access

For debugging and maintenance purposes you may want access the containers shell.

```bash
docker exec -it (whatever your container name is) bash
```

### Installing Plugins and Extensions

* Make a file in your `/data/extensions` folder called `install` and place on each line the Github Repositories name. Upon startup, the container will fetch the source code via composer, save a cache of the install, and then install. Upon further restarts of the container, the image will check to see if there are any updates to the extension, and will proceed with upgrading to the latest.

Example:

````
[/data/flarum] 1 $ cd data
[/data/flarum/data] $ ls
assets  composer.json  extensions  storage
[/data/flarum/data] $ cd extensions/
[/data/flarum/data/extensions] $ ls
list
[/data/flarum/data/extensions] $ cat list
flagrow/upload
michaelbelgium/flarum-discussion-views
[/data/flarum/data/extensions] $
````

Alternatively, if you wish to install an extension while the container is running without restarting, you can use the tool located in `/usr/sbin/extension-tool`

Syntax is as follows:
````
Usage:
  extension-tool {install|remove|update} {packagename}
  extension-tool {install|remove|update} {packagename} --debug
  extension-tool -h|--help
````

For example, if you wished to install `fof/drafts` then here is a command to do it from your host:

`docker exec -it (yourcontainername) extension-tool install fof/drafts`

The rest of the options are self explanatory.


## Support

These images were built to serve a specific need in a production environment and gradually have had more functionality added based on requests from the community.
### Usage
- The [Discussions board](../../discussions) is a great place for working with the community on tips and tricks of using this image.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) personalized support.
### Bugfixes
- Please, submit a [Bug Report](issues/new) if something isn't working as expected. I'll do my best to issue a fix in short order.

### Feature Requests
- Feel free to submit a feature request, however there is no guarantee that it will be added, or at what timeline.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) regarding development of features.

### Updates
- Best effort to track upstream changes, More priority if I am actively using the image in a production environment.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) for up to date releases.

## License
MIT. See [LICENSE](LICENSE) for more details.
## Maintenance
### Shell Access

For debugging and maintenance purposes you may want access the containers shell.

```bash
docker exec -it (whatever your container name is e.g. flarum) bash
```

## References

* https://www.flarum.org

