#!/bin/sh

set -x

HOST_NAME=$(hostname -s)
DATE_TIME=$(date '+%Y-%m-%d-%H-%M-%S')

for i in $(sudo podman volume ls --noheading --format {{.Name}} ); do
    sudo podman volume export $i --output JV-$HOST_NAME-$DATE_TIME-$i.tar
    gzip JV-$HOST_NAME-$DATE_TIME-$i.tar
    scp  JV-$HOST_NAME-$DATE_TIME-$i.tar.gz rlinfati@mia.menoscero.com:/DataVolume/DataBackup/app-JupyterVolume/
    rm   JV-$HOST_NAME-$DATE_TIME-$i.tar.gz
done
# -o StrictHostKeychecking=no

exit 0
