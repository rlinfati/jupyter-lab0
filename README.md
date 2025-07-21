# Jupyter LAB0

## Jupyter Secrets license
- sudo podman secret create GUROBIWLS /opt/gurobi/gurobi.lic
## Jupyter Secrets admin user
- printf superadmin@domain.tld | sudo podman secret create J0-admin_users -
## Jupyter Secrets docker
- printf '%s\n' \
- rlinfati/jupyter-lab0:julia-111 \
- rlinfati/jupyter-lab0:Anaconda \
- quay.io/jupyter/julia-notebook:latest \
- quay.io/jupyter/scipy-notebook:latest \
- quay.io/jupyter/r-notebook:latest \
- quay.io/jupyter/tensorflow-notebook:latest \
- quay.io/jupyter/pytorch-notebook:latest \
- | sudo podman secret create J0-dockerImages -
## Jupyter Secrets oauth2
- printf client-id-code | sudo podman secret create J0-client_id -
- printf client-secret-code | sudo podman secret create J0-client_secret -
- printf tenant-id-code | sudo podman secret create J0-tenant_id -
- printf https://server.domain.tld/hub/oauth_callback | sudo podman secret create J0-oauth_callback_url 
- sudo podman secret ls
## Jupyter Docker Stacks
- sudo podman pull quay.io/jupyter/julia-notebook:latest
- sudo podman pull quay.io/jupyter/scipy-notebook:latest
- sudo podman pull quay.io/jupyter/r-notebook:latest
- sudo podman pull quay.io/jupyter/tensorflow-notebook:latest
- sudo podman pull quay.io/jupyter/pytorch-notebook:latest

## Podman network dns_enabled
- sudo podman network inspect podman | jq .[] | sed s/dns_enabled\":\ false/dns_enabled\":\ true/g | sudo tee /etc/containers/networks/podman.json
- sudo systemctl enable --now podman

## jupyter-hub.container
```
[Container]
Image=docker.io/rlinfati/jupyter-lab0:hub
AutoUpdate=registry
RunInit=true
Secret=J0-admin_users
Secret=J0-dockerImages
Secret=J0-client_id
Secret=J0-client_secret
Secret=J0-tenant_id
Secret=J0-oauth_callback_url 
Volume=/run/podman/podman.sock:/var/run/docker.sock
PublishPort=8000:8000
PodmanArgs=--privileged

[Install]
WantedBy=multi-user.target
```
## jupyter-https.container
```
[Container]
Image=docker.io/library/caddy
AutoUpdate=registry
RunInit=true
Exec=caddy reverse-proxy --from server.domain.tld --to http://systemd-jupyter-hub:8000
PublishPort=80:80
PublishPort=443:443

[Install]
WantedBy=multi-user.target
```

## Jupyter NVIDIA
- sudo grubby --update-kernel=ALL --remove-args="rhgb"
- sudo dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel9/x86_64/cuda-rhel9.repo
- sudo dnf config-manager --add-repo https://developer.download.nvidia.com/hpc-sdk/rhel/nvhpc.repo
- sudo dnf module install nvidia-driver:535
- curl -O https://developer.download.nvidia.com/compute/cuda/repos/rhel9/x86_64/NVIDIA2019-public_key.der
- sudo mokutil --import NVIDIA2019-public_key.der
- sudo dnf install nvidia-container-toolkit
- sudo nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
- sudo podman run --rm -it --device=nvidia.com/gpu=all --entrypoint=bash docker.io/library/julia

## Podman Status
- sudo podman image ls --all
- sudo podman container ls --all
- sudo podman network ls
- sudo podman volume ls
- sudo podman secret ls
