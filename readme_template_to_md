#!/usr/bin/env perl
# parse a template file and write a new markdown file

use strict;
use warnings;
use 5.010;

my $infile = "./README.template";
my $outfile = "./README.md";

my $out_data;

open my $FH, "<", $infile;

my $count = 0;
while (my $line = (<$FH>)) {
  if ($line =~ /!% (.*) %!/) {
    $count++;
    my $string = '$ ' . $1 . "\n";
    my $output = `$1`;
    my $retval = $? >> 8;
    if ($retval != 0) {
      say "There was a problem with command $count";
      say $?;
    }
    # remove ANSII escapes
    $output =~ s/\e\[(1;)?\d+m//g;
    #say $output;
    $out_data .= $string;
    $out_data .= $output;
  } else {
    $out_data .= $line;
  }
}

close $FH;

open my $OFH, ">", $outfile;
print $OFH $out_data;
close $OFH;
