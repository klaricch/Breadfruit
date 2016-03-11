#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;


my $file = $ARGV[0];
$file =~ /(\d+)_fix\.(.*)/;
system "mv $file $1\.$2" 
