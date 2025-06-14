#!/bin/bash
### Battery Warning Script

# log file path
log_file="/home/cyber-syntax/Documents/scripts/battery.log"

# logging function
log() {
  local datetime=$(date +'%Y-%m-%d %H:%M:%S')
  echo "$datetime: $1" >> $log_file
}

# # function to send notification for 20, 10 batteries
# function send_notification() {
#   low_threshold=$1
#   critical_threshold=$2
#
#   # check battery levels and issue notifications
#   if [ $battery_percent -le $critical_threshold ]; then
#       log "Battery is at $battery_percent%. Sending critical notification."
#       notify-send -u critical "Battery Warning" "Battery is at $battery_percent%. Please plug in the charger."
#   elif [ $battery_percent -le $low_threshold ]; then
#       log "Battery is at $battery_percent%. Sending low notification."
#       notify-send "Battery Warning" "Battery is at $battery_percent%. Consider plugging in the charger."
#   fi
# }  

# log the start of the script
log "Battery Warning script started time: $(date +'%H:%M:%S')"

while true; do
    # Get the battery percentage
    battery_percent=$(acpi -b | grep -P -o '[0-9]+(?=%)')

    # Get AC status
    ac_status=$(acpi -a | awk '{print $3}')

    # If charging, do nothing
    if [ "$ac_status" == "Charging" ]; then
      log "AC power connected. Script will sleep for 10 minutes and check again."
      notify-send "Battery Warning" "AC power connected. Script will sleep for 10 minutes and check again."
      sleep 600
      continue
    fi

    # Set notification threshold levels
    low_threshold=20
    critical_threshold=10

    # Check battery levels and issue notifications
    if [ $battery_percent -le $critical_threshold ]; then
        log "Battery is at $battery_percent%. Sending critical notification."
        notify-send -u critical "Battery Warning" "Battery is at $battery_percent%. Please plug in the charger."
    elif [ $battery_percent -le $low_threshold ]; then
        log "Battery is at $battery_percent%. Sending low notification."
        notify-send "Battery Warning" "Battery is at $battery_percent%. Consider plugging in the charger."
    fi

    # Sleep duration based on battery percentage
    sleep_duration=0

    log "Battery is at $battery_percent%. Setting sleep duration based on battery percentage."
    if [ $battery_percent -le 5 ]; then
        sleep_duration=60
    elif [ $battery_percent -le 10 ]; then
        sleep_duration=150
    elif [ $battery_percent -le 20 ]; then
        sleep_duration=300
    elif [ $battery_percent -le 30 ]; then
        sleep_duration=300
    elif [ $battery_percent -le 40 ]; then
        sleep_duration=600
    elif [ $battery_percent -le 50 ]; then
        sleep_duration=900
    elif [ $battery_percent -le 60 ]; then
        sleep_duration=900
    elif [ $battery_percent -le 70 ]; then
        sleep_duration=1200
    else
        sleep_duration=1800
    fi

    # Sleep before checking again
    sleep $sleep_duration
    log "Sleeping for $sleep_duration seconds because battery is at $battery_percent%."

    # Periodically check battery status
    for ((i=0; i<10; i++)); do
        log "Inside periodic check loop."
        log "Checking battery status every 5 minutes for any changes. Iteration: $((i+1))/10."
        # Get the battery percentage
        battery_percent=$(acpi -b | grep -P -o '[0-9]+(?=%)')
        log "Battery is at $battery_percent%."

        # Send notification if battery is critically low
        if [ $battery_percent -le $critical_threshold ]; then
            log "Battery is at $battery_percent%. Sending critical notification."
            notify-send -u critical "Battery Warning" "Battery is at $battery_percent%. Please plug in the charger."
        elif [ $battery_percent -le $low_threshold ]; then
            log "Battery is at $battery_percent%. Sending low notification."
            notify-send "Battery Warning" "Battery is at $battery_percent%. Consider plugging in the charger."
        fi
        
        log "Sleeping for 5 minutes before checking battery status again."
        # Sleep before checking again
        sleep 300
        log "End of periodic check loop. Iteration: $((i+1))/10."
    done
done
