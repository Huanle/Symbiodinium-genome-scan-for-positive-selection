use strict;
die "USAGE:\n perl $0 treei\n" unless @ARGV;
open A, $ARGV[0]; # ./OG0002122_tree.txt
my @pos_sym = ();
my @pos_dino = ();
my $str_sym = "";
my $str_dino = "";
my ($sym_left,$sym_right,$dino_left,$dino_right) = (0,0);
my $tree = "";
while (<A>) {
	chomp;	
	$tree .="$_";
	my @feature = split /,/,$_;
	for my $i (0..$#feature) {
		my $j = $i+1;
		if ($feature[$i] =~ /S[ABF]\|/ or $feature[$i] =~ /SC1\|/ or $feature[$i] =~ /dino9/) { #change according to species symbols
			push @pos_sym,$j;
			my @b_left = $feature[$i] =~ /(\()/g;
			my @b_right= $feature[$i] =~ /(\))/g;
		 	$sym_left += @b_left;
			$sym_right += @b_right;	
			$str_sym .= $feature[$i].",";		
		} elsif ($feature[$i] =~ /dino\d+\|/) # subjected to change !!!
		{
			push @pos_dino,$j;
                        my @b_left = $feature[$i] =~ /(\()/g;
                        my @b_right= $feature[$i] =~ /(\))/g;
                        $dino_left += @b_left;
                        $dino_right += @b_right;
                        $str_dino .= $feature[$i].",";
		}	
	}
} 
open OUT, ">>qualified.tree.txt";
#open O2,">>y_they_are_qualitfied.txt";
open BAD,">>bad.txt";
my $distance_sym = @pos_sym;
my $distance_dino = @pos_dino;
if ($distance_sym != (abs ($pos_sym[0]-$pos_sym[-1]) +1)) { print BAD "$ARGV[0]\tsym not clustered in tree\n"; exit;}
# if ($distance_dino != (abs ($pos_dino[0]-$pos_dino[-1]) +1)) { print BAD "$ARGV[0]\tdino not clustered in tree\n"; exit;}
#### because pollarella is named as dino9 though it is clustered with sym A B C1 and F
# if (($str_sym =~ /^\({1,}S[ABCF]\d*\|/ && $str_sym =~ /\){1,}[,;]*$/ ) && ( $str_dino =~ /^\({1,}dino\d+\|/ && $str_dino =~ /\){1,}[,;]*$/) ) { 
if ( $str_sym =~ /^\({1,}S[ABCF]\d*\|/ && $str_sym =~ /\){1,}[,;]*$/  ) { 
	print OUT "$ARGV[0] good $str_sym ::=====:: $str_dino\n"; 
	#print O2 $ARGV[0],"\t\t",$str_sym,"\t\t$str_dino\n\nout of $tree\n";
} 
else {
	print BAD "$ARGV[0] bad $str_sym ::====:: $str_dino\n";
}


close OUT;
#close O2;
