# NickLinux

Distro live installabile basata su **Fedora**, con:

- **dnf** (dnf5) come package manager e i repository Fedora per gli aggiornamenti
- **KDE Plasma** come desktop, sessione live con login automatico
- **ultimo kernel stabile** di kernel.org (COPR `@kernel-vanilla/stable`, mantenuto da sviluppatori del kernel Fedora); in alternativa il kernel Fedora
- installer Anaconda per installarla su disco
- branding proprio (os-release, /etc/issue, GRUB, "Informazioni sul sistema" di Plasma) che sopravvive agli aggiornamenti

## Struttura

| File | Cosa fa |
|---|---|
| `config.env` | Nome della distro, versione Fedora di base, scelta del kernel |
| `kickstart/distro-kde.ks` | Definizione dell'immagine: pacchetti, lingua (italiano), servizi, sessione live |
| `kickstart/kernel-vanilla.ks` / `kernel-fedora.ks` | Sorgente del kernel |
| `branding/` | Pacchetto RPM `distro-branding` |
| `build.sh` | Costruisce la ISO in un container Fedora |
| `.github/workflows/build-iso.yml` | Costruisce la ISO su GitHub Actions |

## Costruire la ISO

### Opzione A: sul tuo PC Linux

Serve podman (o docker), circa 25 GB liberi e connessione internet.

```bash
./build.sh
# risultato: out/result/nicklinux-kde-<versione>-x86_64.iso
```

La build dura 20-60 minuti. Il log completo è in `out/lmc.log`.

### Opzione B: su GitHub, senza installare nulla

Carica questa cartella in un repository GitHub. Ad ogni push su `main` (o da *Actions → Build ISO → Run workflow*) la ISO viene costruita e si scarica dall'artifact `iso` della run.

## Provarla in una VM

**virt-manager / GNOME Boxes / QEMU** (consigliato)

```bash
qemu-img create -f qcow2 nicklinux.qcow2 30G
qemu-system-x86_64 -enable-kvm -m 4096 -smp 4 -cpu host \
  -bios /usr/share/edk2/ovmf/OVMF_CODE.fd \
  -cdrom out/result/nicklinux-kde-*.iso -drive file=nicklinux.qcow2,if=virtio \
  -device virtio-vga-gl -display gtk,gl=on
```

**VirtualBox**: tipo *Fedora (64-bit)*, almeno 4 GB di RAM e 2 CPU, scheda video *VMSVGA* con 128 MB, attiva *Abilita EFI*.

Note:

- Con il kernel vanilla **Secure Boot va disattivato** (il kernel non è firmato da Fedora). Nelle VM UEFI usa il firmware OVMF senza Secure Boot.
- Dal desktop live, l'icona *Installa su disco rigido* avvia Anaconda.
- Utente live: `liveuser`, senza password.

## Personalizzare

- **Nome**: cambia `DISTRO_NAME` e `DISTRO_ID` in `config.env`.
- **Pacchetti**: aggiungi o togli righe nella sezione `%packages` di `kickstart/distro-kde.ks` (un `-` davanti esclude).
- **Kernel**: `KERNEL_SOURCE="fedora"` per il kernel Fedora firmato (compatibile con Secure Boot e con i driver NVIDIA di RPM Fusion).
- Prossimi passi possibili: sfondo e tema Plasma propri, logo per Plymouth e GRUB, repository RPM della distro.
