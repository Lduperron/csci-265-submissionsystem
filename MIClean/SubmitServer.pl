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
my $studentPath = $root . "config/StudentConfig.txt";
my $coursesConf =$root . "config/CourseConfig.txt";
my $coursesPath = $root . "config/courses/";
my $assignmentsPath = $root . "courses/";
my $coursePath;
my $course;
my $user;
my $password;
my $fileName;
my @asgm;
my $submsn;
print "before while\n";
while(my $new_sock = $sock->accept()) {
    print "inwhile\n";     
    for (my $i = 0; $i < 4; $i++) { 
         print "in for\n";       
        my $line = <$new_sock>;        
        if(defined($line)) {
            print "defined line\n";            
            if ($i == 0) {
                chomp $line;     
                ($user, $password, $course) = split(":", $line);
                my $pass = Passmod->new();
                if (!($pass->verify($user, $password))) { #Check password
                    print $new_sock "0\n";    #user or password is incorrect
                    close($new_sock);
                    last; #break out of for loop
                } elsif (!isEnrolled($studentPath, $user, $course)) {
                    print $new_sock "1\n";    #user isn"t in that course
                    close($new_sock);
                    last;
                }
                print $new_sock "400\n";
            } elsif ($i == 1 ) {
                chomp $line;    # name of assignment
                $fileName = $line;
                @asgm = split (".");
                if (!validAsgm ($asgm[0], $course)) {
                    print $new_sock "2\n"; #assignment doesn"t exist
                    close($new_sock);
                    last;
                }
                    #asgm.txt stored in asgm directory
                my @serverTime = split(" ", localtime);
                my $subDate = dateTime( $serverTime[4] , $serverTime[1] , $serverTime[2]);
   
                if (!onTime( $subDate, $line, $course)) {
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
               unless(open ($submsn, "<", ">".$assignmentsPath . $course . "/" . $asgm[0] . "/" . $user. "/" . $fileName)) {
	               die "\nUnable to create $fileName\n";
               }
               my $j = 0;
               while ($line = <$new_sock>) {
                  if($line=="^D"){
                     last;
                  }
                  printf $submsn $line;
                  $j++;
               }
               if ($j != $length){
                  print $new_sock "4\n"; #file was unexpected length
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
      or die("Unable to open file ". $path);

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
   
	# read assignments file for current course
	open(my $assignments, "<", $assignmentsPath.$course. "/".$asgm)
		or die("Unable to open file ". $assignmentsPath.$course. $asgm);

	# create assignments, tinp, and texp directories
	while (<$assignments>) {
      my @assignment = split(":", $_);
      my $assignment = shift(@assignment);
      if ($assignment eq $asgm) {
         return 1;
      }
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
   
   my $onTime = 0;
   
   # read assignments file for current course
	open(my $assignments, "<", $assignmentsPath.$course.".txt")
		or die("Unable to open file ". $assignmentsPath.$course .".txt");

	# create assignments, tinp, and texp directories
	while (<$assignments>) {
      my @assignment = split(":", $_);
      my $assignment = shift(@assignment);
      my $asgmDueDate = shift(@assignment);
      if ($assignment eq $asgm) {
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

