## Annotate a genome comprehensively using NCBI nr database

**Aim:** Annotate protein sequences by nr database. 

This script will give the best hit and annotation for each input protein sequence with the "hypothetical protein" filtered (If the hit with the best bitscore is annotated as "hypothetical protein", then it will find the next one. If all the top hits are annotated as "hypothetical protein", it will use the annotation in the end with a notice as "All 15 hits show hypothetical protein").

Generally, it will use 30 mins to annotate a microbial genome with pretty high annotation coverage.



**Usage:** 

perl Annotate_protein_sequences_by_NCBI_nr_database.pl [input.faa] 
Note that the input faa file should be ended with ".faa"
The annotation result will be "input.nr_anno.txt"



**Note:**

You will just use diamond in /slowdata/bin (diamond v0.9.14.115) instead of other diamond versions, due to that nr database was made by this diamond



[script] pre01.parse_nr_header_file.pl 

It is used for generating "nr_header.txt" in the nr database folder.