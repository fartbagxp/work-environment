#!/bin/bash
set -ex
sudo sh -c 'echo -n none > /sys/devices/platform/i8042/serio1/drvctl'
sleep 1
sudo sh -c 'echo -n reconnect > /sys/devices/platform/i8042/serio1/drvctl'

# https://github.com/fwupd/firmware-lenovo/issues/388
