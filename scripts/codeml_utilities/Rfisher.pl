use strict;

my $input = shift ; # 
my $output = $input;
$output =~ s/4.Rfisher//;
$output .= "fisher.csv";
my $exe = $input.".R";
open OUT,">$exe" or die "can not open $exe\n";

print OUT "
dat<-read.table(\"$input\",sep=\"\\t\",header=T)
for (i in 1:nrow(dat)) {
p1<- fisher.test( matrix (c (dat[i,2],dat[i,3],dat[i,4],dat[i,5]),2,2),alternative='less')\$p.value;
p2<- fisher.test( matrix (c (dat[i,2],dat[i,3],dat[i,4],dat[i,5]),2,2),alternative='greater')\$p.value;
cat (paste(dat[i,1],p1,p2,dat[i,2],dat[i,3],dat[i,4],dat[i,5],dat[i,6],sep=\",\"),file=\"$output\",append=T,fill=T)
}
";

close OUT;
system ("Rscript $input.R");

