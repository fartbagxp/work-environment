#!/bin/bash
set -ex

# Before resetting, check whether the dead TrackPoint still answers PS/2
# commands. Writing its current sensitivity back sends a real command through
# the RMI4 pass-through; if this fails, a watchdog can detect the hang.
tp=$(dirname "$(ls /sys/bus/serio/devices/serio*/sensitivity 2>/dev/null | head -1)")
if [[ -f "$tp/sensitivity" && "$tp" == /sys/* ]]; then
    if sudo sh -c "cat $tp/sensitivity > $tp/sensitivity"; then
        echo "probe: TrackPoint ($tp) still accepts commands" | sudo tee /dev/kmsg
    else
        echo "probe: TrackPoint ($tp) rejected command" | sudo tee /dev/kmsg
    fi
fi

sudo sh -c 'echo -n none > /sys/devices/platform/i8042/serio1/drvctl'
sleep 1
sudo sh -c 'echo -n reconnect > /sys/devices/platform/i8042/serio1/drvctl'

# https://github.com/fwupd/firmware-lenovo/issues/388
