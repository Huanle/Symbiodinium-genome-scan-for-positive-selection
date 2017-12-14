#!/usr/bin/perl -w
use strict;


my $usage = "\n\tUSGAE: perl thisScript fileContainSeqnamesInColumns FastaInput ColumnNumber Y/N \n
        Y: to extract seq in that column
        N: to extract seq other than those in that column
\n";
die $usage if @ARGV<4 ;
open A, "$ARGV[0]" or die "can not open first input file\n";
my $n = $ARGV[2] -1 ;
my %seq;
my $if = $ARGV[3];

while (<A>){
        next if /^$/;
        chomp; 
        my @a = split (/\s+/,$_);
        $seq{$a[$n]} = 1;
}

close A;


local $/ = ">";

open B, "$ARGV[1]" or die "can not open seq file\n";

my %mem=(); # record if printed to avoid duplication

<B>;

while (<B>){
        chomp;
        my @b = split (/\n/,$_,2);
        my $id = (split (/\s+/,$b[0]))[0];
        $b[0] =~ s/>//; 
        if ($if =~ /y/i) {
                $mem{$id}++;
                print ">$b[0]\n$b[1]\n" if ((exists $seq{$id}) && ($mem{$id}<2));
                delete $seq{$id};
        } elsif ($if =~ /N/) {
                $mem{$id}++;
                print  ">$b[0]\n$b[1]\n" unless  (exists $seq{$id} && ($mem{$id} < 2)) ;
                delete $seq{$id};
        }
}

close B;
