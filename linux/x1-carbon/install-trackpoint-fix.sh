#!/bin/bash
set -e

HOOK_SRC="$(dirname "$0")/fix-trackpoint-on-resume"
HOOK_DEST="/lib/systemd/system-sleep/fix-trackpoint-on-resume"

sudo install -m 755 "$HOOK_SRC" "$HOOK_DEST"
echo "Installed: $HOOK_DEST"
echo "TrackPoint will now be reset automatically after every resume."
