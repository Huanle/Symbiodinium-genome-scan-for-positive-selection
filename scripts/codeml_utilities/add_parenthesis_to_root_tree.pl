use warnings;
use strict;

open A, $ARGV[0] or die "can not open $ARGV[0]\n"; # newick tree 
my $tre = "";
while (<A>) {
	next if not /./;
	chomp;
	$tre .=$_;
}
$tre =~ s/\;$//;
print "\($tre\);";

