# generic set-up
# port forwarding
# 8880 -> 80 op traefik
# 8443 -> 443 op traefik
# 800x -> nodeports 3000x op de agent nodes
# volume!
rm -r -fo jenkins_data
mkdir jenkins_data
# create cluster with k3d config file
k3d cluster create --config .\k3d-config.yaml
$clustername=my-ci-cluster
# $clustername = $(cat .\k3d-config.yaml | Select-String -Pattern 'name: ').Line.Remove(0, 6)
# extract kubeconfig
$KUBECONFIG = "$HOME\k3d\kubeconfig"
k3d kubeconfig get $clustername > $KUBECONFIG
# cluster info check
kubectl cluster-info

# prevent useage of server nodes
kubectl taint node k3d-$clustername-server-0 node-role.kubernetes.io/master:NoSchedule
kubectl taint node k3d-$clustername-server-1 node-role.kubernetes.io/master:NoSchedule

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

# checks
kubectl get nodes -o wide
kubectl get services --namespace devops-tools
kubectl get pods --namespace devops-tools -o wide
$jenkinspod = $(kubectl get pods --namespace devops-tools -o wide | Select-String jenkins-..........-.....).Matches.Value
kubectl logs --namespace devops-tools $jenkinspod
kubectl exec -it $jenkinspod cat  /var/jenkins_home/secrets/initialAdminPassword -n devops-tools
# alternatief: kubectl port-forward service/jenkins-service 6420:8080 --namespace jenkins
# browse naar localhost:8000

$dockerserver = 'https://index.docker.io/v1/'
$dockerusername = 'tomcoolpxl'
$dockerpassword = 'password'
$dockeremail = 'tom.cool@pxl.be'
# kubectl create secret docker-registry dockercred --docker-server=$dockerserver --docker-username=$dockerusername --docker-password=$dockerpassword --docker-email=$dockeremail
kubectl create secret docker-registry dockercred --docker-server=$dockerserver --docker-username=$dockerusername --docker-password=$dockerpassword --docker-email=$dockeremail --namespace devops-tools
