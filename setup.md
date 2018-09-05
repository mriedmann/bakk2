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
server:
    verbosity: 2
    access-control: 127.0.0.0/8 allow
    access-control: 192.168.100.0/24 allow
    access-control: 2001:470:1f09:6b::/64 allow
    aggressive-nsec: yes
    cache-max-ttl: 14400
    cache-min-ttl: 300
    do-ip4: yes
    do-ip6: yes
    do-tcp: yes
    harden-below-nxdomain: yes
    harden-glue: yes
    harden-dnssec-stripped: yes
    qname-minimisation: yes
    hide-identity: yes
    hide-version: yes
    interface: 0.0.0.0
    interface: ::0
    minimal-responses: yes
    num-threads: 4
    pidfile: "/var/run/unbound.pid"
    port: 53
    prefetch: yes
    prefetch-key: yes
    rrset-roundrobin: yes
    so-reuseport: yes
    use-caps-for-id: yes
    use-syslog: no
    logfile: /var/log/unbound
   
remote-control:
    control-enable: yes
    control-interface: 127.0.0.1
    control-port: 8953
    server-key-file: "/etc/unbound/unbound_server.key"
    server-cert-file: "/etc/unbound/unbound_server.pem"
    control-key-file: "/etc/unbound/unbound_control.key"
    control-cert-file: "/etc/unbound/unbound_control.pem"
   
forward-zone:
   name: "."
   forward-tls-upstream: yes
   forward-addr: 9.9.9.9@853         # quad9.net primary
   forward-addr: 1.1.1.1@853         # cloudflare primary
   forward-addr: 149.112.112.112@853 # quad9.net secondary
   forward-addr: 1.0.0.1@853         # cloudflare secondary
 
#  forward-addr: 145.100.185.15@853  # dnsovertls.sinodun.com US
#  forward-addr: 145.100.185.16@853  # dnsovertls1.sinodun.com US
#  forward-addr: 184.105.193.78@853  # tls-dns-u.odvr.dns-oarc.net US
#  forward-addr: 185.49.141.37@853   # getdnsapi.net US
#  forward-addr: 199.58.81.218@853   # dns.cmrg.net US
#  forward-addr: 146.185.167.43@853  # securedns.eu Europe
#  forward-addr: 89.233.43.71@853    # unicast.censurfridns.dk Europe
```

apk add openssl
unbound-control-setup

unbound-anchor -a /etc/unbound/root.key
chown unbound:unbound /etc/unbound/root.key
service unbound restart
rc-update add unbound default
