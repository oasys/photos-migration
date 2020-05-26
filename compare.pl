#!/usr/bin/perl

# compare hashes from multiple image directories and merge
# them into a single output directory

use strict;
use List::MoreUtils qw(uniq);
use File::Basename;
my %h;
my $OUTDIR='./compare-out';
my $DEBUG=0;

die "$OUTDIR already exists, exiting" if -e $OUTDIR;
mkdir "$OUTDIR";

while(<>) {
  if (/^([0-9a-f]{32}) (.*\.(\S+))$/) {
    push(@{$h{$1}{'files'}}, $2)
  } else {
    print "cannot parse line: '$_', skipping.\n";
    next;
  }
}

for my $hash (keys %h) {
  my @files = @{$h{$hash}{'files'}};
  my $count = scalar @files;
  my $choice;

  if ($count == 1) { # unique
    $choice = $files[0];
    print "unique $choice\n" if $DEBUG;
  } elsif ((uniq map{ scalar basename $_ } @files) == 1) { # all filenames match
    $choice = $files[0];
    print "match $choice of ", join(" ", @files), "\n"if $DEBUG;
  } else { # different filenames
    # sort these with the assumption that the shortest will
    # not have any of the " (1)", " (2)" suffixes.
    my @sorted = sort { length $a <=> length $b } @files;
    $choice = $sorted[0];
    print "sort $choice of ", join(" ", @files), "\n"if $DEBUG;
  }

  # hardlink original image
  my $filename = $OUTDIR . '/' . basename $choice;
  link $choice, $filename;

  # sidecar metadata file (required)
  (my $xmp = $choice) =~ s/\.\S+$/.xmp/;
  my $xmpfile = $OUTDIR . '/' . basename $xmp;
  die "missing $xmp" unless -r $xmp;
  link $xmp, $xmpfile;

  # sidecar modifications file (if exists)
  (my $aae = $choice) =~ s/\.\S+$/O.aae/;
  my $aaefile = $OUTDIR . '/' . basename $aae;
  link $aae, $aaefile if -r $aae;

}
