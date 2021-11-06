k3d cluster create --api-port 6550 -p "8880:80@loadbalancer" -p "8000:30000@agent:0" -p "8001:30000@agent:1" -p "8443:443@loadbalancer" --agents 2 --servers 2 my-cluster --volume C:\Users\thraa\system-expert\cicd:/data
k3d kubeconfig get my-cluster > C:\Users\thraa\k3d\kubeconfig
$KUBECONFIG = "$HOME\k3d\kubeconfig"
kubectl cluster-info
kubectl create namespace jenkins
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
