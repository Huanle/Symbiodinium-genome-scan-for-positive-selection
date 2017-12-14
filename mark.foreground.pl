use strict;
use warnings;

open A, $ARGV[0] or die "can not open $ARGV[0]\n";
# (((((dino3.0,(((dino9.1,dino9.0),dino11.0),((((SB.1,SB.0)),dino5.0),perk.0))),dino6.0),dino7.0),dino4.0),dino2.0,dino8.0);
#
my $tre = "";
while (<A>) {
        next unless /./;
        s/\s+//g;
        chomp;
        $tre .=$_;
}
close A;

my @a = split /\,/,$tre;
my @sym = ();
for my $k (@a) {
        $k =~ s/\(|\)//g;
        $k =~ s/;//g;
        push @sym,$k if $k =~ /$ARGV[1]/; #/S[ABCF]\d*/g;
}

print "$sym[0],,$sym[-1]\n";
