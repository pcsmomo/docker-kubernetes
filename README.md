# Docker & Kubernetes Summary

Docker &amp; Kubernetes: The Practical Guide by Maximilian Schwarzmüller

This repository is to summarize this long lecture and it would not include much code.

# Details

## Docker

<details>
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
# it pushes exclude libraries existed on docker hub
```

### 39. Pulling & Using Shared Images

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

### 43. Understanding Data Categories / Different Kinds of Data

#### Docker Data

- Application : Read-only, stored in Images
- Temporary App Data : Read + Writ, temporary, stored in Containers
  - e.g. entered user input
- Permanent App Data : Read + Writ, permanent, stored in Containers & Volumes
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

### 49. Named Volumes To The Rescue!

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
# it only builds but doesn't starts containers
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

# 4. Migrate database (Why does it need?)
docker-compose run --rm artisan migrate
# ERROR: Service 'artisan' failed to build : The command '/bin/sh -c docker-php-ext-install pdo pdo_mysql' returned a non-zero code: 11
# Failed at the first attemption
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

1. Create and launch EC2 instance, VPC and security group
2. Configure security group to expose all required ports to WWW
3. Connect to instance (SSH), install Docker and run container

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
5. Create new key pairs -> save it as "example-1.cer" on my local machine
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

1. Connect AWS ECS and Click Get Started
2. Container definition -> Custom-app -> Configure
   - <!-- This is configure docker run [options] -->
   - Container name: node-demo (--name)
   - image: pcsmomo/node-example-1-aws
   - Port mappings: 80 (-p 80:80)
   - Environment - Entry Point, Command,Working directory and Environment variables
   - Storage and Logging
     - Storage is equivalent to (-v)
     - Check on Log configuration to see logs
3. Task definition
   - Compatibilities FARGATE (Serverless, it runs only when it is excuted, cost-effective)
4. Service : we could set up Load Balancer, but not now
5. Cluster : multiple containers would run in this same Cluster
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
2. Create new revision -> Create -> Update Service -> Skip to review -> Update Service
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
          - <!-- Because Dockerfile is using npm start to use node mon for developer mode -->
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
        3. Configure Security Groups : existing default one
        4. Configure Routing
           - Name: tg
           - Target type: IP
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
The lecture said, the load balancer is not configured correctly. See the next lecture.

</details>

---
