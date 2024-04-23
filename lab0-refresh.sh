#!/bin/sh

set -x

sudo podman pull registry.access.redhat.com/ubi9/ubi:latest
sudo podman pull docker.io/cloudflare/cloudflared:latest
sudo podman pull docker.io/library/caddy:latest

sudo podman pull quay.io/jupyter/julia-notebook:latest
sudo podman pull quay.io/jupyter/scipy-notebook:latest
sudo podman pull quay.io/jupyter/r-notebook:latest
sudo podman pull quay.io/jupyter/tensorflow-notebook:latest
sudo podman pull quay.io/jupyter/pytorch-notebook:latest

sudo podman image prune --force

if [[ $(uname -m) == "x86_64" ]]; then
    sudo podman pull docker.io/rlinfati/jupyter-lab0:hub-2024-xx
    sudo podman pull docker.io/rlinfati/jupyter-lab0:julia-2024-xx
    sudo podman pull docker.io/rlinfati/jupyter-lab0:lab0-2024-xx
    sudo podman pull docker.io/rlinfati/jupyter-lab0:cudalab-2024-xx

    sudo podman pull docker.io/rlinfati/jupyter-lab0:hub-2024-03
    sudo podman pull docker.io/rlinfati/jupyter-lab0:julia-2024-03
    sudo podman pull docker.io/rlinfati/jupyter-lab0:lab0-2024-03
    sudo podman pull docker.io/rlinfati/jupyter-lab0:cudalab-2024-03

    sudo podman image prune --force
else
    sudo podman build --tag jupyter-lab0:hub-2024-xx github.com/rlinfati/jupyter-lab0 --file Dockerfile.HUB
    sudo podman build --tag jupyter-lab0:julia-2024-xx github.com/rlinfati/jupyter-lab0 --file Dockerfile.JULIA --build-arg UNAMEM1=aarch64 --build-arg CPU_TARGET="neoverse-n1"
    sudo podman build --tag jupyter-lab0:lab0-2024-xx github.com/rlinfati/jupyter-lab0 --file Dockerfile.LAB0 --secret id=GUROBIWLS
    sudo podman build --tag jupyter-lab0:cudalab-2024-xx github.com/rlinfati/jupyter-lab0 --file Dockerfile.CUDAlab

    sudo podman image prune --force
fi

exit 0
