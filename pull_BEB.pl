#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;


my $file = $ARGV[0];
open IN, "< $file";
my $line;
my $next;
while (<IN>){
	$line = $_;
	#chomp $line;

	
	if ($line =~ /\(BEB\)/){
		do{
			$next = scalar <IN>;
			print $next;
		#print scalar <IN>;
	} until (scalar <IN> =~ /The/)
	}
}
close IN;
exit;
	