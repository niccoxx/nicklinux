#!/usr/bin/env bash
# Costruisce la ISO live in un container Fedora privilegiato.
# Requisiti sull'host: podman (o docker), ~25 GB liberi, connessione internet.
# Uso: ./build.sh            -> out/result/<nome>.iso
set -euo pipefail
cd "$(dirname "$0")"
set -a; source ./config.env; set +a

ENGINE=${ENGINE:-$(command -v podman || command -v docker || true)}
[ -n "$ENGINE" ] || { echo "Serve podman o docker" >&2; exit 1; }

mkdir -p out
exec "$ENGINE" run --rm --privileged \
    -v "$PWD":/work:z -w /work \
    -e DISTRO_NAME -e DISTRO_ID -e DISTRO_URL -e KERNEL_SOURCE -e ARCH \
    "registry.fedoraproject.org/fedora:${FEDORA_RELEASE}" \
    bash /work/scripts/build-in-container.sh
