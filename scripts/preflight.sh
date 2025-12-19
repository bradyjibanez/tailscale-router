#!/usr/bin/env bash

if [ "$(sysctl -n net.ipv4.ip_forward 2>/dev/null)" != "1" ]; then
  echo "⚠️  WARNING: net.ipv4.ip_forward is NOT enabled"
  echo "⚠️  Subnet routing / exit node will NOT work"
  echo
  echo "👉 Fix with:"
  echo "   sudo sysctl -w net.ipv4.ip_forward=1"
  echo "   sudo tee /etc/sysctl.d/99-tailscale.conf <<< 'net.ipv4.ip_forward=1'"
  echo
else
  echo "✅ net.ipv4.ip_forward OK"
fi
