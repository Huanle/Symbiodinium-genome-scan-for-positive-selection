use strict;

my $paml = shift;
my $tree = shift;
my $prefix = $paml;
my $str = 'paml';
$prefix =~ s/$str//;

my $m2 = " 
 seqfile = $paml * sequence data filename
 treefile = $tree * tree structure file name
 outfile = $prefix.mlc-M2-BS * main result file name
 runmode = 0 * 0: user tree; 1: semi-automatic; 2: automatic * 3: StepwiseAddition; (4,5):PerturbationNNI; ...
 seqtype = 1 * 1:codons; 2:AAs; 3:codons-->AAs
 CodonFreq = 2 * 0:1/61 each, 1:F1X4, 2:F3X4, 3:codon table
 ndata = 1 * number of gene alignments to be analysed
 clock = 0 * 0:no clock, 1:clock; 2:local clock
 model = 2 * models for codons: 0:one, 1:b, 2:2 or more dN/dS  * ratios for branches
 NSsites = 0 * 0:one w;1:neutral;2:selection; * 3:discrete;4:freqs; * 5:gamma;6:2gamma;7:beta;8:beta&w;9:beta&gamma;
 icode = 0 * 0:universal code; 1:mammalian mt; 2-10:see below
 fix_omega = 0 * 1: omega or omega_1 fixed, 0: estimate
 omega = 1 * initial or fixed omega for codons
 cleandata = 1 * remove sites with ambiguity data (1:yes, 0:no)?
 " ;

my $ctl = $prefix."m2.ctl";
open O1,">$ctl";
print O1 $m2;
close O1;


my $m1 = "
seqfile = $paml * sequence data filename
treefile = $tree * tree structure file name
outfile = $prefix.mlc-M0-BS * main result file name
runmode = 0 * 0: user tree; 1: semi-automatic; 2: automatic
* 3: StepwiseAddition; (4,5):PerturbationNNI; ...
seqtype = 1 * 1:codons; 2:AAs; 3:codons-->AAs
CodonFreq = 2 * 0:1/61 each, 1:F1X4, 2:F3X4, 3:codon table
ndata = 1 * number of gene alignments to be analysed
clock = 0 * 0:no clock, 1:clock; 2:local clock
model = 0 * models for codons: 0:one, 1:b, 2:2 or more dN/dS
* ratios for branches
NSsites = 0 * 0:one w;1:neutral;2:selection;
* 3:discrete;4:freqs;
* 5:gamma;6:2gamma;7:beta;8:beta&w;9:beta&gamma;
icode = 0 * 0:universal code; 1:mammalian mt; 2-10:see below
fix_omega = 0 * 1: omega or omega_1 fixed, 0: estimate
omega = 1 * initial or fixed omega for codons
cleandata = 1 * remove sites with ambiguity data (1:yes, 0:no)?
"
;

$ctl = $prefix."m0.ctl";

open OUT,">$ctl";
print OUT "$m1";


 
