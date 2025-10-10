#!/usr/bin/env bash
set -eu

journalctl --user -u pipewire -xe
systemctl --user restart pipewire wireplumber pipewire-pulse
journalctl --user -u pipewire -xe
