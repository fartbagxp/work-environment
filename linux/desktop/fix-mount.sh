#!/usr/bin/env bash

set -eu

## Mount without sudo
udisksctl mount -b /dev/sdb2

## To unmount
# udisksctl unmount -b /dev/sdb2
