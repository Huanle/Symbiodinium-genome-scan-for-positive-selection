use strict;
my $usage = "\n Example Usage: \n\n	 perl add_go.pl  Sym_species.OGs.pfam.HYP.csv ~/Group-Ragan/databases/GO_db/pfam2go.detail.txt ~/Group-Ragan/databases/PfamA/PfamDomain.ano > Sym_species.OGs.pfam.HYP.GO.csv \n\n";
# die $usage if @ARGV!=3;
open A, $ARGV[0];
my $h = <A>;
my @tmp = split /,/,$h,2;
$h=$tmp[1];
print "TCDBID,tcdb-ano,$h" ;
# SA|Smic31989    gnl|TC-DB|P62158|8.A.82.1.1      the calmodulin calcium binding protein (calmodulin) family.
#
my %mem = ();
while (<A>) {
	chomp;
	my @a = split /,/,$_;
	$mem{$a[0]} = join ",",@a[1..$#a];
}
close A;

open B, $ARGV[1];
while (<B>) {
	chomp;
	my @a = split /\t/,$_;	
	my @tmp = (split /\|/,$a[1]); 
	my $id = $tmp[-1];
	$id =~ s/\.\d+$//;
	$id =~ s/\s+//g;
	my $ano = join " ",@a[2..$#a];
	$ano =~ s/,/;/g;
	if (exists $mem{$id}) {
		print "$id,$ano,$mem{$id}\n";
		delete $mem{$id}; 
	} 
}	
close B;

