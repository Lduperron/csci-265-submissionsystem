#!/usr/bin/perl

use IO::File;
use IO::Socket;
use lib '/265/asgm12.csci-265-submissionsysytem/ModuleImplementations/PasswordGen';
use strict;
use warnings;

my $sock = new IO::Socket::INET (                  #fill in values later
                              LocalHost => '',
                              LocalPort => '7071',
                              Proto => 'tcp',
			                     Listen => 3,
                              Reuse => 1
                              );

die "Could not create socket: $!\n" unless $sock;

my @error = (0, 1, 2, 3, 4);
my $root = "../../config/";
my $studentPath = $root . "StudentConfig.txt";
my $coursesPath = $root . "courses/";

while (my $new_sock = $sock->accept()) {
   my $line=<$new_sock>;
   chop $line;
   (my $user, my $password, my $course, my $fileName) = split(":", $line);
   
   
   if (!Verify($user, $password)) { #Check password
      print $new_sock $error[0];    #user or password is incorrect
      close($new_sock);
   }
                                    #otherwise, student exists
   
   #check student exists - find name in master enrollment
   
   #if (!isInFile($studentPath, $user) {
   #   print $new_sock $error[0];
   #   close($new_sock);
   #}      
   

   #check enrollment - check that course is after student name
   
   #2
   if (!isEnrolled($studentPath, $user, $course)) {
      print $new_sock $error[1]
   }

   #check assignment - name of file exists in that class
   my $coursePath = $coursesPath . $course;
   if (!validAsgm ($coursePath, $fileName)) {
      print $new_sock $error[2];
      close($new_sock);
   }
   
   #check due date - server time vs assignment due date
   my $asgmPath = $coursePath . my $asgm . ".txt";
   my @serverTime = split(" ", localtime);
   my $subDate = dateTime( $serverTime[4] , $serverTime[1] , $serverTime[2]);
   
   if (!onTime( $subDate, $asgmPath)) {
      print $new_sock $error[3];
      close($new_sock);
   }
   
   
   
   #store file
}
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

sub findAsgm # coursepath, assignment name
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

sub dateTime #takes year, month, day & binds into 1 variable
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
