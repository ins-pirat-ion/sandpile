#!/bin/bash

export DISPLAY=":0"

speed=`grep '^speed' /proc/acpi/ibm/fan|sed 's/^[^0-9]*//'`

	if [[ $speed -gt 10000  ]]; then
  if [[ ! -f /tmp/fan_alert_sent ]]; then
    zenity --info --text "Fan Error ???? !!!"
    touch /tmp/fan_alert_sent
  else
    echo "alert already sent" > /tmp/fan.out
  fi
else
  echo "speed=$speed" > /tmp/checkminer_last_speed
  echo "speed=$speed" > /tmp/fan.out
  if [[ -f /tmp/fan_alert_sent ]]; then
    echo "clearing alert"
    rm /tmp/fan_alert_sent
  else
    echo "alert already cleared" > /tmp/fan.out
  fi
fi

