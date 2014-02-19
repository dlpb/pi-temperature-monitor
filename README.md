pi-temperature-monitor
======================

A series of scripts to monitor the temperature using a Dallas 18B20 thyristor, connected to a 1 Wire bus device (in my case, a Pi).

There are three scripts that need to be placed in certain places:

1. gather-scripts/write_temp.sh - This needs to be placed on your Pi, or other gathering device, with access to the thyristor. This writes output to ~/output/temp file. This file will need to be accessible by other scripts, e.g. using apache or ssh

2. make_therm_graph.sh - This needs to run on the machine that you want to use to send emails/make graphs from. This needs access to the output from the above script, as well as acecss to gnuplot

3. mail.sh - Sends the email. needs to run from the same folder as make_therm_graph.sh, and is called automatically by that script. Needs access to sendmail and a mail server