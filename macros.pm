#!/usr/bin/perl


sub getValue {
  my $valName=$_[0];
  my $answer = communicate($valName);
  if($answer =~ m/$valName=([^=]+)/){
    return $1;
  }
  die "could not retrieve desired value $valName!";
}


sub plot {

  my $plotDir = "./plots/";
  unless(-e $plotDir) {
    mkdir $plotDir;
  }
  
  my $hpglData = plot_request(); 
      my $baseFileName = "plot".strftime("_%Y.%m.%d_%H:%M:%S", localtime());
      my $hpglFile = $plotDir.$baseFileName.".hpgl";

      open(DATA,">$hpglFile");
      print DATA $hpglData;
      close(DATA);
      
#      system("hp2xx dualplot.hpgl -m eps -h150 -w200 -p542
#       chdir($plotDir);
      system("hp2xx $hpglFile -m eps -p542 -a 2");
#       system("epstopdf $hpglFile.eps --outfile=$baseFileName.pdf");
    system("gv $hpglFile.eps");

}








sub capture {


my $captureDir = "./capture/";
my $channel = shift();
my $ab = shift();


my $transferCmd = "TRC$channel$ab";
my @data;
my @rawData;



my $timePerDiv= getValue("HS$ab");
my $screenWidthTime = $timePerDiv*10;

my $voltsPerDiv=getValue("VS$channel");
my $probeGain = getValue("PBG$channel");
$probeGain =~ s/^X//;
my $screenHeightVoltage= $voltsPerDiv*$probeGain*8;
my $traceOffset = getValue("VP$channel");
my $traceOffsetVoltage = $voltsPerDiv*$probeGain*$traceOffset;

print "\nwhole screen width: $screenWidthTime sec\n";
print "probe gain: $probeGain\n";
print "whole screen height: $screenHeightVoltage volts\n";
print "trace offset: $traceOffsetVoltage volts\n";





my $dataString = communicate($transferCmd);
# testdata if communication is too negthy :D
# my $dataString = "TRC1A=-2,4,8,12,15,19,24,28,31,34,35,36,40,42,43,46,51,50,53,54,56,56,58,60,59,63,65,62,67,67,69,66,72,72,71,69,73,72,75,73,75,75,75,77,77,77,77,77,78,77,78,78,81,79,76,77,78,81,81,78,80,81,80,82,81,80,81,81,82,81,81,81,79,80,80,81,82,81,81,80,84,81,82,81,82,82,82,83,82,81,81,80,83,82,82,81,81,80,83,80,82,83,82,83,81,81,80,84,83,83,83,83,83,84,81,82,84,84,83,83,82,82,81,82,81,83,85,84,83,83,85,81,83,81,82,82,84,81,83,81,82,83,83,82,84,82,82,80,83,82,82,84,83,82,80,80,82,84,84,84,82,85,83,83,83,82,83,83,83,82,81,82,83,83,82,83,83,82,83,81,84,83,83,84,82,82,82,82,84,82,82,82,83,83,81,82,84,82,84,81,82,84,82,81,81,83,82,84,81,83,81,81,82,84,81,81,84,82,83,82,82,81,81,82,81,82,84,82,82,82,84,83,83,81,84,82,83,82,84,83,84,83,82,82,83,84,82,82,82,81,83,84,82,82,83,80,81,82,84,83,82,84,84,84,81,82,83,82,83,82,82,82,82,80,81,81,83,82,82,82,83,84,83,81,82,81,82,81,83,79,82,80,82,83,81,82,81,81,81,81,82,83,82,83,80,79,81,83,83,83,83,82,83,82,83,83,82,83,84,83,83,81,81,82,81,82,85,81,82,81,83,82,83,
# 82,82,81,82,82,82,82,82,82,81,82,82,82,82,81,82,81,82,84,80,82,79,79,78,83,83,85,82,82,82,82,83,82,82,83,83,82,83,82,81,82,81,83,83,81,82,83,85,82,83,82,82,81,82,81,83,82,82,82,81,82,82,81,81,80,82,81,81,82,83,82,81,80,78,85,85,82,82,82,83,83,82,83,82,82,83,81,83,82,82,84,81,81,83,81,83,82,83,82,82,81,81,81,83,82,82,80,81,83,81,83,84,81,82,81,82,80,82,83,81,82,81,81,78,84,82,82,83,82,81,82,80,81,82,82,83,83,82,81,81,82,81,81,83,82,76,67,58,50,43,36,28,20,16,9,4,-2,-8,-11,-14,-16,-22,-28,-31,-34,-35,-39,-40,-41,-44,-46,-52,-52,-55,-54,-56,-57,-59,-60,-60,-62,-63,-65,-65,-66,-66,-68,-69,-70,-71,-71,-74,-71,-72,-73,-73,-74,-74,-73,-76,-76,-75,-76,-76,-77,-77,-77,-76,-79,-77,-79,-80,-80,-78,-81,-79,-80,-79,-79,-79,-80,-82,-83,-82,-78,-79,-80,-80,-79,-80,-79,-81,-80,-79,-79,-79,-82,-81,-81,-80,-80,-83,-80,-80,-82,-82,-81,-80,-80,-80,-79,-81,-83,-79,-81,-81,-82,-82,-82,-81,-81,-80,-82,-82,-81,-82,-82,-81,-81,-80,-81,-83,-82,-82,-79,-81,-82,-80,-81,-80,-82,-82,-81,-82,-83,-81,-82,-81,-82,-82,-80,-82,-82,-80,-82,-
# 80,
# -82,-79,-80,-80,-81,-81,-82,-80,-81,-81,-82,-81,-82,-80,-80,-80,-80,-82,-82,-80,-83,-80,-80,-80,-82,-83,-82,-82,-80,-80,-81,-80,-80,-82,-81,-82,-82,-82,-82,-81,-80,-80,-83,-82,-82,-81,-81,-79,-81,-80,-80,-81,-82,-79,-79,-80,-79,-80,-82,-80,-82,-81,-81,-80,-80,-81,-80,-80,-82,-81,-83,-81,-79,-82,-81,-82,-83,-83,-78,-82,-80,-82,-81,-82,-81,-82,-83,-82,-79,-79,-81,-83,-80,-82,-81,-81,-81,-80,-82,-81,-80,-82,-82,-80,-79,-80,-81,-80,-82,-80,-83,-80,-80,-80,-81,-80,-82,-80,-81,-80,-83,-80,-81,-81,-80,-82,-82,-80,-80,-80,-80,-81,-81,-80,-82,-82,-80,-81,-82,-80,-80,-80,-80,-83,-81,-82,-80,-81,-81,-80,-80,-82,-80,-81,-81,-81,-81,-81,-81,-79,-80,-81,-80,-80,-80,-82,-81,-80,-80,-81,-81,-80,-80,-82,-82,-83,-81,-82,-80,-81,-82,-82,-82,-80,-81,-82,-83,-81,-82,-80,-82,-80,-82,-80,-80,-83,-82,-81,-81,-78,-80,-81,-80,-79,-78,-81,-81,-80,-81,-81,-81,-82,-80,-80,-81,-82,-80,-80,-83,-81,-82,-80,-80,-80,-80,-83,-80,-80,-82,-79,-82,-79,-80,-82,-80,-79,-82,-79,-80,-79,-80,-80,-80,-82,-81,-82,-80,-79,-79,-76,-80,-84,-82,-82,-81,-
# 83,
# -84,-81,-82,-83,-83,-82,-83,-82,-80,-81,-82,-82,-83,-81,-84,-80,-80,-82,-80,-83,-80,-83,-79,-79,-82,-80,-79,-83,-80,-80,-81,-81,-81,-81,-81,-84,-80,-82,-81,-83,-80,-80,-80,-80,-81,-81,-80,-78,-80,-80,-81,-80,-82,-78,-81,-81,-80,-79,-79,-81,-80,-81,-81,-80,-82,-80,-79,-79,-80,-82,-79,-79,-82,-80,-80,-78,-81,-81,-80,-81,-80,-80,-81,-80,-80,-79,-80,-81,-82,-81,-79,-80,-80,-79,-80,-80,-79,-78,-80,-80,-81,-77,-76,-71,-66,-61,-53,-47,-40,-35,-29,-21,-16,-10,-6,0,4,9,13,18,23,24,32";
# 
# 








if ($dataString =~ m/$transferCmd=([^=]+)/ ) {
  # execute if we have the right data format
  @rawData = split(",",$1);
  # calculate the correct values in volts and seconds ...
  my $timeCounter=0;
  push(@data,"#time [s]\t#voltage [V]");
  for my $byte (@rawData) {
    my $scaledVoltage =$byte/224*$screenHeightVoltage-$traceOffsetVoltage;
    my $timeIndex = $timeCounter/1007*$screenWidthTime;
    push(@data,"$timeIndex\t$scaledVoltage");
    $timeCounter++;
  
  }

} else {
    die "answer does not have correct format: $dataString\n\n";
}
      unless(-e $captureDir) {
        mkdir $captureDir;
      }
      my $baseFileName = $captureDir.$transferCmd.strftime("_%Y.%m.%d_%H:%M:%S", localtime());

      open(DATA,">$baseFileName.dat");
      print DATA join("\n",@data);
      close(DATA);

      open(GNUPLOT,"|gnuplot");
      print GNUPLOT "set terminal png\n";
      print GNUPLOT "set output \"$baseFileName.png\"\n";
      print GNUPLOT qq%set xlabel "time [s]"\n%;
      print GNUPLOT qq%set ylabel "voltage [V]"\n%;
      my $minV=-$traceOffsetVoltage-$screenHeightVoltage/2;
      my $maxV=$minV+$screenHeightVoltage;
      print GNUPLOT qq%set yrange [$minV:$maxV]\n%;
#       print GNUPLOT "plot \"./data.dat\"\n";
      print GNUPLOT qq%plot '-' title "channel $channel$ab" w lines\n%;
      print GNUPLOT join("\n",@data);
      print GNUPLOT "\ne\n\n";
      close GNUPLOT;
      
      system("display $baseFileName.png");

}



1;