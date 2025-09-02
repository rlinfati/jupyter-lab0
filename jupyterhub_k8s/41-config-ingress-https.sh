# Ingress

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/refs/heads/main/deploy/static/provider/cloud/deploy.yaml
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/latest/download/cert-manager.yaml

kubectl -n cert-manager patch deploy cert-manager --type='json' -p='[
  {"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--feature-gates=ACMEHTTP01IngressPathTypeExact=false"}
]'

kubectl -n ingress-nginx patch svc ingress-nginx-controller --type='json' -p='[
  {"op":"replace","path":"/spec/type","value":"ClusterIP"}
]'

# grujh
kubectl -n ingress-nginx patch svc ingress-nginx-controller --type='json' -p='[
  {"op":"add","path":"/spec/externalIPs","value":["172.30.101.187"]}
]'
# valjh
kubectl -n ingress-nginx patch svc ingress-nginx-controller --type='json' -p='[
  {"op":"add","path":"/spec/externalIPs","value":["172.30.16.109"]}
]'
# synco.ubb
kubectl -n ingress-nginx patch svc ingress-nginx-controller --type='json' -p='[
  {"op":"add","path":"/spec/externalIPs","value":["146.83.193.158"]}
]'
# cosyn.ubb
kubectl -n ingress-nginx patch svc ingress-nginx-controller --type='json' -p='[
  {"op":"add","path":"/spec/externalIPs","value":["146.83.193.159"]}
]'
# hostPort
kubectl -n ingress-nginx patch deploy ingress-nginx-controller --type='json' -p='[
  {"op":"add","path":"/spec/template/spec/containers/0/ports/0/hostPort","value":80},
  {"op":"add","path":"/spec/template/spec/containers/0/ports/1/hostPort","value":443}
]'

# sudo ss -ltnp
# sudo lsof -nP -iTCP:80  -sTCP:LISTEN
# sudo lsof -nP -iTCP:443 -sTCP:LISTEN
# sudo iptables -t nat -L -n -v | grep -E 'dpt:(80$|443)'

URLREPO=https://raw.githubusercontent.com/rlinfati/jupyter-lab0/refs/heads/master

kubectl apply -f $URLREPO/42-cert-issuer-le.yaml
kubectl apply -f $URLREPO/43-ingres-jupyterhub.yaml

kubectl get all -n jupyterhub-k8s
kubectl get ingress -n jupyterhub-k8s
kubectl get certificaterequest,order,challenge,certificate -n jupyterhub-k8s

kubectl get configmap -A
kubectl get secrets -A
