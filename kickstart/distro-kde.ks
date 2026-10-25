# Live ISO KDE Plasma basata su Fedora, con dnf e kernel stabile recente.
# Costruita con livemedia-creator (vedi build.sh). $releasever e $basearch
# vengono espansi da dnf.

lang it_IT.UTF-8
keyboard --vckeymap=it --xlayouts='it'
timezone Europe/Rome
selinux --enforcing
firewall --enabled --service=mdns
xconfig --startxonboot
zerombr
clearpart --all
part / --size 12288 --fstype ext4
services --enabled=NetworkManager,ModemManager --disabled=sshd
network --bootproto=dhcp --device=link --activate
rootpw --lock --iscrypted locked
shutdown

url --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-$releasever&arch=$basearch
repo --name=updates --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f$releasever&arch=$basearch
# Repository locale con il pacchetto di branding, creato da build.sh
repo --name=distro-local --baseurl=file:///work/out/localrepo

%include kernel.ks

%packages
# Base live
@core
@standard
@base-x
@fonts
@hardware-support
@multimedia
@printing
@guest-desktop-agents
@networkmanager-submodules
glibc-all-langpacks
langpacks-it
livesys-scripts
dracut-live
dracut-config-generic
anaconda-live

# Kernel (dal COPR vanilla o da Fedora, secondo config.env)
kernel
kernel-modules
kernel-modules-extra

# Boot BIOS + UEFI della ISO
grub2-efi-x64
grub2-efi-x64-cdboot
grub2-pc-modules
grub2-tools
grub2-tools-extra
shim-x64
efibootmgr
isomd5sum

# Desktop KDE Plasma
@^kde-desktop-environment
@kde-apps
@kde-media
@firefox
plasma-discover

# Package manager
dnf5
dnf5-plugins

# Branding della distro
distro-branding

# Alleggerimento
-gnome-boxes
%end

%post
# Sessione live: avvio automatico di Plasma con utente "liveuser"
systemctl enable livesys.service livesys-late.service
sed -i 's/^livesys_session=.*/livesys_session="kde"/' /etc/sysconfig/livesys

# Pulizia per l'immagine
rm -f /var/lib/rpm/__db*
rm -f /etc/machine-id && touch /etc/machine-id
dnf clean all || true
%end
