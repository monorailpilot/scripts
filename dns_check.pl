#!/usr/bin/perl
# This script will repetitively call a DNS server to look up a host name and report on the time it takes to process the request.  

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
$max=0;

while ($count < $times) {
	@command=`dig $host \@$server`;
	@ms= grep { /Query time: \d+ msec/ } @command;
	$ms[0] =~/(\d+)/;	
	if ($1 > $threshold) {
		print "Attempt:";
		print $count+1 . " " . $1 . "ms\n";
		$total+=$1;
		if ($max < $1) {
			$max=$1;
		};		
	}
	$count++;
}
print "Max: $max ms, Avg: ".$total/$count."ms\n";

