#!/usr/bin/perl
#
# parse system log for list of filenames that failed to import
#
# Example log output:
#Timestamp                       Thread     Type        Activity             PID    TTL
#2020-05-22 11:40:28.019783-0400 0x2e8f3    Error       0x6f2ea              10623  0    Photos: (Photos) [com.apple.Photos:import.error] ERROR:  (Unsupported resource set: video,xmp, path: MVI_3051.avi), file: PHImportAsset.m, line: 1790
#[...]

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
