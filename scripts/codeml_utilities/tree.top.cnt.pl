use strict;
my @trefile = glob "*.tre";
my %cnt = ();
my %mem = ();
for my $i(@trefile) {
	open A,$i;
	while (<A>) {
	chomp;
	$cnt{$_}++;
	$mem{$_} .=$i." ";
	} close A;
}

foreach my $k(sort {$cnt{$a} <=> $cnt{$b}} keys %cnt) {
	if ($cnt{$k} >4) {
		my $dir = $cnt{$k}."_times";
		my $cmd = "mkdir $dir && mv $mem{$k} $dir";
		system ($cmd);
	}
#	print $k,"\t",$cnt{$k},"\t$mem{$k}\n";
}

	
