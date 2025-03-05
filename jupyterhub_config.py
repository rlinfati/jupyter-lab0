# jupyterhub_config.py
import sys
import os

c = get_config()

c.JupyterHub.hub_ip = "0.0.0.0"

c.JupyterHub.authenticator_class = "azuread"
c.Authenticator.admin_users = open("/run/secrets/J0-admin_users").read().strip()
c.OAuthenticator.oauth_callback_url = open("/run/secrets/J0-oauth_callback_url").read().strip()
c.OAuthenticator.client_id = open("/run/secrets/J0-client_id").read().strip()
c.OAuthenticator.client_secret = open("/run/secrets/J0-client_secret").read().strip()
c.OAuthenticator.allow_all = True
c.AzureAdOAuthenticator.tenant_id = open("/run/secrets/J0-tenant_id").read().strip()
c.AzureAdOAuthenticator.username_claim = "email"

c.JupyterHub.spawner_class = "dockerspawner.DockerSpawner"
c.DockerSpawner.use_internal_ip = True
c.DockerSpawner.network_name = "podman"
c.DockerSpawner.remove = True
c.DockerSpawner.volumes = { "jupyter-user-{username}": '/home/jovyan/work' }
c.DockerSpawner.extra_host_config = { "oom_score_adj": 999, "init": True }
c.DockerSpawner.allowed_images = [dockerImages.strip() for dockerImages in open('/run/secrets/J0-dockerImages')]

if os.path.exists("/run/secrets/J0-CUDA"):
    c.DockerSpawner.volumes.update({
        "/usr/bin/nvidia-smi"                     : {"bind": "/usr/local/libnvidia//nvidia-smi", "mode": "ro"},
        "/usr/lib64/libnvidia-ml.so.1"            : {"bind": "/usr/local/libnvidia/libnvidia-ml.so.1", "mode": "ro"},
        "/usr/lib64/libcuda.so"                   : {"bind": "/usr/local/libnvidia/libcuda.so"  , "mode": "ro"},
        "/usr/lib64/libcuda.so.1"                 : {"bind": "/usr/local/libnvidia/libcuda.so.1", "mode": "ro"},
        "/usr/lib64/libnvidia-ptxjitcompiler.so"  : {"bind": "/usr/local/libnvidia/libnvidia-ptxjitcompiler.so"  , "mode": "ro"},
        "/usr/lib64/libnvidia-ptxjitcompiler.so.1": {"bind": "/usr/local/libnvidia/libnvidia-ptxjitcompiler.so.1", "mode": "ro"},
        "/usr/lib64/libcudadebugger.so.1"         : {"bind": "/usr/local/libnvidia/libcudadebugger.so.1", "mode": "ro"},
        "/usr/lib64/libnvidia-nvvm.so"            : {"bind": "/usr/local/libnvidia/libnvidia-nvvm.so"  , "mode": "ro"},
        "/usr/lib64/libnvidia-nvvm.so.4"          : {"bind": "/usr/local/libnvidia/libnvidia-nvvm.so.4", "mode": "ro"},
        "/usr/lib64/libnvidia-cfg.so"             : {"bind": "/usr/local/libnvidia/libnvidia-cfg.so"  , "mode": "ro"},
        "/usr/lib64/libnvidia-cfg.so.1"           : {"bind": "/usr/local/libnvidia/libnvidia-cfg.so.1", "mode": "ro"},
    })

if os.path.exists("/run/secrets/J0-CUDA"):
    c.DockerSpawner.extra_host_config.update({
        "devices": [
            "/dev/nvidiactl:/dev/nvidiactl",
            "/dev/nvidia0:/dev/nvidia0",
            "/dev/nvidia-uvm:/dev/nvidia-uvm",
            "/dev/nvidia-uvm-tools:/dev/nvidia-uvm-tools",
        ],
    })

if os.path.exists("/run/secrets/J0-CUDA1"):
    c.DockerSpawner.extra_host_config["devices"].append(
        "/dev/nvidia1:/dev/nvidia1"
    )

c.JupyterHub.services = [ { "name": "jupyterhub-idle-culler-service",
                            "command": [sys.executable, "-m", "jupyterhub_idle_culler", "--timeout=86400"],
                            "admin": True } ]

# eof
