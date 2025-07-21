# jupyterhub_config_k8s.py

import sys
import os
import socket

c = get_config()

c.JupyterHub.hub_ip = "0.0.0.0"
c.JupyterHub.hub_connect_url = "http://" + socket.gethostbyname( socket.gethostname() ) + ":8001"

c.JupyterHub.authenticator_class = "dummy"
"""
c.JupyterHub.authenticator_class = "azuread"
c.Authenticator.admin_users = open("/run/secrets/J0-admin_users").read().strip()
c.OAuthenticator.oauth_callback_url = open("/run/secrets/J0-oauth_callback_url").read().strip()
c.OAuthenticator.client_id = open("/run/secrets/J0-client_id").read().strip()
c.OAuthenticator.client_secret = open("/run/secrets/J0-client_secret").read().strip()
c.OAuthenticator.allow_all = True
c.AzureAdOAuthenticator.tenant_id = open("/run/secrets/J0-tenant_id").read().strip()
c.AzureAdOAuthenticator.username_claim = "email"
"""

c.JupyterHub.spawner_class = "kubespawner.KubeSpawner"
c.KubeSpawner.image_pull_policy = "IfNotPresent"

c.KubeSpawner.volume_mounts = [ {
        "name": "jupyter-user-{username}",
        "mountPath": "/home/jovyan/work",
} ]
c.KubeSpawner.volumes = [ {
        "name": "jupyter-user-{username}",
        "persistentVolumeClaim": {"claimName": "jupyter-{username}-work"},
} ]
c.KubeSpawner.storage_pvc_ensure = True
c.KubeSpawner.storage_class = "jupyter-localpath-sc"
c.KubeSpawner.pvc_name_template = "jupyter-{username}-work"
c.KubeSpawner.storage_capacity = "8Gi"
c.KubeSpawner.storage_extra_annotations = {"volumeType": "local"}

PROFILE_RLINFATI = {
    "profile_options": {
        "image": {
            "display_name": "Contenedor:",
            "choices": {
                "julia-111": {
                    "display_name": "Julia 1.11",
                    "kubespawner_override": {
                        "image": "docker.io/rlinfati/jupyter-lab0:julia-111",
                    },
                },
                "julia-110": {
                    "display_name": "Julia 1.10",
                    "kubespawner_override": {
                        "image": "docker.io/rlinfati/jupyter-lab0:julia-110",
                    },
                },
                "julia-999": {
                    "display_name": "Julia",
                    "kubespawner_override": {
                        "image": "docker.io/rlinfati/jupyter-lab0:julia-999",
                    },
                },
                "anaconda-999": {
                    "display_name": "Anaconda",
                    "kubespawner_override": {
                        "image": "docker.io/rlinfati/jupyter-lab0:Anaconda-999",
                    },
                },
            },
        },
    },    
}

PROFILE_JUPYTER = {
    "profile_options": {
        "image": {
            "display_name": "Contenedor:",
            "choices": {
                "julia-notebook": {
                    "display_name": "Notebook Julia",
                    "kubespawner_override": {
                        "image": "quay.io/jupyter/julia-notebook:latest",
                    },
                },
                "scipy-notebook": {
                    "display_name": "Notebook SciPy",
                    "kubespawner_override": {
                        "image": "quay.io/jupyter/scipy-notebook:latest",
                    },
                },
                "r-notebook": {
                    "display_name": "Notebook R",
                    "kubespawner_override": {
                        "image": "quay.io/jupyter/r-notebook:latest",
                    },
                },
                "tensorflow-notebook": {
                    "display_name": "Notebook TensorFlow",
                    "kubespawner_override": {
                        "image": "quay.io/jupyter/tensorflow-notebook:latest",
                    },
                },
                "pytorch-notebook": {
                    "display_name": "Notebook PyTorch",
                    "kubespawner_override": {
                        "image": "quay.io/jupyter/pytorch-notebook:latest",
                    },
                },
            },
        },
    },
}

PROFILE_CUDA = {
    "profile_options": {
        "image": {
            "display_name": "Contenedor:",
            "choices": {
                "juliacuda-111": {
                    "display_name": "Julia + CUDA",
                    "kubespawner_override": {
                        "image": "docker.io/rlinfati/jupyter-lab0:juliacuda-111",
                    },
                },
                "anaconda-999": {
                    "display_name": "Anaconda",
                    "kubespawner_override": {
                        "image": "docker.io/rlinfati/jupyter-lab0:Anaconda-999",
                    },
                },
                "nvpytorch-999": {
                    "display_name": "NVIDIA PyTorch",
                    "kubespawner_override": {
                        "image": "docker.io/rlinfati/jupyter-lab0:NVpytorch-999",
                    },
                },
                "nvtensorflow-999": {
                    "display_name": "NVIDIA TensorFlow",
                    "kubespawner_override": {
                        "image": "docker.io/rlinfati/jupyter-lab0:NVtensorflow-999",
                    },
                },
                "tensorflow-notebook": {
                    "display_name": "Notebook TensorFlow-cuda",
                    "kubespawner_override": {
                        "image": "quay.io/jupyter/tensorflow-notebook:cuda-latest",
                    },
                },
                "pytorch-notebook": {
                    "display_name": "Notebook PyTorch-cuda12",
                    "kubespawner_override": {
                        "image": "quay.io/jupyter/pytorch-notebook:cuda12-latest",
                    },
                },
            },
        },
    },
}

c.KubeSpawner.profile_list = [
    {
        "display_name": "docker.io - rlinfati/jupyter-lab0 - 1/CPU 7/RAM",
        "kubespawner_override": {
            "cpu_limit": 1,
            "mem_limit": "7G",
        },
        **PROFILE_RLINFATI
    },
    {
        "display_name": "quay.io - jupyter - 1/CPU 7/RAM",
        "kubespawner_override": {
            "cpu_limit": 1,
            "mem_limit": "7G",
        },
        **PROFILE_JUPYTER
    },

    {
        "display_name": "docker.io - rlinfati/jupyter-lab0 - 4/CPU 30/RAM",
        "kubespawner_override": {
            "cpu_limit": 4,
            "mem_limit": "30G",
        },
        **PROFILE_RLINFATI
    },
    {
        "display_name": "docker.io - rlinfati/jupyter-lab0 - 12/CPU 120/RAM",
        "kubespawner_override": {
            "cpu_limit": 12,
            "mem_limit": "120G",
        },
        **PROFILE_RLINFATI
    },
    {
        "display_name": "docker.io - rlinfati/jupyter-lab0 - 12/CPU 120/RAM 1/GPU",
        "kubespawner_override": {
            "cpu_limit": 12,
            "mem_limit": "120G",
            "extra_resource_limits": { "nvidia.com/gpu": "1" },
            "allow_privilege_escalation": True,
            "privileged": True,
        },
        **PROFILE_CUDA
    },


    {
        "display_name": "docker.io - rlinfati/jupyter-lab0",
        **PROFILE_RLINFATI
    },
    {
        "display_name": "docker.io - rlinfati/jupyter-lab0 - 1/GPU",
        "kubespawner_override": {
            "extra_resource_limits": { "nvidia.com/gpu": "1" },
            "allow_privilege_escalation": True,
            "privileged": True,
        },
        **PROFILE_CUDA
    },
    {
        "display_name": "quay.io - jupyter",
        **PROFILE_JUPYTER
    },
]

c.JupyterHub.services = [ { "name": "jupyterhub-idle-culler-service",
                            "command": [sys.executable, "-m", "jupyterhub_idle_culler", "--timeout=86400"],
                            "admin": True } ]

# eof
