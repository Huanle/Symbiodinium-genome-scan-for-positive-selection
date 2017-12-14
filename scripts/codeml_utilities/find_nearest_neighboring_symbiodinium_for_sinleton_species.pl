use strict;
# sed 's/,/\n/g'  ./OG0002122_tree.txt| perl -ne 'print $.." ".$_ if /S[ABF]\||SC1\|/;'
#
=pod
perl $0 OG*_tree.txt 
Only applied for more than 1 focal species !!!!

=cut
#
open A, $ARGV[0]; # ./OG0002122_tree.txt
my @pos = ();
my $str = "";
my ($left,$right) = (0,0);
my $tree = "";
while (<A>) {
	chomp;	
	$tree .="$_";
	my @feature = split /,/,$_;
#	print $feature[0],"\t",$feature[-1],"\n";
	for my $i (0..$#feature) {
		my $j = $i+1;
		if ($feature[$i] =~ /S[ABF]\|/ or $feature[$i] =~ /SC1\|/) {
			push @pos,$j;
			my @b_left = $feature[$i] =~ /(\()/g;
			my @b_right= $feature[$i] =~ /(\))/g;
		 	$left += @b_left;
			$right += @b_right;	
			$str .= $feature[$i].",";		
		}	
	}
} 
#print $pos[0],"\t",$pos[-1],"\n";
my $tmp = @pos;
#print "$tmp symbiodiniums\n";
#print "from $pos[0] to $pos[-1]\n";
exit if $tmp != (abs ($pos[0]-$pos[-1]) +1);



open OUT,">>qualified.tree.txt";
open O2,">>y_they_are_qualitfied.txt";
if ($left== $right) { print OUT "$ARGV[0] good $str\n"; print O2 $ARGV[0],"\t\t",$str,"\n\nout of $tree\n";} 
else {print OUT "$ARGV[0] bad $str\n";}

close OUT;
close O2;
