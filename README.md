# command line utility for GOULD 4094

see complete documentation here:
https://acidbourbon.wordpress.com/2013/08/24/dso_linux/

~~~
DSOCMD is a simple tool communicate with a GOULD 4094 DSO (digital storage oscilloscope)
via the serial interface. It is especially useful to export screenshots from the scope
as vector images or capture recorded trace data from the scope's memory.

written 2013 by Michael Wiebusch
acidbourbon.wordpress.com

    Usage: ./dsocmd.pl [-c "COMMAND" | -capture XX | -plot] [options]
   
options:
    [-h|--help]             : Show this help.
    [-tty /dev/yourDevice]  : sets the serial interface to /dev/yourDevice
                              instead of /dev/ttyUSB0
    [-baud BAUDRATE]        : sets the serial interface to BAUDRATE
    [-capture XX]           : downloads the trace data from channel XX (=1A,1B,2A,2B,...)
                              saves a dat file and a plot in ./capture
    [-plot]                 : make a screenshot of the scope and saves it in ./plot
    [-pdf]                  : saves the generated plots as pdf, use in combination with
                              -capture and -plot
    [-show]                 : shows the plot after a -plot or -capture
    [-c "COMMAND"]          : send "COMMAND" to the DSO and print the answer
    [-q]                    : quiet option, do not print debug data when sending a scope
                              command, use in combination with -c
examples:

    ./dsocmd -c "HELLO" -q -tty /dev/ttyUSB1 -baud 9600
    
    ./dsocmd -plot -pdf -show
    
    ./dsocmd -capture 1A -pdf -show
                                     
dependencies:

before you run the script, make sure you have the following software packages installed:

    libdevice-serialport-perl [ for serial communication, mandatory ]
    hp2xx [ for hpgl -> eps conversion ]
    texlive-font-utils [contains "epstopdf", for eps -> pdf conversion ]
    gnuplot [ for plots of downloaded traces ]

On a Debian/Ubuntu/Mint Linux you can install all that by typing this into your console:

$ sudo apt-get install libdevice-serialport-perl hp2xx texlive-font-utils gnuplot

Make sure your user can access the serial interface. Therefore "user" has to be 
member of the "dialout" group. You can achieve this by simply typing:

$ sudo usermod -a -G dialout user

Subsequently user has to log out and in again, so the changes become effective.
~~~
