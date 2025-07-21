#!/bin/sh

set -ex

sudo podman pull registry.access.redhat.com/ubi9/ubi:latest
sudo podman pull registry.access.redhat.com/ubi9/ubi-init:latest
sudo podman pull registry.access.redhat.com/ubi9/ubi-minimal:latest
sudo podman pull registry.access.redhat.com/ubi9/ubi-micro:latest

sudo podman pull registry.access.redhat.com/ubi10/ubi:latest
sudo podman pull registry.access.redhat.com/ubi10/ubi-init:latest
sudo podman pull registry.access.redhat.com/ubi10/ubi-minimal:latest
sudo podman pull registry.access.redhat.com/ubi10/ubi-micro:latest

sudo podman pull docker.io/library/caddy:latest

sudo podman pull quay.io/jupyter/julia-notebook:latest
sudo podman pull quay.io/jupyter/scipy-notebook:latest
sudo podman pull quay.io/jupyter/r-notebook:latest
sudo podman pull quay.io/jupyter/tensorflow-notebook:latest
sudo podman pull quay.io/jupyter/pytorch-notebook:latest

sudo podman image prune --force

sudo podman pull docker.io/rlinfati/jupyter-lab0:hub
sudo podman pull docker.io/rlinfati/jupyter-lab0:k8s
sudo podman pull docker.io/rlinfati/jupyter-lab0:Anaconda
sudo podman pull docker.io/rlinfati/jupyter-lab0:julia-110
sudo podman pull docker.io/rlinfati/jupyter-lab0:julia-111

if [[ -c /dev/nvidiactl ]]; then
    sudo podman pull docker.io/rlinfati/jupyter-lab0:julia-111-cuda
    sudo podman pull docker.io/rlinfati/jupyter-lab0:NVpytorch
    sudo podman pull docker.io/rlinfati/jupyter-lab0:NVtensorflow
    sudo podman pull quay.io/jupyter/tensorflow-notebook:cuda-latest
    sudo podman pull quay.io/jupyter/pytorch-notebook:cuda12-latest
fi

sudo systemctl restart jupyter-hub.service
sudo podman image prune --force

sudo podman image ls -a
sudo podman container ls
sudo systemctl start podman-auto-update
sudo podman image ls -a
sudo podman container ls

exit 0
