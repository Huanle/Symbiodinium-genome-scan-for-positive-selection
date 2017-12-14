#!/usr/bin/perl  -w
use strict;
my $usage = "perl 	$0	 <mcl_dump_file>	<pep/CDS>		<mimimum_length(e.g., 300 for CDS; 100 for pep)> suffix\n";

die "$usage" if @ARGV<3;

open A, "$ARGV[0]" or die; ## dum file produced by mclblastline

open SIN,">singletons.txt" or die;

my $count = 0 ;

my %fam;

while (<A>) {
	my @genes = split /\s+/;
	if (@genes<5) {
	 	print SIN "@genes\n" if @genes < 2;
	#	next;
	}

	for (@genes[1..$#genes]) {
		$fam{$_} = $genes[0];
	}
}

close A;


my $reformated = &format_fasta($ARGV[1]);
open B,"$reformated";
#open B,"$ARGV[1]";
local $/ =">";
open LOG,">families.log" or die ;

<B>;

while (<B>) {
	chomp ;
	my @a = split (/\n/,$_,2);
	my $tmp = (split (/\s+/,$a[0]))[0];
	 $a[1] =~ s/\s//g;
	if (exists $fam{$tmp}) {
		open OUT,">>Family.$fam{$tmp}.$ARGV[-1]";
		print OUT ">$_\n" if (length ($a[1]) >= $ARGV[2]);
		print LOG "$fam{$tmp}\t$tmp\n";
	} 
}
close B;

##############################################################
###########	subrountines	##############################
##############################################################

sub format_fasta {
	my $f = shift;
	open FA,"$f" or die;
	my $out = $f."reformated.fas";
	open OUT ,">$out" or die ;
	while (<FA>) {
		if (/^>/) {
		s/>//g;
		print OUT ">$_";
		} else {
			print OUT "$_";
		}
	 }
	return $out;

} 
		

	
