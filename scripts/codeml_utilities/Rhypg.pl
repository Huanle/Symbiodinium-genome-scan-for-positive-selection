use strict;

my $input = shift ; # SA.loss.pfam.4.Rhypg 
my $output = $input;
$output =~ s/4.Rhypg//;
$output .= ".HYPG.csv";
my $exe = $input.".R";
open OUT,">$exe" or die "can not open $exe\n";

print OUT "
dat<-read.table(\"$input\",sep=\"\\t\",header=T)
for (i in 1:nrow(dat)) {
p1<- phyper(dat[i,2],dat[i,3],dat[i,4],dat[i,5],lower.tail=T)
p2<-phyper(dat[i,2]-1,dat[i,3],dat[i,4],dat[i,5],lower.tail=F)
cat (paste(dat[i,1],p1,p2,dat[i,2],dat[i,3],dat[i,4],dat[i,5],dat[i,6],sep=\",\"),file=\"$output\",append=T,fill=T)
}
";

close OUT;
system ("Rscript $input.R");

