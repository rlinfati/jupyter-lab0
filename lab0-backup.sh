#!/bin/sh

set -x

HOST_NAME=$(hostname -s)
DATE_TIME=$(date '+%Y-%m-%d-%H-%M-%S')

for i in $(sudo podman volume ls --noheading --format {{.Name}} --filter name=jupyter-user); do
    sudo podman volume export $i --output PV-$i-$HOST_NAME-$DATE_TIME.tar
    gzip PV-$i-$HOST_NAME-$DATE_TIME.tar
    scp  PV-$i-$HOST_NAME-$DATE_TIME.tar.gz rlinfati@mia.menoscero.com:/DataVolume/DataBackup/app-JupyterVolume/
    rm   PV-$i-$HOST_NAME-$DATE_TIME.tar.gz
done
# -o StrictHostKeychecking=no

exit 0
