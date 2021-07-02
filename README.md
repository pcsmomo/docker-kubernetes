# Docker & Kubernetes Summary

Docker &amp; Kubernetes: The Practical Guide by Maximilian Schwarzmüller

This repository is to summarize this long lecture and it would not include much code.

# Details

## Docker

<details open>
  <summary>Click to Contract/Expend</summary>

### 3. Why Docker & Containers?

Why would we want independent, standardized "application package"? \

- We want to have the **exact same environment for development and production** \
  -> This ensures that it works exactly as tested
- It should be easy to **share a common development environment**/ setup with (new) employees and colleagues
- We **don't want to uninstall and re-install** local dependencies and runtimes all the time

### 12. Installing & Configuring an IDE

Install Docker Extension on VS Code

### 13. Getting Our Hands Dirty!

```sh
docker build .

#=> writing image sha256:b41ebb6d624069022efc4835523b3a18a587eae911a4885dc1dc081b17b7511c
```

```sh
# docker run b41ebb6d624069022efc4835523b3a18a587eae911a4885dc1dc081b17b7511c
docker run -p 3000:3000 b41ebb6d624069022efc4835523b3a18a587eae911a4885dc1dc081b17b7511c
```

```sh
docker ps
#CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                                       NAMES
#d53a7b8732e8   b41ebb6d6240   "docker-entrypoint.s…"   2 minutes ago   Up 2 minutes   0.0.0.0:3000->3000/tcp, :::3000->3000/tcp   naughty_mayer
```

```sh
docker stop naughty_mayer
```

### 19. Using & Running External (Pre-Built) Images

1. Create

```sh
docker run node
# NodeJS offers an "interactive mode" where you can run basic Node commands (the "REPL"). That's what he's referring to.

# The history of docker Process Status
docker ps -a

# Dive into "node" container to interact
docker run -it node
```

### 21. Building our own Image with a Dockerfile

[Dockerfile reference](https://docs.docker.com/engine/reference/builder/)

### 22. Running a Container based on our own Image

#### To run Docker Image

1. Create Dockerfile and code
2. Create Docker image

```sh
docker build .
#=> => writing image sha256:d9c36df3c92ef2cb043b296a4341544fc68ff6235c1fea9cd8ec6a658817af2
```

3. Run the container based on the created image

```sh
docker run d9c36df3c92ef2cb043b296a4341544fc68ff6235c1fea9cd8ec6a658817af2
# http://localhost doesn't work

# -p : publish
# 3000 : Port I want to access
# 80 : Expose port on Dockerfile
docker run -p 3000:80 d9c36df3c92ef2cb043b296a4341544fc68ff6235c1fea9cd8ec6a658817af2
```

4. Stop the docker container

```sh
# See docker containers currently running without -a
docker ps

# quizzical_chandrasekhar is the given name
docker stop quizzical_chandrasekhar
```

[Docker run reference](https://docs.docker.com/engine/reference/run/)

### 25. Understanding Image Layers

#### Layer Based Architecture

When docker build . but only some code changed not package.json,

```sh
# Copy package.json before npm install
COPY package.json /app
# This won't be executed again unless package.json changes
RUN npm install
# This will be executed always
COPY . /app
```

### 29. Stopping & Restarting Containers

```sh
# help
docker --help
docker ps --help
```

```sh
# Running with the attached mode (foreground, listening)
# either Container ID or Name work
docker start -a nifty_archimedes
docker run -p 3000:80 25c8a7da66bd
```

```sh
# Running with the detached mode (background)
docker start nifty_archimedes
docker run -p 3000:80 -d 25c8a7da66bd
```

```sh
# Attaching to a container
docker attach nifty_archimedes
docker logs -f nifty_archimedes

# Showing logs of a detached container
docker logs nifty_archimedes
```

### 32. Entering Interactive Mode

```sh
# To interact with an utility application not web server
docker build .
# -i: interactive, -t: Allocate a pseudo-TTY
docker run -it 66b7c26c279eb426620747dbd8b25c5dd410a2161fbbc743e8db2bc7dafe9f2
# -a: attach, -i: interactive
docker start -ai priceless_tereshkova
```

### 33. Deleting Images & Containers

```sh
# remove docker containers
docker rm blissful_goodall
docker rm blissful_goodall nifty_archimedes romantic_grothendieck

# images list
docker images
# remove images and layers on the image
# It won't be deleted if there is any running/stopped container from the image
docker rmi 52bdb6aaae5a d9c36df3c92e
# remove all images
docker rmi prune
```

### 34. Removing Stopped Containers Automatically

```sh
# -p -rm : Automatically remove the container when it exits
docker run -p 3000:80 -d --rm 0b260664df6f
```

## 35. A Look Behind the Scenes: Inspecting Images

```sh
docker image inspect 66b7c26c279e
# Those layers are based on Docker file commands and the original image on FROM
```

## 36. Copying Files Into & From A Container

Use case \
: copying out the latest log files from the running container

```sh
docker cp dummy/. thirsty_yalow:/test
rm dummy/test.txt
docker cp thirsty_yalow:/test dummy/.
docker cp thirsty_yalow:/test/test.txt dummy/.
```

### 37. Naming & Tagging Containers and Images

```sh
# naming containers
docker run -p 3000:80 -d -rm --name goalsapp 0b260664df6f

# naming & tagging images (NAME:TAG)
docker build -t goals:latest .

# test running
docker run -p 3000:80 -d --rm --name goalsapp goals:latest
```

### 38. Time to Practice: Images & Containers 1 question

> Maximilian clarified the version/tag of node and python on Dockerfile.
> FROM node:14
> FROM python:3.7
> That looks better for sure.

### 40. Pushing Images to DockerHub

```sh
# docker build -t pcsmomo/node-hello-world .
docker tag goals:latest pcsmomo/node-hello-world
# it clones from the old image

docker push pcsmomo/node-hello-world
# access denided

docker login
docker push pcsmomo/node-hello-world
# it pushes exclude libraries existed on docker hub
```

### 41. Pulling & Using Shared Images

```sh
# remove all images, except images related to running containers
docker image prune -a

docker pull pcsmomo/node-hello-world
docker run -p 3000:80 --rm pcsmomo/node-hello-world

docker rmi pcsmomo/node-hello-world
docker run -p 3000:80 --rm pcsmomo/node-hello-world
# If the image doesn't exist on local, it will reach to the hub automatically
```

> **⚠ Warning: It will find locally first even if the latest version is on the hub**

### 46. Understanding Data Categories / Different Kinds of Data

#### Docker Data

- Application : Read-only, stored in Images
- Temporary App Data : Read + Writ, temporary, stored in Containers
  - e.g. entered user input
- Permanent App Data : Read + Writ, permanent, stored in Containers & Volumes
  - e.g. user accounts

### 48. Building & Understanding the Demo App

```sh
docker build -t feedback-node .
docker run -p 3000:80 -d --name feedback-app --rm feedback-node
```

After writing a feedback \
http&#58;//localhost:3000/feedback/awesome.txt \
-> awesome.txt is saved on the container only

### 49. Understanding the Problem

```sh
docker stop feedback-app
# the container is deleted now due to --rm flag

docker run -p 3000:80 -d --name feedback-app feedback-node
```

http&#58;//localhost:3000/feedback/awesome.txt \
-> Can't reach awesome.txt because it's removed when the container deleted.

```sh
docker stop feedback-app
docker start feedback-app
```

http&#58;//localhost:3000/feedback/awesome.txt \
-> awesome.txt exists

### 50. Introducing Volumes

**Volumes** are **folders on my host machine** hard drive which are **mounted**
(“made available”, mapped) **into containers**

```sh
# Remove the old container and create a new container

docker build -t feedback-node:volumes .

docker stop feedback-app
docker rm feedback-app

docker run -p 3000:80 -d --name feedback-app --rm feedback-node:volumes
```

http&#58;//localhost:3000 \
-> It won't save the file because cross-device error

```sh
# Remove the old image and create a new image

docker logs feedback-app
# UnhandledPromiseRejectionWarning: Error: EXDEV: cross-device link not permitted, rename '/app/temp/awesome.txt' -> '/app/feedback/awesome.txt'

docker stop feedback-app
docker rmi feedback-app

# Fix server.js and rebuild the container
docker build -t feedback-node:volumes .
docker run -p 3000:80 -d --name feedback-app --rm feedback-node:volumes
```

http&#58;//localhost:3000 -> Submit awesome feedback again

```sh
# Kill the old container(--rm) and run a new container
docker stop feedback-app
docker run -p 3000:80 -d --name feedback-app --rm feedback-node:volumes
```

http&#58;//localhost:3000/feedback/awesome.txt \
-> WTF? still awesome.txt doesn't exist

### 52. Named Volumes To The Rescue!

![Two Types of External Data Storages](resources/03_two-types-of-external-data-storages.jpg 'Two Types of External Data Storages')

> Anonymous Volumes will be **removed automatically**, when the container started with --rm, was stopped(and removed). \
> However, if a container is started **without --rm**, the anonymous volume would **NOT be removed**, even if you remove the container. \
> And **a new anonymous volume will be created**, when docker is re-created and re-run

```sh
# Check and delete the Anonymous Volume
docker volume --help
docker volume ls
# DRIVER    VOLUME NAME
# local     4919100018b2e0443ff8933050148acb34801a0a98769d6af084879fce152936
docker stop feedback-app
docker volume ls
# the volume has been removed
```

Delete VOLUME on Dockerfile

```sh
docker rmi feedback-node:volumes
# Use a Named Volume : It is not attached to a container
# -v [volume name]:[container-internal path]
docker build -t feedback-node:volumes .
docker run -d -p 3000:80 --rm --name feedback-app -v feedback:/app/feedback feedback-node:volumes
```

http&#58;//localhost:3000 -> Submit awesome feedback again

```sh
# Stop/remove the container and run a new container
docker stop feedback-app
docker volume ls
# DRIVER    VOLUME NAME
# local     feedback
docker run -d -p 3000:80 --rm --name feedback-app -v feedback:/app/feedback feedback-node:volumes
```

http&#58;//localhost:3000/feedback/awesome.txt -> Ta-da

### 54. Getting Started With Bind Mounts (Code Sharing)

```sh
# add "-v [absolute path of local machine]:[container-internal path]"
# This option is for a developer mode to reflect changes rapidly.

# it will clash and remove the container.
docker run -d -p 3000:80 --rm --name feedback-app -v feedback:/app/feedback -v "/Users/noah/Documents/Study/Study_devops/udemy/docker-kubernetes/docker-kubernetes-git/03_data-volumes/03_data-volumes-01":/app feedback-node:volumes

# without --rm, it will still clash.
docker run -d -p 3000:80 --name feedback-app -v feedback:/app/feedback -v "/Users/noah/Documents/Study/Study_devops/udemy/docker-kubernetes/docker-kubernetes-git/03_data-volumes/03_data-volumes-01":/app feedback-node:volumes
# or docker run -d -p 3000:80 --name feedback-app -v feedback:/app/feedback -v pwd:/app feedback-node:volumes

docker ps -a
docker logs feedback-app
# Error: Cannot find module 'express'
```

### 56. Combining & Merging Different Volumes

```sh
# add "v /app/node_modules" -> Connected to an anonymous volume
# equivalent to "VOLUME [ "/app/node_modules" ]" on Dockerfile
docker run -d -p 3000:80 --rm --name feedback-app -v feedback:/app/feedback -v "/Users/noah/Documents/Study/Study_devops/udemy/docker-kubernetes/docker-kubernetes-git/03_data-volumes/03_data-volumes-01":/app -v /app/node_modules feedback-node:volumes
```

If feedback.html on local changes, it will display on the browser.

### 57. A NodeJS-specific Adjustment: Using Nodemon in a Container

After changing package.json and Dockerfile

```sh
docker rmi feedback-node:volumes
docker build -t feedback-node:volumes .
docker run -d -p 3000:80 --rm --name feedback-app -v feedback:/app/feedback -v "/Users/noah/Documents/Study/Study_devops/udemy/docker-kubernetes/docker-kubernetes-git/03_data-volumes/03_data-volumes-01":/app -v /app/node_modules feedback-node:volumes
docker run -d -p 3000:80 --rm --name feedback-app -v feedback:/app/feedback -v pwd:/app -v /app/node_modules feedback-node:volumes
```

Change server.js

http&#58;//localhost:3000 -> Submit awesome feedback again

```sh
docker logs feedback-app
```

### 58. Volumes & Bind Mounts: Summary

We have used all different approaches

- docker run –v /app/data ... : Anonymous Volume
- docker run –v [volume name]:/app/data ... : Named Volume
- docker run –v [physical path]:/app/data ... : Bind Mount

### 60. A Look at Read-Only Volumes

```sh
# add ":ro" -> Docker container can't write on this volume
# connect /app/temp to an anonymous volume
docker run -d -p 3000:80 --rm --name feedback-app -v feedback:/app/feedback -v "/Users/noah/Documents/Study/Study_devops/udemy/docker-kubernetes/docker-kubernetes-git/03_data-volumes/03_data-volumes-01":/app:ro -v /app/temp -v /app/node_modules feedback-node:volumes
```

### 61. Managing Docker Volumes

```sh
docker volume create --help
docker volume create feedback-files
docker volume inspect feedback
# "Mountpoint": "/var/lib/docker/volumes/feedback/_data"
# The path is inside of the virtual machine docker created

docker volume rm feedback-files
```

## 62. Using "COPY" vs Bind Mounts

-v [absolute path of local machine]:[container-internal path]

> Bind Mounts option is for a developer mode to reflect changes rapidly. \
> Better keep "COPY" in Dockerfile, so it creates a snapshot in the production

## 65. Working with Environment Variables & ".env" Files

```sh
# Using ENV from Dockerfile
docker build -t feedback-node:env .
docker run -d --rm -p 3000:80 --name feedback-app -v feedback:/app/feedback -v "/Users/noah/Documents/Study/Study_devops/udemy/docker-kubernetes/docker-kubernetes-git/03_data-volumes/03_data-volumes-01:/app:ro" -v /app/temp -v /app/node_modules feedback-node:env

# Using runtime ENVironment variables
# --env or -e
docker run -d --rm -p 3000:8000 --env PORT=8000 --name feedback-app -v feedback:/app/feedback -v "/Users/noah/Documents/Study/Study_devops/udemy/docker-kubernetes/docker-kubernetes-git/03_data-volumes/03_data-volumes-01:/app:ro" -v /app/temp -v /app/node_modules feedback-node:env

docker run -d --rm -p 3000:8000 -e PORT=8000 --name feedback-app -v feedback:/app/feedback -v "/Users/noah/Documents/Study/Study_devops/udemy/docker-kubernetes/docker-kubernetes-git/03_data-volumes/03_data-volumes-01:/app:ro" -v /app/temp -v /app/node_modules feedback-node:env

# Using .env file
docker run -d --rm -p 3000:8000 --env-file ./.env --name feedback-app -v feedback:/app/feedback -v "/Users/noah/Documents/Study/Study_devops/udemy/docker-kubernetes/docker-kubernetes-git/03_data-volumes/03_data-volumes-01:/app:ro" -v /app/temp -v /app/node_modules feedback-node:env
```

## 66. Environment Variables & Security

> **⚠ Warning: ENV on Dockerfile can be exposed through "docker history \<image\>"** \
> For credentials and private keys, use .env and do not commit to github.

### 67. Using Build Arguments (ARG)

```sh
# Using Dockerfile
docker build -t feedback-node:web-app .
# Manipulate ARG on Dockerfile
docker build -t feedback-node:dev --build-arg DEFAULT_PORT=8000 .
```

## 75. Creating a Container & Communicating to the Web (WWW)

```sh
docker build -t favorites-node .
# it clasehs as it can't connect 'mongodb://localhost:27017/swfavorites'
docker run --name favorites -d --rm -p 3000:3000 favorites-node
docker run --name favorites --rm -p 3000:3000 favorites-node

# comment the mongoose part on app.js
docker run --name favorites -d --rm -p 3000:3000 favorites-node
```

http&#58;//localhost:3000/movies -> works \
http&#58;//localhost:3000/people -> works

### 76. Making Container to Host Communication Work

Change localhost to "host.docker.internal" on app.js \
Re build the image and run \
http&#58;//localhost:3000/favorites -> works if mongodb is installed on the host machine

### 77. Container to Container Communication: A Basic Solution

```sh
docker run mongo
docker run -d --name mongodb mongo
docker container inspect mongodb
# "IPAddress": "172.17.0.2",

# Change "host.docker.internal" to "172.17.0.2" on app.js
docker build -t favorites-node .
docker run --name favorites -d --rm -p 3000:3000 favorites-node

# Now two containers are running
docker ps
```

Run Postman and send data

```json
// http://localhost:3000/favorites
// Method : Post
// Body -> Raw, JSON
{
  "name": "A New Hope",
  "type": "movie",
  "url": "http://swapi.dev/api/films/1/"
}
```

http&#58;//localhost:3000/favorites -> works

### 78. Introducing Docker Networks: Elegant Container to Container Communication

```sh
# Create a new network
docker stop favorites
docker stop mongodb
docker container prune

docker run -d --name mongodb --network favorites-net mongo
# docker: Error response from daemon: network favorites-net not found.

docker network --help
docker network create favorites-net
# with --network
# it doesn't need -p flag
docker rm mongodb
docker run -d --name mongodb --network favorites-net mongo

# Change "172.17.0.2" to "mongodb" on app.js
# If both are the name network, using the container name, "mongodb" works
docker build -t favorites-node .
docker run --name favorites --network favorites-net -d --rm -p 3000:3000 favorites-node
```

### 86. Dockerizing the MongoDB Service

```sh
docker run --name mongodb --rm -d -p 27017:27017 mongo
```

### 87. Dockerizing the Node App

```sh
backend % docker build -t goals-node .
backend % docker run --name goals-backend --rm -d -p 80:80 goals-node
```

</details>

---

## What I have learned from this course

-

## Next Step

-
