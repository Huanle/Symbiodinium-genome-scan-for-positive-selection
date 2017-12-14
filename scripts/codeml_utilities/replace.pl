use strict;

open A, $ARGV[0] or die;

my %pfam=();
while (<A>) {
	chomp;
	s/\///g;
	my @a = split /\s+/,$_,2;
	$pfam{$a[0]} .=$a[1]."\t";
}

close A;

open B, $ARGV[1];

while (<B>) {
	chomp;
	my @a = split /\s+/,$_;
	print $a[0],"\t";
	shift @a;
	for my $i (@a) {
	print $pfam{$i},"\t";
	}
	print "\n";
}
close B;


