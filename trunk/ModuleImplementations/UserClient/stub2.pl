#!/usr/bin/perl

$| = 1;

#use warnings;
use IO::Socket;

$sock = new IO::Socket::INET (
                              LocalHost => '',
                              LocalPort => '8585',
                              Proto => 'tcp',
			      Listen => 3,
                              Reuse => 1
                              );
die "Error: Unable to create socket: $!\n" unless $sock;

while($new_sock = $sock->accept()) {     
    print $new_sock '3\n';
    close($new_sock);
}   
close($sock);
