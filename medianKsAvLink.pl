#!/usr/bin/perl -w
use strict;

## notice: I borrowed the idea from http://biowiki.org/pub/Fall11/JacobVoganHomework9/tree.pl.txt 
## KS values were used to build tree. however, tree branch length was not used at all. median Ks values 
## were chosen to represent age of duplication events as described in Blanc and Wolfe, 2004

my $usage = "\nUSAGE:  perl $0 <ks_ka_tbl_file> <minimum Ks> <maximum Ks>  <column containing Ks> <yes/no to skip first row> \n\n"; ### 

die $usage if (@ARGV<5);

open INF,"$ARGV[0]" or die; ### filtered Ks output file

my $col = $ARGV[3] - 1; ### column that contains Ks values
# $ARGV[0] has the following format
# gene1	gene2	Ks	SE
# 2	1	0.8669	0.4487
# 3	1	1.1173	0.7794
# ....

<INF> if ($ARGV[4] =~ /yes/i);

my %dist; ## hash of hash -- distance matrix
my %ks; ### store pairwise ks values; will not be modified through the whole process.
my %H; ## tree height
my %cluster; ## store clusters 

while (<INF>) {
	chomp;
	my @a = split (/\s+/,$_) ;
	next if  ($a[$col] < $ARGV[1] or $a[$col] > $ARGV[2]);
	$dist{$a[0]}{$a[1]} = $a[$col]/1.0 ;
	$dist{$a[1]}{$a[0]} = $a[$col]/1.0 ;
	$ks{$a[0]}{$a[1]} = $a[$col]/1.0 ;
	$ks{$a[1]}{$a[0]} = $a[$col]/1.0 ;
	$H{$a[0]} = 0;  ## initialize tree height
	$H{$a[1]} = 0;  ## same as above
}

my $cnt = 0 ;
###############  similar to UPGMA loop and find the closet nodes
my ($node1,$node2);
my $num = keys%dist;

for (my $n=1; $n<$num; $n++) {
	my $min = 10000;
	foreach my $k1 (keys %dist) {
		MIN: foreach my$k2 (keys %dist) {
			if ($k1 eq $k2) {next MIN};
			if (not exists $dist{$k1}{$k2}) {next;}
			if (exists $dist{$k1}{$k2} && $dist{$k1}{$k2} < $min) {
				$min = $dist{$k1}{$k2};
				$node1 = $k1;
				$node2 = $k2;
			} 
		}
	}

	delete $dist{$node1};
	delete $dist{$node2};

	my $HK = 0.5 * ($H{$node1} + $H{$node2} + $min) ; #height for new node
	my $ka = $HK - $H{$node1} ; ## this is branch length
	my $kb = $HK - $H{$node2} ; ## same as above

	my $newNode = $node1."**".$node2; ## new node and will be print in newic format
	my ($ele1, $ele2) = ($node1,$node2);
	my @originalNodes1 = ();
	my @originalNodes2 = ();
	for (split(/\*/,$ele1)) {
		push @originalNodes1,$_ if /./;
	}

	for (split(/\*/,$ele2)) {
		 push @originalNodes2,$_ if /./;
        }


	my @originalKS = ();
	for my$i(0..$#originalNodes1) {
		for my$j(0..$#originalNodes2) {
			if (($originalNodes1[$i] ne $originalNodes2[$j]) and (exists $ks{$originalNodes1[$i]}{$originalNodes2[$j]})) {
				push @originalKS,$ks{$originalNodes1[$i]}{$originalNodes2[$j]};
			}
		}
	}
	my $medianKs = median (@originalKS);

	print "$node1**$node2\tmedian KS:\t$medianKs\n";
	$H{$newNode} = $HK; # height for new node

	foreach my $k3 (keys %dist) {
			if (exists $dist{$k3}{$node1} && exists $dist{$k3}{$node2}) {
				$dist{$k3}{$newNode} = 0.5 * ($dist{$k3}{$node1} + $dist{$k3}{$node2});
				$dist{$newNode}{$k3} = $dist{$k3}{$newNode};
			} elsif (exists $dist{$k3}{$node1} && ! exists  $dist{$k3}{$node2}) {
				#print STDERR "not exist $k3<-->$node2\n";
				$dist{$k3}{$newNode} = 1 * $dist{$k3}{$node1};
				$dist{$newNode}{$k3} = $dist{$k3}{$newNode};
			} elsif ( exists $dist{$k3}{$node2} && ! exists $dist{$k3}{$node1}) {
				#print STDERR "not exist $k3<-->$node1\n";
				$dist{$k3}{$newNode} = 1 *  $dist{$k3}{$node2};
				$dist{$newNode}{$k3} = $dist{$k3}{$newNode}; 
			} else {
				#print STDERR "not exists $k3<-->$node2   $k3<-->$node1\n";
				next;
			}

			delete $dist{$k3}{$node1};
			delete $dist{$k3}{$node2};
		
	} 
	
	
}

### end of UPGMA

sub median {
my @values = @_ ;
my $median;
my $mid = int @values/2;
my @sorted_values = sort {$a<=>$b} @values;
if (@values % 2) {
  	$median = $sorted_values[ $mid ];
} else {
   	$median = ($sorted_values[$mid-1] + $sorted_values[$mid])/2;
       } 
}
	

sub mean {
	my @values = @_;
	my $mean ;
	for my$m (@values) {
		$mean += $m;
	}
	return $mean/@values;
}


	

	
