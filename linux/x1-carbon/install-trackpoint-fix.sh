#!/bin/bash
set -e

HOOK_SRC="$(dirname "$0")/fix-trackpoint-on-resume"
HOOK_DEST="/lib/systemd/system-sleep/fix-trackpoint-on-resume"

sudo install -m 755 "$HOOK_SRC" "$HOOK_DEST"
echo "Installed: $HOOK_DEST"
echo "TrackPoint will now be reset automatically after every resume."

WATCHDOG_SRC="$(dirname "$0")/trackpoint-watchdog"
WATCHDOG_DEST="/usr/local/bin/trackpoint-watchdog"
UNIT_SRC="$(dirname "$0")/trackpoint-watchdog.service"
UNIT_DEST="/etc/systemd/system/trackpoint-watchdog.service"

sudo install -m 755 "$WATCHDOG_SRC" "$WATCHDOG_DEST"
sudo install -m 644 "$UNIT_SRC" "$UNIT_DEST"
sudo restorecon "$WATCHDOG_DEST" "$UNIT_DEST" 2>/dev/null || true
sudo systemctl daemon-reload
sudo systemctl enable --now trackpoint-watchdog.service
echo "Installed: $WATCHDOG_DEST, $UNIT_DEST"
echo "TrackPoint will now be reset automatically when it stops responding."
