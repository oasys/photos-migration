#!/usr/bin/perl

use strict;
use File::Basename;
my $INDIR='./compare-out';
my $OUTDIR='./to-be-transcoded';
my $DEBUG=0;

die "$OUTDIR already exists, exiting" if -e $OUTDIR;
mkdir "$OUTDIR";

while(<>) {
  chomp;
  warn "cannot read '$_': $!\n" unless -r "$INDIR/$_";

  my $filename = $OUTDIR . '/' . basename $_;
  link "$INDIR/$_", $filename;

  (my $xmp = $_) =~ s/\.\S+$/.xmp/;
  my $xmpfile = $OUTDIR . '/' . basename $xmp;
  die "missing $xmp" unless -r "$INDIR/$xmp";
  link "$INDIR/$xmp", $xmpfile;

  (my $aae = $_) =~ s/\.\S+$/.aae/;
  my $aaefile = $OUTDIR . '/' . basename $aae;
  link "$INDIR/$aae", $aaefile if -r "$INDIR/$aae";

}
