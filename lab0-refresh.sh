#!/bin/sh

set -x

sudo podman pull registry.access.redhat.com/ubi9/ubi:latest
sudo podman pull docker.io/library/caddy:latest

sudo podman pull quay.io/jupyter/julia-notebook:latest
sudo podman pull quay.io/jupyter/scipy-notebook:latest
sudo podman pull quay.io/jupyter/r-notebook:latest
sudo podman pull quay.io/jupyter/tensorflow-notebook:latest
sudo podman pull quay.io/jupyter/pytorch-notebook:latest

sudo podman image prune --force

if [[ $(uname -m) == "x86_64" ]]; then
    sudo podman pull docker.io/rlinfati/jupyter-lab0:hub-999

    sudo podman pull docker.io/rlinfati/jupyter-lab0:julia-110
    sudo podman pull docker.io/rlinfati/jupyter-lab0:cudalab-110

    sudo podman pull docker.io/rlinfati/jupyter-lab0:julia-111
    sudo podman pull docker.io/rlinfati/jupyter-lab0:cudalab-111

    sudo podman image prune --force
else
    sudo podman build --tag rlinfati/jupyter-lab0:hub-999       github.com/rlinfati/jupyter-lab0 --file Dockerfile.HUB && \
    sudo podman build                                           github.com/rlinfati/jupyter-lab0 --file Dockerfile.ORlib --build-arg UNAMEM1=aarch64 --build-arg CPU_TARGET="neoverse-n1" --secret id=GUROBIWLS && \
    sudo podman build --tag rlinfati/jupyter-lab0:julia-999     github.com/rlinfati/jupyter-lab0 --file Dockerfile.JULIA --build-arg UNAMEM1=aarch64 --build-arg CPU_TARGET="neoverse-n1" --secret id=GUROBIWLS && \
    sudo podman build --tag rlinfati/jupyter-lab0:cudalab-999   github.com/rlinfati/jupyter-lab0 --file Dockerfile.CUDAlab && \
    sudo podman image prune --force
fi

sudo podman image ls -a
sudo podman container ls
sudo systemctl start podman-auto-update
sudo podman image ls -a
sudo podman container ls

exit 0
