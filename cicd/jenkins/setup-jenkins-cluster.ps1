# generic set-up
# port forwarding
# 8880 -> 80 op traefik
# 8443 -> 443 op traefik
# 800x -> nodeports 3000x op de agent nodes
# volume!
k3d cluster create --api-port 6550 -p "8880:80@loadbalancer" -p "8000:30000@agent:0" -p "8001:30000@agent:1" -p "8443:443@loadbalancer" --agents 2 --servers 2 my-cluster --volume C:\Users\thraa\system-expert\cicd\jenkins_data:/data
k3d kubeconfig get my-cluster > C:\Users\thraa\k3d\kubeconfig
$KUBECONFIG = "$HOME\k3d\kubeconfig"
kubectl cluster-info

# separate namespace
kubectl create namespace devops-tools

# opzetten service account
# ClusterRole en ServiceAccount: jenkins-admin
# permissies voor alle cluster components
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

# set up ingress voor jenkins
# kubectl create -f ingress.yaml

# checks
kubectl get nodes -o wide
kubectl get services --namespace devops-tools
kubectl get pods --namespace devops-tools -o wide
kubectl logs --namespace devops-tools <jenkins-pod-name>
# kubectl exec -it <jenkins-pod-name> cat  /var/jenkins_home/secrets/initialAdminPassword -n devops-tools
# kubectl port-forward service/jenkins 6420:8080 --namespac jenkins
# browse naar localhost:8000
# https://digitalavenue.dev/How-To-Setup-Jenkins-On-Kubernetes/
# Until Kubernetes 1.4 removes the SNATing of source ips, seems that CSRF (enabled by default in Jenkins 2) needs to be configured to avoid WARNING: No valid crumb was included in request errors. This can be done checking Enable proxy compatibility under Manage Jenkins -> Configure Global Security
kubectl create secret docker-registry regcred --docker-server=https://index.docker.io/v1/ --docker-username=tomcoolpxl --docker-password=<password> --docker-email=tom.cool@pxl.be
# https://devopscube.com/build-docker-image-kubernetes-pod/
# https://devopscube.com/setup-jenkins-on-kubernetes-cluster

install kubernetes, mavin plugins
turn on proxy compatibility
