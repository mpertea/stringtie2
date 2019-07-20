## Obtaining and installing StringTie

In order to build StringTie from this GitHub repository
the following steps can be taken:
 
```
git clone https://github.com/mpertea/stringtie2
cd stringtie2
make release
```

If the compilation is successful, the resulting `stringtie` binary can then be copied to 
a programs directory of choice.

Installation of StringTie this way should take less than a minute on a regular Linux or Apple MacOS 
desktop.

Note that simply running `make` will produce an executable which is more suitable for debugging 
and runtime checking but which can be significantly slower than the optimized version which 
is obtained by using `make release` as instructed above.

## Running StringTie

Run stringtie from the command line like this:
```
stringtie [options] <aligned_reads.bam>
```
The main input of the program is a SAMTools BAM file with RNA-Seq mappings
sorted by genomic location (for example the accepted_hits.bam file produced
by TopHat).

### Running StringTie on test data
After building the program with `make release` as instructed above, the current binary
can be tested on a small data set with a command like this:
```
make test
```
This will run the included `run_tests.sh` script which downloads a small test data set 
and runs a few simple tests to ensure that the program works as expected. 
The tests can also be run manually as shown below (after changing to the _test_data_ directory, `cd test_data`):

#### Run 1: Input consists of only alignments of short reads
```
stringtie -o short_reads.out.gtf short_reads.bam
```

#### Run 2: Input consists of alignments of short reads and superreads
```
stringtie -o short_reads_and_superreads.out.gtf short_reads_and_superreads.bam
```
    
#### Run 3: Input consists of alignments of long reads
```
stringtie -L -o long_reads.out.gtf long_reads.bam
```
    
#### Run 4: Input consists of alignments of long reads and reference annotation (guides)
```
stringtie -L -G human-chr19_P.gff -o long_reads_guided.out.gtf long_reads.bam
```

The above runs should take around one second each on a regular Linux or MacOS desktop. 
(see also <a href="https://github.com/mpertea/stringtie2/blob/master/test_data/README.md">test data</a> info).

### StringTie options

The following optional parameters can be specified (use -h/--help to get the
usage message):
```
 --version : print just the version at stdout and exit
 --conservative : conservative transcriptome assembly, same as -t -c 1.5 -f 0.05
 --rf assume stranded library fr-firststrand
 --fr assume stranded library fr-secondstrand
 -G reference annotation to use for guiding the assembly process (GTF/GFF3)
 -o output path/file name for the assembled transcripts GTF (default: stdout)
 -l name prefix for output transcripts (default: STRG)
 -f minimum isoform fraction (default: 0.01)
 -L use long reads settings (default:false)
 -m minimum assembled transcript length (default: 200)
 -a minimum anchor length for junctions (default: 10)
 -j minimum junction coverage (default: 1)
 -t disable trimming of predicted transcripts based on coverage
    (default: coverage trimming is enabled)
 -c minimum reads per bp coverage to consider for multi-exon transcript
    (default: 1)
 -s minimum reads per bp coverage to consider for single-exon transcript
    (default: 4.75)
 -v verbose (log bundle processing details)
 -g maximum gap allowed between read mappings (default: 50)
 -M fraction of bundle allowed to be covered by multi-hit reads (default:1)
 -p number of threads (CPUs) to use (default: 1)
 -A gene abundance estimation output file
 -B enable output of Ballgown table files which will be created in the
    same directory as the output GTF (requires -G, -o recommended)
 -b enable output of Ballgown table files but these files will be 
    created under the directory path given as <dir_path>
 -e only estimate the abundance of given reference transcripts (requires -G)
 -x do not assemble any transcripts on the given reference sequence(s)
 -u no multi-mapping correction (default: correction enabled)
 -h print this usage message and exit

Transcript merge usage mode: 
  stringtie --merge [Options] { gtf_list | strg1.gtf ...}
With this option StringTie will assemble transcripts from multiple
input files generating a unified non-redundant set of isoforms. In this mode
the following options are available:
  -G <guide_gff>   reference annotation to include in the merging (GTF/GFF3)
  -o <out_gtf>     output file name for the merged transcripts GTF
                    (default: stdout)
  -m <min_len>     minimum input transcript length to include in the merge
                    (default: 50)
  -c <min_cov>     minimum input transcript coverage to include in the merge
                    (default: 0)
  -F <min_fpkm>    minimum input transcript FPKM to include in the merge
                    (default: 1.0)
  -T <min_tpm>     minimum input transcript TPM to include in the merge
                    (default: 1.0)
  -f <min_iso>     minimum isoform fraction (default: 0.01)
  -g <gap_len>     gap between transcripts to merge together (default: 250)
  -i               keep merged transcripts with retained introns; by default
                   these are not kept unless there is strong evidence for them
  -l <label>       name prefix for output transcripts (default: MSTRG)
```

## Input files

StringTie takes as input a binary SAM (BAM) file sorted by reference position. 
This file contains spliced read alignments such as the ones produced by TopHat or HISAT2.
A text file in SAM format should be converted to BAM and sorted using the 
samtools program:
```
samtools view -Su alns.sam | samtools sort - alns.sorted
```
The file resulted from the above command (alns.sorted.bam) can be used 
directly as input to StringTie. 

Any SAM spliced read alignment (a read alignment across at least one junction)
needs to contain the XS tag to indicate the strand from which the RNA that produced
this read originated. TopHat alignments already include this tag, but if you use
a different read mapper you should check that this tag is also included for spliced alignment
records. For example HISAT2 should be run with the `--dta` option in order to tag spliced 
alignments this way. As explained above, the alignments in SAM format should be sorted and
preferrably converted to BAM.

Optionally, a reference annotation file in GTF/GFF3 format can be provided to StringTie 
using the `-G` option. In this case, StringTie will check to see if the reference transcripts 
are expressed in the RNA-Seq data, and for the ones that are expressed it will compute coverage
and FPKM values.
Note that the reference transcripts should be fully covered by reads in order to be included
in StringTie's output with the original ID of the reference transcript shown in the 
_`reference_id`_ GTF attribute in the output file . Other transcripts assembled from 
the input alignment data by StringTie and not present in the reference file will be 
printed as well ("novel" transcripts).

## Installation of the super-reads module (optional)

This optional module can be used to de-novo assemble, align and pre-process
RNA-Seq reads, preparing them to be used as "super-reads" by Stringtie.

Mode detailed information is provided in the SuperReads_RNA/README.md 
Quick installation instructions for this module (assuming the above Stringtie installation 
was completed):

```
 cd SuperReads_RNA
 ./install.sh
```

### Using super-reads with Stringtie

After running the super-reads module (see the SuperRead_RNA/README.md file for usage details), there 
is a BAM file which contains sorted alignment for both short reads and super-reads, called *`sr_merge.bam`*, 
created in the selected output directory. This file can be directly given as the main input file
to StringTie as described in the _Running Stringtie_ section above.


## License
StringTie is free, open source software released under an <a href="https://opensource.org/licenses/MIT">MIT License</a>.
