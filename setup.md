Internet fähigen VirtuellenSwitch einrichten

`new-vm -Name DNSResolver -MemoryStartupBytes 1024MB -BootDevice VHD -NewVHDPath E:\VirtEnv\Bakk2\DNSResolver.vhdx -Path E:\VirtEnv\Bakk2\DNSResolver\ -NewVHDSizeBytes 20GB -Generation 1 -SwitchName External`

`Set-VMDvdDrive -Path 'E:\Users\Michael\Downloads\alpine-standard-3.8.0-x86_64.iso' -VMName DNSResolver`

boot VM

login: root (no password)

```
setup-alpine -f answerfile
```

reboot

login: root (with pw set in setup)

apk update
apk add unbound

```

```

apk add openssl
unbound-control-setup

unbound-anchor -a /etc/unbound/root.key
chown unbound:unbound /etc/unbound/root.key
service unbound restart
rc-update add unbound default
