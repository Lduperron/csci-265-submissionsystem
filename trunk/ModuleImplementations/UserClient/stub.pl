#!/usr/bin/perl

$| = 1;

#use warnings;
use IO::Socket;

$sock = new IO::Socket::INET (
                              LocalHost => '',
                              LocalPort => '7071',
                              Proto => 'tcp',
			      Listen => 3,
                              Reuse => 1
                              );
die "Error: Unable to create socket: $!\n" unless $sock;

while($new_sock = $sock->accept()) {     
    for ($i = 0; $i < 4; $i++) {        
        $line = <$new_sock>;        
        if(defined($line)) {            
            if ($i == 0) {
                chop $line;     
                ($name, $passw, $class) = split(":", $line);
                if ($name ne 'matthew') { 
                    print $new_sock '0';
                    print "CLOSE\n"; 
                    close($new_sock);
                    $i = 4; 
                } elsif ($passw ne 'math') {
                    print $new_sock '1';
                    print "CLOSE\n"; 
                    close($new_sock);
                    $i = 4;
                } elsif ($class ne 'top') {
    		            print $new_sock '2';
                    print "CLOSE\n"; 
                    close($new_sock);
                    $i = 4;
                }
            } elsif ($i == 1 || $i == 2) {
                chop $line;                
                if ($line ne 'file.txt') { 
                    print $new_sock '3';
                    print "CLOSE\n"; 
                    close($new_sock);
                    $i = 4;
                } elsif ($line eq '1\n') {
                    print $new_sock '4';
                    print "CLOSE\n"; 
                    close($new_sock);
                    $i = 4;
                } else {
                    print $new_sock '5';
                    print "CLOSE\n"; 
                    close($new_sock);
                    $i = 4;
                }
            }             
        }
    }
} 
   
close($sock);
