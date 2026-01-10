#!/usr/bin/env bash

OFFSET_FILE="/tmp/rofi_calendar_offset"

TODAY_YEAR=$(date +%Y)
TODAY_MONTH=$(date +%m)
TODAY_DAY=$(date +%-d)

if [ $# -eq 0 ]; then
  OFFSET=0
else
  OFFSET=$(cat "$OFFSET_FILE" 2>/dev/null || echo 0)
fi

if [ $# -eq 0 ]; then
  # Initial menu
  TARGET_DATE=$(date --date="$OFFSET month" +%Y-%m-01)
  TARGET_YEAR=$(date --date="$TARGET_DATE" +%Y)
  TARGET_MONTH=$(date --date="$TARGET_DATE" +%m)
  CAL=$(cal -m "$(date --date="$TARGET_DATE" +%m)" "$(date --date="$TARGET_DATE" +%Y)")
  if [[ "$TARGET_YEAR" == "$TODAY_YEAR" && "$TARGET_MONTH" == "$TODAY_MONTH" ]]; then
    CAL=$(echo "$CAL" | sed -E "s/(^|[^0-9])($TODAY_DAY)([^0-9]|$)/\1<span color='#81A1C1FF'><b>\2<\/b><\/span>\3/g")
  fi
  echo -e "$CAL\n▶ Next Month\n◀ Previous Month"
else
  # Handle selection
  case "$1" in
  "◀ Previous Month")
    OFFSET=$((OFFSET - 1))
    ;;
  "▶ Next Month")
    OFFSET=$((OFFSET + 1))
    ;;
  esac
  echo "$OFFSET" > "$OFFSET_FILE"
  # New menu
  TARGET_DATE=$(date --date="$OFFSET month" +%Y-%m-01)
  TARGET_YEAR=$(date --date="$TARGET_DATE" +%Y)
  TARGET_MONTH=$(date --date="$TARGET_DATE" +%m)
  CAL=$(cal -m "$(date --date="$TARGET_DATE" +%m)" "$(date --date="$TARGET_DATE" +%Y)")
  if [[ "$TARGET_YEAR" == "$TODAY_YEAR" && "$TARGET_MONTH" == "$TODAY_MONTH" ]]; then
    CAL=$(echo "$CAL" | sed -E "s/(^|[^0-9])($TODAY_DAY)([^0-9]|$)/\1<span color='#81A1C1FF'><b>\2<\/b><\/span>\3/g")
  fi
  echo -e "$CAL\n▶ Next Month\n◀ Previous Month"
fi

# Launcher
if [ $# -eq 0 ]; then
  rofi -show calendar -modi "calendar:$0" -markup-rows -theme $HOME/.config/rofi/calendar/style-calendar.rasi -p "Calendar"
fi
