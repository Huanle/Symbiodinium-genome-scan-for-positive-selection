use warnings;
use strict;
my $tre = shift;
my $outgroup = shift;
my $tmp = (split /\./,$tre)[0];
my $out = $tmp.".$outgroup.root.tre";

my $rcmd = <<"RCMD";
library ("ape")
intre<-read.tree ("$tre")
roottree <- root (intre, outgroup="$outgroup",resolve.root=T)
write.tree(file="$out",roottree)
RCMD
 ;

my $rscript = $tmp.".R";
open S,">$rscript";
print S "$rcmd";

my $cmd = "R --vanilla -q < $rscript";

system ("$cmd");

