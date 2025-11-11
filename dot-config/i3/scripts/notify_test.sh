#!/usr/bin/env bash

delay=${1:-30} # default to 30 seconds if no argument given
title=${2:-"Hello!"}
body=${3:-"Your timed notification is here."}

sleep "$delay"
notify-send "$title" "$body"
