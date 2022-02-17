# command line utility for GOULD 4094

see complete documentation here:
https://acidbourbon.wordpress.com/2013/08/24/dso_linux/

# prerequisites

- install necessary packages
- assuming you have perl installed by default
~~~
sudo apt-get install libdevice-serialport-perl hp2xx texlive-font-utils gnuplot gv
~~~

- enable your user to access serial ports (just to be sure)
~~~
sudo usermod -a -G dialout user
~~~

- get the script
~~~
git clone https://github.com/acidbourbon/dsocmd
cd dsocmd
chmod +x dsocmd.pl
~~~


# usage

- get a screenshot
  - optional: show it directly (with gv)
  - optional: convert to pdf
~~~
./dsocmd.pl -plot [-show] [-pdf]
~~~
