#!/bin/bash

# ───────────────────────────────
#  🌐 Live Network Info UI (AJAX-like)
# ───────────────────────────────

# Helper functions
get_ip() { ip route get 1.1.1.1 2>/dev/null | awk '/src/ {print $7}'; }
get_gw() { ip route | awk '/default/ {print $3}'; }

IP=$(get_ip)
GW=$(get_gw)
AUTO_CONNECT=true

# Generate a numeric key (YAD plug ID must be an integer)
KEY=$RANDOM

# ───────────────────────────────
# Start the main YAD UI
# ───────────────────────────────

# Run the form in a subpanel with listen mode
yad --plug=$KEY --tabnum=1 --form \
    --title="🌐 Network Monitor" \
    --width=420 --height=260 \
    --listen \
    --field="💻 IP Address:RO" "$IP" \
    --field="🚪 Gateway:RO" "$GW" \
    --field="🔁 Automatically Connected:CHK" "$AUTO_CONNECT" \
    --button="💾 Save:0" \
    --button="❌ Close:1" \
    > >(while read -r line; do
        case "$line" in
            "0") 
                yad --info --title="💾 Save" --text="Settings saved successfully!" --button="OK:0"
                ;;
            "1") kill $PPID ;;
        esac
    done) &

# Attach a YAD panel to the plug above
yad --paned --key=$KEY --title="🌐 Network Control Center" --width=440 --height=280 &
PANE_PID=$!

# ───────────────────────────────
# Background refresher (AJAX effect)
# ───────────────────────────────
while kill -0 $PANE_PID 2>/dev/null; do
    sleep 5
    NEW_IP=$(get_ip)
    NEW_GW=$(get_gw)
    # Send live updates to YAD
    echo "set:1:$NEW_IP"
    echo "set:2:$NEW_GW"
done | yad --plug=$KEY --tabnum=1 --listen >/dev/null 2>&1 &

wait $PANE_PID
