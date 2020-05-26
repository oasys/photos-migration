# Scripts to aid macOS photos migration

## Export

If these are in separate photo libraries, first export all files
to a directory for each library (`dir1`, `dir2`, etc.).  Make
sure to check the "generate `.xmp` sidecar option" in order to
also export metadata.

## getsums.pl

Calculate hashes for all the files to be merged.

    getsums.pl dir1 dir2 [...] > sums

## compare.pl

Merge multiple directories of files into a single output directory
based on the hash.  It will create hard links in the output directory
to preserve disk space.

    cat sums | compare.pl

## Import

From photos, File > Import, and select the `compare-out` directory.

Import all photos, and check the final count of images/videos.

## Transcode

If not all the files import, it is possible that some
of them may have failed due to [incompatible media
types](https://support.apple.com/en-us/HT209029).  These will need to be
transcoded to a supported file type.

### getlist.pl

Parses the system log for failed imports and outputs the list of files.

    getlist.pl > files

### transcode.sh

Transcodes videos to HEVC/h.265 format.

    cd compare-out ; ls -1 | tr '\n' '\0' | xargs -0 -n1 ../transcode.sh

### Re-import

Attempt to re-import the transcoded files.

## Clean up
