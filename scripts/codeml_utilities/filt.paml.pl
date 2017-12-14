use strict;
my $in = shift;

open A, $in;
my $inf = <A>;
close A;
my @a = split /\s+/,$inf;

if ($a[2] < 30) {
	my $rename = $in.".too.short";
	system ("mv $in $rename");
}
close A;	
