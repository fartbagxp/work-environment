#!/usr/bin/env bash

set -eu

pkill -9 -f -e Agent.exe
pkill -9 -f -e Battle.net
pkill -9 -f -e wine
pkill -9 -f -e battle
pkill -9 -f -e explorer.exe
pkill -9 -f -e winedevice.exe
