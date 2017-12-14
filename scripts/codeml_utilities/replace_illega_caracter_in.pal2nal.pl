use strict;
open A,$ARGV[0] or die "can not open $ARGV[0]\n";

while (<A>) {
	chomp;
	if (/^>/) {print $_,"\n";} 
	else {
		 s/\s+//g;
		 s/[^AGCTU-]/-/ig;
		print "$_\n";
	}
}	
close A;
exit (0);
