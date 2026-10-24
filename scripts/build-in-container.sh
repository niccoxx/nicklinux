#!/usr/bin/env bash
# Eseguito dentro il container Fedora da build.sh
set -euo pipefail
cd /work
export DISTRO_NAME DISTRO_ID DISTRO_URL KERNEL_SOURCE ARCH

dnf -y install lorax anaconda-tui pykickstart rpm-build createrepo_c xorriso
RELEASEVER=$(rpm -E %fedora)
echo ">> Base Fedora $RELEASEVER, kernel: $KERNEL_SOURCE"

# 1. Pacchetto di branding + repository locale
rm -rf out/rpmbuild out/localrepo out/result
mkdir -p out/rpmbuild/SOURCES out/localrepo
cp branding/apply-branding.sh out/rpmbuild/SOURCES/
rpmbuild -bb branding/distro-branding.spec \
    --define "_topdir /work/out/rpmbuild" \
    --define "distro_name $DISTRO_NAME" \
    --define "distro_id $DISTRO_ID" \
    --define "distro_url $DISTRO_URL"
cp out/rpmbuild/RPMS/noarch/*.rpm out/localrepo/
createrepo_c out/localrepo

# 2. Kickstart unico
cp "kickstart/kernel-${KERNEL_SOURCE}.ks" kickstart/kernel.ks
(cd kickstart && ksflatten -c distro-kde.ks -o ../out/flat.ks)
ksvalidator out/flat.ks

# 3. ISO live
ISO_NAME="${DISTRO_ID}-kde-${RELEASEVER}-${ARCH}.iso"
VOLID=$(echo "${DISTRO_ID}-KDE-${RELEASEVER}" | tr '[:lower:]' '[:upper:]' | cut -c1-32)
livemedia-creator \
    --ks out/flat.ks \
    --no-virt \
    --make-iso \
    --iso-only \
    --iso-name "$ISO_NAME" \
    --project "$DISTRO_NAME" \
    --volid "$VOLID" \
    --releasever "$RELEASEVER" \
    --resultdir /work/out/result \
    --logfile /work/out/lmc.log \
    --nomacboot

echo ">> Fatto: out/result/$ISO_NAME"
