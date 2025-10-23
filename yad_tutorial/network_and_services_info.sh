#!/bin/bash

# Temp file to hold exported info
EXPORT_FILE="/tmp/network_service_info.txt"

##########################
# Collect Network Info
##########################

# MAC Address
MAC=$(ip link | awk '/ether/ {print $2; exit}')
# IP Address
IP=$(hostname -I | awk '{print $1}')
# Gateway
GATEWAY=$(ip route | awk '/default/ {print $3; exit}')
# Hostname
HOSTNAME=$(hostname)
# Firewall Status
if command -v firewall-cmd >/dev/null 2>&1; then
    FIREWALL_STATUS=$(firewall-cmd --state 2>/dev/null)
elif command -v ufw >/dev/null 2>&1; then
    FIREWALL_STATUS=$(ufw status | grep -i "Status:" | awk '{print $2}')
else
    FIREWALL_STATUS="Not Installed ❌"
fi
# Internet Connectivity
ping -c1 -W1 8.8.8.8 &>/dev/null && NET_STATUS="Online 🌐" || NET_STATUS="Offline ❌"
# Gateway Reachability
ping -c1 -W1 "$GATEWAY" &>/dev/null && GW_STATUS="Reachable ✅" || GW_STATUS="Unreachable ❌"
# Open Ports (top 5)
if command -v ss >/dev/null; then
    PORTS=$(ss -tuln | awk 'NR>1 {print $1, $5}' | head -n 5 | paste -sd ", " -)
elif command -v netstat >/dev/null; then
    PORTS=$(netstat -tuln | awk 'NR>2 {print $1, $4}' | head -n 5 | paste -sd ", " -)
else
    PORTS="N/A"
fi

##########################
# Collect Service Status
##########################

check_service() {
    local service=$1
    if systemctl list-unit-files | grep -q "$service"; then
        STATUS=$(systemctl is-active "$service" 2>/dev/null)
        [ "$STATUS" = "active" ] && echo "Running ✅" || echo "Not Running ❌"
    else
        echo "Not Installed ❌"
    fi
}

SRV_NETWORKING=$(check_service networking)
SRV_FIREWALL=$(check_service firewalld)
SRV_SSH=$(check_service sshd)
SRV_MYSQL=$(check_service mysql)
[ "$SRV_MYSQL" = "Not Installed ❌" ] && SRV_MYSQL=$(check_service mariadb)
SRV_HTTPD=$(check_service httpd)
SRV_VSFTPD=$(check_service vsftpd)
SRV_NFDUMP=$(check_service nfdump)

##########################
# Export Function
##########################
export_info() {
    cat <<EOF > "$EXPORT_FILE"
System Network & Service Information
====================================

[Network Info]
MAC Address            : $MAC
IP Address             : $IP
Gateway                : $GATEWAY
Gateway Reachability   : $GW_STATUS
Hostname               : $HOSTNAME
Firewall Status        : $FIREWALL_STATUS
Internet Status        : $NET_STATUS
Open Ports             : $PORTS

[Service Status]
Networking             : $SRV_NETWORKING
Firewall (firewalld)   : $SRV_FIREWALL
SSH (sshd)             : $SRV_SSH
MySQL/MariaDB          : $SRV_MYSQL
HTTPD (Apache)         : $SRV_HTTPD
FTP (vsftpd)           : $SRV_VSFTPD
nfdump                 : $SRV_NFDUMP
EOF
}

# Run export
export_info

##########################
# Create Notebook Tabs with Buttons
##########################

# Use --notebook properly with one --form per --tab
yad --title="[MKM]: Network & Services Manager"  --center   \
    --width=600 --height=500 \
    --notebook \
    --tab="🌐 Network Info" \
        --form --columns=2 \
        --field="🖧 MAC Address":RO "$MAC" \
        --field="📶 IP Address":RO "$IP" \
        --field="🛣️ Gateway":RO "$GATEWAY" \
        --field="📡 Gateway Reachability":RO "$GW_STATUS" \
        --field="🖥️ Hostname":RO "$HOSTNAME" \
        --field="🔥 Firewall Status":RO "$FIREWALL_STATUS" \
        --field="🌍 Internet Status":RO "$NET_STATUS" \
        --field="🔓 Open Ports (top 5)":RO "$PORTS" \
    --tab="🛠️ Services" \
        --form --columns=2 \
        --field="🔌 Networking":RO "$SRV_NETWORKING" \
        --field="🔥 Firewall (firewalld)":RO "$SRV_FIREWALL" \
        --field="🔐 SSH (sshd)":RO "$SRV_SSH" \
        --field="🛢️ MySQL/MariaDB":RO "$SRV_MYSQL" \
        --field="🌐 HTTPD (Apache)":RO "$SRV_HTTPD" \
        --field="📤 FTP (vsftpd)":RO "$SRV_VSFTPD" \
        --field="📈 nfdump":RO "$SRV_NFDUMP" \
    --button="🔄 Refresh!view-refresh":1 \
    --button="📁 Export Info!document-save":2 \
    --button="📄 Open Logs!document-open":3 \
    --button="❌ Close!gtk-close":0\
    --image="$(pwd)/icons/humming-bird_5.png"  \
    --window-icon="$(pwd)/icons/humming-bird_16.png"

# Handle button responses
case $? in
    1) exec "$0" ;;  # Refresh (re-execute the script)
    2) yad --text="✅ Info exported to:\n$EXPORT_FILE" --button=OK --width=400 --center ;;
    3) journalctl -xe | yad --text-info --title="📄 System Logs" --width=800 --height=600 ;;
    0) printf "[INFO]: Closing Network & Services GUI" ;;
esac

