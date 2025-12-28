#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
STATE_DIR="$SCRIPT_DIR/unifi_state"
STATE_FILE="$STATE_DIR/state.txt"
TS_BIN="/usr/bin/tailscale"

mkdir -p "$STATE_DIR"

: > "$STATE_FILE"

echo "=== UniFi State Snapshot ===" >> "$STATE_FILE"
echo "Timestamp: $(date)" >> "$STATE_FILE"
echo "Hostname: $(hostname)" >> "$STATE_FILE"
echo "" >> "$STATE_FILE"

echo "--- System ---" >> "$STATE_FILE"
uname -a >> "$STATE_FILE" 2>&1
echo "" >> "$STATE_FILE"

echo "--- Routing Table ---" >> "$STATE_FILE"
ip route show >> "$STATE_FILE" 2>&1
echo "" >> "$STATE_FILE"

echo "--- Policy Rules ---" >> "$STATE_FILE"
ip rule show >> "$STATE_FILE" 2>&1
echo "" >> "$STATE_FILE"

echo "--- Tailscale ---" >> "$STATE_FILE"
if [ -x "$TS_BIN" ]; then
    TS_NAME=$($TS_BIN status --json 2>/dev/null | grep -m1 '"HostName"' | cut -d'"' -f4)
    echo "Machine: $TS_NAME" >> "$STATE_FILE"
    $TS_BIN status >> "$STATE_FILE" 2>&1
else
    echo "Tailscale not installed" >> "$STATE_FILE"
fi
echo "" >> "$STATE_FILE"

echo "--- Firewall Summary ---" >> "$STATE_FILE"
iptables -S >> "$STATE_FILE" 2>&1
