#!/bin/bash

# Get MAC address (first non-loopback)
MAC=$(ip link | awk '/ether/ {print $2; exit}')

# Get IP address
IP=$(hostname -I | awk '{print $1}')

# Get default gateway
GATEWAY=$(ip route | awk '/default/ {print $3; exit}')

# Get hostname
HOSTNAME=$(hostname)

# Check firewall status
if command -v firewall-cmd >/dev/null 2>&1; then
    FIREWALL_STATUS=$(firewall-cmd --state 2>/dev/null)
elif command -v ufw >/dev/null 2>&1; then
    FIREWALL_STATUS=$(ufw status | grep -i "Status:" | awk '{print $2}')
else
    FIREWALL_STATUS="Not Installed"
fi

# Check network connectivity (Internet)
ping -c1 -W1 8.8.8.8 >/dev/null 2>&1 && NET_STATUS="Online" || NET_STATUS="Offline"

# Check gateway reachability
ping -c1 -W1 "$GATEWAY" >/dev/null 2>&1 && GW_STATUS="Reachable" || GW_STATUS="Unreachable"

# Get open ports (top 5 for display)
if command -v ss >/dev/null; then
    PORTS=$(ss -tuln | awk 'NR>1 {print $1, $5}' | head -n 5 | paste -sd ", " -)
elif command -v netstat >/dev/null; then
    PORTS=$(netstat -tuln | awk 'NR>2 {print $1, $4}' | head -n 5 | paste -sd ", " -)
else
    PORTS="N/A"
fi

# Display all data in a YAD form with disabled (read-only) fields
yad --title="Network Configuration" \
    --width=600 \
    --form \
    --columns=2 \
    --separator='\n' \
    --field="MAC Address":RO "$MAC" \
    --field="IP Address":RO "$IP" \
    --field="Gateway IP":RO "$GATEWAY" \
    --field="Gateway Reachability":RO "$GW_STATUS" \
    --field="Hostname":RO "$HOSTNAME" \
    --field="Firewall Status":RO "$FIREWALL_STATUS" \
    --field="Internet Status":RO "$NET_STATUS" \
    --field="Open Ports (top 5)":RO "$PORTS"

