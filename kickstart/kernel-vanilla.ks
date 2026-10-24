# Ultimo kernel stabile da kernel.org, pacchettizzato da Fedora (COPR @kernel-vanilla/stable).
# Ha versione più alta del kernel Fedora, quindi dnf lo preferisce automaticamente.
repo --name=kernel-vanilla-stable --baseurl=https://download.copr.fedorainfracloud.org/results/@kernel-vanilla/stable/fedora-$releasever-$basearch/

%post
cat > /etc/yum.repos.d/kernel-vanilla-stable.repo <<'REPO'
[kernel-vanilla-stable]
name=Kernel vanilla stable (kernel.org)
baseurl=https://download.copr.fedorainfracloud.org/results/@kernel-vanilla/stable/fedora-$releasever-$basearch/
type=rpm-md
gpgcheck=1
gpgkey=https://download.copr.fedorainfracloud.org/results/@kernel-vanilla/stable/pubkey.gpg
repo_gpgcheck=0
enabled=1
enabled_metadata=1
REPO
%end
