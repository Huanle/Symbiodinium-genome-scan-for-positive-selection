use strict;
use warnings;
die "\n 	Usage: \n 	perl $0 <iqtree log file> <number of cpus>\n\n" if @ARGV<2;
open A, $ARGV[0]; 
my $aln = $ARGV[0];
$aln =~ s/\.log//;
while (<A>) {
	next unless /^Best-fit/;
	my $m = (split /\s+/,$_)[2];
	print "iqtree-omp -s $aln -m $m -bb 2000 -nt $ARGV[1]  -redo\n";
	last;
}
close A;


