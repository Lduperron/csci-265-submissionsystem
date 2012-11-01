#!/usr/bin/perl

$| = 1;

$SIG{"PIPE"} = "IGNORE";

use IO::File;
use IO::Socket;

# removes the old location of FindBin
use FindBin;

# finds the location of the ACTUALL SumbitServer.pl
# using FindBin to keep on top of dir struct 
use lib "$FindBin::Bin";

use Passmod;
use strict;
use warnings;

my $sock = new IO::Socket::INET (
                              LocalHost => "",
                              LocalPort => "8585",
                              Proto => "tcp",
			                     Listen => 3,
                              Reuse => 1
                              );
die "Error: Unable to create socket: $!\n" unless $sock;

my $root = "$FindBin::Bin"."/../../";
my $configPath = $root . "config/";
my $studentPath =  $configPath ."StudentConfig.txt";
my $coursesConf = $configPath. "CourseConfig.txt";
my $coursesPath =  $configPath . "courses/";
my $assignmentsPath = $root . "courses/";
my $coursePath;
my $course;
my $user;
my $password;
my $fileName;
my @asgm;
my $submsn;

while(my $new_sock = $sock->accept()) {    
    for (my $i = 0; $i < 4; $i++) {        
        my $line = <$new_sock>;        
        if(defined($line)) {         
            if ($i == 0) {
                chomp $line;     
                ($user, $password, $course) = split(":", $line);
                my $pass = Passmod->new();
                if (!($pass->verify($user, $password))) { #Check password
                    print $new_sock "0\n";    #user or password is incorrect
                    close($new_sock);
                    last; #break out of for loop
                } elsif (!isEnrolled($studentPath, $user, $course)) {
                    print $new_sock "1\n";    #user isn't in that course
                    close($new_sock);
                    last;
                }
                print $new_sock "400\n";
            } elsif ($i == 1 ) {
                chomp $line;    # name of assignment
                $fileName = $line;
                @asgm = split(/\./, $fileName);
                if (!validAsgm ($asgm[0], $course)) {
                    print $new_sock "2\n"; #assignment doesn't exist
                    close($new_sock);
                    last;
                }
                
                my @serverTime = split(" ", localtime);
                my $subDate = dateTime( $serverTime[4] , $serverTime[1] , $serverTime[2]);
                print "1st $subDate\n";
                if (!onTime( $subDate, $fileName, $course)) {
                    print $new_sock "3\n";
                    close($new_sock);
                    last;
                }
                print $new_sock "400\n";
            }elsif ($i == 2) {
               chomp $line;
               my $length = $line;
               #length is expected # of lines for submission file
               #make txt file in correct directory & store socket file in it
               # with user file already in assignment dir
               my$storePath = $assignmentsPath. $course. "/" . $asgm[0]. "/". $user. "/" . $fileName;
               unless(open ($submsn, "<", '>'.$storePath)) {
	               print "\nUnable to create $fileName\n";
	               print $new_sock "4\n"; #file storage failed
                  close($new_sock);
                  last;
               }
               my $j = 0;
               while ($line = <$new_sock>) {
                  if($line eq "^D"){
                     last;
                  }
                  printf $submsn $line;
                  $j++;
               }
               if ($j != $length){
                  print $new_sock "4\n"; #file storage failed
                  close($new_sock);
                  unlink($submsn);   
               }else{
                  print $new_sock "5\n";
                  close ($new_sock);
               }
               last;
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
   
   open(my $students, "<", $path)
      or return 0;

   while (<$students>) {
      my @student = split(":", $_);
      my $student = shift(@student);
   
      chomp($student);
      if ($student eq $user) {
   	   while (my $configcourse = shift(@student)) {
   		   chomp($configcourse);
   		   if ($configcourse eq $course) {
   		      return 1;
   	      }
   	   }
      }
   }
   return 0;
}

sub validAsgm # assignment path, assignment name
              # opens course directory, checks if assignment exists
{
   my $asgm = shift;
   my $course = shift;
   print "$asgm\n";
	# read assignments file for current course
	open(my $assignments, "<", $coursesPath.$course. ".txt")
		or return 0;

	# create assignments, tinp, and texp directories
	while (<$assignments>) {
      my @assignment = split(":", $_);
      my $assignment = shift(@assignment);
      if ( ($assignment) eq $asgm) {
         return 1;
      }
      print "$assignment\n";
	}
	return 0;

}

sub onTime # checks if file is on time
           # compares date it was submitted with due date
           #if sub<=due, it"s good
{
   my $subDate = shift;
   my $asgm = shift;
   my $course = shift;
   
   print "2nd $subDate\n";
   
   my $onTime = 0;
   
   # read assignments file for current course
	open(my $assignments, "<", $coursesPath.$course.".txt")
		or die("Unable to open file ". $coursesPath.$course .".txt");

	# create assignments, tinp, and texp directories
	while (<$assignments>) {
      my @assignment = split(":", $_);
      my $assignment = shift(@assignment);
      my $asgmDueDate = shift(@assignment);
      print "Due: $asgmDueDate\n";
      if (($assignment . ".txt") eq $asgm) {
         if ($subDate <= $asgmDueDate) {
            return 1;
         }else{
            return 0;
         }
      }
	}
	return 0;
   
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

