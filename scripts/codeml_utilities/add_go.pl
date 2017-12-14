use strict;
my $usage = "\n Example Usage: \n\n	 perl add_go.pl  Sym_species.OGs.pfam.HYP.csv ~/Group-Ragan/databases/GO_db/pfam2go.detail.txt ~/Group-Ragan/databases/PfamA/PfamDomain.ano > Sym_species.OGs.pfam.HYP.GO.csv \n\n";
die $usage if @ARGV!=3;
open A, $ARGV[0];
my $h = <A>;
my @tmp = split /,/,$h,2;
$h=$tmp[1];
print "DomainID,Domain-ano,GOID,GO_namespace,GO_term,$h" ;

my %mem = ();
my %dom = ();
while (<A>) {
	chomp;
	#print $_,"\n";
	my @a = split /,/,$_;
	$mem{$a[0]} = join ",",@a[1..$#a];
}
close A;

open B, $ARGV[1];
while (<B>) {
	chomp;
	s/;\s+/;/g;
	s/\s+;/;/g;
	s/,/-/g;
	my @a = split /\;/,$_;	
	$a[0] =~ s/\s+//g;
	if (exists $mem{$a[0]}) {
		s/;/,/g;
		print "$_,$mem{$a[0]}\n";
		delete $mem{$a[0]}; 
	} 
}	
close B;
open C, $ARGV[2]; 
while (<C>) {
chomp;
my @a = split /\s+/,$_,2;	
$dom{$a[0]} = $a[1];
}
foreach my$k (keys %mem) {
	my $ano = (exists $dom{$k})?$dom{$k}:"NA";
	print "$k,$ano,NA,NA,NA,$mem{$k}\n";
}
