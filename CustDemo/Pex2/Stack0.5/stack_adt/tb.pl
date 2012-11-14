#================================================================--
# Design Unit  : cew testbench for stack
#
# File Name    : tb.cew
#
# Purpose      : unit testing
#
# Note         :
#
# Limitations  :
#
# Errors       : none known
#
# Modules      : stack_adt::stack
#
# Dependences  : cew
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#------------------------------------------------------------------
# Revision List
# Version      Author  Date    Changes
# 1.0          PW      Oct 12  New version
#================================================================--

$|=1;
use strict;
use warnings;













use lib '../';
use stack_adt::stack;
use exc::exception;
use Try::Tiny;

my $cew_Test_Count=0;
          my $cew_Error_Count=0;


# Local Function Load (s, n);
# pushes n values on the stack from
# the sequence 10, 100, 1000 ... 
# note: no exception checking

sub load {
   my $s=shift @_;
   my $n=shift @_;
   
   for (my $i=0; $i<$n; $i++) {
      $s->push(($i+1)*10);
   }
}

#############
# empty stack
#############

my $stack0=stack_adt::stack->new(10);
{
            try {
               $cew_Test_Count=$cew_Test_Count+1;
               $stack0->top() ;
            } catch {
               if(($_->get_exc_name()) ne ("empty")){
                  $cew_Error_Count=$cew_Error_Count+1;
                  print("Unexpected Exception caught in Exception Case: ", ($_ ->get_exc_name()), "\n");
                  print("Test Case EXCEPTION (Ecase) in script at line number ",60,"\n\n");
               }
            }
   }

{
            try {
               $cew_Test_Count=$cew_Test_Count+1;
               $stack0->pop() ;
            } catch {
               if(($_->get_exc_name()) ne ("empty")){
                  $cew_Error_Count=$cew_Error_Count+1;
                  print("Unexpected Exception caught in Exception Case: ", ($_ ->get_exc_name()), "\n");
                  print("Test Case EXCEPTION (Ecase) in script at line number ",61,"\n\n");
               }
            }
   }


#################
# half full stack
#################

my $stack1=stack_adt::stack->new(10);
{
            try {
               $cew_Test_Count=$cew_Test_Count+1;
               load($stack1, 5) ;
                if (($stack1->top()) != (50)) {
                   $cew_Error_Count=$cew_Error_Count+1;
                   print("Test Case ERROR (Ncase) in script at line number ", 68, "\n");
                   print("Actual Value is ", $stack1->top(), " \n");
                   print("Expected Value is ", 50, "\n");
                }
            } catch {
               $cew_Error_Count=$cew_Error_Count+1;
               print("Exception caught in Normal Case: ", ($_ ->get_exc_name()) , "\n");
               print("Test Case EXCEPTION (Ncase) in script at line number ",68,"\n\n");
            }
   }

{
            try {
               $cew_Test_Count=$cew_Test_Count+1;
               $stack1->pop() ;
                if (($stack1->top()) != (40)) {
                   $cew_Error_Count=$cew_Error_Count+1;
                   print("Test Case ERROR (Ncase) in script at line number ", 69, "\n");
                   print("Actual Value is ", $stack1->top(), " \n");
                   print("Expected Value is ", 40, "\n");
                }
            } catch {
               $cew_Error_Count=$cew_Error_Count+1;
               print("Exception caught in Normal Case: ", ($_ ->get_exc_name()) , "\n");
               print("Test Case EXCEPTION (Ncase) in script at line number ",69,"\n\n");
            }
   }

{
            try {
               $cew_Test_Count=$cew_Test_Count+1;
               $stack1->pop() ;
                if (($stack1->top()) != (30)) {
                   $cew_Error_Count=$cew_Error_Count+1;
                   print("Test Case ERROR (Ncase) in script at line number ", 70, "\n");
                   print("Actual Value is ", $stack1->top(), " \n");
                   print("Expected Value is ", 30, "\n");
                }
            } catch {
               $cew_Error_Count=$cew_Error_Count+1;
               print("Exception caught in Normal Case: ", ($_ ->get_exc_name()) , "\n");
               print("Test Case EXCEPTION (Ncase) in script at line number ",70,"\n\n");
            }
   }


#################
# full stack
#################

my $stack2=stack_adt::stack->new(10);
{
            try {
               $cew_Test_Count=$cew_Test_Count+1;
               load($stack2, 10) ;
                if (($stack2->top()) != (100)) {
                   $cew_Error_Count=$cew_Error_Count+1;
                   print("Test Case ERROR (Ncase) in script at line number ", 77, "\n");
                   print("Actual Value is ", $stack2->top(), " \n");
                   print("Expected Value is ", 100, "\n");
                }
            } catch {
               $cew_Error_Count=$cew_Error_Count+1;
               print("Exception caught in Normal Case: ", ($_ ->get_exc_name()) , "\n");
               print("Test Case EXCEPTION (Ncase) in script at line number ",77,"\n\n");
            }
   }

{
            try {
               $cew_Test_Count=$cew_Test_Count+1;
               $stack2->push(110) ;
            } catch {
               if(($_->get_exc_name()) ne ("full")){
                  $cew_Error_Count=$cew_Error_Count+1;
                  print("Unexpected Exception caught in Exception Case: ", ($_ ->get_exc_name()), "\n");
                  print("Test Case EXCEPTION (Ecase) in script at line number ",78,"\n\n");
               }
            }
   }

{
            try {
               $cew_Test_Count=$cew_Test_Count+1;
                ;
                if (($stack2->top()) != (100)) {
                   $cew_Error_Count=$cew_Error_Count+1;
                   print("Test Case ERROR (Ncase) in script at line number ", 79, "\n");
                   print("Actual Value is ", $stack2->top(), " \n");
                   print("Expected Value is ", 100, "\n");
                }
            } catch {
               $cew_Error_Count=$cew_Error_Count+1;
               print("Exception caught in Normal Case: ", ($_ ->get_exc_name()) , "\n");
               print("Test Case EXCEPTION (Ncase) in script at line number ",79,"\n\n");
            }
   }

{
            try {
               $cew_Test_Count=$cew_Test_Count+1;
               $stack2->pop() ;
                if (($stack2->top()) != (90)) {
                   $cew_Error_Count=$cew_Error_Count+1;
                   print("Test Case ERROR (Ncase) in script at line number ", 80, "\n");
                   print("Actual Value is ", $stack2->top(), " \n");
                   print("Expected Value is ", 90, "\n");
                }
            } catch {
               $cew_Error_Count=$cew_Error_Count+1;
               print("Exception caught in Normal Case: ", ($_ ->get_exc_name()) , "\n");
               print("Test Case EXCEPTION (Ncase) in script at line number ",80,"\n\n");
            }
   }


################
# stress test
################

my $stack3=stack_adt::stack->new(100);

for (my $i=0; $i<100; $i++) {
   {
            try {
               $cew_Test_Count=$cew_Test_Count+1;
               $stack3->push($i) ;
                if (($stack3->top()) != ($i)) {
                   $cew_Error_Count=$cew_Error_Count+1;
                   print("Test Case ERROR (Ncase) in script at line number ", 89, "\n");
                   print("Actual Value is ", $stack3->top(), " \n");
                   print("Expected Value is ", $i, "\n");
                }
            } catch {
               $cew_Error_Count=$cew_Error_Count+1;
               print("Exception caught in Normal Case: ", ($_ ->get_exc_name()) , "\n");
               print("Test Case EXCEPTION (Ncase) in script at line number ",89,"\n\n");
            }
   }

}

for (my $i=99; $i>=0; $i--) {
   {
            try {
               $cew_Test_Count=$cew_Test_Count+1;
                ;
                if (($stack3->top()) != ($i)) {
                   $cew_Error_Count=$cew_Error_Count+1;
                   print("Test Case ERROR (Ncase) in script at line number ", 93, "\n");
                   print("Actual Value is ", $stack3->top(), " \n");
                   print("Expected Value is ", $i, "\n");
                }
            } catch {
               $cew_Error_Count=$cew_Error_Count+1;
               print("Exception caught in Normal Case: ", ($_ ->get_exc_name()) , "\n");
               print("Test Case EXCEPTION (Ncase) in script at line number ",93,"\n\n");
            }
   }

   {
            try {
               $cew_Test_Count=$cew_Test_Count+1;
               $stack3->pop() ;
                if ((0) != (0)) {
                   $cew_Error_Count=$cew_Error_Count+1;
                   print("Test Case ERROR (Ncase) in script at line number ", 94, "\n");
                   print("Actual Value is ", 0, " \n");
                   print("Expected Value is ", 0, "\n");
                }
            } catch {
               $cew_Error_Count=$cew_Error_Count+1;
               print("Exception caught in Normal Case: ", ($_ ->get_exc_name()) , "\n");
               print("Test Case EXCEPTION (Ncase) in script at line number ",94,"\n\n");
            }
   }

}
   
print("\n**********Summary**********\n");
          print("Total number of test cases = ", $cew_Test_Count, "\n");
          print("Total number of test cases in error = ", $cew_Error_Count, "\n");

