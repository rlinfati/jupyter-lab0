#!/bin/sh

set -x

if [ -z "$1" ]; then
    echo "Uso: $0 <host>"
    exit 1
fi

HOST="$1"
SHORT_HOST=$(echo "$HOST" | cut -f1 -d.)
DATE_TIME=$(date '+%Y-%m-%d-%H-%M-%S')
volist=$(ssh "$HOST" sudo podman volume ls --noheading --format '{{.Name}}' --filter name=jupyter-user)

echo "Host: $HOST"
echo "Volúmenes encontrados: $volist"

for volume in $volist; do
    TAR_FILE="PV-${volume}-${SHORT_HOST}-${DATE_TIME}.tar"
    echo "Exportando volumen $volume a $TAR_FILE"

    ssh "$HOST" sudo podman volume export "$volume" > "$TAR_FILE"
    gzip "$TAR_FILE"
done

exit 0 
