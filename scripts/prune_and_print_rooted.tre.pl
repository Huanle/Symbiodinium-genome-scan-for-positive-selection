use strict;

my$paml=shift;
my$super_tree =shift;

open A,$paml or die "can not open $paml \n";  # adapt script to work on fasta format 

my $prefix = $paml;
# $prefix =~ s/\.paml//;
my @tmp = split /\./, $paml;
$prefix = $tmp[0].".$tmp[1]";


my $species = "$prefix.species.txt";
my $pruneTree = $prefix.".tre";
open O, ">$species" or die "can not open $species file\n"; 
while (<A>) {
	if (/^>/) {s/>//;my @a = split /\s+/,$_; print O $a[0],"\n";} # if /^>]/;
}
close O;

my $rcmd = <<"RCMD";
library ("ape") 
intre<-read.tree ("$super_tree")
species<-read.table("$species",header=F)
inlabl<-as.vector (species\$V1)
# pruned.tre<-drop.tip (intre, intre\$tip.label[-match(as.vector(inlabl), intre\$tip.label)])
pruned.tre <-drop.tip (intre, setdiff(intre\$tip.label,inlabl))
write.tree (pruned.tre,file="$pruneTree")
dev.off ()
RCMD
;

my $rscript = $prefix.".R";
open S,">$rscript";
print S "$rcmd";

my $cmd = "R --vanilla -q < $rscript";

system ("$cmd");
system ("rm $rscript");# $species");
