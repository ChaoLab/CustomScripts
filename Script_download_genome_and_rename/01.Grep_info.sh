grep "Organism name:" *.txt | sed "s/_assembly_stats.txt:# Organism name:  /\t/g"  > Organism_name.txt
grep "Infraspecific name:" *.txt | sed "s/_assembly_stats.txt:# Infraspecific name:  strain=/\t/g" >Infraspecific_name.txt
grep "Isolate:" *.txt | sed "s/_assembly_stats.txt:# Isolate:  /\t/g" > Isolate.txt
grep "Taxid:" *.txt | sed "s/_assembly_stats.txt:# Taxid:          /\t/g" | cut -f 2 | sort -u > Taxid_NR.list
grep "Taxid:" *.txt | sed "s/_assembly_stats.txt:# Taxid:          /\t/g"  > Taxid.txt
