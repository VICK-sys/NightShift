#!/bin/sh
set -e
cd "$(dirname "$0")"
haxe run.hxml -- "$@"
