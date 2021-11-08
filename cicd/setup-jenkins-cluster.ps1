k3d cluster create --api-port 6550 -p "8880:80@loadbalancer" -p "8000:30000@agent:0" -p "8001:30000@agent:1" -p "8443:443@loadbalancer" --agents 2 --servers 2 my-cluster --volume C:\Users\thraa\system-expert\cicd:/data
k3d kubeconfig get my-cluster > C:\Users\thraa\k3d\kubeconfig
$KUBECONFIG = "$HOME\k3d\kubeconfig"
kubectl cluster-info
kubectl create namespace jenkins
kubectl create -f jenkins\jenkins-service-account.yaml
kubectl create -f jenkins\jenkins-pvc.yaml -n jenkins
kubectl create -f jenkins\jenkins-deployment.yaml -n jenkins
kubectl get pods -n jenkins
kubectl create -f jenkins\jenkins-service.yaml --namespace jenkins
kubectl create -f jenkins\jenkins-ingress.yaml --namespace jenkins
kubectl get services --namespace jenkins
kubectl get nodes -o wide
kubectl get svc -n jenkins
kubectl get pods -n jenkins -o wide
kubectl logs -n jenkins <jenkins-pod-name>
kubectl port-forward service/jenkins 6420:8080 -n jenkins
# https://digitalavenue.dev/How-To-Setup-Jenkins-On-Kubernetes/
# Until Kubernetes 1.4 removes the SNATing of source ips, seems that CSRF (enabled by default in Jenkins 2) needs to be configured to avoid WARNING: No valid crumb was included in request errors. This can be done checking Enable proxy compatibility under Manage Jenkins -> Configure Global Security
kubectl create secret docker-registry regcred --docker-server=https://index.docker.io/v1/ --docker-username=tomcoolpxl --docker-password=1DN92DNykh^*L --docker-email=tom.cool@pxl.be
# https://devopscube.com/build-docker-image-kubernetes-pod/
# https://devopscube.com/setup-jenkins-on-kubernetes-cluster
