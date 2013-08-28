#!/usr/bin/perl
#
#Quick and dirty DNS check, display average response times, not founds and other goodies
if ($#ARGV!=3) {
	print "\nUsage: dns_check.pl <HOST> <DNS SERVER> <REPETITIONS> <DISPLAY THRESHOLD IN MS>\n\n";
	exit(1);
}
$host=$ARGV[0];
$server=$ARGV[1];
$times=$ARGV[2];
$threshold=$ARGV[3];
$total=0;
$count=0;
$notfound=0;
$max=0;
$lasterror=0;

print "Current Attempt: ";

while ($count < $times) {
	@command=`dig $host \@$server`;
	@ms= grep { /Query time: \d+ msec/ } @command;
	@result= grep { /ANSWER SECTION/ } @command;
	if (!$lasterror) {
		print "\b" x length($count);
	}
	$lasterror=0;
	print $count+1;
	$ms[0] =~/(\d+)/;	
	if (($1 > $threshold) || (!@result)){
		$lasterror=1;	
		print "\b" x (length($times)+ 16);
		print "Attempt:";
		print $count+1 . " " . $1 . "ms";
		if (!@result) {
			print " Not Found";
			$notfound++;
		}
		print "                 \nCurrent Attempt: ";
	};
	$total+=$1;
	if ($max < $1) {
		$max=$1;
	}
	$count++;
}
print "\nMax: $max ms, Avg: ".$total/$count."ms Not Found:$notfound\n";

