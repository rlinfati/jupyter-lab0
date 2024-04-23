#!/bin/sh

set -x

case $(hostname --short) in
  gru)
    sudo podman create --interactive --tty --oom-score-adj 902 --init --name jupyter-lab0  --replace                     --secret J0-admin_users --secret J0-dockerImages --secret J0-client_id --secret J0-client_secret --secret J0-tenant_id --secret J0-oauth_callback_url --volume /run/podman/podman.sock:/var/run/docker.sock --privileged localhost/jupyter-lab0:hub-2024-xx
    sudo systemctl start jupyter-lab0
    sudo podman image prune --force
    sudo podman logs jupyter-lab0
    ;;
  chela)
    sudo podman create --interactive --tty --oom-score-adj 902 --init --name jupyter-lab0     --replace --publish 8000:8000 --secret J0-admin_users --secret J0-dockerImages --secret J0-client_id --secret J0-client_secret --secret J0-tenant_id --secret J0-oauth_callback_url --volume /run/podman/podman.sock:/var/run/docker.sock --privileged docker.io/rlinfati/jupyter-lab0:hub-2024-xx
    sudo systemctl start jupyter-lab0
    sudo podman image prune --force
    sudo podman logs jupyter-lab0
    ;;
  birra)
    sudo podman create --interactive --tty --oom-score-adj 902 --init --name jupyter-lab0     --replace --publish 8000:8000 --secret J0-admin_users --secret J0-dockerImages --secret J0-client_id --secret J0-client_secret --secret J0-tenant_id --secret J0-oauth_callback_url --volume /run/podman/podman.sock:/var/run/docker.sock --privileged docker.io/rlinfati/jupyter-lab0:hub-2024-xx
    sudo systemctl start jupyter-lab0
    sudo podman image prune --force
    sudo podman logs jupyter-lab0
    ;;
  synco)
    sudo podman create --interactive --tty --oom-score-adj 902 --init --name jupyter-lab0     --replace                     --secret J0-admin_users --secret J0-dockerImages --secret J0-client_id --secret J0-client_secret --secret J0-tenant_id --secret J0-oauth_callback_url --volume /run/podman/podman.sock:/var/run/docker.sock --privileged docker.io/rlinfati/jupyter-lab0:hub-2024-xx
    sudo systemctl start jupyter-lab0
    sudo podman image prune --force
    sudo podman logs jupyter-lab0
    echo
    sudo podman create --interactive --tty --oom-score-adj 999 --init --name jupyter-CUDAlab --replace --publish 8888:8888 --volume jupyter-user-CUDAlab:/home/jovyan/work --device=nvidia.com/gpu=all docker.io/rlinfati/jupyter-lab0:cudalab-2024-xx
    sudo systemctl start jupyter-CUDAlab
    sudo podman image prune --force
    sudo podman logs jupyter-CUDAlab
    ;;
  cosyn)
    sudo podman create --interactive --tty --oom-score-adj 902 --init --name jupyter-lab0     --replace                     --secret J0-admin_users --secret J0-dockerImages --secret J0-client_id --secret J0-client_secret --secret J0-tenant_id --secret J0-oauth_callback_url --volume /run/podman/podman.sock:/var/run/docker.sock --privileged docker.io/rlinfati/jupyter-lab0:hub-2024-xx
    sudo systemctl start jupyter-lab0
    sudo podman image prune --force
    sudo podman logs jupyter-lab0
    ;;
esac

exit 0
