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
my ($left,$right) = (0,0);
my $tree = "";
my @marks = ();

while (<A>) {
	chomp;	
	$tree .="$_";
	my @feature = split /,/,$_;
#	print $feature[0],"\t",$feature[-1],"\n";
	for my $i (0..$#feature) {
		my $j = $i+1;
                $feature[$i] =~ s/[\)\(;]//g;
		if ($feature[$i] =~ /^S[ABF]/ or $feature[$i] =~ /^SC1/) {
			$feature[$i] =~ s/;//;
			push @marks, $feature[$i];
		}	
	}
} 

if (@marks>1) {
print "$marks[0],,$marks[-1]\n";
}  else { print "$marks[0]\n";}  
