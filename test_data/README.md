## Test/demo data

The test data included here can be automatically retrieved by the `run_tests.sh`
script included with all source or binary distributions of StringTie. The `run_tests.sh` 
script will also run StringTie on these data sets and compare the output with the 
precomputed, expected output for each case. If the output of each test matches the 
expected output, the test is considered successful (and "OK." will be shown on the next line), 
otherwise an error will be reported.

## Running these tests manually

Assuming these files are in a ./test_data/ sub-directory located in the same directory where the 
stringtie binary is located, (which would be the case if the `run_tests.sh` script had been run 
at least once), here are the command lines for each test:

###Test 1: Input consists of only alignments of short reads

    
../stringtie -o short_reads.out.gtf short_reads.bam
    

###Test 2: Input consists of alignments of short reads and superreads

    
../stringtie -o short_reads_and_superreads.out.gtf short_reads_and_superreads.bam
    

###Test 3: Input consists of alignments of long reads

    
../stringtie -L -o long_reads.out.gtf long_reads.bam
    
###Test 4: Input consists of alignments of long reads and reference annotation (guides)

    
../stringtie -L -G human-chr19_P.gff -o long_reads_guided.out.gtf long_reads.bam
    
