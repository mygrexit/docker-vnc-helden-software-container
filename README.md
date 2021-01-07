# Fork of [**ConSol/docker-headless-vnc-container**](https://github.com/ConSol/docker-headless-vnc-container)

I modified the original repo to perform a specific task.
I took most of the readme and rewrote it to fit my repo.

For the RPG **Das Schwarze Auge** or **DSA**, there is a software that helps in the creation and management of the heroes.

[**Helden-Software**](https://www.helden-software.de)

To be able to access and edit the hero from anywhere, i placed it inside this Docker image.
The software is a Java application, which makes a separate container that is accessible from the browser complicated and this seems like the easiest solution.

Only Ubuntu 16.04. with XFCE surface is used.

Summary:
This repository contains a Docker images with Ubuntu 16.04, headless VNC, JRE8 and the "Helden Software".

Each Docker image is installed with the following components:

* Desktop environment [**Xfce4**](http://www.xfce.org)
* VNC-Server (default VNC port `5901`)
* [**noVNC**](https://github.com/novnc/noVNC) - HTML5 VNC client (default http port `6901`)
* JRE8
* [**Helden-Software**](https://www.helden-software.de)
  
![Docker VNC Desktop access via HTML page](.pics/vnc_container_view.png)

## Status

![Docker automated](https://img.shields.io/docker/automated/mygrexit/docker-vnc-helden-software-container)
![Pulls](https://img.shields.io/docker/pulls/mygrexit/docker-vnc-helden-software-container)
![Build Size](https://img.shields.io/docker/image-size/mygrexit/docker-vnc-helden-software-container/latest)

## Current provided OS & UI sessions:
* `mygrexit/docker-vnc-helden-software-container`: `Ubuntu` with `Xfce4`, `JRE8` and `Helden-Software`

## Usage

- Run command with mapping to local port `5901` (vnc protocol) and `6901` (vnc web access):

      docker run -d -p 5901:5901 -p 6901:6901 mygrexit/docker-vnc-helden-software-container
  
- Change the default user and group within a container to your own with adding `--user $(id -u):$(id -g)`:

      docker run -d -p 5901:5901 -p 6901:6901 --user $(id -u):$(id -g) mygrexit/docker-vnc-helden-software-container

- If you want to get into the container use interactive mode `-it` and `bash`
      
      docker run -it -p 5901:5901 -p 6901:6901 mygrexit/docker-vnc-helden-software-container bash

## Usage with docker-compose

I prefer using docker-compose for my containers. I also use [**traefik**](https://github.com/traefik/traefik) which creates a reverse proxy and a basic authentication. Feel free to adjust it to your needs. Please note that I don't have any exposed ports in my example since it's proxied.

```
version: '3.1'

services:
  helden-software:
    image: mygrexit/docker-vnc-helden-software-container:latest
    container_name: helden_server
    restart: always
    volumes:
      - helden_data:/headless/helden/
    environment:
      - VNC_PW=vncpassword

    labels:
      - traefik.http.routers.helden-software.rule=Host(`helden.domain.com`)
      - traefik.http.routers.helden-software.tls=true
      - traefik.http.routers.helden-software.tls.certresolver=lets-encrypt
      - traefik.port=80
      - traefik.http.services.helden-software.loadbalancer.server.port=6901
      - traefik.http.routers.helden-software.middlewares=simpleAuth@file

    networks:
      web:

volumes:
   helden_data:
        external: true

networks:
    web:
      external: true
```

# Connect & Control
If the container is started like mentioned above, connect via one of these options:

* connect via __VNC viewer `localhost:5901`__, default password: `vncpassword`
* connect via __noVNC HTML5 full client__: [`http://localhost:6901/vnc.html`](http://localhost:6901/vnc.html), default password: `vncpassword` 
* connect via __noVNC HTML5 lite client__: [`http://localhost:6901/?password=vncpassword`](http://localhost:6901/?password=vncpassword) 




## Hints

### 1) Change User of running Container

Per default, since version `1.3.0` all container processes will be executed with user id `1000`. You can change the user id as follows: 

#### 1.1) Using root (user id `0`)
Add the `--user` flag to your docker run command:

    docker run -it --user 0 -p 6911:6901 mygrexit/docker-vnc-helden-software-container

#### 1.2) Using user and group id of host system
Add the `--user` flag to your docker run command:

    docker run -it -p 6911:6901 --user $(id -u):$(id -g) mygrexit/docker-vnc-helden-software-container

### 2) Override VNC environment variables
The following VNC environment variables can be overwritten at the `docker run` phase to customize your desktop environment inside the container:
* `VNC_COL_DEPTH`, default: `24`
* `VNC_RESOLUTION`, default: `1920x1080`
* `VNC_PW`, default: `my-pw`

#### 2.1) Example: Override the VNC password
Simply overwrite the value of the environment variable `VNC_PW`. For example in
the docker run command:

    docker run -it -p 5901:5901 -p 6901:6901 -e VNC_PW=my-pw mygrexit/docker-vnc-helden-software-container

#### 2.2) Example: Override the VNC resolution
Simply overwrite the value of the environment variable `VNC_RESOLUTION`. For example in
the docker run command:

    docker run -it -p 5901:5901 -p 6901:6901 -e VNC_RESOLUTION=800x600 mygrexit/docker-vnc-helden-software-container
    
### 3) View only VNC
Since version `1.2.0` it's possible to prevent unwanted control via VNC. Therefore you can set the environment variable `VNC_VIEW_ONLY=true`. If set, the startup script will create a random password for the control connection and use the value of `VNC_PW` for view only connection over the VNC connection.

     docker run -it -p 5901:5901 -p 6901:6901 -e VNC_VIEW_ONLY=true mygrexit/docker-vnc-helden-software-container

