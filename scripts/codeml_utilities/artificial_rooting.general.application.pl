# examples of symbiodinium lineages needed to be rerooted

# $s = "(SB,(dino11,(dino4,dino8)),dino6);" ;

# $t = "((SA,(SB,SC1)),(dino5,dino9));";
#  $x = "(SA,SB,((dino11,dino2),dino9));";
open A, $ARGV[0]; 
my $tre = "";
while (<A>) {
	next unless /./;
	s/\s+//g;
	$tre .=$_;
}

my @a = split /\,/,$tre;

my $mem = ();

my $j = @a;
my @sym_order = () ;
for my $k (0..$#a) {
	$mem{$k} = $a[$k] ;	
	push @sym_order, $k if $a[$k] =~ /S[ABCF]\d*/;
}

$mem{$sym_order[0]} = "\(".$mem{$sym_order[0]};
if ($mem{$sym_order[-1]} =~ /;/) {
	$mem{$sym_order[-1]} =~ s/;//; 
	$mem{$sym_order[-1]} = $mem{$sym_order[-1]}."\);";
} else {
	$mem{$sym_order[-1]} = $mem{$sym_order[-1]}."\)" ;
}

for (0..(@a-2)) {
	print $mem{$_},",";
}
print $mem{$#a},"\n"; 

print $t,"\n";
