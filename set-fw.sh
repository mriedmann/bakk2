#!/bin/sh
LAN="192.168.100.0/24"
SELF="192.168.100.70"
SYS_DNS="9.9.9.9"

# Delete all existing rules
iptables -F

# Set default chain policies
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

# Allow incoming SSH from LAN
iptables -A INPUT -i eth0 -p tcp --dport 22 -m state --state NEW,ESTABLISHED -s $LAN -d $SELF -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport 22 -m state --state ESTABLISHED -d $LAN -s $SELF -j ACCEPT

# Allow incoming DNS TCP from LAN
iptables -A INPUT -i eth0 -p tcp --dport 53 -m state --state NEW,ESTABLISHED -s $LAN -d $SELF -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport 53 -m state --state ESTABLISHED -d $LAN -s $SELF -j ACCEPT

# Allow incoming DNS UDP from LAN
iptables -A INPUT -i eth0 -p udp --dport 53 -s $LAN -d $SELF -j ACCEPT
iptables -A OUTPUT -o eth0 -p udp --sport 53 -d $LAN -s $SELF -j ACCEPT

# Allow outgoing DNS UDP to SYS_DNS
iptables -A OUTPUT -o eth0 -p udp --dport 53 -d $SYS_DNS -s $SELF -j ACCEPT
iptables -A INPUT -i eth0 -p udp --sport 53 -s $SYS_DNS -d $SELF -j ACCEPT

# Allow outgoing DNS TCP to SYS_DNS
iptables -A OUTPUT -o eth0 -p tcp --dport 53 -m state --state NEW,ESTABLISHED -d $SYS_DNS -s $SELF -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --sport 53 -m state --state ESTABLISHED -s $SYS_DNS -d $SELF -j ACCEPT

# Allow outgoing HTTP
iptables -A OUTPUT -o eth0 -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --sport 80 -m state --state ESTABLISHED -j ACCEPT

# Allow outgoing DNS-To-TLS to all but LAN
iptables -A OUTPUT -o eth0 -p tcp --dport 853 -m state --state NEW,ESTABLISHED ! -d $LAN -s $SELF -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --sport 853 -m state --state ESTABLISHED ! -s $LAN -d $SELF -j ACCEPT

# Allow incoming ICMP Echo
iptables -A INPUT -p icmp --icmp-type 8 -m state --state NEW,ESTABLISHED,RELATED -d $SELF -j ACCEPT
iptables -A OUTPUT -p icmp --icmp-type 0 -m state --state ESTABLISHED,RELATED -s $SELF -j ACCEPT

iptables -A OUTPUT -p icmp --icmp-type 8 -m state --state NEW,ESTABLISHED,RELATED -s $SELF -j ACCEPT
iptables -A INPUT -p icmp --icmp-type 0 -m state --state ESTABLISHED,RELATED -d $SELF -j ACCEPT