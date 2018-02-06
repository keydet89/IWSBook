#! c:\perl\bin\perl.exe
# http://alvinalexander.com/perl/perl-parse-apache-access-log-file-logfile

use strict;
use Time::Local;

my $file = "f:\\binary4\\access\.log";
open(FH,"<",$file) || die "Could not open ".$file.": $!\n";
while (<FH>) {
	chomp;
	s/\s+/ /go;
	my ($clientAddress, $rfc1413, $username, $localTime, $httpRequest, $statusCode,$bytesSentToClient, $referer,$clientSoftware) =
     /^(\S+) (\S+) (\S+) \[(.+)\] \"(.+)\" (\S+) (\S+) \"(.*)\" \"(.*)\"/o;
  
  my $gmt = processTime($localTime);
  $httpRequest =~ s/%((?:[0-9a-fA-F]{2})+)/pack 'H*', $1/ge;
  
  print $gmt."|Apache|||".$httpRequest." [".$statusCode."]\n";
}
close(FH);

sub processTime {
	my $dt1 = shift;
	my $dt = (split(/\s/,$dt1))[0];
	my %month = ("Jan" => 0,
	             "Feb" => 1,
	             "Mar" => 2,
	             "Apr" => 3,
	             "May" => 4,
	             "Jun" => 5,
	             "Jul" => 6,
	             "Aug" => 7,
	             "Sep" => 8,
	             "Oct" => 9,
	             "Nov" => 10,
	             "Dec" => 11);
	
	my ($date,$hr,$min,$sec) = split(/:/,$dt,4);
	my ($day,$mon,$yr) = split(/\//,$date,3);
	return timegm($sec,$min,$hr,$day,$month{$mon},$yr);
}