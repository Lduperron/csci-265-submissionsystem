#!/usr/bin/perl

$| = 1;

#use warnings;
use IO::Socket;

$sock = new IO::Socket::INET (
                              LocalHost => "",
                              LocalPort => "8585",
                              Proto => "tcp",
			                     Listen => 3,
                              Reuse => 1
                              );
die "Error: Unable to create socket: $!\n" unless $sock;

while($new_sock = $sock->accept()) {     
	for ($i = 0; $i < 2; $i++) {	 
	 	$line = <$new_sock>;        
     	if(defined($line)) {            
     	    chomp $line;
			if ($i == 0) {   
     	        ($name, $passw, $class) = split(":", $line);
     	        if ($name ne "matthew") { 
     	            print $new_sock "0\n";
     	            print "name\n"; 
     	            close($new_sock);
     	            $i = 4; 
     	        } elsif ($passw ne "math") {
     	            print $new_sock "0\n";
     	            print "pass\n"; 
     	            close($new_sock);
     	            $i = 4;
     	        } elsif ($class ne "top") {
    	 	         print $new_sock "1\n";
     	            print "class\n"; 
     	            close($new_sock);
     	            $i = 4;
     	        }else{
                 print $new_sock "400\n";      
 
                 print "all good\n";
              }
		 	 } elsif ($i == 1) {
			  	if ($line ne "file.txt") { 
                    print $new_sock "2\n";
                    print "CLOSE\n"; 
                    close($new_sock);
                    $i = 4;
                } else{
                 print $new_sock "400\n";        
              }
            }

  

		} 
	} 

	$num = <$new_sock>;

	if ($i != 4) {
		$line = <$new_sock>;
		for ($i = 0; $i < $num; $i++) {        
    			chop $line;                
        		if (defined($line)) {	
				if ($line eq "1") {
	        		    print $new_sock "5\n";
	        		    print "CLOSE\n"; 
	        		    close($new_sock);
                   last;
	        		    
	        		} else {
	        		    print $new_sock "4\n";
	        		    print "CLOSE\n"; 
	        		    close($new_sock);
	        		    $i = $num;
	        		} 
			}
			$line = <$new_sock>;           
    		}
	} 
}   
close($sock);
