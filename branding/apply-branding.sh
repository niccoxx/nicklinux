#!/bin/sh
# Scrive /etc/os-release (che ha la precedenza su /usr/lib/os-release)
# con l'identità della distro, mantenendo la versione di Fedora sottostante.
set -e
. /usr/libexec/distro-branding/branding.conf
VERSION_ID=$(. /usr/lib/os-release && echo "$VERSION_ID")

rm -f /etc/os-release
cat > /etc/os-release <<OS
NAME="$DISTRO_NAME"
VERSION="$VERSION_ID (KDE Plasma)"
ID=$DISTRO_ID
ID_LIKE=fedora
VERSION_ID=$VERSION_ID
PLATFORM_ID="platform:f$VERSION_ID"
PRETTY_NAME="$DISTRO_NAME $VERSION_ID (KDE Plasma)"
ANSI_COLOR="0;38;2;61;174;233"
LOGO=fedora-logo-icon
HOME_URL="$DISTRO_URL"
VARIANT="KDE Plasma"
VARIANT_ID=kde
OS

printf '%s %s\nKernel \\r su \\m (\\l)\n\n' "$DISTRO_NAME" "$VERSION_ID" > /etc/issue

if [ -f /etc/default/grub ]; then
    sed -i "s/^GRUB_DISTRIBUTOR=.*/GRUB_DISTRIBUTOR=\"$DISTRO_NAME\"/" /etc/default/grub
fi
