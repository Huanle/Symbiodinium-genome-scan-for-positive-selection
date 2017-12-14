#!/usr/bin/perl -w

use strict;

my $paml = $ARGV[0];
die "USAGE: perl $0 <paml file>\n" if (@ARGV<1);

my $tmp= $paml;
$tmp =~ s/paml//g;

my $ctl = $paml."codemel.ctl";

my $out = $tmp."codeml.out";

open CTL,">$ctl";

print CTL "seqfile = $paml * sequence data file name
      outfile = $out           * main result file
	noisy = 3   * 0,1,2,3,9: how much rubbish on the screen
      verbose = 1   * 1: detailed output, 0: concise output
      runmode = -2   * 0: user tree;  1: semi-automatic;  2: automatic
                    * 3: StepwiseAddition; (4,5):PerturbationNNI 

      seqtype = 1   * 1:codons; 2:AAs; 3:codons-->AAs
    CodonFreq = 2   * 0:1/61 each, 1:F1X4, 2:F3X4, 3:codon table
        clock = 0   * 0: no clock, unrooted tree, 1: clock, rooted tree
        model = 0
                    * models for codons:
                        * 0:one, 1:b, 2:2 or more dN/dS ratios for branches

      NSsites = 0   * dN/dS among sites. 0:no variation, 1:neutral, 2:positive
        icode = 0   * 0:standard genetic code; 1:mammalian mt; 2-10:see below

    fix_kappa = 0   * 1: kappa fixed, 0: kappa to be estimated
        kappa = 2   * initial or fixed kappa
    fix_omega = 0   * 1: omega or omega_1 fixed, 0: estimate 
        omega = 1   * initial or fixed omega, for codons or codon-transltd AAs

    fix_alpha = 1   * 0: estimate gamma shape parameter; 1: fix it at alpha
        alpha = .0  * initial or fixed alpha, 0:infinity (constant rate)
       Malpha = 0   * different alphas for genes
        ncatG = 4   * # of categories in the dG or AdG models of rates

        getSE = 1   * 0: don't want them, 1: want S.E.s of estimates
 RateAncestor = 1   * (1/0): rates (alpha>0) or ancestral states (alpha=0)

  fix_blength = 1  * 0: ignore, -1: random, 1: initial, 2: fixed
       method = 0   * 0: simultaneous; 1: one branch at a time

";


=pod
`codeml $ctl`;
`rm $ctl`;
`mv 4fold.nuc $tmp.4fold.nuc`; ## some times 4DTv is prefered over Ks 

open RUB, "rub" or die "can not open rub\n";

my %ID;

while (<RUB>) {
	next if /^$/;
	chomp;
	my @a = split (/\s+/,$_);
	$a[1] =~ s/\(||\)//g;
	$a[4] =~ s/\(||\)//g;
	$ID{$a[0]} = $a[1];
	$ID{$a[3]} = $a[4];
}

close RUB;
=cut
=pod
open RST, "rst" or die "can not open rst file\n";
open GYOUT,">$tmp.GoldmanYang1994.dNdS.txt" or die "can not open $tmp.GoldmanYang1994.dNdS.txt";
print GYOUT "seq\tseq\tdS\tdN\tdN/dS\n";
while (<RST>) {
	chomp;
	if (/^\s+/) {
		$_=~ s/^\s+//;
		my @a = split (/\s+/,$_);
		print GYOUT $ID{$a[0]},"\t",$ID{$a[1]},"\t",$a[5],"\t",$a[4],"\t",$a[6],"\n";
	}
}
close GYOUT;
=cut


