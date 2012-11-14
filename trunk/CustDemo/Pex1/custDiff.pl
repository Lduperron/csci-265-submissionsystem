#! /usr/bin/perl
#
# the cmd line arg's will be in the order, tact/file texp/file
# assume that if tinp of a test is -t alnum, then texp will have
#  charactors in the password...
#
#

use strict;
use warnings;


   my $fileOne = $ARGV[0];
   my $fileTwo = $ARGV[1];

   my $errorCount;
   $errorCount=0;

   my $FOL;
   my $FTL;

   my @FOLLine;
   my @FTLLine;

   my $passOne;
   my $passTwo;

   


   open(FILEONE, "<$fileOne");
   open(FILETWO, "<$fileTwo");

# maybe a way to handle diffrent length files
   my(@fileOneLines) = <FILEONE>; # read file into list
   my(@fileTwoLines) = <FILETWO>; # then test the lenght of thoes list
   my $fOneLength;
   my $fTwoLength;

   $fOneLength = @fileOneLines;
   $fTwoLength = @fileTwoLines;

   if($fOneLength!=$fTwoLength){
      $errorCount++;
      print "Files are not of the same length\n";
   }
#end of file length test

   close(FILEONE);
   close(FILETWO);


   open(FILEONE, "<$fileOne");
   open(FILETWO, "<$fileTwo");



   while($FOL = <FILEONE>){
      if($FTL = <FILETWO>){

         @FOLLine=split(" ",$FOL);
         @FTLLine=split(" ",$FTL);

         if(($FOLLine[0] eq "Password:")&&($FTLLine[0] eq "Password:")){
#passOne is the tact, passTwo is texp
#use passTwo to determin rules of passOne
            $passOne = $FOLLine[1];
            $passTwo = $FTLLine[1];
            if((length($passOne)) == (length($passTwo))){
               #the same length
               if($passTwo=~(m/\D/)){
               #using alnum
                  if($passOne=~(m/\D/)){
                     #passed
                  }else{
                     $errorCount++;
                     print "lines FileOne .. FileTwo:\n$FOL$FTL"; 
                     #failed alnum check
                  }
               }else{
               #using num
                  if($passOne=~(m/\D/)){
                     $errorCount++;
                     print "lines FileOne .. FileTwo:\n$FOL$FTL";
                     #failed num check
                  }else{
                     #passed
                  }
               }
            }else{
               $errorCount++;
               print "lines FileOne .. FileTwo:\n$FOL$FTL";
               #failed length check
            }
         }else{

            if($FOL ne $FTL){
               $errorCount++;
               print "lines FileOne .. FileTwo:\n$FOL$FTL"; 
            }else{
# the two lines are the same
            }
         }
      }
      else{ # FILEONE is not empty, but FILETWO is

         $errorCount++;
         print "Extra Line in FileOne: $FOL";
      }
   }

   while(<FILETWO>){ # FILEONE is empty, BUT FILETWO still has txt
      $FTL = $_;
      $errorCount++;
      print "Extra Line in FileTwo: $FTL";
   }




   close(FILEONE);
   close(FILETWO);


   if($errorCount > 0){
      print "\nErrors on pass = $errorCount\n";
      exit(1);
   }else{
      exit(0);
   }




