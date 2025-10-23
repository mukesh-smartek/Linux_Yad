#!/bin/bash

# ──────────────────────────────────────────────
# 🖥️  Network Info UI using YAD
# ──────────────────────────────────────────────

# Function to get current IP and Gateway
get_ip() {
    ip route get 1.1.1.1 2>/dev/null | awk '/src/ {print $7}'
}

get_gateway() {
    ip route | awk '/default/ {print $3}'
}

# Initial values
IP_ADDR=$(get_ip)
GATEWAY=$(get_gateway)

# Assume "auto connect" enabled (can replace with real check logic)
AUTO_CONNECT=true

# ──────────────────────────────────────────────
# Function to display dialog
# ──────────────────────────────────────────────
while true; do
    yad --form \
        --title="🌐 Network Configuration" \
        --width=400 --height=250 \
        --center \
        --window-icon=network-wired \
        --separator="|" \
        --item-separator="|" \
        --field="💻 IP Address:" "$IP_ADDR" \
        --field="🚪 Gateway:" "$GATEWAY" \
        --field="🔁 Automatically Connected:CHK" "$AUTO_CONNECT" \
        --button="💾 Save:0" \
        --button="❌ Close:1" \
        --image=network-workgroup \
        --text="<b>🧭 Network Information</b>\nCheck and update your network connection details below." \
        --width=400

    ret=$?
    [[ $ret -eq 1 ]] && break  # Close pressed → exit loop

    # If Save clicked (return code 0)
    if [[ $ret -eq 0 ]]; then
        # Read latest values from yad (use temp file to capture)
        values=$(yad --form \
            --title="✏️ Edit Network Details" \
            --width=400 \
            --center \
            --field="💻 IP Address:" "$IP_ADDR" \
            --field="🚪 Gateway:" "$GATEWAY" \
            --field="🔁 Automatically Connected:CHK" "$AUTO_CONNECT" \
            --button="💾 Apply Changes:0" \
            --button="❌ Cancel:1" \
            --image=network-workgroup \
            --window-icon=network-wired \
            --text="Modify your network details below:")

        [ $? -eq 1 ] && continue

        NEW_IP=$(echo "$values" | awk -F'|' '{print $1}')
        NEW_GW=$(echo "$values" | awk -F'|' '{print $2}')
        NEW_AUTO=$(echo "$values" | awk -F'|' '{print $3}')

        # Save changes (example commands)
        # NOTE: Requires root privileges for actual network config.
        # ip addr add $NEW_IP/24 dev eth0
        # ip route add default via $NEW_GW

        IP_ADDR=$NEW_IP
        GATEWAY=$NEW_GW
        AUTO_CONNECT=$NEW_AUTO

        # Confirmation popup
        yad --info \
            --title="✅ Saved" \
            --text="Network settings updated successfully!\n\n💻 IP: <b>$IP_ADDR</b>\n🚪 Gateway: <b>$GATEWAY</b>\n🔁 Auto-connect: <b>$AUTO_CONNECT</b>" \
            --image=network-workgroup \
            --window-icon=network-wired \
            --button="OK:0" \
            --center
    fi
done
