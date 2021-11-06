k3d cluster create --api-port 6550 -p "8181:80@loadbalancer" -p "8443:443@loadbalancer" --agents 2 --servers 2 my-cluster --volume C:\Users\thraa\system-expert\pv:/data
k3d kubeconfig get my-cluster > C:\Users\thraa\k3d\kubeconfig
$KUBECONFIG = "$HOME\k3d\kubeconfig"
kubectl cluster-info
kubectl apply -f .\app.yaml
kubectl get pv
kubectl get pvc
kubectl get pods