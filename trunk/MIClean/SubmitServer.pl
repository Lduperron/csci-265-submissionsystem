#!/usr/bin/perl

$| = 1;

$SIG{"PIPE"} = "IGNORE";

use IO::File;
use IO::Socket;

# removes the old location of FindBin
use FindBin;

# Finds the location of the ACTUAL SubmitServer.pl
# It may be called by adminClient in different directory,
# but paths are relative to SubmitServer's location 
use lib "$FindBin::Bin";

# SubmitServer uses Passmod's function verify to check user/password
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

#Error codes: 0=Invalid user/password, 1=user not enrolled in course,
#             2=Invalid assignment,    3=Assignment is late
#             4=File storage failed
#Success codes: 400=Go-ahead signal for userClient to send next element
#               5=File storage successful

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
my $asgmName;
my $submsn;

while(my $new_sock = $sock->accept()) {    
    for (my $i = 0; $i < 3; $i++) {        
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
                print $new_sock "400\n"; #go-ahead to userclient
            } elsif ($i == 1 ) {
                chomp $line;    # name of assignment
                $fileName = $line;
               ($asgmName, my $asgmType)  = split(/\./, $fileName);
                        #don't want file type (eg ".cpp") for all
                        #checks using the file name
                if (!validAsgm ($asgmName, $course)) {
                    print $new_sock "2\n"; #assignment doesn't exist
                    close($new_sock);
                    last;
                }
                
                my @serverTime = split(" ", localtime);
                #Gives date in different format than due date is stored,
                #send to dateTime for formatting
                my $subDate = dateTime( $serverTime[4] , $serverTime[1] 
                                      , $serverTime[2]);
                  #sends year, month, day

                #check if assignment is on time
                if (!onTime( $subDate, $asgmName, $course)) {
                    print $new_sock "3\n"; #assignment is late
                    close($new_sock);
                    last;
                }
                print $new_sock "400\n"; #go ahead to userclient
            }elsif ($i == 2) {
               chomp $line;
               my $length = $line;
               #length is expected # of lines for submission file

               my $storePath = $assignmentsPath. $course. "/" . 
                               $asgmName. "/". $user. "/" . $fileName;
               #make a file in user's directory for that assignment & 
               #store socket file in it with user file already in 
               #assignment dir
               unless(open ($submsn, ">", $storePath)) {
                  print "\nUnable to create $storePath\n";
                  print $new_sock "4\n"; #file storage failed
                  close($new_sock);
                  last;
               }
               my $j = 0;
               while ($line = <$new_sock>) {
 
                  if($line eq "^D\n"){ #End of file transmission from client
                     close($submsn);
                     last;
                  }else{
                     print $submsn $line; #Stores line of asgm in file
                     $j++;
                  }
               }
               if ($j != $length){ #Did not recieve correct # of lines,
                                   #something went wrong
                  print "Unexpected File Length\n";
                  print $new_sock "4\n"; #file storage failed
                  close($new_sock);
                  unlink($submsn); #file is not what it should be,
                                   #remove it  
               }else{
                  print $new_sock "5\n"; #file storage successful
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

   #opens student config
   open(my $students, "<", $path)
      or return 0;

   #finds user
   while (<$students>) {
      my @student = split(":", $_);
      my $student = shift(@student);

      #finds (or doesn't) course, =>enrolled
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
        open(my $assignments, "<", $coursesPath.$course. ".txt")
                or return 0;

        # looks for assignment
        while (<$assignments>) {
           my @assignment = split(":", $_);
           my $assignment = shift(@assignment);
           if ( ($assignment) eq $asgm) {
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
   
   # read assignments file for current course
        open(my $assignments, "<", $coursesPath.$course.".txt")
                or die("Unable to open file ". $coursesPath.$course .".txt");

        # finds due date for given assignment
        while (<$assignments>) {
      my @assignment = split(":", $_);
      my $assignment = shift(@assignment);
      my $asgmDueDate = shift(@assignment);
      if (($assignment) eq $asgm) {
         if ($subDate <= $asgmDueDate) { #compares, if <= then it's
                                         #on time& will be accepted
            return 1;
         }else{
            return 0;
         }
      }
        }
        return 0;
   
}

sub dateTime # takes year, month, day & binds into 1 variable
             # in same format of due date YYYYMMDD
{
   my $year = shift @_;
   my $month = shift @_;
   my $day = shift @_;

      
   my $finalTime = $year;

   #Month is given as a string, format to integer   
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
   }elsif( $month eq "Jun") {
      $finalTime = $finalTime . "06";
   }elsif( $month eq "Jul") {
      $finalTime = $finalTime . "07";
   }elsif( $month eq "Aug") {
      $finalTime = $finalTime . "08";
   }elsif( $month eq "Sep") {
      $finalTime = $finalTime . "09";
   }elsif( $month eq "Oct") {
      $finalTime = $finalTime . "10";
   }elsif( $month eq "Nov") {
      $finalTime = $finalTime . "11";
   }else{
      $finalTime = $finalTime . "12";
   }

   #Take's 1-9 and makes them 01, 02,...,09, to match 10, 22, etc
   $day = sprintf("%0*d", 2, $day);
   
   $finalTime = $finalTime . $day;
   return $finalTime;
}

