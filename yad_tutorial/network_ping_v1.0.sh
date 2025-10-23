#!/bin/bash
# ───────────────────────────────────────────────
# 🌐 Network Diagnostics Center (Ping + Traceroute)
# Uses YAD for professional, uniform UI
# ───────────────────────────────────────────────

# Helper functions
run_ping() {
    local target="$1"
    if [[ -z "$target" ]]; then
        echo "❌ Please enter a valid hostname or IP."
        return
    fi
    echo "🔍 Pinging $target ... (Press Ctrl+C to stop)"
    ping -c 4 "$target" 2>&1
}

run_trace() {
    local target="$1"
    if [[ -z "$target" ]]; then
        echo "❌ Please enter a valid hostname or IP."
        return
    fi
    echo "🛰️ Tracing route to $target ..."
    traceroute -n "$target" 2>&1
}

# ───────────────────────────────────────────────
# Main UI (Tab view)
# ───────────────────────────────────────────────
KEY=$RANDOM

yad --plug=$KEY --tabnum=1 --form \
    --width=450 --height=350 \
    --title="🌐 Network Diagnostics Center" \
    --text="<b>📶 Ping Utility</b>\nCheck connectivity to a host below." \
    --field="🌍 Host/IP:" "" \
    --button="▶️ Start Ping:0" \
    --button="❌ Close:1" \
    > >(while read -r line; do
        case "$line" in
            "0") 
                # Get the target and run ping in real-time dialog
                TARGET=$(yad --entry --title="🌍 Enter Host/IP" --text="Enter hostname or IP to ping:" --entry-text="8.8.8.8")
                [ -z "$TARGET" ] && continue
                run_ping "$TARGET" | yad --text-info --title="📶 Ping Results for $TARGET" \
                    --width=600 --height=400 --fontname="Monospace 10" \
                    --button="OK:0"
                ;;
            "1") kill $PPID ;;
        esac
    done) &


# Tab 2: Traceroute
yad --plug=$KEY --tabnum=2 --form \
    --width=450 --height=350 \
    --text="<b>🛰️ Traceroute Utility</b>\nTrace network hops visually below." \
    --field="🌍 Host/IP:" "" \
    --button="🚀 Start Trace:0" \
    --button="❌ Close:1" \
    > >(while read -r line; do
        case "$line" in
            "0")
                TARGET=$(yad --entry --title="🛰️ Enter Host/IP" --text="Enter hostname or IP to trace:" --entry-text="8.8.8.8")
                [ -z "$TARGET" ] && continue
                
                # Run traceroute and convert output into a map-like format
                TMPFILE=$(mktemp)
                run_trace "$TARGET" > "$TMPFILE"

                # Convert traceroute output to a "map" with arrows (IP chain)
                MAP=$(awk '/^[ 0-9]+/{ if (NR>1) printf " ➜ "; printf $2 } END{print ""}' "$TMPFILE")
                INFO=$(cat "$TMPFILE")

                yad --notebook --width=650 --height=500 \
                    --tab="🗺️ Network Map" --text="<b>Route Visualization:</b>\n\n$MAP" \
                    --tab="📄 Full Output" --text-info --filename="$TMPFILE" --fontname="Monospace 10" \
                    --button="OK:0" --center
                rm -f "$TMPFILE"
                ;;
            "1") kill $PPID ;;
        esac
    done) &


# ───────────────────────────────────────────────
# Main container with tabs
# ───────────────────────────────────────────────
yad --notebook \
    --width=480 --height=400 \
    --key=$KEY \
    --tab="📶 Ping" \
    --tab="🛰️ Traceroute" \
    --title="🌐 Network Diagnostics Center" \
    --window-icon=network-workgroup \
    --center
