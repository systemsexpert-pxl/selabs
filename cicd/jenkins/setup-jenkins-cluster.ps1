# generic set-up
# port forwarding
# 8880 -> 80 op traefik
# 8443 -> 443 op traefik
# 800x -> nodeports 3000x op de agent nodes
# volume!
rm -r -fo jenkins_data
mkdir jenkins_data
k3d cluster create --api-port 6550 -p "8880:80@loadbalancer" -p "8000:30000@agent:0" -p "8001:30000@agent:1" -p "8443:443@loadbalancer" --agents 2 --servers 2 my-cluster --volume C:\Users\thraa\system-expert\cicd\jenkins\jenkins_data:/data
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
# alternatief kubectl port-forward service/jenkins 6420:8080 --namespace jenkins
# browse naar localhost:8000

$dockerserver = 'https://index.docker.io/v1/'
$dockerusername = 'tomcoolpxl'
$dockerpassword = 'password'
$dockeremail = 'tom.cool@pxl.be'
# kubectl create secret docker-registry dockercred --docker-server=$dockerserver --docker-username=$dockerusername --docker-password=$dockerpassword --docker-email=$dockeremail
kubectl create secret docker-registry dockercred --docker-server=$dockerserver --docker-username=$dockerusername --docker-password=$dockerpassword --docker-email=$dockeremail --namespace devops-tools
