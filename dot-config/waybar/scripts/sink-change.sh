# #!/bin/bash

# Get active sink name
running_sink=$(pactl list sinks short | grep "RUNNING" | cut -f 2)

# Define sink available_sinks
headset='alsa_output.pci-0000_28_00.3.analog-surround-51'
DP_1='alsa_output.pci-0000_26_00.1.hdmi-stereo-extra1'
DP_2='alsa_output.pci-0000_26_00.1.hdmi-stereo-extra2'

# Get available sink available_sinks
available_sinks=$(pactl list sinks short | cut -f 2)

# Function to print current active sink name
print_sink() {
    if [ "$running_sink" = "$headset" ]; then
        echo "Headset"
    elif [ "$running_sink" = "$DP_1" ]; then
        echo "DP-1"
    elif [ "$running_sink" = "$DP_2" ]; then
        echo "DP-2"
    else
        echo "No Active Sink"
    fi
}

# Function to change sink
change_sink() {
    if [ "$running_sink" = "$headset" ]; then
        if [[ $available_sinks == *"$DP_1"* ]]; then
            pactl set-default-sink $DP_1
            echo "DP-1"
        elif [[ $available_sinks == *"$DP_2"* ]]; then
            pactl set-default-sink $DP_2
            echo "DP-2"
        else
            pactl set-default-sink $headset
        fi
    elif [ "$running_sink" = "$DP_1" ]; then
        if [[ $available_sinks == *"$DP_2"* ]]; then
            pactl set-default-sink $DP_2
            echo "DP-2"
        elif [[ $available_sinks == *"$headset"* ]]; then
            pactl set-default-sink $headset
            echo "Headset"
        else
            pactl set-default-sink $DP_1
        fi
    elif [ "$running_sink" = "$DP_2" ]; then
        if [[ $available_sinks == *"$headset"* ]]; then
            pactl set-default-sink $headset
            echo "Headset"
        elif [[ $available_sinks == *"$DP_1"* ]]; then
            pactl set-default-sink $DP_1
            echo "DP-1"
        else
            pactl set-default-sink $DP_2
        fi
    else
        pactl set-default-sink $headset
    fi
}

# Check command line arguments and call functions
if [ "$1" = "--status" ]; then
    print_sink
elif [ "$1" = "--change" ]; then
    change_sink
else
    echo "Invalid argument"
fi
