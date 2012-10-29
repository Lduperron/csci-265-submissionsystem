#!/usr/bin/perl

$| = 1;

use IO::File;
use IO::Socket;
use lib '/265/asgm12/csci-265-submissionsystem/ModuleImplentations/PasswordGen/PassMod.pm';
use strict;
use warnings;

my $sock = new IO::Socket::INET (
                              LocalHost => '',
                              LocalPort => '7071',
                              Proto => 'tcp',
			                  Listen => 3,
                              Reuse => 1
                              );
die "Error: Unable to create socket: $!\n" unless $sock;

my $root = "../../config/";
my $studentPath = $root . "StudentConfig.txt";
my $coursesPath = $root . "courses/";
my $coursePath;
my $course;
my $user;
my $password;
while(my $new_sock = $sock->accept()) {     
    for (my $i = 0; $i < 4; $i++) {        
        my $line = <$new_sock>;        
        if(defined($line)) {            
            if ($i == 0) {
                chop $line;     
                ($user, $password, $course) = split(":", $line);
                
                if (!verify($user, $password)) { #Check password
                    print $new_sock '0';    #user or password is incorrect
                    close($new_sock);
                    $i = 4;
                } elsif (!isEnrolled($studentPath, $user, $course)) {
                    print $new_sock '1';    #user isn't in that course
                    $i = 4;                
                }

            } elsif ($i == 1 || $i == 2) {
                chop $line;    # name of assignment
                my $length = $line;
                chop $line;
                my @asgm = split (".", $line);
                $coursePath = $coursesPath . $course;            
                if (!validAsgm ($coursePath, $line)) {
                    print $new_sock '2';
                    close($new_sock);
                    $i = 4;
                } 
                my $asgmPath = $coursePath . $asgm[0] . "/". $asgm[0] . ".txt";    
                    #asgm.txt stored in asgm directory
                my @serverTime = split(" ", localtime);
                my $subDate = dateTime( $serverTime[4] , $serverTime[1] , $serverTime[2]);
   
                if (!onTime( $subDate, $asgmPath)) {
                    print $new_sock '3';
                    close($new_sock);
                    $i = 4;
                }
                else {
                    #make txt file in correct directory & store socket file in it
                    # with user file already in assignment dir
                    my $filePath = $coursePath . $asgm[0] . "/" . $user;
                    open(my $submsn, '<', $filePath . $asgm[0] . ".txt");
                    my $j = 0;
                    while (defined($line)) {
                        print $submsn $line;
                        $line = <$new_sock>;
                        $j++;
                    }
                    if ($j != $length){
                    print $new_sock "4"; #file was unexpected length
                    close($new_sock);
                    unlink($submsn);    
                    }else{
                    print $new_sock "5";
                    close ($new_sock);
}
                    $i = 4;
                }
            }             
        }
    }
} 
   
close($sock);

sub isEnrolled #path, user, course
{
my $path = shift @_;
my $user = shift @_;
my $course = shift @_;

my $fullLine = onFileLine($path, $user);
my @line = split(":", $fullLine);

if (!$fullLine) {  #should be in file, as password verification implies
                     #that the student exists & should be in file. just in case
   return 0;
}else{
   for (my $j=0; $j<@line; $j++) {
      chomp $line[$j];
      if ($line[$j] eq $course) {
         return 1;
      }
   }
}
return 0;
}

#returns line of file searchTerm is found on, 0 if not found   
sub onFileLine # filePath, searchTerm
{
   my $filePath = shift @_;
   my $searchTerm = shift @_;
   
   my $found = 0;
   my @tmp;
   
   open (my $file,'<', $filePath );
   $tmp[0] = <$file>;
   chomp $tmp[0];
   for (my $i=0; <$file>; $i++) {
      $tmp[$i] = <$file>;
   }
   for (my $j=0;$j<@tmp; $j++) {
      if (index($tmp[$j], $searchTerm) != -1) {
         return $tmp[$j];
      }
   }
   return 0;
   
}

sub validAsgm # coursepath, assignment name
              # opens course directory, checks if assignment exists
{
   my $coursePath = shift @_;
   my $asgm = shift @_;
   my $found = 0;
   
   opendir (my $course, $coursePath);
   my @files;
   for (my $i = 0; my $file = readdir($course); $i++) {
      $files[$i] = $file;
   }
   
   for (my $j=0; $j<@files; $j++) {
      if ($files[$j] eq $asgm) {
         $found = 1;
      }
   }
   return $found;
}

sub onTime # checks if file is on time
           # compares date it was submitted with due date
           #if sub<=due, it's good
{
   my $subDate = shift @_;
   my $path = shift @_;
   
   my $onTime = 0;
   
   open(my $asgm, '<', $path);
   my $dueDate = <$asgm>;
   
   if ($subDate <= $dueDate) {
      $onTime = 1;
   }
   
   close($asgm);
   return $onTime;
}

sub dateTime # takes year, month, day & binds into 1 variable
             # in same format of due date
{
   my $year = shift @_;
   my $month = shift @_;
   my $day = shift @_;

      
   my $finalTime = $year;

   
   if ($month eq "Jan") {
      $finalTime = $finalTime . "01";
   }elsif( $month eq "Feb") {
      $finalTime = $finalTime . "02";
   }elsif( $month eq "Mar") {
      $finalTime = $finalTime . "03";
   }elsif( $month eq "Apr") {
      $finalTime = $finalTime . "04";
   }elsif( $month eq "May") {
      $finalTime = $finalTime . "05";
   }elsif( $month eq "June") {
      $finalTime = $finalTime . "06";
   }elsif( $month eq "July") {
      $finalTime = $finalTime . "07";
   }elsif( $month eq "Aug") {
      $finalTime = $finalTime . "08";
   }elsif( $month eq "Sept") {
      $finalTime = $finalTime . "09";
   }elsif( $month eq "Oct") {
      $finalTime = $finalTime . "10";
   }elsif( $month eq "Nov") {
      $finalTime = $finalTime . "11";
   }else{
      $finalTime = $finalTime . "12";
   }
   
   $finalTime = $finalTime . $day;
   return $finalTime;
}

