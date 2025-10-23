#!/bin/bash
# ───────────────────────────────────────────────
# 🌐 Network Diagnostics Center (Ping + Traceroute)
# Persistent, professional YAD interface
# ───────────────────────────────────────────────

# Helper functions
run_ping() {
    local target="$1"
    [ -z "$target" ] && echo "❌ Please enter a valid hostname or IP." && return
    ping -c 4 "$target" 2>&1
}

run_trace() {
    local target="$1"
    [ -z "$target" ] && echo "❌ Please enter a valid hostname or IP." && return
    tracepath -n "$target" 2>&1
}

# ───────────────────────────────────────────────
# Main UI with Tabs
# ───────────────────────────────────────────────
KEY=$RANDOM

# Tab 1: Ping
(
    yad --plug=$KEY --tabnum=1 --form \
        --width=450 --height=250 \
        --text="<b>📶 Ping Utility</b>\nCheck connectivity to a host below." \
        --field="🌍 Host/IP:" "8.8.8.8" \
        --button="▶️ Start Ping:0" \
        --button="❌ Close:1" \
    | while IFS="|" read -r host _; do
        [ "$?" = "1" ] && break
        # Launch Ping in subwindow (does not close main)
        if [ -n "$host" ]; then
            run_ping "$host" | yad --text-info \
                --title="📶 Ping Results for $host" \
                --width=600 --height=400 \
                --fontname="Monospace 10" \
                --button="OK:0" --center
        fi
    done
) &


# Tab 2: Traceroute
(
    yad --plug=$KEY --tabnum=2 --form \
        --width=450 --height=250 \
        --text="<b>🛰️ Traceroute Utility</b>\nTrace network hops visually below." \
        --field="🌍 Host/IP:" "8.8.8.8" \
        --button="🚀 Start Trace:0" \
        --button="❌ Close:1" \
    | while IFS="|" read -r host _; do
        [ "$?" = "1" ] && break
        if [ -n "$host" ]; then
            TMPFILE=$(mktemp)
            run_trace "$host" > "$TMPFILE"

            MAP=$(awk '/^[ 0-9]+/{ if (NR>1) printf " ➜ "; printf $2 } END{print ""}' "$TMPFILE")

            yad --notebook --width=650 --height=500 \
                --tab="🗺️ Network Map" \
                --text="<b>Route Visualization:</b>\n\n$MAP" \
                --tab="📄 Full Output" \
                --text-info --filename="$TMPFILE" \
                --fontname="Monospace 10" \
                --button="OK:0" --center

            rm -f "$TMPFILE"
        fi
    done
) &


# ───────────────────────────────────────────────
# Main Notebook Container (Remains Active)
# ───────────────────────────────────────────────
yad --notebook \
    --width=480 --height=320 \
    --key=$KEY \
    --tab="📶 Ping" \
    --tab="🛰️ Traceroute" \
    --title="🌐 Network Diagnostics Center" \
    --window-icon=network-workgroup \
    --center
