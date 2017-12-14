use strict;

open A, $ARGV[0];

my %pfam = ();
while (<A>) {
	
	chomp;
	my @a = split /\s+/,$_;
	next unless @a>1;
#	$a[1] =~ s/\s+//g;
#	my @b = split /-/,$a[1];
	my $k = $a[0];
	print $k,"\t";
	my %seen = ();
	my $total = 0;
	shift @a;
	for my $i (@a) {
		$seen{$i}++ unless ($i =~ /\s+/ig);
	}
	my @values = values %seen;
#	print join "\t",keys %seen,"\t",join "\t",@values,"\n";
    if (keys %seen > 0) {	
#	my $SD = sd (\@values); 
#	print $SD,"\t", av(\@values),"\t";
	for my $j (keys %seen) {
		#print $j,"\t" if not ($seen{$j} >= (av(\@values) + 1.96*$SD)   or  $seen{$j} <= (av (\@values)) - 1.96*$SD);
		print $j,"\t" ; # if ($seen{$j} >= av(\@values) ) ;#+ 1.96*$SD)   or  $seen{$j} <= (av (\@values)) - 1.96*$SD);
	}
	print "\n";
} else {print keys%seen,"\n";}  
}

sub av {
my @a = @{$_[0]};
my $n = @a;
my $sum = 0;
grep {$sum +=$_}@a;
my $av = $sum/$n;
return $av;
}

sub sd {
	my @a = @{$_[0]};
	my $n = @a;
	my $sum = 0;
	grep {$sum+=$_}@a;
	my $av = $sum/$n;
	my $ssq = 0;
	for my $j (@a) {
		$ssq += ($j - $av)**2;
	}
	my $sd = sqrt ($ssq/($n-1));
	return $sd;
}
