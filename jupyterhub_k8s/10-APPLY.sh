#!/bin/sh

set -ex

sudo mkdir --context=unconfined_u:object_r:container_file_t:s0 /home/jupyterhub-localpath

URLREPO=https://raw.githubusercontent.com/rlinfati/jupyter-lab0/refs/heads/master

kubectl apply -f $URLREPO/jupyterhub_k8s/11-namespace.yaml 
kubectl apply -f $URLREPO/jupyterhub_k8s/12-rbac.yaml
kubectl apply -f $URLREPO/jupyterhub_k8s/13-deployment.yaml
kubectl apply -f $URLREPO/jupyterhub_k8s/14-services.yaml
kubectl apply -f $URLREPO/jupyterhub_k8s/15-localpath-rbac.yaml
kubectl apply -f $URLREPO/jupyterhub_k8s/16-localpath-configmap.yaml
kubectl apply -f $URLREPO/jupyterhub_k8s/17-localpath-deployment.yaml
kubectl apply -f $URLREPO/jupyterhub_k8s/18-localpath-storageclass.yaml
kubectl apply -f $URLREPO/jupyterhub_k8s/19-caddy-host.yaml

kubectl apply -f $URLREPO/jupyterhub_k8s/22-jupyterhub-oauth.yaml
kubectl apply -f $URLREPO/jupyterhub_k8s/23-jupyterhub-profiles.yaml
kubectl apply -f $URLREPO/jupyterhub_k8s/24-jupyterhub-config.yaml

kubectl apply -f $URLREPO/jupyterhub_k8s/25-jupyterhub-licenses.yaml

kubectl get all,pv,pvc,sc -n jupyterhub-k8s
kubectl logs -n jupyterhub-k8s deployment/jupyterhub-hub 
kubectl logs -n jupyterhub-k8s deployment/jupyterhub-localpath
kubectl logs -n jupyterhub-k8s deployment/jupyterhub-caddy

# rm a && vi a && kubectl delete -f a && kubectl apply -f a
# rm a && vi a && kubectl delete -f a && kubectl apply -f a && kubectl delete -f z && kubectl apply -f z
# kubectl rollout restart -n jupyterhub-k8s deployment/jupyterhub-caddy
# kubectl rollout restart -n jupyterhub-k8s deployment/jupyterhub-hub

##########
# NVIDIA #
##########

# sudo nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
sudo nvidia-ctk runtime configure --runtime=crio --config=/etc/crio/crio.conf.d/99-nvidia.conf
sudo systemctl restart crio

kubectl apply -f $URLREPO/jupyterhub_k8s/32-nvidia-runtime.yaml
kubectl apply -f $URLREPO/jupyterhub_k8s/33-nvidia-plugin.yaml

kubectl get pod,ds -n kube-system
kubectl logs -n kube-system daemonset.apps/nvidia-device-plugin-daemonset
kubectl describe node

# eof
