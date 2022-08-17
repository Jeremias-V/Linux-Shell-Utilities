#!/bin/bash

## Script to connect to previously paired bluetooth devices with bluetoothctl.

# Definition of formatting variables.
RED='\e[1;31m'
GREEN='\e[1;32m'
WHITE='\e[0m'
CYAN='\e[1;36m'
YELLOW='\e[1;33m'
ERROR="${RED}Error:${WHITE}"

# Check if the parameter is correct. 
if [ "$#" -ne 1 ]; then
	echo -e "\n${ERROR} Invalid number of parameters, must provide"\
			"ONE parameter as the name of the bluetooth device to connect.\n"
	exit 1
fi

btctl_error="No default controller available"

paired=$(bluetoothctl paired-devices)
count=$(echo -n $paired | wc -c)

# Check if bluetoothctl is working and there are previously paired devices.
if [[ "$btctl_error" == "$paired" || $count -eq 0 ]]; then
	echo -e "\n${ERROR} Couldn't find your paired devices, check"\
			"your bluetooth configuration or pair your device.\n"
	exit 1
fi

# Extract relevant data to variables for error checking and connection.
address=$(echo -n $paired | grep $1 | awk '{print $2}')
paired=$(echo -n $paired | awk '{print $3}')
count=$(echo -n $address | wc -c)

list_devices () { echo -e "${CYAN}${paired}${WHITE}\n"; }

# Check if the given parameter matches any device.
if [ $count -eq 0 ]; then
	echo -e "\n${ERROR} Couldn't find any device matching your"\
			"parameter.\n\nTry with the following devices:\n"
	list_devices
	exit 1
fi

# Check if the given parameter matches multiple devices (>1).
count=$(echo $address | wc -l)
if [ $count -gt 1 ]; then
	echo -e "\n${ERROR} Found multiple paired devices matching your pattern,"\
			"specify better your device name.\n\n Try with the following devices:\n"
	list_devices
	exit 1
fi

# Print loading dots for indicating a process is running.
echo -ne "\n${YELLOW}Trying to connect to your paired device."
while sleep 1; do printf "."; done &
timeout 10 bluetoothctl connect $address &> /dev/null
connect_code=$?
kill $!
echo -e "${WHITE}\n"

# Check if the exit code of bluetoothctl was 0 (success code).
if [ $connect_code -ne 0 ]; then
	echo -e "${ERROR} Something went wrong when connecting to your paired"\
			"device. Check if the device is ready to connect (bluetooth is"\
			"turned on and allowing connections).\n"
	exit 1
else
	echo -e "${GREEN}Success!${WHITE} connected to ${CYAN}${paired}${WHITE}.\n"
fi

# Exit with code 0 meaning all filters were passed and the script ended rightfully.
exit 0

