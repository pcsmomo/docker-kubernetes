!!The part need to be fixed

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

---

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

---

### 155. Deploying a Standalone Frontend App

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

It might have been a good idea that using the same name of tag on every services for this app
