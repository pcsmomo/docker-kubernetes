# Docker & Kubernetes Summary

Docker &amp; Kubernetes: The Practical Guide by Maximilian Schwarzmüller

This repository is to summarize this long lecture and it would not include much code.

Docker version 20.10.7, build f0df350

# Details

## Docker

<details>
  <summary>Click to Contract/Expend</summary>

### 3. Why Docker & Containers?

Why would we want an independent, standardized "application package"? \

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

### 28. Stopping & Restarting Containers

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

### 31. Entering Interactive Mode

```sh
# To interact with an utility application not web server
docker build .
# -i: interactive, -t: Allocate a pseudo-TTY
docker run -it 66b7c26c279eb426620747dbd8b25c5dd410a2161fbbc743e8db2bc7dafe9f2
# -a: attach, -i: interactive
docker start -ai priceless_tereshkova
```

### 32. Deleting Images & Containers

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

### 33. Removing Stopped Containers Automatically

```sh
# -p -rm : Automatically remove the container when it exits
docker run -p 3000:80 -d --rm 0b260664df6f
```

## 34. A Look Behind the Scenes: Inspecting Images

```sh
docker image inspect 66b7c26c279e
# Those layers are based on Docker file commands and the original image on FROM
```

## 35. Copying Files Into & From A Container

Use case \
: copying out the latest log files from the running container

```sh
docker cp dummy/. thirsty_yalow:/test
rm dummy/test.txt
docker cp thirsty_yalow:/test dummy/.
docker cp thirsty_yalow:/test/test.txt dummy/.
```

### 36. Naming & Tagging Containers and Images

```sh
# naming containers
docker run -p 3000:80 -d -rm --name goalsapp 0b260664df6f

# naming & tagging images (NAME:TAG)
docker build -t goals:latest .

# test running
docker run -p 3000:80 -d --rm --name goalsapp goals:latest
```

### Asgmt. Time to Practice: Images & Containers 1 question

> Maximilian clarified the version/tag of node and python on Dockerfile.
> FROM node:14
> FROM python:3.7
> That looks better for sure.

### 38. Pushing Images to DockerHub

```sh
# docker build -t pcsmomo/node-hello-world .
docker tag goals:latest pcsmomo/node-hello-world
# it clones from the old image

docker push pcsmomo/node-hello-world
# access denided

docker login
docker push pcsmomo/node-hello-world
# it pushes exclude libraries that existed on docker hub
```

### 39. Pulling & Using Shared Images

```sh
# remove all images, except images related to running containers
docker image prune -a

docker pull pcsmomo/node-hello-world
docker run -p 3000:80 --rm pcsmomo/node-hello-world

docker rmi pcsmomo/node-hello-world
docker run -p 3000:80 --rm pcsmomo/node-hello-world
# If the image doesn't exist on local, it will reach the hub automatically
```

> **⚠ Warning: It will find locally first even if the latest version is on the hub**

### 43. Understanding Data Categories / Different Kinds of Data

#### Docker Data

- Application: Read-only, stored in Images
- Temporary App Data: Read + Write, temporary, stored in Containers
  - e.g. entered user input
- Permanent App Data: Read + Write, permanent, stored in Containers & Volumes
  - e.g. user accounts

### 45. Building & Understanding the Demo App

```sh
docker build -t feedback-node .
docker run -p 3000:80 -d --name feedback-app --rm feedback-node
```

After writing a feedback \
http&#58;//localhost:3000/feedback/awesome.txt \
-> awesome.txt is saved on the container only

### 46. Understanding the Problem

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
-> It won't save the file because a cross-device error

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

### 49. Named Volumes To The Rescue!

![Two Types of External Data Storages](resources/03_two-types-of-external-data-storages.jpg 'Two Types of External Data Storages')

> Anonymous Volumes will be **removed automatically**, when the container started with --rm, was stopped(and removed). \
> However, if a container is started **without --rm**, the anonymous volume would **NOT be removed**, even if you remove the container. \
> And **a new anonymous volume will be created** when docker is re-created and re-run

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

### 51. Getting Started With Bind Mounts (Code Sharing)

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

### 53. Combining & Merging Different Volumes

```sh
# add "v /app/node_modules" -> Connected to an anonymous volume
# equivalent to "VOLUME [ "/app/node_modules" ]" on Dockerfile
# -v /app/node_modules : Then /app folder will not overwrite them
docker run -d -p 3000:80 --rm --name feedback-app -v feedback:/app/feedback -v "/Users/noah/Documents/Study/Study_devops/udemy/docker-kubernetes/docker-kubernetes-git/03_data-volumes/03_data-volumes-01":/app -v /app/node_modules feedback-node:volumes
```

If feedback.html on local changes, it will display on the browser.

### 54. A NodeJS-specific Adjustment: Using Nodemon in a Container

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

### 55. Volumes & Bind Mounts: Summary

We have used all different approaches

- docker run –v /app/data ... : Anonymous Volume
- docker run –v [volume name]:/app/data ... : Named Volume
- docker run –v [physical path]:/app/data ... : Bind Mount

### 56. A Look at Read-Only Volumes

```sh
# add ":ro" -> Docker container can't write on this volume
# connect /app/temp to an anonymous volume
docker run -d -p 3000:80 --rm --name feedback-app -v feedback:/app/feedback -v "/Users/noah/Documents/Study/Study_devops/udemy/docker-kubernetes/docker-kubernetes-git/03_data-volumes/03_data-volumes-01":/app:ro -v /app/temp -v /app/node_modules feedback-node:volumes
```

### 57. Managing Docker Volumes

```sh
docker volume create --help
docker volume create feedback-files
docker volume inspect feedback
# "Mountpoint": "/var/lib/docker/volumes/feedback/_data"
# The path is inside of the virtual machine docker created

docker volume rm feedback-files
```

## 58. Using "COPY" vs Bind Mounts

-v [absolute path of local machine]:[container-internal path]

> Bind Mounts option is for a developer mode to reflect changes rapidly. \
> Better keep "COPY" in Dockerfile, so it creates a snapshot in the production

## 61. Working with Environment Variables & ".env" Files

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

## 62. Environment Variables & Security

> **⚠ Warning: ENV on Dockerfile can be exposed through "docker history \<image\>"** \
> For credentials and private keys, use .env and do not commit to github.

### 63. Using Build Arguments (ARG)

```sh
# Using Dockerfile
docker build -t feedback-node:web-app .
# Manipulate ARG on Dockerfile
docker build -t feedback-node:dev --build-arg DEFAULT_PORT=8000 .
```

## 71. Creating a Container & Communicating to the Web (WWW)

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

### 72. Making Container to Host Communication Work

Change localhost to "host.docker.internal" on app.js \
Re build the image and run \
http&#58;//localhost:3000/favorites -> works if mongodb is installed on the host machine

### 73. Container to Container Communication: A Basic Solution

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

### 74. Introducing Docker Networks: Elegant Container to Container Communication

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

### 81. Dockerizing the MongoDB Service

MongoDB Server

```sh
docker run --name mongodb --rm -d -p 27017:27017 mongo
```

### 82. Dockerizing the Node App

Backend Server

```sh
backend % docker build -t goals-node .
backend % docker run --name goals-backend --rm -d -p 80:80 goals-node
```

### 83. Moving the React SPA into a Container

Frontend Server

```sh
frontend % docker build -t goals-react .

# it will stop the server
frontend % docker run --name goals-frontend --rm -d -p 3000:3000 goals-react

# add -it -> -i: interactive, -t: Allocate a pseudo-TTY
# React project should run with -it flag
frontend % docker run --name goals-frontend --rm -d -p 3000:3000 -it goals-react
```

### 84. Adding Docker Networks for Efficient Cross-Container Communication

```sh
docker network create goals-net

# MongoDB Server
# We no longer need to publish ports
docker run --name mongodb --rm -d --network goals-net mongo

# Backend Server not publishing 80 port
# Need to fix app.js to use the mongodb container name
backend % docker build -t goals-node .
backend % docker run --name goals-backend --rm -d --network goals-net goals-node

# Frontend Server
# NO need to fix App.js to use the goals-backend container name
# Because it is working on the browser so it still needs to use localhost
frontend % docker run --name goals-frontend --rm -d -p 3000:3000 -it goals-react

# Bakenc Server publishing the port
backend % docker run --name goals-backend --rm -d -p 80:80 --network goals-net goals-node
```

### 85. Adding Data Persistence to MongoDB with Volumes

[Mongo Docker Official Image](https://hub.docker.com/_/mongo)

[Mongo DB Connection String URI Format](https://docs.mongodb.com/manual/reference/connection-string/)

```sh
# create data volume to connect mongodb data
docker run --name mongodb -v data:/data/db --rm -d --network goals-net mongo

# Add Authentication
docker stop mongodb
docker volume rm data
docker run --name mongodb -v data:/data/db --rm -d --network goals-net -e MONGO_INITDB_ROOT_USERNAME=noah -e MONGO_INITDB_ROOT_PASSWORD=secret mongo

# Add MongoDB authentication data to app.js and rebuild the backend server
backend % docker build -t goals-node .
backend % docker run --name goals-backend --rm -d -p 80:80 --network goals-net goals-node
```

### 86. Volumes, Bind Mounts & Polishing for the NodeJS Container

```sh
# Add nodemon
backend % docker build -t goals-node .

# create logs volume to connect /app/logs
# the longer path has precedence than shorter path : /app/logs > /app
# -v /app/node_modules : Then /app folder will not overwrite them
backend % docker run --name goals-backend -v "/Users/noah/Documents/Study/Study_devops/udemy/docker-kubernetes/docker-kubernetes-git/05_docker_multi/backend:/app" -v logs:/app/logs -v /app/node_modules --rm -d -p 80:80 --network goals-net goals-node
```

```sh
# Add ENV MONGODB_USERNAME and ENV MONGODB_PASSWORD to Dockerfile
backend % docker build -t goals-node .

# add -e MONGODB_USERNAME=noah
# it will overwrite MONGODB_USERNAME from Dockerfile
backend % docker run --name goals-backend -v "/Users/noah/Documents/Study/Study_devops/udemy/docker-kubernetes/docker-kubernetes-git/05_docker_multi/backend:/app" -v logs:/app/logs -v /app/node_modules -e MONGODB_USERNAME=noah --rm -d -p 80:80 --network goals-net goals-node
```

### 87. Live Source Code Updates for the React Container (with Bind Mounts)

```sh
frontend % docker run --name goals-frontend \
  -v /Users/noah/Documents/Study/Study_devops/udemy/docker-kubernetes/docker-kubernetes-git/05_docker_multi/frontend/src:/app/src  \
  --rm  \
  -d  \
  -p 3000:3000  \
  -it  \
  goals-react
```

### 93. Diving into the Compose File Configuration

[Docker Compose](https://docs.docker.com/compose/)

[Compose file version 3 reference](https://docs.docker.com/compose/compose-file/compose-file-v3/)

### 95. Docker Compose Up & Down

```sh
docker image prune -a

docker-compose up
# detached mode
docker-compose up -d

# removing containers and networks
docker-compose down
# including volumes
docker-compose down -v
```

### 96. Working with Multiple Containers

```sh
docker-compose up -d
docker-compose down
```

> The services were created under the name "05_docker_multi_backend_1" and"05_docker_multi_mongodb_1" \
> The backend server, 'mongodb://mongodb:27017/course-goals' is connecting to mongodb not to 05_docker_multi_mongodb_1 \
> As we create the service name, mongodb on docker-compose.yaml, it works just fine.

### 97. Adding Another Container

✅ MongoDB + Node Backend Server + React (create-react-app) Server, succeeded

```sh
docker-compose up -d
# Creating network "05_docker_multi_default" with the default driver
# Creating 05_docker_multi_mongodb_1 ... done
# Creating 05_docker_multi_backend_1 ... done
# Creating 05_docker_multi_frontend_1 ... done

docker-compose down
```

### 98. Building Images & Understanding Container Names

```sh
# it only builds but doesn't start containers
docker-compose build
```

### 103. Different Ways of Running Commands in Containers

```sh
# a long process... to use only "npm init"
docker run -it -d node
docker exec friendly_mendel node -v
docker exec -it friendly_mendel npm init
# it will create package.json, but inside the container
docker stop friendly_mendel
docker container rm friendly_mendel

# Make the process short
docker run -it node npm init
```

### 104. Building a First Utility Container

```sh
docker build -t node-util .
docker run -it -v /Users/noah/Documents/Study/Study_devops/udemy/docker-kubernetes/docker-kubernetes-git/06_docker_utility-container:/app node-util npm init
# package.json is crated on the local host machine
```

### 105. Utilizing ENTRYPOINT

```sh
docker build -t mynpm .
docker run -it -v /Users/noah/Documents/Study/Study_devops/udemy/docker-kubernetes/docker-kubernetes-git/06_docker_utility-container:/app mynpm init
docker run -it -v /Users/noah/Documents/Study/Study_devops/udemy/docker-kubernetes/docker-kubernetes-git/06_docker_utility-container:/app mynpm install express --save
```

### 106. Using Docker Compose

```sh
docker-compose run --rm npm-container init
```

### 112. Adding a Nginx (Web Server) Container

[Nginx Docker Hub](https://hub.docker.com/_/nginx)

### 113. Adding a PHP Container

[PHP Docker Hub](https://hub.docker.com/_/php)

[php dockerfile](https://github.com/docker-library/php/blob/master/7.3/alpine3.13/fpm/Dockerfile)

### 114. Adding a MySQL Container

[MySQL Docker Hub](https://hub.docker.com/_/mysql)

homestead is laravel's default database name

### 115. Adding a Composer Utility Container

[Composer Docker Hub](https://hub.docker.com/_/composer)

### 116. Creating a Laravel App via the Composer Utility Container

[Laravel installation via composer](https://laravel.com/docs/8.x/installation#installation-via-composer)

```sh
docker-compose run --rm composer create-project laravel/laravel .
```

### 118. Launching Only Some Docker Compose Services

```sh
docker-compose up --help
# Usage: up [options] [--scale SERVICE=NUM...] [--] [SERVICE...]

docker-compose up -d server php mysql
# nginx server is exited
docker logs 07_docker_laravel-php_server_1
# nginx: [emerg] "server" directive is not allowed here in /etc/nginx/nginx.conf:1

# fix docker-compose.yaml
docker-compose down
docker-compose up -d server php mysql

# add dependencies on docker-compose.yaml
docker-compose down
docker-compose up -d server
# this is working correctly
# but it will not rebuild images if the images exist

# add --build
# It will be quick as it is using cached one from the layer
docker-compose down
docker-compose up -d --build server
```

Add h1 tag on "src/resources/views/welcome.blade.php" to test. \
http&#58;//localhost:8000 -> h1 tag appears

### 119. Adding More Utility Containers

```sh
# database migration? create tables
docker-compose run --rm artisan migrate
```

### 121. Bind Mounts and COPY: When To Use What

```sh
docker-compose down
docker-compose up -d --build server
# http://localhost:8000 -> Permission denied

# add the permision on php.dockerfile
docker-compose down
docker-compose up -d --build server
```

### 122. Module Resources

addgroup laravel and adduser laravel

### Laravel & PHP Commands Summary

✅ Nginx + PHP + MySQL, All Servers Succeeded

✅ Composer + Artisan (+ NPM), All Utility Containers Succeeded

```sh
# 1. Create a laravel project to /src
docker-compose run --rm composer create-project laravel/laravel .

# 2. Change database variables on /src/.env file
DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=homestead
DB_USERNAME=homestead
DB_PASSWORD=secret

# 3. Run servers
docker-compose up -d --build server

# 4. Migrate the database (Why does it need?)
docker-compose run --rm artisan migrate
# ERROR: Service 'artisan' failed to build : The command '/bin/sh -c docker-php-ext-install pdo pdo_mysql' returned a non-zero code: 11
# Failed at the first attempt
# probably a permission issue?

docker-compose run --rm artisan migrate
# Migration table created successfully.

# 5. Clean up
docker-compose down
docker volume rm [volumes]
(docker network rm [networks])
docker image rm [images]
```

</details>

## Docker Deployment

<details>
  <summary>Click to Contract/Expend</summary>

### 125. Deployment Process & Providers

Deploy to AWS EC2

1. Create and launch EC2 instance, VPC, and security group
2. Configure security group to expose all required ports to WWW
3. Connect to instance (SSH), install Docker, and run the container

### 126. Getting Started With An Example

```sh
docker build -t node-dep-example .
docker run -d --rm --name node-dep -p 80:80 node-dep-example
```

### 129. Connecting to an EC2 Instance

1. Go to AWS EC2
2. Launch Instance
3. Select Amazon Linux 2 AMI
4. Choose all default options.
5. Create new key pairs file -> save it as "example-1.cer" on my local machine
6. Launch

On Instance

1. Click Connect
2. Choose SSH Client and follow the steps
3. chmod 400 example-1.cer
4. sudo ssh -i "example-1.cer" ec2-user@ec2-[X-XX-XXX-XX].ap-southeast-2.compute.amazonaws.com (IP address is different when restarted)

### 130. Installing Docker on a Virtual Machine

```sh AWS
sudo yum update -y
sudo amazon-linux-extras install docker
sudo service docker start
```

### 132. Pushing our local Image to the Cloud

```sh
docker build -t node-dep-example-1-aws .
docker tag node-dep-example-1-aws pcsmomo/node-example-1-aws
docker login
docker push pcsmomo/node-example-1-aws
```

### 133. Running & Publishing the App (on EC2)

```sh AWS
sudo docker run -d --rm -p 80:80 pcsmomo/node-example-1-aws
```

http&#58;//3.26.113.49/ -> This site can't be reached \

Allow HTTP from Security Group on AWS

1. EC2 -> My Instance running -> Security -> Select the Security groups
2. Add inbound rules, HTTP from anywhere

http&#58;//3.26.113.49/ -> Works

### 134. Managing & Updating the Container / Image

```sh
# Change source codes
docker build -t node-dep-example-1-aws .
docker tag node-dep-example-1-aws pcsmomo/node-example-1-aws
docker push pcsmomo/node-example-1-aws
```

```sh AWS
sudo docker pull pcsmomo/node-example-1-aws
sudo docker run -d --rm -p 80:80 pcsmomo/node-example-1-aws
```

---

### 138. Deploying with AWS ECS: A Managed Docker Container Service

1. Connect AWS ECS (Elastic Container Service) and Click Get Started
2. Container definition -> Custom-app -> Configure
   - (This configuration is docker run [options])
   - Container name: node-demo (--name)
   - image: pcsmomo/node-example-1-aws
   - Port mappings: 80 (-p 80:80)
   - Environment - Entry Point, Command, Working directory, and Environment variables
   - Storage and Logging
     - Storage is equivalent to (-v)
     - Check on Log configuration to see logs
3. Task definition
   - Compatibilities FARGATE (Serverless, it runs only when it is executed, cost-effective)
4. Service: we could set up Load Balancer, but not now
5. Cluster: multiple containers would run in this same Cluster
6. Create!
7. View Service -> tasks -> click running task -> find the Public IP and go!

### 140. Updating Managed Containers

```sh
# Change source codes
docker build -t node-dep-example-1-aws .
docker tag node-dep-example-1-aws pcsmomo/node-example-1-aws
docker push pcsmomo/node-example-1-aws
```

1. ECS -> Cluster -> default -> Tasks -> click running task definition (not task)
2. Create new revision -> Create -> Action -> Update Service -> Skip to review -> Update Service
3. Service -> Tasks -> New task with status Provisioning, Penging, Running \
   The first task will be removed automatically
4. Click the new task -> Find the Public IP and go! (different IP though)

[Adding a Load Balancer to a Fargate task](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/service-load-balancing.html)

---

### 141. Preparing a Multi-Container App

The backend and MongoDB Containers are not in the same docker network \
But when they are in the same cluster on ECS, they can use localhost. \
@mongodb:27017/ -> @${process.env.MONGODB_URL}:27017/

Set up MONGODB_URL=mongodb on local as compose service name is mongodb \
And separately set up MONGODB_URL variable on AWS ECS.

```sh
docker build -t goals-node ./backend
docker tag goals-node pcsmomo/goals-node
docker push pcsmomo/goals-node
```

### 142. Configuring the NodeJS Backend Container

1. Create Cluster
   1. AWS ECS -> Cluster -> Create Cluster
   2. Networking Only -> Next
      - Cluster Name: goals-app
      - Create VPC: check (Take a memo of name of VPC)
      - Create, it takes a couple of minutes
      - View Cluster
2. Create Tasks first (Services are based on tasks)
   1. AWS ECS -> Task Definitions -> Create new Task Definition
   2. FARGATE -> Next Step
      - Task Definition Name: goals
      - Task Role : ecsTaskExecutionRole
      - Task Memory : 0.5GB (The smallest one)
      - Task CPU : 0.25 vCPU (The smallest one)
      - Add container
        - container name: goals-backend
        - image: pcsmomo/goals-node
        - Port mappings: 80
        - Environment
          - (Because the Dockerfile is using "npm start" to use nodemon for the developer mode.)
          - command: node, app.js
          - Environment variables
            - MONGODB_USERNAME=max
            - MONGODB_PASSWORD=secret
            - MONGODB_URL=localhost
        - Add
      - Add container
        - container name: mongodb
        - image: mongo
        - Port mappings: 27017
        - Environment
          - Environment variables
            - MONGO_INITDB_ROOT_USERNAME=max
            - MONGO_INITDB_ROOT_PASSWORD=secret
   3. Create
3. Create Service
   1. AWS ECS -> Cluster -> Services -> Create : Configure service
      - Launch type: FARGATE
      - Task Definition: goals
      - Service name: goals-service
      - Number of tasks: 1
      - Next Step
   2. Configure network
      - Cluster VPC: choose the one when the cluster created (vpc-0803a9dc38bf99d7e (10.0.0.0/16))
      - Subnets: Choose both subnets available (ap-southeast-2a, ap-southeast-2b)
      - Auto-assign public IP: ENABLED
      - Load balancer type: Application Load Balancer (No load balancer is found)
      - Click EC2 Console to create a load balancer
        1. Application Load Balancer, Configure
           - Name: ecs-lb
           - VPC: choose the same VPC (vpc-0803a9dc38bf99d7e (10.0.0.0/16))
           - Availability Zones: check both (ap-southeast-2a, ap-southeast-2b)
           - Next: Configure Security Settings
        2. Configure Security Settings : Basic (As we are not using HTTPS now)
        3. (Changed)Configure Security Groups : check both default and goals--xxxx (This opens port 80 to incoming traffic)
        4. Configure Routing
           - Name: tg
           - Target type: IP
           - (Changed)Health checkes
             - Protocol: HTTP
             - Path: /goals
        5. Register Targets: As is, ECS is automatically registering targets here.
        6. Next: Review -> Create
      - Refresh Load balancer name and choose ecs-lb
      - Container name : port : goals-backend:80:80 -> Add to load balancer
        - target group name: tg
      - Next step
   3. Set Auto Scaling (optional) : Do not adjust the service’s desired count
   4. Review -> Create Service

Clusters -> goals-app -> Tasks -> Click the running task -> Two Containers are pending -> Runnings -> Connect to the Public IP 13.211.219.9

http&#58;//13.211.219.9 -> This site can’t be reached 13.211.219.9 refused to connect. \
The lecture said the load balancer is not configured correctly. See the next lecture.

### 144. Using a Load Balancer for a Stable Domain

AWS EC2 -> Load Balancers -> ecs-lb -> DNS name (This is the endpoint) \
But still can't reach it. Something was wrong with the target group.

Clusters -> goals-app -> Tasks -> Stopped \
You can see some stopped tasks. It means something went wrong, so the load balancer is recreating the tasks. (another meaning is that the load balancer works fine)

1. AWS EC2 -> Target Groups -> tg (the one we created) -> Health Checks -> Edit -> change Path from "/" to "/goals"
2. AWS EC2 -> Load Balancers -> ecs-lb -> Security groups -> Add goals-xxxxx one beside the default one

It doesn't work for me.
So, I created a new revision of Task Definition: goals and updated the service with that one.

✅ It works!!!!!!!, succeeded

Run Postman and send data

```json
// http://ecs-lb-2034865568.ap-southeast-2.elb.amazonaws.com/goals
// Method : Post
// Body -> Raw, JSON
{
  "text": "A first test!"
}

// http://ecs-lb-2034865568.ap-southeast-2.elb.amazonaws.com/goals
// Method : Get
{
  "goals": [
    {
      "id": "60e15115465c540021231195",
      "text": "A first test!"
    }
  ]
}

// http://ecs-lb-2034865568.ap-southeast-2.elb.amazonaws.com/goals/60e15115465c540021231195
// Method : Delete
{
  "message": "Deleted goal!"
}
```

### 145. Using EFS Volumes with ECS

```sh
# Change app.js and re-launch the app
docker build -t goals-node ./backend
docker tag goals-node pcsmomo/goals-node
docker push pcsmomo/goals-node
```

AWS ECS -> Clusters -> goals-app -> Services -> goals-service -> Update -> Force new deployment: Check -> Skip to Review -> Update Service

> No need to create a new revision

!The service created the new task and the stored data has been lost.

1. AWS ECS -> Task Definitions -> goals:latest -> Create new revision
2. Add volume
   - Name: data
   - Volume type: EFS
   - File system ID
     1. Click Amazon EFS console to create a new file system
        - Create a file system
          - Name: db-storage
          - Virtual Private Cloud(VPC): choose the same VPC (vpc-0803a9dc38bf99d7e)
          - Customize
            1. Next: Network access -> we would have two subnet masks
            2. New tab: AWS EC2 -> Security Groups -> Create security group
               - Security group name: efs-sc
               - Description: multiple container example sc to be added to the new EFS, db-storage
               - VPC: the same VPC (vpc-0803a9dc38bf99d7e)
               - Add Inbound rule
                 - Type: NFS
                 - Source: Security Groups - goals--xxxx | sg-xxxxxxx (managin my containers)
               - Create security group
            3. Previous and Next to refresh
            4. Choose the new security group, efs-sc instead of the default one for both subnet masks
            5. Next: File system policy
            6. Next: Review and create
            7. Create
     2. refresh File system and select db-storage
   - Access point: None (You can read the document if you don't want to create a new EFS and use several access points on this volume)
   - Add
   - (This is a little bit as defining "data" volume with docker-compose )
3. Connecting to the container
   - click mongodb container
     - Mount points
       - Source Volume: data (the EFS volume name)
       - Container path: /data/db
       - (just the same as docker-compose.yaml, mongodb service)
     - Update
4. Create
5. Action -> Update Service
   - Platform version: Latest (When using EFS, "Latest" sometimes fails to run container then choose "1.4.0")
   - Force new deployment: Check
   - Skip to review
   - Update Service
6. Tasks -> the new task will be PROVISIONING, PENDING, and RUNNING

Run Postman and save data

```json
// http://ecs-lb-2034865568.ap-southeast-2.elb.amazonaws.com/goals
// Method : Post
// Body -> Raw, JSON
{
  "text": "A third test!"
}
```

Restart the service, then a new task will be created

AWS ECS -> Clusters -> goals-app -> Services -> goals-service -> Update -> Force new deployment: Check -> Skip to Review -> Update Service

> ⚠ Warning 1: If I update service several times before the previous deployment finishes, those will be in a queue and will be processed in order

> ⚠ Warning 2: In this scenario, the old task will be stopped, when the new task passes its health check. \
> While both tasks are running at the same time, if users write data on both tasks, it will all write on the same EFS. \
> we can stop the old task manually to prevent this problem. \
> However, we will replace the mongodb container with a different solution soon. \
> I guess it's MongoDB Atlas.

### 148. Moving to MongoDB Atlas

> We can use the mongodb container for development and MongoDB Atlas for production. \
> However, the db versions should be the same, otherwise we could possibly use new or deprecated features between the versions.

1. Atlas -> Current Project -> Network Access -> ADD IP ADDRESS -> ALLOW ACCESS FROM ANYWHERE
2. Atlas -> Current Project -> Database Access -> ADD NEW DATABASE USER
   - username: max
   - password: 8D8mEKSXoFlGaVkj (Autogenerate Secure Password)
   - Grant specific privileges or Read and write to any database
     - readWrite @ goals-dev
     - readWrite @ goals (production)

Update backend.env and Test

```sh
docker-compose up
# DB Connected
```

Test with Postman http&#58;//localhost:goals -> works fine

### 149. Using MongoDB Atlas in Production

```sh
# Change app.js and backend.env and re-launch the app
docker build -t goals-node ./backend
docker tag goals-node pcsmomo/goals-node
docker push pcsmomo/goals-node
```

1. AWS ECS -> Task Definitions -> goals:latest -> Create new revision
2. Delete db container and related volumes
   - Container Definitions -> mongodb -> delete
   - AWS Elastic File System (EFS) -> db-storage (fs-011d2539) -> Delete
   - AWS EC2 -> Security Groups -> efs-sc -> Delete
   - Make sure to delete "data" volume on this task definition
3. Change Backend Configurations
   - Container Definitions -> goals-backend
     - MONGODB_URL: noahcluster.pvxa3.mongodb.net
     - MONGODB_PASSWORD: 8D8mEKSXoFlGaVkj
     - MONGODB_NAME: goals
4. Create
5. Action -> Update Service
   - Platform version: Latest (It's not using EFS anymore so no need to select 1.4.0)
   - Force new deployment: Check
   - Skip to review
   - Update Service

If docker image is deployed to docker hub again, only Update Service is needed

AWS ECS -> Clusters -> goals-app -> Services -> goals-service -> Update -> Force new deployment: Check -> Skip to Review -> Update Service

> I forgot to delete volume part on the task definition after deleting EFS. \
> Because of this, new tasks failed again and again...😢

### 150. Our Updated & Target Architecture

Frontend projects need an extra process, "build" due to JSX which browsers cannot understand.

### 154. Building a Multi-Stage Image

[Docker - Use multi-stage builds](https://docs.docker.com/develop/develop-images/multistage-build/)

[Docker Nginx](https://hub.docker.com/_/nginx)

```sh
docker build -f frontend/Dockerfile.prod -t goals-react ./frontend
docker tag goals-react pcsmomo/goals-react
docker push pcsmomo/goals-react
```

### 155. Deploying a Standalone Frontend App

1. AWS ECS -> Task Definitions -> goals:latest -> Create new revision
2. Add Container
   - container name: goals-frontend
   - image: pcsmomo/goals-react
   - Port mappings: 80
   - Startup Dependency Ordering
     - Container name: goals-backend
     - Condition: SUCCESS
   - Add
3. ⚠Create button is disabled
   - Because backend and frontend containers are using the same port. 80
   - Container ports and protocols combination must be unique within a Task definition
4. Cancel

Create a new task definition for goals-react

1. AWS ECS -> Task Definitions -> Create new Task Definition
   1. FARGATE -> Next Step
      - Task Definition Name: goals-react
      - Task Role : ecsTaskExecutionRole (the same as the backend)
      - Task Memory : 0.5GB (minimum amount)
      - Task CPU : 0.25 vCPU (minimum amount)
      - Add container
        - container name: goals-frontend
        - image: pcsmomo/goals-react
        - Port mappings: 80
        - Add
   2. Create
2. Create a new load balancer
   - Click EC2 Console to create a load balancer
     1. Application Load Balancer, Configure
        - Name: goals-react-lb
        - Scheme: internet-facing
        - VPC: choose the same VPC (vpc-0803a9dc38bf99d7e (10.0.0.0/16))
        - Availability Zones: check both (ap-southeast-2a, ap-southeast-2b)
        - Next: Configure Security Settings
     2. Configure Security Settings : Basic (As we are not using HTTPS now)
     3. Configure Security Groups : check both default and goals--xxxx (This opens port 80 to incoming traffic)
     4. Configure Routing
        - Target group: New target group
        - Name: react-tg
        - Target type: IP
        - Health checkes
          - Protocol: HTTP
          - Path: /
     5. Register Targets: As is, ECS is automatically registering targets here.
     6. Next: Review
     7. Create
        - DNS name: goals-react-lb-1862629005.ap-southeast-2.elb.amazonaws.com

⚠ So now, the url in App.js need to be changed as we have two separates services for backend and frontend

```sh
docker build -f frontend/Dockerfile.prod -t goals-react ./frontend
docker tag goals-react pcsmomo/goals-react
docker push pcsmomo/goals-react
```

1. Create Service
   1. AWS ECS -> Cluster -> Services -> Create : Configure service
      - Launch type: FARGATE
      - Task Definition: goals-react
      - Cluster: goals-app
      - Service name: goals-react-service
      - Number of tasks: 1
      - Deployment type: Rolling update
      - Next Step
   2. Configure network
      - Cluster VPC: choose the one when the cluster created (vpc-0803a9dc38bf99d7e (10.0.0.0/16))
      - Subnets: Choose both subnets available (ap-southeast-2a, ap-southeast-2b)
      - Security groups: Select existing security group (goals--3617, exposing port 80)
      - Auto-assign public IP: ENABLED
      - Load balancer type: Application Load Balancer (No load balancer is found)
      - Load balancer name: goals-react-lb
      - Container name : port : goals-frontend:80:80 -> Add to load balancer
        - target group name: react-tg
      - Next step
   3. Set Auto Scaling (optional) : Do not adjust the service’s desired count
   4. Review
   5. Create Service
2. Tasks -> the new task will be PROVISIONING, PENDING, and RUNNING

✅ Node Server + React Server on AWS, succeeded
Front: http&#58;//goals-react-lb-1862629005.ap-southeast-2.elb.amazonaws.com
Backend: http&#58;//ecs-lb-2034865568.ap-southeast-2.elb.amazonaws.com/goals

---

## 157. Understanding Multi-Stage Build Targets

```sh
# --target build
docker build --target build -f frontend/Dockerfile.prod -t goals-react ./frontend
```

It will only build the node part and stop it before FROM nginx \
This option would be helpful, if we have complex dockerfiles with multiple stages.

</details>

## Kubernetes

<details>
  <summary>Click to Contract/Expend</summary>

### 172. What Is Kubernetes Exactly?

Kubernetes is like Docker-Compose for multiple machines

### 180. Kubernetes does NOT manage your Infrastructure

- What do I need to do
  1. Create the Cluster and the Node Instance (Worker + Master Nodes)
  2. Setup API Server, kublelet and other Kubernetes services / software on Nodes
  3. Create other (cloud) provider resources that might be needed (e.g. Load Balancer, File systems)
- What Kubernetes does
  1. Create objects (e.g. Pods) and manage them
  2. Monitor Pods and re-create them, scale Pods etc.
  3. Kubernetes utilizes the provided (cloud) resources to apply your configuration/goals

### 181. Kubernetes: Required Setup & Installation Steps

### 182. macOS Setup

Two tools ([more tools](https://kubernetes.io/docs/tasks/tools/))
and hypervision : Docker

1. kubectl: The Kubernetes command-line tool, like a president running commands against Kubernetes clusters
   - Install kubectl binary with curl on macOS (https://www.virtualbox.org/wiki/Downloads) : binary
   - ln -s ./kubectl /usr/local/bin/kubectl

```sh
# 1. Download the latest release:
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"

# 2. Validate the binary (optional)
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl.sha256"
echo "$(<kubectl.sha256)  kubectl" | shasum -a 256 --check
# > kubectl: OK

# 3. Make the kubectl binary executable.
chmod +x ./kubectl

# 4. Move the kubectl binary to a file location on your system PATH.
sudo mv ./kubectl /usr/local/bin/kubectl
sudo chown root: /usr/local/bin/kubectl

# 5. Test to ensure the version you installed is up-to-date:
kubectl version --client
# Client Version: version.Info{Major:"1", Minor:"21", GitVersion:"v1.21.2", GitCommit:"092fbfbf53427de67cac1e9fa54aaa09a28371d7", GitTreeState:"clean", BuildDate:"2021-06-16T12:59:11Z", GoVersion:"go1.16.5", Compiler:"gc", Platform:"darwin/amd64"}
```

2. minikube: Local Kubernetes. Dummy cluster for developer
   - [Installation](https://minikube.sigs.k8s.io/docs/start/) : binary
   - [Start with docker driver](https://minikube.sigs.k8s.io/docs/drivers/docker/)

```sh
# Installation
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64
sudo install minikube-darwin-amd64 /usr/local/bin/minikube

# 2. Start my cluster
minikube start --driver=docker
# it creates a docker image and a running container

# 3. Check minikube status
minikube status

# 4. See minikube web dashboard
minikube dashboard
```

### 186. A First Deployment - Using the Imperative Approach

```sh
docker build -t kub-first-app .

# Check minikube running
minikube status
# if it's not running
# minikube start --driver=docker

kubectl help
kubectl create  # to see create help
# kubectl is automatically connecting to minikube

# kubectl create deployment first-app --image=kub-first-app
# kubectl get deployments
# kubectl get pods
# kubectl delete deployment first-app
## We can see the deployment and pod but they are not ready 0/1
## Because kub-first-app is only on my local machine.
## So kubectl cannot find the image from the minikube cluster

docker tag kub-first-app pcsmomo/kub-first-app
docker push pcsmomo/kub-first-app
kubectl create deployment first-app --image=pcsmomo/kub-first-app
kubectl get deployments
# NAME        READY   UP-TO-DATE   AVAILABLE   AGE
# first-app   1/1     1            1           36s
kubectl get pods
# NAME                         READY   STATUS    RESTARTS   AGE
# first-app-67468bb98f-l5v9d   1/1     Running   0          38s
minikube dashboard
# can see all details
```

### 189. Exposing a Deployment with a Service

- ClusterIP : default, reachable from inside of the Cluster
- NodePort : This is exposed on IP and port of worker nodes
- LoadBalancer : Most commonly used accessable from outside

```sh
kubectl expose deployment first-app --type=LoadBalancer --port=8080
kubectl get services
# EXTERNAL-IP keeps <pending>

# this command is for a local specific purpose
minikube service first-app
# http://127.0.0.1:56557/
```

### 190. Restarting Containers

http&#58;//127.0.0.1:56557/error -> Exit node server and throw an error \
-> The server is down but it rolls back and starting restart the service.

```sh
kubectl get pods
# NAME                         READY   STATUS   RESTARTS   AGE
# first-app-67468bb98f-l5v9d   0/1     Error    1          5h22m

# After a while
# NAME                         READY   STATUS    RESTARTS   AGE
# first-app-67468bb98f-l5v9d   1/1     Running   2          5h22m
```

### 191. Scaling in Action

Replica : An instance of a Pod

```sh
# Scale up
kubectl scale deployment/first-app --replicas=3
kubectl get pods
# NAME                         READY   STATUS              RESTARTS   AGE
# first-app-67468bb98f-l5v9d   1/1     Running             2          5h32m
# first-app-67468bb98f-bkzhv   0/1     ContainerCreating   0          2s
# first-app-67468bb98f-s9qgt   0/1     ContainerCreating   0          2s
```

http&#58;//127.0.0.1:56557/error -> One pot is down but still be able to connent the same url and connected the other running pod.

```sh
# CrashLoopBackOff
# NAME                         READY   STATUS              RESTARTS   AGE
# first-app-67468bb98f-l5v9d   1/1     CrashLoopBackOff    3          5h32m
```

```sh
# Scale down
kubectl scale deployment/first-app --replicas=1
kubectl get pods
```

### 192. Updating Deployments

```sh
# After editing app.js
docker build -t pcsmomo/kub-first-app .
docker push pcsmomo/kub-first-app
kubectl get deployments

# Clarify the container and the new image path
# Check the container name "kub-first-app" inside the pod
kubectl set image deployment/first-app kub-first-app=pcsmomo/kub-first-app
# New image won't be adjusted because the tag name hasn't been changed

docker build -t pcsmomo/kub-first-app:2 .
docker push pcsmomo/kub-first-app:2
kubectl set image deployment/first-app kub-first-app=pcsmomo/kub-first-app:2
# deployment.apps/first-app image updated
kubectl rollout status deployment/first-app
# deployment "first-app" successfully rolled out
```

### 193. Deployment Rollbacks & History

```sh
# make an error
kubectl set image deployment/first-app kub-first-app=pcsmomo/kub-first-app:3
kubectl rollout status deployment/first-app
# Waiting for deployment "first-app" rollout to finish: 1 old replicas are pending termination...

# The new pod failed to run, so the old pod is still running.
kubectl get pods
# NAME                         READY   STATUS             RESTARTS   AGE
# first-app-567948dbdb-vgbq8   0/1     ErrImagePull       0          16s
# first-app-567948dbdb-vgbq8   0/1     ImagePullBackOff   0          73s

# Roll back to the healthily working pod
kubectl rollout undo deployment/first-app
#deployment.apps/first-app rolled back

kubectl get pods
# The errored pod has been removed
# NAME                        READY   STATUS    RESTARTS   AGE
# first-app-fdff796fc-gqf75   1/1     Running   0          17m

kubectl rollout history deployment/first-app
kubectl rollout history deployment/first-app --revision=3

# Roll back to specific revision
kubectl rollout undo deployment/first-app --to-revision=1
kubectl get pods
# It runs the old pod, but terminates the current one.
# NAME                         READY   STATUS        RESTARTS   AGE
# first-app-67468bb98f-v2zlk   1/1     Running       0          7s
# first-app-fdff796fc-gqf75    1/1     Terminating   0          18m
```

```sh
kubectl delete service first-app
# minicube create the service but kubectl deletes it

kubectl delete deployment first-app
# deployement will delete pods
```

### 194. The Imperative vs The Declarative Approach

If all those commands could be overwhelming. \
Let's make it like docker-compose

- Imperative Approach : docker run, kubectl create/expose
- Declarative Approach : docker-compose, kubectl apply

### 195. Creating a Deployment Configuration File (Declarative Approach)

[Kubernetes Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)

[Deployment v1 apps](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.19/#deployment-v1-apps)

```sh
kubectl apply -f=deployment.yaml
```

### 197. Working with Labels & Selectors

```sh
kubectl apply -f=deployment.yaml
kubectl get pods
```

### 198. Creating a Service Declaratively

```sh
kubectl apply -f service.yaml
kubectl get services
minikube service backend
```

### 199. Updating & Deleting Resources

Update yaml files and just apply again

```sh
# All ways work either imperatively and declaratively
kubectl delete deployment name
kubectl delete service name

kubectl delete -f=deployment.yaml,service.yaml
kubectl delete -f deployment.yaml -f service.yaml
```

### 200. Multiple vs Single Config Files

```sh
kubectl delete -f=deployment.yaml -f=service.yaml
kubectl apply -f master-deployment.yaml
```

### 201. More on Labels & Selectors

```sh
kubectl delete -f=master-deployment.yaml

# add label on deployment.yaml and service.yaml
kubectl apply -f=deployment.yaml -f=service.yaml
kubectl delete deployment,service -l group=example
```

### 202. Liveness Probes

```sh
# after adding livenessProbe
kubectl apply -f=deployment.yaml -f=service.yaml
minikube service backend
```

### 203. A Closer Look at the Configuration Options

Pull the updated image

1. Change tag
   - image: pcsmomo/kub-first-app:3
2. Use latest
   - image: pcsmomo/kub-first-app:latest
3. Add Pull Policy
   - image: pcsmomo/kub-first-app:2
   - imagePullPolicy: Always

```sh
docker build -t pcsmomo/kub-first-app:2 .
docker push pcsmomo/kub-first-app:2

kubectl apply -f=deployment.yaml -f=service.yaml
kubectl delete -f=deployment.yaml -f=service.yaml
```

### 207. Starting Project & What We Know Already

```sh
docker-compose up -d --build
```

Run Postman and send data

```json
// http://localhost/story
// Method : Post
// Body -> Raw, JSON
{
  "text": "A first test!"
}

// http://localhost/story
// Method : Get
{
  "story": "The first test~~!\n"
}
```

```sh
docker-compose down
docker-compose up -d --build
# the data is still stored
```

### 209. Kubernetes Volumes: Theory & Docker Comparison

Kubernetes Volumes lifetime depends on the Pod lifetime \
However, Kubernetes Volume is more powerful than Docker Volume

### 210. Creating a New Deployment & Service

```sh
docker build -t pcsmomo/kub-data-demo .
docker push pcsmomo/kub-data-demo

kubectl apply -f=service.yaml -f=deployment.yaml
minikube service story-service
```

### 211. Getting Started with Kubernetes Volumes

We will scratch three types among many many volume types.

- emptyDir
- hostPath
- csi

### 212. A First Volume: The "emptyDir" Type

```sh
# change app.js
docker build -t pcsmomo/kub-data-demo:1 .
docker push pcsmomo/kub-data-demo:1
kubectl apply -f=deployment.yaml
# After saving data, if it clashes with /error, all data will be gone.
# as volume lifetime depends on the pod's lifetime

# Add volume on deployment.yaml
kubectl apply -f=deployment.yaml
# http://127.0.0.1:51643/story -> {"message": "Failed to open file."}
# Because of emptyDir: {}
# But now, after saving data, if it clashes with /error, all data will be still there.
```

The down size of emptyDir is when we have more than one replicas

### 213. A Second Volume: The "hostPath" Type

If there are multiple nodes, hostPath is not good enough but it is better approach than emptyDir

```sh
# change replicas:2
kubectl apply -f=deployment.yaml
# change to hostPath
kubectl apply -f=deployment.yaml
```

### 214. Understanding the "CSI" Volume Type

[Amazon EFS CSI Driver](https://github.com/kubernetes-sigs/aws-efs-csi-driver)

Container Storage Interface (CSI) volume is kind of special and flexible. \
As long as venders(AWS, Azure, Etc.) support this type, we can use csi type

### 215. From Volumes to Persistent Volumes

Persistent Volume are detached from nodes and pods \
So emptyDir and hostPath types are not available.

### 216. Defining a Persistent Volume

[Resource Model](https://github.com/kubernetes/community/blob/master/contributors/design-proposals/scheduling/resources.md)

- E.g. Gi, Mi

### 218. Using a Claim in a Pod

```sh
# Storage Class
kubectl get sc
#NAME                 PROVISIONER                RECLAIMPOLICY   VOLUMEBINDINGMODE   ALLOWVOLUMEEXPANSION   AGE
#standard (default)   k8s.io/minikube-hostpath   Delete          Immediate           false                  33h

kubectl apply -f=host-pv.yaml
kubectl apply -f=host-pvc.yaml
kubectl apply -f=deployment.yaml

kubectl get pv
#NAME      CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM              STORAGECLASS   REASON   AGE
#host-pv   1Gi        RWO            Retain           Bound    default/host-pvc   standard                22s
kubectl get pvc
# NAME       STATUS   VOLUME    CAPACITY   ACCESS MODES   STORAGECLASS   AGE
# host-pvc   Bound    host-pv   1Gi        RWO            standard       47s
```

### 220. Using Environment Variables

```sh
# change app.js
docker build -t pcsmomo/kub-data-demo:2 .
docker push pcsmomo/kub-data-demo:2
kubectl apply -f=deployment.yaml
```

### 221. Environment Variables & ConfigMaps

```sh
kubectl apply -f=environment.yaml
kubectl get configmap
kubectl delete -f=deployment.yaml
kubectl apply -f=deployment.yaml
```

### 224. Module Introduction

```sh
docker-compose up -d --build
```

Postman test

```json
// http://localhost:8000/tasks
// Method : Post
// Header -> Key: Authorization, Value: Noah abc
// Body -> Raw, JSON
{
  "text": "A first task",
  "title": "Do this, too!"
}
```

### 226. Creating a First Deployment

```sh
# check no deployment and service running except the default service
kubectl get deployments
kubectl get services

users-api % docker build -t pcsmomo/kub-demo-users .
users-api % docker push pcsmomo/kub-demo-users
kubernetes % kubectl apply -f=users-deployment.yaml
```

### 227. Another Look at Services

```sh
kubernetes % kubectl apply -f=users-service.yaml
minikube service users-service
# http://127.0.0.1:56269
```

### 228. Multiple Containers in One Pod

```sh
auth-api % docker build -t pcsmomo/kub-demo-auth .
auth-api % docker push pcsmomo/kub-demo-auth
users-api % docker build -t pcsmomo/kub-demo-users .
users-api % docker push pcsmomo/kub-demo-users
```

no need to create service for auth as we don't want to expose this to the outside world

### 229. Pod-internal Communication

```sh
kubernetes % kubectl apply -f=users-deployment.yaml

kubectl describe pods
# resources:
#   limits:
#     memory: '128Mi'
#     cpu: '500m'
# It occurs 'Insufficient cpu' warning and new pods are stuck in pending
```

- Docker is using AUTH_ADDRESS: auth
  - as it can approach container name under the same network
- Kubernetes is using AUTH_ADDRESS: localhost
  - as it can communicate with localhost under the same pod

### 231. Pod-to-Pod Communication with IP Addresses & Environment Variables

```sh
kubernetes % kubectl apply -f=auth-deployment.yaml,auth-service.yaml
kubectl get services
# change localhost to the ClusterIP from auth-service
kubernetes % kubectl apply -f=users-deployment.yaml

# change to use "AUTH_SERVICE_SERVICE_HOST" kubernetes auth generated
users-api % docker build -t pcsmomo/kub-demo-users .
users-api % docker push pcsmomo/kub-demo-users

kubernetes % kubectl delete -f=users-deployment.yaml
kubernetes % kubectl apply -f=users-deployment.yaml
```

### 232. Using DNS for Pod-to-Pod Communication

Kubernetes clusters come with build-in service, CoreDNS \
So we can use [service name].default (default namespace)

### 234. Challenge Solution

```sh
tasks-api % docker build -t pcsmomo/kub-demo-tasks .
tasks-api % docker push pcsmomo/kub-demo-tasks
kubernetes % kubectl apply -f=tasks-service.yaml -f=tasks-deployment.yaml
minikube service tasks-service
```

task pod does not run. getting weird error message. \
I think.. when docker push, some layers are "Mounted from pcsmomo/kub-demo-users" \
Can't solve this problem now.

```sh
kubectl logs tasks-deployment-647c85d66c-vr7rb
# Error: Cannot find module '/app/users-app.js'
kubectl describe pod tasks-deployment-647c85d66c-9nl9x
# Normal Pulled 2s kubelet Successfully pulled image "pcxxxmo/kub-demo-tasks:latest" in 3.70906067s
# Warning BackOff 0s (x2 over 1s) kubelet Back-off restarting failed container
```

### 235. Adding a Containerized Frontend

```sh
frontend % docker build -t pcsmomo/kub-demo-frontend .
frontend % docker push pcsmomo/kub-demo-frontend

docker run -p 80:80 --rm -d pcsmomo/kub-demo-frontend
# When fetch tasks, we get CORS error

# Add headers related to CORS on task-app.js
tasks-api % docker build -t pcsmomo/kub-demo-tasks .
tasks-api % docker push pcsmomo/kub-demo-tasks
kubernetes % kubectl delete -f=tasks-deployment.yaml
kubernetes % kubectl apply -f=tasks-deployment.yaml

# add Authorization headers on App.js
frontend % docker build -t pcsmomo/kub-demo-frontend .
frontend % docker push pcsmomo/kub-demo-frontend
docker stop frontendserver
docker run -p 80:80 --rm -d pcsmomo/kub-demo-frontend
# All features work

docker stop frontendserver
```

### 236. Deploying the Frontend with Kubernetes

```sh
kubernetes % kubectl apply -f=frontend-service.yaml -f=frontend-deployment.yaml
minikube service frontend-service
```

237. Using a Reverse Proxy for the Frontend

Reverse Proxy

```sh
frontend % docker build -t pcsmomo/kub-demo-frontend .
frontend % docker push pcsmomo/kub-demo-frontend
kubernetes % kubectl delete -f=frontend-deployment.yaml
kubernetes % kubectl apply -f=frontend-deployment.yaml
```

</details>

## Kubernetes Deployment

<details>
  <summary>Click to Contract/Expend</summary>

### 243. Preparing the Starting Project

```sh
users-api % docker build -t pcsmomo/kub-dep-users .
users-api % docker push pcsmomo/kub-dep-users
auth-api % docker build -t pcsmomo/kub-dep-auth .
auth-api % docker push pcsmomo/kub-dep-auth

# For testing myself
kubernetes % kubectl apply -f=users.yaml,auth.yaml
minikube service users-service
```

POSTMAN Test

```json
// http://127.0.0.1:56279/signup
// Method : Post
// Body -> Raw, JSON
{
  "email": "test@test.com",
  "password": "testpass"
}
// Result
{
  "message": "User created.",
  "user": {
    "_id": "60e67c119bb1ae5f727c841b",
    "email": "test@test.com",
    "password": "$2a$12$hWFQeJyU9nGY8Vb1Wiz/O.gn7Rt0d90dPiK6sBeBA7dlys9aMhY9C",
    "__v": 0
  }
}

// http://127.0.0.1:56279/login
// Method : Post
// Body -> Raw, JSON
{
  "email": "test@test.com",
  "password": "testpass"
}
// Result
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2MjU3MTc4NTEsImV4cCI6MTYyNTcyMTQ1MX0.Qq3OnxXdHFlcI-Bhvxhqnc_Nt8l5hw0lOLciX60KxiU",
  "userId": "60e67c119bb1ae5f727c841b"
}
```

### 246. Creating & Configuring the Kubernetes Cluster with EKS

1. AWS EKS (Elastic Kubernetes Service)
   - cluster name: kub-dep-demo
   - Next step
   1. Configure cluster
      - kubernetes version: 1.17
      - Create Role
        1. IAM -> Roles -> Create role
        2. AWS service -> EKS -> EKS - Cluster -> Next: Permissions
        3. Permissions -> Next: Tags
        4. Tags : Next: Review
        5. Review : Role name: eksClusterRole -> Create Role
      - Cluster Service Role: refresh and choose eksClusterRole
      - Next
   2. Specify networking
      - AWS CloudFormation -> Create stack
        1. Create stack
           - [Create VPC](https://docs.aws.amazon.com/eks/latest/userguide/create-public-private-vpc.html#create-vpc)
           - Amazon S3 URL: https://s3.us-west-2.amazonaws.com/amazon-eks/cloudformation/2020-10-29/amazon-eks-vpc-private-subnets.yaml
           - Next
        2. Specify stack details
           - Stack name: eksVpc
           - Next
        3. Tags -> Next
        4. Review -> Create stack
      - VPC : refresh and choose eksVpc
      - Cluster endpoint access: Public and private
      - Next
   3. Configure logging : Next
   4. Review: Create

#### Configure kube config file

```sh
subl /Users/noah/.kube/config
cp config config.minikube # create a backup
```

[Install AWS CLI](https://aws.amazon.com/cli/)

1. AWS My security credentials -> Create access key and download the csv file

```sh
aws configure
# AWS Access Key ID [None]: ABCDE
# AWS Secret Access Key [None]: ZXYW
# Default region name [None]: ap-southeast-2
# Default output format [None]:

aws eks --region ap-southeast-2 update-kubeconfig --name kub-dep-demo
# It adds my EKS cluster configurations to /Users/noah/.kube/config \

minikube delete
kubectl get pods
# kubectl is connected to my EKS Cluster now
```

## </details>

## What I have used

- git rebase -i HEAD~2
- git stash

## Thoughts

- Holy moly. AWS setting part is always challenging, 18 minute lecture got me for almost 2 hours to complete the setting such as "145. Using EFS Volumes with ECS"
- It might be a good idea of using the same name for tags on every service for this app

## next remove mongodb user
