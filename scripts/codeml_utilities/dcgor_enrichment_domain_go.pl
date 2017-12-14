use strict;
my $usage = "perl $0 backgroun_ano interest_ano <InterPro/Pfam>\n";
# example perl ~/Bin/inHouse/codeml_util/enrichment_pfam.pl all.genes.pfam.txt Symbio.Specific.Genes.ipr.txt Pfam 2>err  
die "\n$usage\n" if @ARGV!=3;
my $background = shift;
my $interest = shift;
my $type = shift ;
my $prefix = $interest;
$prefix =~ s/.txt$//;
my $r = qq 
(
library ("dcGOR")
input <-read.table ("$interest",header=F)
data<- as.vector (input\$V2 )
input2 <-read.table ("$background",header=F)
background <- as.vector (input2\$V2)
eoutput <- dcEnrichment (data, background=background, domain="$type", ontology="GOMF")  ## change (Pfam) to (InterPro) based on annotation
write (eoutput, file="$prefix.$type.MF.txt",verbose=T)
eoutput <- dcEnrichment (data, background=background, domain="$type", ontology="GOBP")
write (eoutput, file="$prefix.$type.BP.txt",verbose=T)
eoutput <- dcEnrichment (data, background=background, domain="$type", ontology="GOCC")
write (eoutput, file="$prefix.$type.CC.txt",verbose=T)
);

open OUT, ">$prefix.$type.R";
print OUT "$r";
system ("Rscript $prefix.$type.R") ;
close OUT;
