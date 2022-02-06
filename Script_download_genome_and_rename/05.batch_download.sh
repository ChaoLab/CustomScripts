cat ncbi-genomes-2019-02-09_fa.list |while read line
do
i=$(echo $line | sed "s/\n//g")
wget "$i"
done

cat ncbi-genomes-2019-02-09_faa.list |while read line
do
i=$(echo $line | sed "s/\n//g")
wget "$i"
done


cat ncbi-genomes-2019-02-09_gb.list |while read line
do
i=$(echo $line | sed "s/\n//g")
wget "$i"
done
