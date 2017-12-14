use warnings;
use strict;

my $fasta_aln = shift; 

open A, "$fasta_aln" or die "can not open $fasta_aln\n";
my $num_seq = 0;
my $num_sym = 0;
while (<A>) {
	if (/^>/) {
		$num_seq ++;
		if (/^>SA|^>SB|^>SC1|^>SF/) {
			$num_sym++;
		}
	}
}
#if (-e "alignment_containing_only_syms.txt") { unlink "alignment_containing_only_syms.txt";}
#if (-e "alignment_containing_not_only_syms.txt") {unlink "alignment_containing_not_only_syms.txt";}

open O1,">>alignment_containing_only_syms.txt" or die "can not open alignment_containing_only_syms.txt\n";
open O2,">>alignment_containing_not_only_syms.txt" or die "can not open alignment_containing_not_only_syms.txt\n";
if ($num_seq == $num_sym) {
	print O1 $fasta_aln,"\t","all syms\t$num_sym seqeunces\n";
}
 elsif ($num_sym>0 && $num_sym != $num_seq) {
	print O2 "$fasta_aln\tnot only syms\t$num_sym syms out of $num_seq sequences\n";
}

close O1;
close O2;
close A;

