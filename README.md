# Tailscale Router / Exit Node

Dockerized Tailscale node that can:
- Advertise LAN subnets
- Act as an exit node
- Survive reboots
- Not depend on host OS config beyond forwarding

## Requirements
- Linux host
- Docker + docker compose
- net.ipv4.ip_forward = 1

## First-time setup

1. Enable IP forwarding (host):
```bash
sudo sysctl -w net.ipv4.ip_forward=1

<<<<<<< HEAD
First-time setup
Enable IP forwarding (host):
sudo sysctl -w net.ipv4.ip_forward=1

## SETUP IPTABLES LOGIC FOR EACH TAILSCALE NODE ROUTER

Tailscale Subnet Router with NETMAP (Overlapping LANs)
====================================================

PURPOSE
-------
This host acts as a Tailscale subnet router for a LAN that overlaps
with other sites using the same 192.168.0.0/24 range.

Traffic is 1:1 NETMAP-translated to a unique subnet so multiple sites
can coexist on the same Tailscale network.

Example mapping:
  10.90.0.X  <->  192.168.0.X


REQUIREMENTS
------------
- Linux host on the LAN (192.168.0.0/24)
- Tailscale running in host networking mode
- Kernel support for ipt_NETMAP
- Root privileges


ENABLE IP FORWARDING
--------------------
Run once:
  sysctl -w net.ipv4.ip_forward=1

Persist across reboot:
  echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf


LOAD NETMAP MODULE (IF REQUIRED)
--------------------------------
  modprobe ipt_NETMAP


IPTABLES RULES
--------------
Tailscale -> LAN (Destination Translation):
  iptables -t nat -A PREROUTING \
    -d 10.90.0.0/24 \
    -j NETMAP --to 192.168.0.0/24

LAN -> Tailscale (Source Translation):
  iptables -t nat -A POSTROUTING \
    -s 192.168.0.0/24 \
    -j NETMAP --to 10.90.0.0/24


ADVERTISE SUBNET TO TAILSCALE
-----------------------------
  tailscale up --advertise-routes=10.90.0.0/24

Approve the advertised route in the Tailscale admin console.


VERIFICATION
------------
List NAT rules and counters:
  iptables -t nat -L -n -v

Test from another Tailscale node:
  ping 10.90.0.105
  ssh user@10.90.0.105

Traffic should reach:
  192.168.0.105


NOTES / GOTCHAS
---------------
- These rules MUST run on the Tailscale subnet router host
- Do NOT implement this on a UniFi gateway
- Docker must use host networking for Tailscale
- Do NOT combine NETMAP with MASQUERADE
- Each site must advertise a unique 10.x.0.0/24 subnet


EXAMPLE MULTI-SITE LAYOUT
-------------------------
Site A: 192.168.0.0/24 -> 10.90.0.0/24
Site B: 192.168.0.0/24 -> 10.80.0.0/24
Site C: 192.168.0.0/24 -> 10.70.0.0/24


CLEANUP (REMOVE RULES)
---------------------
  iptables -t nat -D PREROUTING -d 10.90.0.0/24 -j NETMAP --to 192.168.0.0/24
  iptables -t nat -D POSTROUTING -s 192.168.0.0/24 -j NETMAP --to 10.90.0.0/24


SUMMARY
-------
NETMAP provides clean 1:1 subnet translation, allowing overlapping
LANs to be shared safely behind Tailscale without modifying edge
routers or readdressing networks.

### Run this to persists after reboot

sudo apt install iptables-persistent
sudo netfilter-persistent save

