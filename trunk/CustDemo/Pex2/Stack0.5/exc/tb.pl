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
# Modules      : exc::exception
#
# Dependences  : cew
#
# Author       : Peter Walsh, Vancouver Island University
#  Editor      :   Oliver Jourmel
#
# System       : Perl (Linux)
#
#------------------------------------------------------------------
# Revision List
# Version      Author  Date    Changes
# 1.0          PW      Oct 12  New version (using cewEcase only)
# 1.1          OJ      Nov 08  Added cewEcases
#================================================================--

$|=1;
use strict;
use warnings;













use lib '../';
use exc::exception;
use Try::Tiny;

my $cew_Test_Count=0;
          my $cew_Error_Count=0;


# no exception thrown (should not fail)
{
            try {
               $cew_Test_Count=$cew_Test_Count+1;
                ;
                if ((0) != (0)) {
                   $cew_Error_Count=$cew_Error_Count+1;
                   print("Test Case ERROR (Ncase) in script at line number ", 43, "\n");
                   print("Actual Value is ", 0, " \n");
                   print("Expected Value is ", 0, "\n");
                }
            } catch {
               $cew_Error_Count=$cew_Error_Count+1;
               print("Exception caught in Normal Case: ", ($_ ->get_exc_name()) , "\n");
               print("Test Case EXCEPTION (Ncase) in script at line number ",43,"\n\n");
            }
   }


# unexpected exception thrown (should fail)
{
            try {
               $cew_Test_Count=$cew_Test_Count+1;
               die(exc::exception->new("full")) ;
                if ((0) != (0)) {
                   $cew_Error_Count=$cew_Error_Count+1;
                   print("Test Case ERROR (Ncase) in script at line number ", 46, "\n");
                   print("Actual Value is ", 0, " \n");
                   print("Expected Value is ", 0, "\n");
                }
            } catch {
               $cew_Error_Count=$cew_Error_Count+1;
               print("Exception caught in Normal Case: ", ($_ ->get_exc_name()) , "\n");
               print("Test Case EXCEPTION (Ncase) in script at line number ",46,"\n\n");
            }
   }


# expected exception thrown (should not fail)
{
            try {
               $cew_Test_Count=$cew_Test_Count+1;
               die(exc::exception->new("full")) ;
            } catch {
               if(($_->get_exc_name()) ne ("full")){
                  $cew_Error_Count=$cew_Error_Count+1;
                  print("Unexpected Exception caught in Exception Case: ", ($_ ->get_exc_name()), "\n");
                  print("Test Case EXCEPTION (Ecase) in script at line number ",49,"\n\n");
               }
            }
   }


# unexpected exception thrown (should fail)
{
            try {
               $cew_Test_Count=$cew_Test_Count+1;
               die(exc::exception->new("ull")) ;
            } catch {
               if(($_->get_exc_name()) ne ("full")){
                  $cew_Error_Count=$cew_Error_Count+1;
                  print("Unexpected Exception caught in Exception Case: ", ($_ ->get_exc_name()), "\n");
                  print("Test Case EXCEPTION (Ecase) in script at line number ",52,"\n\n");
               }
            }
   }

{
            try {
               $cew_Test_Count=$cew_Test_Count+1;
               die(exc::exception->new("full")) ;
            } catch {
               if(($_->get_exc_name()) ne ("ull")){
                  $cew_Error_Count=$cew_Error_Count+1;
                  print("Unexpected Exception caught in Exception Case: ", ($_ ->get_exc_name()), "\n");
                  print("Test Case EXCEPTION (Ecase) in script at line number ",53,"\n\n");
               }
            }
   }


# expected exception not thrown (should fail)
{
            try {
               $cew_Test_Count=$cew_Test_Count+1;
                ;
            } catch {
               if(($_->get_exc_name()) ne ("full")){
                  $cew_Error_Count=$cew_Error_Count+1;
                  print("Unexpected Exception caught in Exception Case: ", ($_ ->get_exc_name()), "\n");
                  print("Test Case EXCEPTION (Ecase) in script at line number ",56,"\n\n");
               }
            }
   }


print("\n**********Summary**********\n");
          print("Total number of test cases = ", $cew_Test_Count, "\n");
          print("Total number of test cases in error = ", $cew_Error_Count, "\n");

