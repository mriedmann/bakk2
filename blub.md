# Was kann ich mit DNS unter meiner Kontrolle alles anstellen?

Ich kann User mit einer oder allen Adresse/n auf die IP meines Servers umleiten.
Ich kann andere MX Einträge setzen und so Mail-Clients und Server umbiegen.
Ich kann SRV Records eintragen und so die Service-Discovery auf meinen Server lenken.

# Wie kann ich das DNS des Client unter meine Kontrolle bringen?

MitM:
LAN-Attacken: ARP-Spoofing, DHCP-Spoofing, ICMP-Redirect, BGP-Spoofing
L1-Attacken: aLTEr

Direkte Angriffe über das Netzwerk:
DNS-Attacken: DNS-Spoofing, DNS Cache Poisoning

# Special-Shit
DNS Rebind
BitSquatting

# Wie kann ich mich gegen die Übernahme schützen?

Prinzipiell:
Aus einem Clientapplikationsstandpunkt heraus ist ein MitM Angriff wenig bedrohlich solange die Applikation eine Möglichkeit hat die Authentizität der Gegenstelle zu prüfen. Eines der am meisten genützten Transportprotokollstacks (HTTP + TLS) führt diese Prüfung anhand von X509 Zertifikaten und einer vorinstallierten TrustCain durch. Ein MitM-Angriff kann daher zwar die Erreichbarkeit des Ziels einschränken, die Vertraulichkeit und Authentizität der Nutzdaten bleibt jedoch erhalten. Die Vertraulichkeit der DNS-Anfragen ist dadurch jedoch nicht gegeben. Es ist daher einfach, die Kommunikationsdaten abzugreifen, was die Gefahr für andere Angriffe erhöht. Das Kernproblem im heutigen Umfeld stellt daher nicht, wie im DNSSEC Paper suggeriert, die Authentizität, sondern die Vertraulichkeit der Anfragen dar. Da diese jedoch von DNSSEC nicht sichergestellt wird, wundert es nicht, dass diese Technologie bis heute wenig Anklang gefunden hat. Eine Stärke von DNSSEC besteht bei Angriffen auf authentitative DNS Server, welche eine stetige Gefahr für die Sicherheit der Clients darstellen. Dar eine eigene autentitative, extern gerichtete DNS-Infrastruktur einen hohen administrativen Aufwand birgt, wird diese Aufgabe immer häufiger an externe Anbieter ausgelagert und verliert dadurch an Bedeutung. Für den lokalen Netzwerkbetrieb sind solche Server jedoch nach wir vor unerlässlich. Hier kann mit einer Kombination aus allen zur Verfügung stehenden Technologien eine starke Verbesserung wer Sicherheit, Wartbarkeit und Performance des DNS-Auflösungsprozesses geschaffen werden.  

Für keine Unternehmen stellt das einsetzen von speziellen, vertrauenswürdigen "Open Resolver"-Services und eine Härtung der lokalen Netzwerk-Struktur eine . Der Einsatz von DNSSEC Validierung auf diesen Servern kann zusätzliche Sicherheit bringen. Wird der Verkehr zu den Upstream-Servern über TLS verschlüsselt 

2016 gestartete DPRIVE Initiative der IETF => Angriffe auf DNS Privicy ernst nehmen!
0x20 methode zum "verlängern" der TxID und schutz vor poisoning

Prio 1:
Zuverlässigen Upstream Server verwenden 
* Quad9
* Google
* Cloudflare
* OpenDNS
* Norton ConnectSafe
* DNS.Watch
* OpenNIC
* VeriSign DNS

Prio 2:
Privicy! Verbindung zu Server mit DNS-over-TLS schützen

Prio 3:
Eigenen, lokalen gehärteten, forward-only DNS Resolver mit zuverlässigem upstream Resolver einrichten.
* IP Sanitazing (unbound: private-address)
* cache-min-ttl > 1min (mitigation gegen DNS Rebind)
* DNSSEC Verify
Strikte Trennung zwischen Resolver und öffentlichem, authoritativem DNS Server! Resolver darf nicht öffentlich erreichbar sein (DoS Ampl.).

Prio 4:
Netzwerksicherheit herstellen, outbound DNS-traffic auf der Firewall verbieten, http-proxy einrichten, IDS einsetzen. 

Prio 5:
Eigenen, lokalen DNS Resolver auf den Clients nutzen (z.B. Stubby) wenn Netzwerksicherheit fraglich ist und die Clients performant genug sind.



Ein Entscheidung am Anfang: DNS Konzept ändern oder nicht?

Wenn Nein:

Gegen MitM: 
* Netzwerk Security (IDS, DHCP-/DNS-Guard + Port Security am Switch, moderne Hardware und immer Switches)
* IPSEC/TLS/etc (durch Verschlüsselung und Authentifizierung kein MitM möglich; kann Henne & Ei Problem haben (SSL CRLs))
* Firewall (Filtering gegen IP-Spoofing von außen)


Frage: Wie wie Verbindung zwischen Client und resolver sichern?
* IPSEC 
  * Henne/EI Problematik
  * aufwendig
  * availability risiko ohne Fallback, mit ist die Sicherheit gefährdet
* MitM Defense auf der Netzwerkhardware
  * Teuer
  * Unzuverlässig
* DNSCurve/DoT/DoH/DNSCrypt oder DNSSEC Validation am Client
  * Performance
  * Wartung aufwendig
  * Usability schlecht (je nach OS)

Antwort: 
* Einen zuverlässigen DNS Resolver mit Privicy Policy nutzen
* in OS mit Unterstützung DoT/DoH einschalten
* in OS ohne Unterstützung secure Stub-Resolver (Stubby, DNSCrypt) 
