# jupyterhub_config_k8s.py

import sys
import os
import socket

c = get_config()

c.JupyterHub.hub_ip = "0.0.0.0"
#with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as s:
#    s.connect(("kubernetes.default.svc", 443))
#    c.JupyterHub.hub_connect_url = "http://" + s.getsockname()[0] + ":8001"
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

c.KubeSpawner.image_pull_policy = "IfNotPresent"

c.KubeSpawner.cpu_guarantee = 1
c.KubeSpawner.cpu_limit     = 4
c.KubeSpawner.mem_guarantee = "4G"
c.KubeSpawner.mem_limit     = "16G"

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

c.JupyterHub.spawner_class = "kubespawner.KubeSpawner"

PROFILE_RLINFATI = [ {
        "display_name": "docker.io - rlinfati/jupyter-lab0",
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
                    "anaconda-999": {
                        "display_name": "Anaconda",
                        "kubespawner_override": {
                            "image": "docker.io/rlinfati/jupyter-lab0:Anaconda-999",
                        },
                    },
                    "julia-999": {
                        "display_name": "Julia - multiarch",
                        "kubespawner_override": {
                            "image": "docker.io/rlinfati/jupyter-lab0:julia-999",
                        },
                    },
                },
            },
        },
    },
]

PROFILE_CUDA = [ {
        "display_name": "docker.io - rlinfati/jupyter-lab0 - CUDA",
        "kubespawner_override": {
            "extra_resource_limits": { "nvidia.com/gpu": "1" },
            "allowPrivilegeEscalation": True,
            "privileged": True,
        },
        "profile_options": {
            "image": {
                "display_name": "Contenedor:",
                "choices": {
                    "juliacuda-111": {
                        "display_name": "Julia 1.11 + CUDA",
                        "kubespawner_override": {
                            "image": "docker.io/rlinfati/jupyter-lab0:juliacuda-111",
                        },
                    },
                    "anaconda-999": {
                        "display_name": "Anaconda + CUDA",
                        "kubespawner_override": {
                            "image": "docker.io/rlinfati/jupyter-lab0:Anaconda-999",
                        },
                    },
                    "nvpytorch-999": {
                        "display_name": "NVIDIA PyTorch + CUDA",
                        "kubespawner_override": {
                            "image": "docker.io/rlinfati/jupyter-lab0:NVpytorch-999",
                        },
                    },
                    "nvtensorflow-999": {
                        "display_name": "NVIDIA TensorFlow + CUDA",
                        "kubespawner_override": {
                            "image": "docker.io/rlinfati/jupyter-lab0:NVtensorflow-999",
                        },
                    },
                },
            },
        },
    },
]

PROFILE_JUPYTER = [ {
        "display_name": "quay.io - jupyter",
        "profile_options": {
            "image": {
                "display_name": "Contenedor:",
                "choices": {
                    "julia-notebook": {
                        "display_name": "Julia Notebook",
                        "kubespawner_override": {
                            "image": "quay.io/jupyter/julia-notebook:latest",
                        },
                    },
                    "scipy-notebook": {
                        "display_name": "SciPy Notebook",
                        "kubespawner_override": {
                            "image": "quay.io/jupyter/scipy-notebook:latest",
                        },
                    },
                    "r-notebook": {
                        "display_name": "R Notebook",
                        "kubespawner_override": {
                            "image": "quay.io/jupyter/r-notebook:latest",
                        },
                    },
                    "tensorflow-notebook": {
                        "display_name": "TensorFlow Notebook",
                        "kubespawner_override": {
                            "image": "quay.io/jupyter/tensorflow-notebook:latest",
                        },
                    },
                    "pytorch-notebook": {
                        "display_name": "PyTorch Notebook",
                        "kubespawner_override": {
                            "image": "quay.io/jupyter/pytorch-notebook:latest",
                        },
                    },
                },
            },
        },
    },
]

c.KubeSpawner.profile_list = PROFILE_RLINFATI + PROFILE_CUDA + PROFILE_JUPYTER

c.JupyterHub.services = [ { "name": "jupyterhub-idle-culler-service",
                            "command": [sys.executable, "-m", "jupyterhub_idle_culler", "--timeout=86400"],
                            "admin": True } ]

# eof
