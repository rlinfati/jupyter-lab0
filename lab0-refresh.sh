#!/bin/sh

set -ex

sudo podman pull docker.io/library/caddy:alpine

sudo podman pull quay.io/jupyter/julia-notebook:latest
sudo podman pull quay.io/jupyter/scipy-notebook:latest
sudo podman pull quay.io/jupyter/r-notebook:latest
sudo podman pull quay.io/jupyter/tensorflow-notebook:latest
sudo podman pull quay.io/jupyter/pytorch-notebook:latest

sudo podman image prune --force

sudo podman pull docker.io/rlinfati/jupyter-lab0:hub
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

sudo podman image prune --force
sudo podman image ls -a
sudo podman container ls

sudo systemctl start podman-auto-update
sudo podman image ls -a
sudo podman container ls

exit 0
