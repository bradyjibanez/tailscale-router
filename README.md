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

##MAGIC SETTING FROM BRADY

#Add this to the router server

# Translate incoming 10.90.0.x requests to the real 192.168.0.x network
sudo iptables -t nat -A PREROUTING -d 10.90.0.0/24 -j NETMAP --to 192.168.xxx.0/24
# Ensure the return traffic is handled correctly
sudo iptables -t nat -A POSTROUTING -s 192.168.xxx.0/24 -j NETMAP --to 10.90.0.0/24

#Unifi LAN -> Shadow SNAT Rule
Type: Src.Nat
Interface: Default LAN
Traslated IP: Shadow LAN (10.xxx.0.0/24)

Source: IP
Specific: LAN subnet (192.168.xxx.0/24)

Destination: Any
Port: Any
