#!/usr/bin/env bash

HERE=$(dirname "$(readlink -f "$0")")
SCREEN_SIZE=${SCREEN_SIZE:-1280x720}
XDISPLAY=${XDISPLAY:-:1}
LOG_LEVEL=${LOG_LEVEL:-INFO}
APP=${APP:-$(python3 -c "from libqtile.utils import guess_terminal; print(guess_terminal())")}
QTILE_CMD=${QTILE_CMD:-qtile}

# Validate required commands
command -v Xephyr >/dev/null 2>&1 || {
  echo "Error: Xephyr is not installed" >&2
  exit 1
}
command -v "$QTILE_CMD" >/dev/null 2>&1 || {
  echo "Error: qtile is not installed" >&2
  exit 1
}

# Cleanup function
cleanup() {
  local exit_code=$?
  [[ -n "${XEPHYR_PID:-}" ]] && kill "$XEPHYR_PID" 2>/dev/null
  [[ -n "${QTILE_PID:-}" ]] && kill "$QTILE_PID" 2>/dev/null
  exit "$exit_code"
}

trap cleanup EXIT INT TERM

Xephyr +extension RANDR -screen "$SCREEN_SIZE" "$XDISPLAY" -ac &
XEPHYR_PID=$!

(
  sleep 1
  # Use the installed qtile command with the config from current directory
  env DISPLAY="$XDISPLAY" QTILE_XEPHYR=1 "$QTILE_CMD" start -c "$HERE/config.py" -l "$LOG_LEVEL" "$@" &
  QTILE_PID=$!
  env DISPLAY="$XDISPLAY" $APP &
  wait "$QTILE_PID"
)
