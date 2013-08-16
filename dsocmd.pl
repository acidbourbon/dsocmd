#!/usr/bin/perl
use strict;
use warnings;
use Device::SerialPort;
use Time::HiRes;
use Getopt::Long;
use POSIX qw/strftime/;


require macros;




# defaults
my $baudrate=9600;
my $port;


my $opt_command;
my $opt_help;
my $opt_macro;
my $opt_capture;
my $ser_dev = "/dev/ttyUSB0";



GetOptions ('h|help'      => \$opt_help,
#             't|time=f'    => \$opt_time,
#             'p|path=s'    => \$opt_path
              'c|cmd=s'   => \$opt_command,
              'tty=s'     => \$ser_dev,
              'baud=s'    => \$baudrate,
              'capture=s' => \$opt_capture,
              'm|macro=s' => \$opt_macro
            );
           
if($opt_help) {
    &help();
    exit(0);
}


init_port();

if(defined($opt_command)){
  communicate($opt_command);
  print "\n\n";
  exit;
}


if(defined($opt_macro)) {
  eval "$opt_macro();"
  
}


if(defined($opt_capture)){

  if($opt_capture =~ m/(\d)([AB])/){
    my $channel =$1;
    my $ab = $2;
    capture($channel,$ab);
  } else {
    die "wrong parameters to capture subroutine.\n";
  }
  exit;

}



















sub help(){
    print "Usage: exec_evtbuild_t.pl -t <float>
   
required:
   [-t|--time  <seconds>]             : The runtime of the daq_netmem (effective runtime).
   [-h|--help]                        : Show this help.
   [-p|--path /path/to/dump/data/ ]   : Specify the path where the data is to be written to.
                                        default: ./

"
}






sub communicate {

  my $ack_timeout=0.5;
  my $answer_timeout=10;

  my $command = $_[0];
  print "sending command $command\n";


  $port->are_match("\r");
  $port->lookclear; 
  $port->write("\n$command\n\n");
  
  my $ack = 0;




ACK_POLLING:  for (my $i = 0; ($i<$ack_timeout*100) ;$i++) {
#     print $i."\n";
    while(my $a = $port->lookfor) {
        if($a=~ m/\?([^\?]+)/) {
          my $cmd_echo = $1;
          print "DSO received command $cmd_echo\n\n";
          if($cmd_echo ne $command) {
            print "ERROR: command transmission faulty\n";
            return "ERROR";
          }
          $ack=1;
          last ACK_POLLING;
        }

    } 
      Time::HiRes::sleep(.01);

  }
  
  unless($ack) {
    print "no answer\n";
    return "no answer";
  }
  
ANSWER_POLLING:  for (my $i = 0; ($i<$answer_timeout*100) ;$i++) {
#     print $i."\n";
    while(my $a = $port->lookfor) {

        print "received answer:\n";
        print $a."\n";
        return $a;

    } 
      Time::HiRes::sleep(.01);

  }
  
  print "no answer :(\n";
  return "no answer";
  

}






sub init_port {


  # talk to the serial interface

  $port = new Device::SerialPort($ser_dev);
  unless ($port)
  {
    print "can't open serial interface $ser_dev\n";
    exit;
  }

  $port->user_msg('ON'); 
  $port->baudrate($baudrate); 
  $port->parity("none"); 
  $port->databits(8); 
  $port->stopbits(1); 
  $port->handshake("xoff"); 
  $port->write_settings;

}