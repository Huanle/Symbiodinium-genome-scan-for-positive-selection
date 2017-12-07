# Symbiodinium-genome-scan-for-positive-selection
scripts, commands used for positive selection analysis of Symbiodinium genomes and dinoflagellate transcriptomes.
Analyses results have been published: https://www.biorxiv.org/content/early/2017/10/05/198762; DOI:10.1101/198762 

# Roadmap of the analysis
Refer to Supplementary Figure 6 of the paper. 

# Commands

1. prepare fasta sequences of amino acids and CDS (coding) sequences 
this is to format sequence IDs in the '>Species_ID|sequence_ID' style. This can be done using 'orthomclAdjustFasta' - an Orthomcl (v2+) utility or simply with unix sed command.

      sed 's/>/>Species_ID|/' aa.fasta > aa.faa  
      sed 's/>/>Species_ID|/' cds.fasta > cds.fna 
      you can do some filtering using orthomcl utility orthomclFilterFasta if you wish.

2. put all sequence files (each stands for one species) in a folder
1) mkdir 15_species 

2) orthofinder -f 15_species/ 
orthofinder allows you to stop analyses at certain step(s). This is useful. For instance, when you want speed up reciprocal blast. 
you can try commands such as " orthofinder -f 15_species/ -op ". This command will prepare everything including the structured directories and the commands needed for all-vs-all blastp. You can then run these commands on your cluster in your favorite way (job arrays for example). Other designated stops, such as stop after detection of orthologs or stop after tree inference enable saving time and customized analyses.
i am running version 1.4, the latest version seems to be more versatile. So you are encouraged to exploit it.

3)  awk '{print $2}' SpeciesIDs.txt|cut -d '.' -f1 > sp_id  # this gives you all species IDs of your own choice in one file.

4)  perl metrics.orthgrp.pl sp_id Orthogroups.txt S[ABCF]\d*\|  > stat.otgp.txt # this generates basic metrics such as no. of genes, no. of genes from species of interest from each ortho-Group. the latest version of orthofinder produce this file automatically. so you can skip this if you are using the new program. Orthogroups.txt is the output from orthofinder. S[ABCF]\d*\| is a regular expression used to scan all genes from all species of interest. 

5) bsaed on the above file, youc an easily select, say, symbiodinium specific genes
awk '$1 == $5' stat.otgp.txt| cut -d ' ' -f9- | sed 's/://' > sym_specific.ogrp.txt 

6)  generate single copy orthogoups 
awk '$1>3 &&  $3 == $1 && $5>0' stat.otgp.txt | cut -d ' ' -f9- |sed 's/://' > Single_Copy.txt

7)  and paralogous ortho-groups
awk '$1>3 &&  $3 == $1 && $5>0' stat.otgp.txt | cut -d ' ' -f9- |sed 's/://' > Single_Copy.txt

now let's use these single copy orthogroups to do selection analysis.
since we will to do branch models test, that means we need a phylogeneic tree (ideally species tree) for each orthogoup. That is Y you see '$1>3' in step 6) becasue you need >=4 species to countruct a tree.
the species tree can be derived via many approaches. For now let's assume you already have a species tree for all species invovled in this analysis. 

8) generate proten/CDS sequences for each orthogroup;
perl print_orthogroups.pl Single_Copy.txt all.pep 30 pep  # pep: it is protein sequence; 30: protein sequence has >= 30 residues 
perl print_orthogroups.pl Single_Copy.txt all.pep 90 dna #  dna: input is CDS sequences; 90: dna sequences at least 90 bp long.
i found again the newest orthofinder can do this for you. so congrates as you don't need wrting your own scripts.

9)  it is always to check correspondence of your protein and dna sequences 
	 a simple example:
grep -c '>' Family.OG00*pep >P
grep -c '>' Family.OG00*dna > N
paste P N | sed 's/:/ /g' |awk '$2!=$4' |wc -l # allows you to find all orthogroups having different no. of dna and pep sequences due to whatever reasons. 
10) assuming some orthogroups have more PEP than CDS sequences. the command below will make them the same again
for i in *dna;do grep '>' $i |sed 's/>//' | perl select-seq.pl - ${i/dna/pep} 1 Y > ${i/dna/pep}.filt ;done
 
11)  it is very common that, your CDS and PEP sequences contain illegal letters which may cause errors during downstream analyses. You need to clean them up. E.G. many gene prediction programs produce sequences contain '*' and other illegal signs. to remove them: 
for i in OG00*pep.filt;do perl -ne 'if (/^>/) {print \$_;} else {s/\W+//g;print \$_,\"\\n\";}'  $i > $i.clean;done

12)  multiple sequence alignment
for i in OG00*pep;do echo linsi --localpair --maxiterate 1000 --anysymbol --thread 20 $i '>' $i.aln;done >aln.sh # then job array will help you speed it up.

13 )  trim alignments
for i in OG*aln;do trimal -in $i -out ${i/aln/trimal} -automated1 ;done
 watch out, after trimming, some alignemtns have <4 sequences/species and wont be used for further analysis

14)  you can used the trimmed alignment to infer species tree if you do not have one. but let's assume we already have one and stored in newick format in file "sp.tre".
for i in OG00*trimal;do grep '>' $i |cut -d '|' -f1 >$i.sp;done # get species in each orthogroups
for i in OG00*sp;do perl prune_and_print_unrooted.tre.pl $i sp.tre;done # prune species tree and give you correpondent topology of speceies from different orthogroups

 15)  CDS alignment based on PEP alignemnt. So far, we have been playing with PEP. But selection analysis needs aligned CDS as input. 
for i in OG00*trimal; do echo perl pal2nal.pl $i ${i/aln/dna} -output fasta > ${i/aln/pal2nal} ;done 

16)  it often surprises you that a few failures from last step can be caused by non-perfect matches between CDS-PEP sequences. I use macse to retranslate CDS sequences into proteins and repeat step 15). 
find . -name "*pal2nal" -size 0 | cut -d '/' -f2 |cut -d '.' -f1|awk '{print $0".dna"}' >2btrans
for i in `cat 2btrans ` ; do perl -e 'while (<>) {if (/>/){print $_;} else {chomp; s/[^AGCT]/-/g; print $_,"\n";}}' $i >$i.tmp; mv $i.tmp $i;done
for i  in *dna; do echo java -jar ~/h.liu/Bin/Selection/macse_v0.9b1.jar -i $i -o $i.macse;done 

17)  many selection tests can be done:
M2 vs M1: PS on sites (M2 prone to miss some sites) (Yang 2000)
M3 VS M0: test of variability among sites
bsA VS bsA1: PS on sites on specific branch (Zhang 2005)  and Several other tests.....
we are interested in bsA VS bsA1.
to do it, we need to mark the foregroud lineages in the tree.

there are also several available softwares to do this test.
here we rely on paml.
if you are a familiar with perl, some perl modules are available for you to do it quickly. http://bioperl.org/howtos/PAML_HOWTO.html if you are familiar with python. Congrates, it seems even easier: http://biopython.org/wiki/PAML

for  i in OG*sp;do perl -e '$f =shift; open A,$f; while (<A>) {chomp; push @a,$_ if /S[ABCF]\d*/;} @b = sort {$a cmp $b}@a; print  "$b[0]\,\,$b[-1]","\n"; ' $i > ${i/sp**/mark};done
for i in *pal2nal;do mk=`cat ${i}.mark`; echo "ete3 evol -t ${i}.tre --alg $i --mark $mk  --models bsA bsA1  --tests bsA,bsA1 -o ${i/pal**}bsAbsA1  -C 2 >${i/pal**}bsabsa1.log 2>${i/pal**}bsabsa1.err" ;done  > work.sh      
