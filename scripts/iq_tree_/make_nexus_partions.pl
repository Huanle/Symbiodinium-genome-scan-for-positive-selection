use strict;

open A, $ARGV[0] or die "can not open $ARGV[0]\n";  # partitions.txt produced by AMAS

print "#nexus\nbegin sets;\n";

while (<A>) {
	chomp;
#	p1_OG0006659=1-284
	my ($p) = $_ =~ /p\d+(_OG\d+)=\d+\S+\d+/;
	$_ =~ s/$p/ /;
	$_ =~ s/=/= /;
	$_ =~ s/p/part/;
	print "\tcharset $_;\n";
}
close A;
print "\tcharpartition mine = ";
open B, $ARGV[1] or die "can not open $ARGV[1]\n";
while (<B>) {
	chomp;
	my @a = split /\s+/,$_;
	print "$a[1]:part$., ";
}
print ";\nend;\n";	
