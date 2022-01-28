#!/usr/bin/perl

use strict;
use warnings;

# Aim: Annotate protein sequences by nr database
# Usage: perl Annotate_protein_sequences_by_NCBI_nr_database.pl [input.faa] 
#        Note that the input faa file should be ended with ".faa"
#        The annotation result will be "input.nr_anno.txt"

# Note:
# 1. You will just use diamond in /slowdata/bin (diamond v0.9.14.115) instead of other diamond versions,
#    due to that nr database was made by this diamond


# Configurations:
my $nr_database_folder = "/slowdata/databases/NCBI_nr_diamond_Sep2021";
# In the nr database folder, these files should be present
# nr DIAMOND database: nr.dmnd
# nr header file: nr_header.txt (the nr_header.txt file can be parsed by provided script)

# Make tmp folder
`mkdir tmp`;

# Step 1 Run diamond 
my $input = $ARGV[0];
my $max_target_seq_num = 15; # The max target sequence number for diamond blastp result
my $threads = 10; # The number of cpus you use to run diamond
my $subject_cover = 50; # The minimum subject cover% to report an alignment

my ($input_name) = $input =~ /^(.+?)\.faa/;

`diamond blastp --db $nr_database_folder/nr --query $input --outfmt 6 --max-target-seqs $max_target_seq_num --out tmp/$input_name.diamond_result.txt --threads $threads --subject-cover $subject_cover -b 16 -c 1`;

# Step 2 Parse diamond result
`cut -f2 tmp/$input_name.diamond_result.txt | sort -u > tmp/$input_name.diamond_result.col2_unique`;
`grep -Ff tmp/$input_name.diamond_result.col2_unique $nr_database_folder/nr_header.txt | cut -f1 > tmp/$input_name.diamond_result.col2_unique.grep_nr_col1`;

# Step 3 Parse the annotation result
## Step 3.1 Store the %Acc2anno_tax
my %Acc2anno_tax = _get_unique_acc_hash("tmp/$input_name.diamond_result.col2_unique.grep_nr_col1");

## Step 3.2 Parse the blast result to get 15 annotations (or less) for each input protein 
my %All_hits = (); #$pro => [0] $acc, [1] $iden, [2] $e, [3] $bitscore
my $pro = ""; # the pro id of the top 1 hits
open IN, "tmp/$input_name.diamond_result.txt";
while (<IN>){
	chomp;
	my $acc = my $iden = my $e = my $bitscore = "";
	my @tmp = split (/\t/);
	$pro = $tmp[0];
	$acc = $tmp[1];
	$iden = $tmp[2];
	$e = $tmp[-2];
	$bitscore = $tmp[-1];
		
	my $blast_result = "$acc\t$iden\t$e\t$bitscore";
	if (!exists $All_hits{$pro}){
		$All_hits{$pro} = $blast_result;
	}else{
		$All_hits{$pro} .= ",".$blast_result;
	}
}
close IN;

## Step 3.3 Get no "hypothetical protein" top hit for each protein
my %All_top_hit = (); # $pro => [0] $acc [1] $anno [2] $tax [3] $hit_situation [4] $iden [5] $e [6] $bitscore
foreach my $pro (sort keys %All_hits){
	my @Hits = split (/\,/, $All_hits{$pro});
	my $acc_final = "";
	my $anno_final = "";
	my $tax_final = "";
	my $hit_situation_final = "";
	my $iden_final = "";
	my $e_final = "";
	my $bitscore_final = "";
	
	for(my $i=0; $i<=$#Hits; $i++){
		my $hit = $Hits[$i];
		my @Blast_result = split (/\t/,$hit);
		
		my $acc = $Blast_result[0];
		my $iden = $Blast_result[1];
		my $e = $Blast_result[2];
		my $bitscore = $Blast_result[3];
		
		my $anno = $Acc2anno_tax{$acc}[0];
		my $tax = $Acc2anno_tax{$acc}[1];
		
		if ($anno !~ /^hypothetical protein/){
			my $j = $i + 1; # Show the rank of this hit
			my $k = scalar @Hits; # Show the total number of hits
			$hit_situation_final = "Rank $j out of $k hits";
			$acc_final = $acc;
			$anno_final = $anno;
			$tax_final = $tax;
			$iden_final = $iden;
			$e_final = $e;
			$bitscore_final = $bitscore;
			last;
		}
	}
	
	# If after the whole loop all annotation are hypothetical protein
	if (!$hit_situation_final){
		my $k = scalar @Hits; # Show the total number of hits
		$hit_situation_final = "All $k hits show hypothetical protein";
		
		my $hit = $Hits[0];
		my @Blast_result = split (/\t/,$hit);
		my $acc = $Blast_result[0];
		my $iden = $Blast_result[1];
		my $e = $Blast_result[2];
		my $bitscore = $Blast_result[3];
		
		my $anno = $Acc2anno_tax{$acc}[0];
		my $tax = $Acc2anno_tax{$acc}[1];
			
		$acc_final = $acc;
		$anno_final = $anno;
		$tax_final = $tax;
		$iden_final = $iden;
		$e_final = $e;
		$bitscore_final = $bitscore;
	}
	
	$All_top_hit{$pro}[0] = $acc_final;
	$All_top_hit{$pro}[1] = $anno_final;
	$All_top_hit{$pro}[2] = $tax_final;
	$All_top_hit{$pro}[3] = $hit_situation_final;
	$All_top_hit{$pro}[4] = $iden_final;
	$All_top_hit{$pro}[5] = $e_final;
	$All_top_hit{$pro}[6] = $bitscore_final;
}

## Step 3.4 Write down result
open OUT, ">$input_name.nr_anno.txt";
print OUT "query\taccession\tproduct\ttaxonomy\thit situation\tidentity\tevalue\tbitscore\n";
foreach my $pro (sort keys %All_top_hit){
	my $acc = $All_top_hit{$pro}[0];
	my $anno = $All_top_hit{$pro}[1];
	my $tax = $All_top_hit{$pro}[2];
	my $hit_situation = $All_top_hit{$pro}[3];
	my $iden = $All_top_hit{$pro}[4];
	my $e = $All_top_hit{$pro}[5];
	my $bitscore = $All_top_hit{$pro}[6];
	print OUT "$pro\t$acc\t$anno\t$tax\t$hit_situation\t$iden\t$e\t$bitscore\n";
}
close OUT;

`rm -r tmp`;

# Subroutine
# Get the hash of accession to annotation and taxonomy information
sub _get_unique_acc_hash{
	my $input = $_[0]; # Get the input
	my %Acc2anno_tax_inside = (); # $acc => [0] $anno [1] $tax
	open IN_, "$input";
	while(<IN_>){
		chomp;
		my $line = $_;
		my $acc = my $anno = my $tax = "";
		if($line =~ /MULTISPECIES\:/){
			($acc,$anno,$tax) = $line =~ /^>(.+?)\sMULTISPECIES\:\s(.+?)\s\[(.+)\]$/;  
		}elsif($line =~ /RecName/){
			$tax = "Unknown";
			if ($line !~ /\;/){
				($acc,$anno) = $line =~ /^>(.+?)\sRecName\:\sFull\=(.+)$/; 
			}else{
				($acc,$anno) = $line =~ /^>(.+?)\sRecName\:\sFull\=(.+?)\;/; 
			}
		}elsif($line =~ / Chain /){
			$tax = "Unknown";
			($acc,$anno) = $line =~ /^>(.+?)\s(Chain.+?)$/;
		}elsif($line =~ /\|\|/){
			$tax = "Unknown";
			($acc,$anno) = $line =~ /^>(.+?)\s(.+)$/;  
		}elsif($line =~ /^>\S+?\s\[[^\[]+?\]$/){ # For matching line like ">XP_002257793.1 [Plasmodium knowlesi strain H]"
			($acc,$tax) = $line =~ /^>(.+?)\s\[(.+)\]$/; $anno = "hypothetical protein";
		}elsif($line =~ /^>\S+?\s[^\[]+?$/){ # For matching line like ">WP_066353836.1 unnamed protein product"
			$tax = "Unknown";
			($acc,$anno) = $line =~ /^>(.+?)\s(.+?)$/;
		}else{
			($acc,$anno,$tax) = $line =~ /^>(.+?)\s(.+?)\s\[(.+)\]$/;
		}
		$Acc2anno_tax_inside{$acc}[0] = $anno; $Acc2anno_tax_inside{$acc}[1]  = $tax;
	}
	close IN_;
	
	return %Acc2anno_tax_inside;
}
