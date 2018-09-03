#!/usr/bin/env bash

echo -n "reconnect" | sudo tee /sys/bus/serio/devices/serio1/drvctl
