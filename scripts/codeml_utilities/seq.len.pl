#!/usr/bin/perl -w
local $/ = ">";

<>;

while (<>){chomp;
        @a = split (/\n/,$_,2);
        $a[1] =~ s/\s+//ig;
        $a[1] =~ s/\n//ig;
        $seq = (split (/\s+/,$a[0]))[0];
        $l = length ($a[1]);
        print "$seq\t$l\n";
        $sum += $l;
        print "total length is $sum\n";
}
