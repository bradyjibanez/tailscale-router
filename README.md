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
