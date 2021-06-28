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

</details>

---

## What I have learned from this course

-

## Next Step

- TDD?
  > Frankly, I wrote tests after writing code. I did feel testing is like a chore as the instructor, Bonnie mentioned. I have got to change my process to use profer TDD.
