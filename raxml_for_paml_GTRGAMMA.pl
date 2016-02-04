#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

#this script runs raxmlHPC-PTHREAD with the GTRGAMAA substitution model on input phylip files
#on command line: script.pl <alignment.phy>

my $file = $ARGV[0];
$file =~ /(.*)\.phy/;
my $id =$1;


system "raxmlHPC-PTHREADS -T 10 -p 1234 -s $file -n $id.tree -m  GTRGAMMA";

exit;

