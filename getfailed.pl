#!/usr/bin/perl
#
# parse system log for list of filenames that failed to import

use strict;

my %files;

open(F, q/log show --predicate '(subsystem == "com.apple.Photos") && (category == "import.error")'|/);
while(<F>) {
  $files{$1}++ if /path: (.*)\),/;
}

for (keys %files) {
  next if $_ eq '(null)';
  print "$_\n";
}
