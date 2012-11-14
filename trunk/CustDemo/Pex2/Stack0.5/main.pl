#!/usr/bin/perl
#================================================================--
# Design Unit  : main
#
# File Name    : main.pl
#
# Purpose      : demonstrate the use of stack adt
#                 -> not complete <-
#
# Note         :
#
# Limitations  :
#
# Errors       : none known
#
# Modules      : stack_adt::stack
#
# Dependences  : none
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#------------------------------------------------------------------
# Revision List
# Version      Author  Date    Changes
# 1.0          PW      Oct 12  New version
#=========================================================


use strict;
use warnings;

use lib './';
use stack_adt::stack;
use exc::exception;
use Try::Tiny;

# catch die calls without exit
$SIG{__DIE__} = sub { };

# redirrect stderr messages to /dev/null
close (STDERR);
open (STDERR, ">/dev/null");

while (1) {

   print ("How may pushes should I perform (max 4 CTRL C to exit) ");
   my $num = <>;
   chop($num);

   do {
      try {
         my $s=stack_adt::stack->new(4);
         for (my $i=0; $i<$num; $i++) {
            $s->push($i);
         }
         print ("Good pushing.. \n");
         $s->dump();
         print ("Should I divide by 0? (Y/n) ");
         my $ans = <>;
         my $x;
         chop($ans);
         if ($ans eq "Y") {
            $x=$x/0;
         }
      }

      catch {
         my $e=$_;
         if (ref($e) eq "exc::exception") {
            if ($e->get_exc_name() eq "full") {
               print ("Opps... stack too small for that many pushes\n");
            } 
         } else {
            print "IGNORING EXCEPTION $_ \n";
         }
      }
   };
}
