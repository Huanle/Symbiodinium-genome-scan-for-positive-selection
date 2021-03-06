use strict;
=pod
  my @str = qw(dia  red  TAH gre  cil4  cil2  cil1 cil3  perk api  dino6 dino7 dino3  dino4 dino2 dino8 dino5 dino11 SA SC1 SF SB dino9 dino10 ciliates_P_caudatum ciliates_P_tetraurelia ciliates_P_biaurelia ciliates_T_thermophila_SB210) ;
  my %pattern = ();

	for my$s (@str) {
	my $tmp = $s."_";
	$pattern{$tmp} =0;
} 
=cut


open SEQ,$ARGV[0];

open OUT,">$ARGV[0].rename";

my %taxa = ();
my %cnt = ();
while (<SEQ>) {
	chomp;
	if (/^>/) {
		my @a = split /\s+/,$_;
		my $id = $a[0];
		$id =~ s/>//;
		my $tax = (split /\|/,$id)[0];
	#	my $gene = (split /\|/,$id)[1];
		$id =~ s/\|/_/;
		$taxa{$id} = $tax.".".$cnt{$tax}++;
		print OUT ">$taxa{$id}";
	} else {s/[^AGCT]/-/gi; print OUT "$_";} print OUT "\n";
}

close OUT;
open A, $ARGV[1];

open OUT,">$ARGV[1].rename";
while (<A>) {
	chomp;
	s/:\d*\.*\d+//g;
	s/:NA//g;
	s/:-\d+//g;
=pod
	foreach my $k (keys %pattern) {
		s/\b$k\b//g;
	}

=cut
	s/\|/_/g;
	foreach my $l (keys %taxa)
	{
		$taxa{$l} =~ s/\|/\\\|/;
		 #print qq(s/$l/$taxa{$l}/) ,"\n";
		$_ =~ s/\b$l\b/$taxa{$l}/;
	}
	print OUT $_,"\n";
}
close A;
close OUT;
