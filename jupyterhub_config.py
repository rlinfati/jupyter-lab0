# jupyterhub_config.py
import sys

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
c.DockerSpawner.extra_host_config = { "oom_score_adj": 1000, "init": True }
c.DockerSpawner.allowed_images = [dockerImages.strip() for dockerImages in open('/run/secrets/J0-dockerImages')]

c.JupyterHub.services = [ { "name": "jupyterhub-idle-culler-service",
                            "command": [sys.executable, "-m", "jupyterhub_idle_culler", "--timeout=86400"],
                            "admin": True } ]

# eof
