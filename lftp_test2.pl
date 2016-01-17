#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

my $file = "lftpfile.txt";


system "lftp sftp://kristen:moraceae\@10.0.8.1 -e 'cd homes/kristen/data; put $file;bye'";

exit;