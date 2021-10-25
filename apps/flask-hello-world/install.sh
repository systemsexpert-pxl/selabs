# cluster set-up
k3d cluster create my-cluster --port 8080:80@loadbalancer --api-port 6443 --servers 2 --agents 3
kubectl cluster-info

# build and publish docker image
docker build -t flask-hello-world:latest .
docker tag flask-hello-world:latest tomcoolpxl/flask-hello-world:1.0
docker login
docker push tomcoolpxl/flask-hello-world:1.0
docker logout

# kubernetes deployment, service and ingress
kubectl apply -f kubernetes/deployment.yaml
kubectl apply -f kubernetes/service.yaml
kubectl apply -f kubernetes/ingress.yaml

# test - better wait a while though
curl localhost:8080
