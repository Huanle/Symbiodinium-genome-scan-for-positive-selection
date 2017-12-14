use strict;

open A,$ARGV[0];  # gain or lost domains 

my %pfam = ();
my %grp = ();

while (<A>) {
	chomp;
	my @a = split /\s+/,$_;
	for my$i (@a[1..$#a]) {
		$pfam{$i}++;
		$grp{$i} .= $a[0]." ";
	}
}
close A;

my $n = 0; # total domains in sample

for my $l (keys%pfam) {$n+=$pfam{$l};}

open B, $ARGV[1] or die "can not open $ARGV[1]\n";

my %bac_pfam = ();
while (<B>) {
	chomp;
	my @a = split /\s+/,$_;
	for my$i (@a[1..$#a]) {
		$bac_pfam{$i}++;	
	}
}

close B;

my $N=0; # total domains in population 
for my $j (keys %bac_pfam) { $N+=$bac_pfam{$j};}


my $prefix = (split /\./,$ARGV[0])[0];
#print "Pfam\tK\tk\tN\tn\tfam_in_foreground\n";
#print "Pfam\tp_under\tp_over\thitInSample\thitInpOp\tfailInpop\tsampleSize\tassociated_fams\n";
print "Pfam\thitInSample\thitInPop-hitInsample\tsampleSize-hitInSample\tfailInPop-sampleSize+hitInSample\tassociated_fams\n";
foreach my $k (keys %bac_pfam) {
	next unless exists $pfam{$k}; 
	my $hitInPop = $bac_pfam{$k};
	my $sampleSize = $n ;
	my $failInPop = $N - $hitInPop;

	print "$k\t$pfam{$k}\t";
	print $hitInPop-$pfam{$k}; print "\t";
	print $sampleSize-$pfam{$k}; print "\t";
	print $failInPop-$sampleSize+$pfam{$k};
	print "\t$grp{$k}\n";
#	print $k,"\t",$pfam{$k},"\t",$bac_pfam{$k},"\t",$N-$bac_pfam{$k}."\t".$n."\t".$grp{$k}."\n" ;
}


