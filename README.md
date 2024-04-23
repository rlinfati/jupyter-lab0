# Jupyter LAB0

## Fix Jupyter Volume User
- for i in $(sudo podman volume ls --noheading --format {{.Name}} --filter name=jupyter-user); do
- sudo chown 1000  /var/lib/containers/storage/volumes/$i/_data
- sudo chgrp  100 /var/lib/containers/storage/volumes/$i/_data
- sudo chmod 0755  /var/lib/containers/storage/volumes/$i/_data
- done

## Jupyter Secrets license
- sudo podman secret create GUROBIWLS /opt/gurobi/gurobi.lic
## Jupyter Secrets admin user
- printf superadmin@domain.tld | sudo podman secret create J0-admin_users -
## Jupyter Secrets docker
- printf '%s\n' \
- quay.io/jupyter/julia-notebook:latest \
- quay.io/jupyter/scipy-notebook:latest \
- quay.io/jupyter/r-notebook:latest \
- quay.io/jupyter/tensorflow-notebook:latest \
- quay.io/jupyter/pytorch-notebook:latest \
- docker.io/rlinfati/jupyter-lab0:julia-2024-xx \
- docker.io/rlinfati/jupyter-lab0:lab0-2024-xx \
- localhost/jupyter-lab0:julia-2024-xx \
- localhost/jupyter-lab0:lab0-2024-xx | sudo podman secret create J0-dockerImages -
## Jupyter Secrets oauth2
- printf client-id-code | sudo podman secret create J0-client_id -
- printf client-secret-code | sudo podman secret create J0-client_secret -
- printf tenant-id-code | sudo podman secret create J0-tenant_id -
- printf https://server.domain.tld/hub/oauth_callback | sudo podman secret create J0-oauth_callback_url -
- sudo podman secret ls
## Jupyter Docker Stacks
- sudo podman pull quay.io/jupyter/julia-notebook:latest
- sudo podman pull quay.io/jupyter/scipy-notebook:latest
- sudo podman pull quay.io/jupyter/r-notebook:latest
- sudo podman pull quay.io/jupyter/tensorflow-notebook:latest
- sudo podman pull quay.io/jupyter/pytorch-notebook:latest
## Jupyter Lab0
- sudo podman pull docker.io/rlinfati/jupyter-lab0:hub-2024-xx
- sudo podman pull docker.io/rlinfati/jupyter-lab0:julia-2024-xx
- sudo podman pull docker.io/rlinfati/jupyter-lab0:lab0-2024-xx
- sudo podman pull docker.io/rlinfati/jupyter-lab0:cudalab-2024-xx
## Jupyter Lab0 upload
- sudo podman login docker.io
- sudo podman push docker.io/rlinfati/jupyter-lab0:hub-2024-xx     docker.io/rlinfati/jupyter-lab0:hub-2024-xx
- sudo podman push docker.io/rlinfati/jupyter-lab0:julia-2024-xx   docker.io/rlinfati/jupyter-lab0:julia-2024-xx
- sudo podman push docker.io/rlinfati/jupyter-lab0:lab0-2024-xx    docker.io/rlinfati/jupyter-lab0:lab0-2024-xx
- sudo podman push docker.io/rlinfati/jupyter-lab0:cudalab-2024-xx docker.io/rlinfati/jupyter-lab0:cudalab-2024-xx

## Podman network dns_enabled
- sudo podman network inspect podman | jq .[] | sed s/dns_enabled\":\ false/dns_enabled\":\ true/g | sudo tee /etc/containers/networks/podman.json
- sudo systemctl enable --now podman

## Jupyter Build
- sudo podman build --tag jupyter-lab0:hub-2024-xx     github.com/rlinfati/jupyter-lab0 --file Dockerfile.HUB
- sudo podman build --tag jupyter-lab0:julia-2024-xx   github.com/rlinfati/jupyter-lab0 --file Dockerfile.JULIA
- sudo podman build --tag jupyter-lab0:lab0-2024-xx    github.com/rlinfati/jupyter-lab0 --file Dockerfile.LAB0
- sudo podman build --tag jupyter-lab0:cudalab-2024-xx github.com/rlinfati/jupyter-lab0 --file Dockerfile.CUDAlab

## Jupyter Run https
- sudo podman create --interactive --tty --oom-score-adj 901 --init --name jupyter-https --replace --publish 80:80 --publish 443:443 docker.io/library/caddy caddy reverse-proxy --from server.domain.tld --to http://jupyter-lab0:8000
- sudo podman start jupyter-https
- sudo podman logs -f jupyter-https
## Jupyter Run hub
- sudo podman create --interactive --tty --oom-score-adj 902 --init --name jupyter-lab0  --replace --secret J0-admin_users --secret J0-dockerImages --secret J0-client_id --secret J0-client_secret --secret J0-tenant_id --secret J0-oauth_callback_url --volume /run/podman/podman.sock:/var/run/docker.sock --privileged docker.io/rlinfati/jupyter-lab0:hub-2024-xx
- sudo podman start jupyter-lab0
- sudo podman logs -f jupyter-lab0
## Jupyter Run hub w/o https
- sudo podman create --interactive --tty --oom-score-adj 902 --init --name jupyter-lab0  --replace --publish 8000:8000 --secret J0-admin_users --secret J0-dockerImages --secret J0-client_id --secret J0-client_secret --secret J0-tenant_id --secret J0-oauth_callback_url --volume /run/podman/podman.sock:/var/run/docker.sock --privileged docker.io/rlinfati/jupyter-lab0:hub-2024-xx

## Jupyter Service
- sudo podman generate systemd --name jupyter-https | grep -v PIDFile | sudo tee /etc/systemd/system/jupyter-https.service
- sudo podman generate systemd --name jupyter-lab0 | grep -v PIDFile | sudo tee /etc/systemd/system/jupyter-lab0.service
- sudo systemctl daemon-reload
- sudo systemctl enable jupyter-https jupyter-lab0
- sudo systemctl start jupyter-https jupyter-lab0

## Jupyter NVIDIA
- sudo grubby --update-kernel=ALL --remove-args="rhgb"
- sudo dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel9/x86_64/cuda-rhel9.repo
- sudo dnf config-manager --add-repo https://developer.download.nvidia.com/hpc-sdk/rhel/nvhpc.repo
- sudo dnf module install nvidia-driver:535
- wget https://developer.download.nvidia.com/compute/cuda/repos/rhel9/x86_64/NVIDIA2019-public_key.der
- sudo mokutil --import NVIDIA2019-public_key.der
- sudo dnf install nvidia-container-toolkit
- sudo nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
- sudo podman run --rm -it --device=nvidia.com/gpu=all --entrypoint=bash docker.io/library/julia

## Jupyter CUDAlab Run
- sudo podman create --interactive --tty --oom-score-adj 999 --init --name jupyter-CUDAlab --replace --publish 8888:8888 --volume jupyter-user-CUDAlab:/home/jovyan/work --device=nvidia.com/gpu=all docker.io/rlinfati/jupyter-lab0:cudalab-2024-xx
- sudo podman start jupyter-CUDAlab
- sudo podman logs -f jupyter-CUDAlab
- sudo podman generate systemd --name jupyter-CUDAlab | grep -v PIDFile | sudo tee /etc/systemd/system/jupyter-CUDAlab.service
- sudo systemctl daemon-reload
- sudo systemctl enable jupyter-CUDAlab
- sudo systemctl start jupyter-CUDAlab

## Podman Status
- sudo podman image ls --all
- sudo podman container ls --all
- sudo podman network ls
- sudo podman volume ls
- sudo podman secret ls
