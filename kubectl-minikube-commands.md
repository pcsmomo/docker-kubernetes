kubectl

```sh
kubectl version --client
kubectl help

kubectl get deployments
kubectl get pods
kubectl get services
kubectl get sc  # Storage Class
kubectl get pv  # Persistent Volume
kubectl get pvc # Persistent Volume Claim
kubectl get configmap
kubectl get namespaces

kubectl describe [pot name]
kubectl logs [pot name]

# Step 1
kubectl create deployment first-app --image=pcsmomo/kub-first-app

# Step 2
kubectl expose deployment first-app --type=LoadBalancer --port=8080
```

minikube

```sh
minikube start --driver=docker
minikube status
minikube dashboard

# Step 3
minikube service first-app

minikube delete
```

---

Whole process

### 186. A First Deployment - Using the Imperative Approach

```sh
docker build -t pcsmomo/kub-first-app .
docker push pcsmomo/kub-first-app

kubectl create deployment first-app --image=pcsmomo/kub-first-app
kubectl expose deployment first-app --type=LoadBalancer --port=8080

minikube service first-app

# (Optional) Scaling
kubectl scale deployment/first-app --replicas=3
kubectl scale deployment/first-app --replicas=1
```

### 192. Updating Deployments

Edit app.js

```sh
# Trigger with the new tag name
docker build -t pcsmomo/kub-first-app:2 .
docker push pcsmomo/kub-first-app:2

kubectl set image deployment/first-app kub-first-app=pcsmomo/kub-first-app:2
```

```sh
kubectl delete service first-app
kubectl delete deployment first-app
```

---

Ease use

```sh
kubectl apply -f=deployment.yaml
kubectl apply -f service.yaml
kubectl delete -f=deployment.yaml -f=service.yaml
minikube service backend
```
