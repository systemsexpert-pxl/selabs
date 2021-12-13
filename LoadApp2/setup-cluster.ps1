# setup-cluster.ps1
# set up k3d cluster based on config file

# script config
$clusterconfigfile = "./cluster/k3d-config.yaml"
$mounteddatavolume = $false

# environment variable $Env:clusterconfigfile overrides script config
if ($Env:clusterconfigfile) {
  $clusterconfigfile = $Env:clusterconfigfile
}

# define cluster volume /data
# $mounteddatavolume must be True
# use $clusterdata environment variable or default to ./data
# exception if mounted directory doesn't exist
$ClusterData = $env:clusterdata
if (($mounteddatavolume) -and (-not ($ClusterData))) {
  $clusterdata = $(Resolve-Path "$PSScriptRoot\data\").ToString().TrimEnd('\')
}

# retrieve cluster name from cluster config yaml
$clustername = $(Get-Content $clusterconfigfile | Select-String -Pattern 'name:').ToString().Substring(6)
if (-not ($clustername)) {
  throw "Can't find cluster name in $clusterconfigfile."
}

# console
Write-Host "Creating k3d cluster " -NoNewline -ForegroundColor green
Write-Host "$clustername" -NoNewline -ForegroundColor blue
if ($mounteddatavolume) {
  Write-Host ", with mounted volume " -NoNewline -ForegroundColor green
  Write-Host "${clusterdata}:/data, " -NoNewline -ForegroundColor blue
}
Write-Host "..." -ForegroundColor green
Write-Host ""

# create cluster using cluster config yaml
if ($mounteddatavolume) {
  k3d cluster create --config "$clusterconfigfile" --volume "${clusterdata}:/data" --k3s-arg "--disable=traefik@server:*" --k3s-arg "--disable=metrics-server@server:0"
}
else {
  k3d cluster create --config "$clusterconfigfile" --k3s-arg "--disable=traefik@server:*" --k3s-arg "--disable=metrics-server@server:0"
}

# taint server nodes
kubectl taint node k3d-$clustername-server-0 node-role.kubernetes.io/master:NoSchedule
kubectl taint node k3d-$clustername-server-1 node-role.kubernetes.io/master:NoSchedule

# cluster info check
kubectl cluster-info

# console
Write-Host ""
Write-Host "K3d cluster " -NoNewline -ForegroundColor green
Write-Host "$clustername" -NoNewline -ForegroundColor blue
if ($mounteddatavolume) {
  Write-Host ", with mounted volume " -NoNewline -ForegroundColor green
  Write-Host "${clusterdata}:/data," -NoNewline -ForegroundColor blue
}
Write-Host " was created." -ForegroundColor green
Write-Host ""

# pipeline output
Write-Host "Pipeline output: " -ForegroundColor white
Write-Output "$clustername"