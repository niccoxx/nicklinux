# Branding della distro. Nome e id arrivano da build.sh con --define.
%{!?distro_name: %global distro_name NickLinux}
%{!?distro_id: %global distro_id nicklinux}
%{!?distro_url: %global distro_url https://example.org}

Name:           distro-branding
Version:        1.0
Release:        1%{?dist}
Summary:        Branding per %{distro_name}
License:        MIT
BuildArch:      noarch
Source0:        apply-branding.sh
Requires:       fedora-release-common

%description
Imposta nome, logo testuale e identità di %{distro_name} sopra la base Fedora
(os-release, /etc/issue, GRUB, Plasma). Si riapplica da solo quando
fedora-release viene aggiornato.

%prep

%build

%install
install -Dm0755 %{SOURCE0} %{buildroot}%{_libexecdir}/distro-branding/apply
cat > %{buildroot}%{_libexecdir}/distro-branding/branding.conf <<CONF
DISTRO_NAME="%{distro_name}"
DISTRO_ID="%{distro_id}"
DISTRO_URL="%{distro_url}"
CONF

%post
%{_libexecdir}/distro-branding/apply || :

%triggerin -- fedora-release-common, kde-settings
%{_libexecdir}/distro-branding/apply || :

%files
%{_libexecdir}/distro-branding/

%changelog
* Sat Oct 24 2026 Distro Builder <builder@example.org> - 1.0-1
- Prima versione
