#!/bin/bash

CLUSTER_NAME="my-ci-cluster"
k3d cluster create --config ./k3d-config.yaml
kubectl taint node k3d-$CLUSTER_NAME-server-0 node-role.kubernetes.io/master:NoSchedule
kubectl taint node k3d-$CLUSTER_NAME-server-1 node-role.kubernetes.io/master:NoSchedule

# Separate namespace
kubectl create namespace devops-tools

# Setup service account
# ClusterRole en ServiceAccount: jenkins-admin
kubectl apply -f service-account.yaml

# set up PV en PVC
kubectl create -f volume.yaml

# set up deployment
# jenkins:latest
kubectl create -f deployment.yaml

# check status
kubectl get deployments --namespace devops-tools
kubectl get pods --namespace devops-tools

# set up service voor jenkins
# UI accessible op nodeport 30000
kubectl create -f service.yaml

# checks
kubectl get nodes -o wide
kubectl get services --namespace devops-tools
kubectl get pods --namespace devops-tools -o wide
JENKINS_POD=`kubectl get pods --namespace devops-tools -o wide -o jsonpath="{.items[0].metadata.name}"`
kubectl logs --namespace devops-tools $JENKINS_POD

# Read sensitive info from user input
echo ""
echo "Next up, we wil require some Docker Hub info :)"
echo ""
DOCKER_SERVER='https://index.docker.io/v1/'
echo "Enter hub.docker.com username/id:"
read DOCKER_USER
echo "Enter hub.docker.com password:"
read DOCKER_PASS
echo "Enter hub.docker.com email:"
read DOCKER_MAIL
# kubectl create secret docker-registry dockercred --docker-server=$DOCKER_SERVER --docker-username=$DOCKER_USER --docker-password=$DOCKER_PASS --docker-email=$DOCKER_MAIL
kubectl create secret docker-registry dockercred --docker-server=$DOCKER_SERVER --docker-username=$DOCKER_USER --docker-password=$DOCKER_PASS --docker-email=$DOCKER_MAIL --namespace devops-tools
