#1.  MSA of pep seqeunces
linsi --localpair --maxiterate 1000 --anysymbol single_copy_ortholog.pep > single_copy_ortholog.pep.aln

#2. generate cds alignemnt based on pep alignment
pal2nal.pl -output paml  single_copy_ortholog.pep.aln single_copy_ortholog.cds > single_copy_ortholog.pal2nal

# rename the seqeunce IDs to the same as the ones included in species tree
perl -ne 'if (/^>/) {s/\|\S+//g; print $_,"\n";}else{print $_;}'  single_copy_ortholog.pal2nal > single_copy_ortholog.pal2nal.rename

#3. prune species tree according to species included in the alignment
prune_and_print_unrooted.tre.pl  single_copy_ortholog.pal2nal species.tre

#4 determine marks on the tree
perl mark.foreground.pl single_copy_ortholog.pal2nal.tre S[ABCF]\d* > single_copy_ortholog.mark

#5 run codeml 
ete3 evol -t single_copy_ortholog.pal2nal.tre  --alg single_copy_ortholog.pal2nal --codeml_param omega,1 --models bsA bsA  --tests bsA,bsA1 --mark SA,,SC1 -o single_copy_ortholog.bsAbsA1 --cpu 2  

