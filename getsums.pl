#!/usr/bin/perl

# calculate hashes for all files in a set of directories

use strict;
use Digest::MD5;

for my $dir (@ARGV) {
  $dir=~s|/$||;
  opendir(my $dh, $dir) || die "Can't open $dir: $!";
    while (readdir $dh) {
      next if /^\./;
      next if /\.xmp$/;
      next if /\.aae$/;
      open (my $fh, '<', "$dir/$_") or die "Can't open '$dir/$_': $!";
      binmode ($fh);
      print Digest::MD5->new->addfile($fh)->hexdigest, " $dir/$_\n";
    }
  closedir $dh;
}
