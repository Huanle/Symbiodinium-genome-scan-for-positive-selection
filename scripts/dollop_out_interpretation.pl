# awk '/root/ && /yes/ {print NR}' outfile
# usage:  awk 'NR>=12676' outfile | perl -ne 'chomp;  if (/yes/||/no/) {$_ =~ s/^\s+//; print "\n", $_;} else {print $_;}'  | perl dollop_out_interpretation.pl  > Gain_Loss.txt

use strict;
while (<>) {
	next unless /\s+yes\s+/;
	chomp;
	my @a = split /\s+/,$_; 
	my $start = shift @a; 
	my $end=shift @a; 
	my $change=shift @a;
	my $character = join "",@a; 
	print "$start\t$end\t$change\t";
	#my @digits = split "",$character;
	my %dollo = ();
	my %cnt = ();
	my $l = length ($character);
	$character =~ s/\./!/g;
	for my $i (0..$l-1) {
		my $c = substr ($character,$i,1);
		if ($c -1 ==0 ) {
		#print "$i;";
		$dollo{'gain'} .= "orthoGrp".$i." ";
		$cnt{'gain'}++;
		} elsif ($c =~ /0/)  { 
		#print "$i;";
		$dollo{'loss'} .= "orthoGrp".$i." ";
		$cnt{'loss'}++;
		} else {next;} 
	} #print "\n"; 
	
	foreach my $k (sort keys %dollo) {
		print $k,"\t",$cnt{$k},"\t$dollo{$k};\t";
	}  

	print "\n";
 
}




