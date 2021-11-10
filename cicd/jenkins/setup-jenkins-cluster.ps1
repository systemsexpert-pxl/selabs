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
# kubectl port-forward service/jenkins 6420:8080 --namespac jenkins
# browse naar localhost:8000
# https://digitalavenue.dev/How-To-Setup-Jenkins-On-Kubernetes/
# Until Kubernetes 1.4 removes the SNATing of source ips, seems that CSRF (enabled by default in Jenkins 2) needs to be configured to avoid WARNING: No valid crumb was included in request errors. This can be done checking Enable proxy compatibility under Manage Jenkins -> Configure Global Security
$dockerserver = 'https://index.docker.io/v1/'
$dockerusername = 'tomcoolpxl'
$dockerpassword = 'password'
$dockeremail = 'tom.cool@pxl.be'

# kubectl create secret docker-registry regcred --docker-server=$dockerserver --docker-username=$dockerusername --docker-password=$dockerpassword --docker-email=$dockeremail
kubectl create secret docker-registry regcred --docker-server=$dockerserver --docker-username=$dockerusername --docker-password=$dockerpassword --docker-email=$dockeremail --namespace devops-tools
# https://devopscube.com/build-docker-image-kubernetes-pod/
# https://devopscube.com/setup-jenkins-on-kubernetes-cluster
# https://devopscube.com/jenkins-build-agents-kubernetes/
# https://itnext.io/jenkins-running-workers-in-kubernetes-and-docker-images-build-83299a10f3ca


install kubernetes, mavin plugins, kubernetes cli plugin
turn on proxy compatibility

kubernetes:
namespace: devops-tools
jenkins URL:
http://jenkins-service.devops-tools.svc.cluster.local:8080
pod label:
jenkins
agent
pod template:
name: kube-agent
namespace: devops-tools
labels: kubeagent
add container template


new pipeline
git -> https://github.com/systemsexpert-pxl/selabs.git
create credentials voor github
branch specifier empty
invoke top-level Maven targets -> 'clean package'

Tools config
jdk-11
https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.13%2B8/OpenJDK11U-jdk_x64_linux_hotspot_11.0.13_8.tar.gz
jdk-11.0.13+8

env var:
JAVA_HOME
/var/jenkins_home/tools/hudson.model.JDK/jdk-11/jdk-11.0.13+8
