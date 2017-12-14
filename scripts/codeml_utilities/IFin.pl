#!/usr/bin/env perl -w
use warnings;
use strict;
my %len = ();
open A, $ARGV[0];

while (<A>) {
	chomp;
	my @a = split /\s+/,$_;
	$len{$a[0]} = 0; #$a[1];
}
close A;

open B, $ARGV[1];
while (<B>) {
	chomp;
	my @a = split /\s+/,$_;
#	print $a[0],"\t";
#	for my $i (1..$#a) {
	print $_,"\n" if exists $len{$a[0]};
#	} print "\n";
}
close B;



