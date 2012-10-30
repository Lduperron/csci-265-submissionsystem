#!/usr/bin/perl

$| = 1;

open(INFILE,@ARGV);

use IO::Socket;
use warnings;

$sock = new IO::Socket::INET (
                              PeerAddr => 'localhost', #change to address
                              PeerPort => '7071', 
                              Proto => 'tcp'
                             );
die "Error: Unable to connect to the submission server.\n" unless $sock;

#Assume proper use??

if (scalar(@ARGV) == 0) {
    print "Error: No username, password, class name, or file name submitted.\n";
    exit(0);
} elsif (scalar(@ARGV) == 1) {
    print "Error: No password, class name, or file name submitted.\n";
    exit(0);
} elsif (scalar(@ARGV) == 2) {
    print "Error: No class name or file name submitted.\n";
    exit(0);
} elsif (scalar(@ARGV) == 3) {
    print "Error: No file name submitted.\n";
    exit(0);
} elsif (scalar(@ARGV) >= 5) {
    print "Error: Too many input parameters.\n";
    exit(0);
}

$tline = join(":", $ARGV[0], $ARGV[1], $ARGV[2]);

@tmpFile = split('/', $ARGV[3]); #Need to split or just nav to directory?

$fname = $tmpFile[(scalar(@tmpFile)-1)]; 

@tmpArr = ($tline, $fname);

open(DATA, $ARGV[3]) or die $!;

for ($i = 2; <DATA>; $i++) {
    $tmpArr[$i] = $_; 
}  

for ($i = 0; $i < scalar(@tmpArr); $i++) {
    print $sock "$tmpArr[$i]\n";
}

$valid = <$sock>;

while (defined($valid)) {       
    if ($valid eq "0") {
        print "Error: Username is not valid.\n";
        exit(0);
    } elsif ($valid eq "1") { 
        print "Error: Password is not valid.\n";
        exit(0);
    } elsif ($valid eq "2") {
        print "Error: Class name is not valid.\n";
        exit(0);
    } elsif ($valid eq "3") {
        print "Error: Filename is not valid.\n";
        exit(0);
    } elsif ($valid eq "4") {
        print "File submit failed.\n";
        exit(1);
    } elsif ($valid eq "5") {
        print "File submit successful.\n";
        exit(0);
    }
    $valid = <$sock>;
}

close DATA;