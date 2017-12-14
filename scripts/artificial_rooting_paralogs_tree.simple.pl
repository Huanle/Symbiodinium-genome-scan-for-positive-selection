my $fh = shift;
open A, $fh;
my $tre = "";
while (<A>) {
	$tre .= $_ if /\S+/;
}
#$tre = "(SC1.0,(SF.0,SF.1),dino2.0);";
if ($tre =~ /(\(S[ABFC][0-9]*\S*S[ABFC][0-9]*\.[0-9]+\))/) {
	$str = $1; 
	$tre =~ s/\Q$str\E/\($str\)/;
	print $tre;
}


