#! /bin/bash

#This script downloads a set of temperatures, in csv format, fromt he output script. 
#The actual location of your temperature output file may vary, in which case, replace the line below with the correct location of your temperatures.

curl -L -o 'temperatures.tmp' http://10.252.77.9/temperature 

#We take the last 50 readings, which, if they are taken every 15 minutes, gives about 12 hours of readings. Depending on your frequency of readings, you may want to take more or less lines than this.
tail -50 temperatures.tmp > temperatures.machine

#Convert the temperatures from millidegrees celsius to degrees celsius, to make the graphs easier to read. Then convert the date timestamps to normal dates to create a readable csv output file
cat temperatures.machine | awk '{ split ($0,a,","); print a[1] "," a[2]/1000} ' "$@" > temperatures.last
cat temperatures.last | awk '{ split ($0,a,","); print strftime("%d/%m/%Y,%H:%M",a[1]) "," a[2]}' "$@" > temperatures.human

#make a graph from the temperatures.last file
echo "set datafile separator ','
set xlabel 'Time'
set timefmt '%s'
set format x '%H:%M'
set xdata time
set xtics 60*60
set term png size 1560,768
set output 'temperature.png'
plot 'temperatures.last' using 1:2 with lines
" | gnuplot

#define a threshold over which an email can be sent.
THRESHOLD=26
MILLI=26000

#read in the last set of temperatures (in millidegrees) and if the temperature was above the threshold, send the email
while read p; do
	temp=`echo $p | cut -d"," -f2`
	if [ "$temp" -ge "$MILLI" ]; then
		echo "high temp"
		bash mail.sh $THRESHOLD
		exit
	fi
done < temperatures.machine
