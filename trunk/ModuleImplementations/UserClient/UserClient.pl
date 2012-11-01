#!/usr/bin/perl

$| = 1;

open(INFILE,@ARGV);

use IO::Socket;
use warnings;

$sock = new IO::Socket::INET (
                              PeerAddr => 'localhost',
                              PeerPort => '8585', 
                              Proto => 'tcp'
                             );
if (!$sock) {
        print "Error: Unable to connect to the submission server.\n";
        exit(0);
}

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

@tmpFile = split('/', $ARGV[3]); 

$fname = $tmpFile[(scalar(@tmpFile)-1)];

@tmpArr = ($tline, $fname);

if (!open(DATA, $ARGV[3])) {
    print "Can't open $ARGV[3] $!\n";  #hard enough??
    exit(0);
}

$tmpArr[2] = '0';

for ($i = 3; <DATA>; $i++) {

     $tmpArr[$i] = $_;

}  

close DATA;

$sizeArr = scalar(@tmpArr) - 3;

$tmpArr[2] = $sizeArr."\n";



print $sock "$tmpArr[0]\n";

$valid = <$sock>;
chomp($valid);

if($valid eq "400")
{
   print $sock "$tmpArr[1]\n";
   $valid = <$sock>;
   chomp($valid);
   if($valid eq "400")
   {

      for ($i = 2; $i < scalar(@tmpArr); $i++) 
      {
          print $sock "$tmpArr[$i]";
      }
      # server need's this to know when to stop receiving the file!!!
      print $sock "^D\n";
      $valid = <$sock>;
      chomp($valid);
      
   }
}



if (defined($valid)) { 
    if ($valid eq "0") { 
        print "Error: Username/password is not valid.\n";

    } elsif ($valid eq "1") { 
        print "Error: Class name is not valid.\n";

    } elsif ($valid eq "2") {
        print "Error: Filename is not valid.\n";

    } elsif ($valid eq "3") {
        print "Error: Assignment is late.\n";

    } elsif ($valid eq "4") {
        print "File submit failed.\n";

    } elsif ($valid eq "5") {
        print "File submit successful.\n";
        close($sock);
        exit(1);
    }

    close($sock);
    exit(0);
}

exit(0); #If the function gets here it must have failed