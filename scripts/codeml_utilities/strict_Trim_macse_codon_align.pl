use strict;

open A, $ARGV[0] or die "can not open macse_dna.fasta\n";

my %codon2aa = qw(
		TCA  S  TCC  S  TCG  S  TCT  S  TTC  F  TTT  F  TTA  L  TTG  L
		CTA  L  CTC  L  CTG  L  CTT  L  CCA  P  CCC  P  CCG  P  CCT  P
		CAC  H  CAT  H  CAA  Q  CAG  Q  CGA  R  CGC  R  CGG  R  CGT  R
		ATA  I  ATC  I  ATT  I  ATG  M  ACA  T  ACC  T  ACG  T  ACT  T
		AAC  N  AAT  N  AAA  K  AAG  K  AGC  S  AGT  S  AGA  R  AGG  R
		GTA  V  GTC  V  GTG  V  GTT  V  GCA  A  GCC  A  GCG  A  GCT  A
		GAC  D  GAT  D  GAA  E  GAG  E  GGA  G  GGC  G  GGG  G  GGT  G
		TAC  Y  TAT  Y  TGC  C  TGT  C  TGG  W
		);
my %stop = qw (TAA - TAG - TGA -);
my %tobedel = ();
my %aln = ();
local $/ = ">";
<A>;
while (<A>) {
	chomp;
	my @a = split /\n/,$_,2;
	my $id = (split /\s+/,$a[0])[0];
	my $seq = $a[1];
	$seq =~ s/\s+//g;
	$seq =~ s/\n//g;
	$seq = uc ($seq);
	$aln{$id}  = $seq; 
	my $pos=0;
	while ($seq =~ /(...)/g) {
		my $tmp = $pos;
		$pos += 3;
		my $end = $pos-1;
		if (exists  $codon2aa{$1} ) { #print "---"; 
			next;
		}
		else {	
			for my $i ($tmp..$end) {
				$tobedel{$i} = 1;  # remeber stopcodons and gaps from macse_dna_alignment;
			}
		}
	}
}
close A;

foreach my $m ( sort {$a cmp $b}  keys %aln) {
	print ">$m\n";
	my $seq = $aln{$m};
	my $pos = 0;
	while ($seq =~ /(.)/g) { print $1 unless exists $tobedel{$pos} ; $pos++;} 
	print "\n"; 
}  

