use strict;
my $input = shift;
my $out = $input;
$out .= ".padjust.csv";

my $rscript = "dat<-read.csv(\"$input\",header=F)
pover<- as.vector(dat\$V3)
pund<-as.vector(dat\$V2)
ajund<-p.adjust(pund)
ajover<-p.adjust(pover)
for (i in 1:nrow(dat)) {
cat (paste(dat[i,1],dat[i,2],dat[i,3],ajund[i],ajover[i],dat[i,4],dat[i,5],dat[i,6],dat[i,7],dat[i,8],sep=\",\"),file=\"$out\",append=T,fill=T)
}
";


my $Rscript = $input."padjust.R";
open R, ">$Rscript";

print R "$rscript";

system ("Rscript $Rscript");


