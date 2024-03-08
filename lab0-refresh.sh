#!/bin/sh

set -x

sudo podman pull quay.io/jupyter/base-notebook:ubuntu-22.04
sudo podman pull quay.io/jupyter/minimal-notebook:ubuntu-22.04
sudo podman pull quay.io/jupyter/julia-notebook:ubuntu-22.04
sudo podman pull quay.io/jupyter/scipy-notebook:ubuntu-22.04
sudo podman pull quay.io/jupyter/r-notebook:ubuntu-22.04
sudo podman pull quay.io/jupyter/datascience-notebook:ubuntu-22.04

sudo podman image prune --force

if [[ $(uname -m) == "x86_64" ]]; then
    sudo podman pull docker.io/rlinfati/jupyter-lab0:hub-2024-xx
    sudo podman pull docker.io/rlinfati/jupyter-lab0:julia-2024-xx
    sudo podman pull docker.io/rlinfati/jupyter-lab0:lab0-2024-xx
    sudo podman pull docker.io/rlinfati/jupyter-lab0:lab0lab-2024-xx
    sudo podman pull docker.io/rlinfati/jupyter-lab0:cudalab-2024-xx

    sudo podman pull docker.io/rlinfati/jupyter-lab0:hub-2024-03
    sudo podman pull docker.io/rlinfati/jupyter-lab0:julia-2024-03
    sudo podman pull docker.io/rlinfati/jupyter-lab0:lab0-2024-03
    sudo podman pull docker.io/rlinfati/jupyter-lab0:lab0lab-2024-03
    sudo podman pull docker.io/rlinfati/jupyter-lab0:cudalab-2024-03

    sudo podman image prune --force
else
    sudo podman build --tag jupyter-lab0:hub-2024-xx github.com/rlinfati/jupyter-lab0 --file Dockerfile.HUB
    sudo podman build --tag jupyter-lab0:julia-2024-xx github.com/rlinfati/jupyter-lab0 --file Dockerfile.JULIA
    sudo podman build --tag jupyter-lab0:lab0-2024-xx --secret id=GUROBIWLS github.com/rlinfati/jupyter-lab0 --file Dockerfile.LAB0
    sudo podman build --tag jupyter-lab0:lab0lab-2024-xx github.com/rlinfati/jupyter-lab0 --file Dockerfile.LAB0lab
    sudo podman build --tag jupyter-lab0:cudalab-2024-xx github.com/rlinfati/jupyter-lab0 --file Dockerfile.CUDAlab

    sudo podman image prune --force
fi

exit 0
