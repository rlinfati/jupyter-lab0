# Jupyter LAB0

## Kubernetes
- jupyterhub_k8s

## NVIDIA
- sudo grubby --update-kernel=ALL --remove-args="rhgb"
- sudo dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel9/x86_64/cuda-rhel9.repo
- sudo dnf config-manager --add-repo https://developer.download.nvidia.com/hpc-sdk/rhel/nvhpc.repo
- sudo dnf module install nvidia-driver:535
- curl -O https://developer.download.nvidia.com/compute/cuda/repos/rhel9/x86_64/NVIDIA2019-public_key.der
- sudo mokutil --import NVIDIA2019-public_key.der
- sudo dnf install nvidia-container-toolkit
- sudo nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
- sudo podman run --rm -it --device=nvidia.com/gpu=all --entrypoint=bash docker.io/library/julia

## git commit
- git reset --soft HEAD^1 && git commit -a -m "Kubernetes" && git push -f
