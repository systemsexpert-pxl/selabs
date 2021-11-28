# create cluster with k3d config file
k3d cluster create --config .\k3d-config.yaml
$clustername = "my-cluster"
# $clustername = $(cat .\k3d-config.yaml | Select-String -Pattern 'name: ').Line.Remove(0, 6)
# extract kubeconfig
$KUBECONFIG = "$HOME\k3d\kubeconfig"
k3d kubeconfig get $clustername > $KUBECONFIG
# cluster info check
kubectl cluster-info

# prevent useage of server nodes
kubectl taint node k3d-$clustername-server-0 node-role.kubernetes.io/master:NoSchedule
kubectl taint node k3d-$clustername-server-1 node-role.kubernetes.io/master:NoSchedule
