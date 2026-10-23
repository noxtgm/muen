#!/bin/bash

if [[ -t 1 && -t 2 && -z "${NO_COLOR:-}" ]]; then
    OFF=$'\e[0m'
    BOLD=$'\e[1m'
    RED=$'\e[1;31m'
    BLUE=$'\e[1;34m'
    GREEN=$'\e[1;32m'
    YELLOW=$'\e[1;33m'
else
    OFF=''
    BOLD=''
    RED=''
    BLUE=''
    GREEN=''
    YELLOW=''
fi
