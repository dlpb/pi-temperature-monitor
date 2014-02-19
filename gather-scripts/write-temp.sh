#! /bin/bash

#This script outputs a temperature as read from the w1 device (normally in 1000ths of a degree) to the directory ~/output/temp

echo "`date +%s`,`find /sys/bus/w1/devices/28-*/w1_slave  | xargs -I {} tail -1 {} | cut -d"=" -f2`" >> ~/output/temp

