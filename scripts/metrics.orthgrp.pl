use strict;
my $usage = <<_EUSAGE_;
	perl ~/Bin/inHouse/genefamilies_dup/metrics.orthgrp.pl  sp_id Orthogroups.txt regular_expression > stats.orthgrp
_EUSAGE_
;
print $usage if @ARGV != 3;

my %mem = ();

my $spid = shift;

open A,$spid;
my @species = ();
while (<A>) {
	chomp;
	$mem{$_} = 0;
	push @species, $_;
}
close A;

my $orthgrp = shift;

open B, $orthgrp;

my $reg = shift;

while (<B>){ 
	my @a = $_=~ /\s+(\w+\d*)\|/g;
	#my @sym = $_ =~ /\s+(S[ABCF[1]*)\|/g;
	my @sym = $_ =~ /\s+($reg)/g;
	my $gene_num = 0;
	my %taxa = ();
	my %symbio = ();
#	foreach my $s (@species) {$symbio{$s} = 0;}
	for my$i (@a) {
		 if (exists $mem{$i}) {$gene_num++; $taxa{$i}++; if ($i =~ /S[ABCF]\d*/) {$symbio{$i}++;}};
	} 
	my $num_taxa = keys %taxa;
	my $num_sym;
	$num_sym = keys %symbio ? keys%symbio:0;
#	print "$num_taxa\t$num_sym\n";

#	my %sym_sp = map {$_=>1}@sym; #keys %symbio;
#	my $num_sp = keys %sym_sp;
#	my $sym_genes = @sym ;
	my $sym_genes=0;
	foreach my $g (keys %symbio) { $sym_genes += $symbio{$g};}
	print "$num_taxa taxa $gene_num genes $num_sym Symbio_Species $sym_genes Sybio_genes $_";
#	print "$num_taxa taxa $gene_num genes $num_sp Symbio_Species $sym_genes Sybio_genes $_";
}	
close B;
