#!/usr/bin/perl
$| = 1;

use strict
use warnings
# where is Passmod.pm?
# where is Report.pm???


#constant options
my $SERVSTA="SERVSTART";
my $SERVSTO="SERVSTOP";
my $SERVSTAT="SERVSTAT";

my $PASSGENALL="PASSGENALL";
my $PASSGEN="PASSGEN";

my $CPASSALL="CPASSALL";
my $CPASS="CPASS";

my $REPS="REPSIMP";
my $REPD="REPDET";

my $QUIT="Q";
my $EXIT="EXIT";
my $H="H";
my $HELP="HELP";
#-------------------------------------------------------------------
#           MAIN Program
#-------------------------------------------------------------------
my $input;




   while(<>){
      print ":";
      $input=$_;
         uc $input;
      if($input==$SERVSTA){
         Server("start");
      }else if($input==$SERVSTO){
         Server("stop");
      }else if($input==$SERVSTAT){
         Server("stat");
      }else if($input==$PASSGENALL){
         print "New passwords will be generated for all students\n";
         Pass("all");
      }else if($input==$PASSGEN){
         while(<>){
            print "generate new passwords for student:\n";
            if(Pass($_)==1){

            }else{
               last;
            }
         }
      }else if($input==$CPASSALL){
         print "All passwords will be cleard for all students\n";
         clearPass("all");
      }else if($input==$CPASS){
         while(<>){
            print "Clear all passwords for student:\n";
            if(clearPass($_)==1){

            }else{
               last;
            }
         }
      }else if($input==$REPS){

      }else if($input==$REPD){

      }else if($input==$H){
         printHelp;
      }else if($input==$HELP){
         printHelp;
      }else if($input==$QUIT){
         last;
      }else if($input==$EXIT){
         last;
      }else{
         print "Invalid Command, Enter $HELP for help\n";
      }
   }



sub Server
{
   my $arg;
   $arg = shift @_;

   if($ard == "start"){
      

   }else if($arg == "stop"){


   }else if($arg == "stat"){

   }else{
      return -1;
   }
   return 1;
}

 
sub Pass
{
   my $sName;
   $sName = shift @_;

   #verify $sName is a valid student
      # if not valid, return 1

   $pass = new passMod;
   $pass->setSetting("length",$passLength);
   $pass->setSetting("type",$passType);
   $pass->setSetting("number",$passNumber);

   if($sName=="all"){
      #for all student in /config/stuendt.txt
      $pass->generate(#studnets);
   }else{
      $pass->generate($sName);
   }

   return 0;
}

sub clearPass
{
   my $sName;
   $sName = shift @_;

   #verify $sName is a valid student
      # if not valid return 1

   $pass = new passMod;
   $pass->setSetting("length",$passLength);
   $pass->setSetting("type",$passType);
   $pass->setSetting("number",0);

   if($sName=="all"){
      #for all student in /config/stuendt.txt
      $pass->generate(#studnets);
   }else{
      $pass->generate($sName);
   }

   return 0;
}


sub Report
{
# where is Report.pm???
   $report = new Report;
}

sub printHelp
{
   print "This is the Main Administrive interface to the SubmitionsSystem\n";

   print "The following commands are recognized\n";
   print "Enter $SERVSTA to start the Submition Server\n";
   print "Enter $SERVSTO to stop the Submition Server\n";
   print "Enter $SERVSTAT to display the current status\n
          of the Submition Server\n";
   print "Enter $PASSGENALL to generate NEW passwords for all students\n";
   print "Enter $PASSGEN to generate NEW passwords for a single student\n";

   print "Enter $CPASSALL to clear all passwords for all students\n";
   print "Enter $CPASS to clear all passwords for a single student\n";

   print "Enter $REPS to display the summary results of an assignment report\n";
   print "Enter $REPD to display the detailed results of an assignment report\n";
# what is the name of this exectutable? (main.pl)
   print "Enter $QUIT to quit the AdminClient\n";
   print "Enter $HElP to display this message\n";

   return 0;
}

















