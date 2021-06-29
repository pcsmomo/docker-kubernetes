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
% docker build .

#=> => writing image sha256:b41ebb6d624069022efc4835523b3a18a587eae911a4885dc1dc081b17b7511c
```

```sh
# docker run b41ebb6d624069022efc4835523b3a18a587eae911a4885dc1dc081b17b7511c
% docker run -p 3000:3000 b41ebb6d624069022efc4835523b3a18a587eae911a4885dc1dc081b17b7511c
```

```sh
% docker ps
#CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                                       NAMES
#d53a7b8732e8   b41ebb6d6240   "docker-entrypoint.s…"   2 minutes ago   Up 2 minutes   0.0.0.0:3000->3000/tcp, :::3000->3000/tcp   naughty_mayer
```

```sh
% docker stop naughty_mayer
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
% docker build .
#=> => writing image sha256:d9c36df3c92ef2cb043b296a4341544fc68ff6235c1fea9cd8ec6a658817af2
```

3. Run the container based on the created image

```sh
% docker run d9c36df3c92ef2cb043b296a4341544fc68ff6235c1fea9cd8ec6a658817af2
# http://localhost doesn't work

# -p : publish
# 3000 : Port I want to access
# 80 : Expose port on Dockerfile
% docker run -p 3000:80 d9c36df3c92ef2cb043b296a4341544fc68ff6235c1fea9cd8ec6a658817af2
```

4. Stop the docker container

```sh
# See docker containers currently running without -a
% docker ps

# quizzical_chandrasekhar is the given name
% docker stop quizzical_chandrasekhar
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

</details>

---

## What I have learned from this course

-

## Next Step

- TDD?
  > Frankly, I wrote tests after writing code. I did feel testing is like a chore as the instructor, Bonnie mentioned. I have got to change my process to use profer TDD.
