# Docker & Kubernetes Summary

Docker &amp; Kubernetes: The Practical Guide by Maximilian Schwarzmüller

This repository is to summarize this long lecture and it would not include much code.

## Details

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
http://localhost:3000/feedback/awesome.txt \
-> awesome.txt is saved on the container only

### 49. Understanding the Problem

```sh
docker stop feedback-app
# the container is deleted now due to --rm flag

docker run -p 3000:80 -d --name feedback-app feedback-node
```

http://localhost:3000/feedback/awesome.txt \
-> Can't reach awesome.txt because it's removed when the container deleted.

```sh
docker stop feedback-app
docker start feedback-app
```

http://localhost:3000/feedback/awesome.txt \
-> awesome.txt exists

### 50. Introducing Volumes

**Volumes** are **folders on my host machine** hard drive which are **mounted** (“made available”, mapped) **into containers**

</details>

---

## What I have learned from this course

-

## Next Step

-

```

```
