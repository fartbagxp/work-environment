#!/usr/bin/env bash
set -eu

mise self-update -y && mise upgrade && mise prune && mise cache prune
