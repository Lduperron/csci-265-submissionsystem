#!/usr/bin/perl
######################################################
#-------------File: ./adt/exception_tst.pl-------------
# Peter Walsh
# exception test driver 
######################################################

use lib '../';
use exc::exception;
use Try::Tiny;

$|=1;

do {
   try { 
      print ("In the try blockbefore throwing full\n");
      die (exc::exception->new("full"));
      print ("In the try block after throwing full\n");
   }
   
   catch { 
      my $exc=$_;
      print ("EXCEPTION\n");
      my $exc_name=$exc->get_exc_name();
      print ("Exception $exc_name cought \n");
   }

};

