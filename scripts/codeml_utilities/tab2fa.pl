use strict;

open A, $ARGV[0]; 

my %seq = ();

while (<A>) {
my @a = split /\s+/,$_,2;
my @b = split /:/,$a[0];
$seq{$b[0]} .=$a[1];
}


foreach my$k (keys%seq) {
	print ">$k\n$seq{$k}\n";
}
close A;
exit (0);
