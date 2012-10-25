#!/usr/bin/perl
#
#  1 = sucsess
#  0 = fail
#
#  functions return sucsess status. ie. (1 == good)
#
#


$| = 1;

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/PasswordGen"; #Adds the PasswordGen folder into the libary string so that it can find Session::Token
use lib "$FindBin::Bin/PasswordGen/Session"; #Adds the PasswordGen/Session folder into the library so that Dynaloader can find its way down the tree to the .so.
                                             # Should be a robust enough work around, as long as the files are kept realitive to each other.   

use IO::File;
use File::Path 'make_path';
use PasswordGen::Passmod;

#use Report;

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

# define all config varibales used
my $passLength;
my $passType;
my $passNumber;

#---------------------------------------------------------------------
#        Startup Dir Stuct Managment
#---------------------------------------------------------------------


#do{
#---------------------------------------------------------------------
# Comments: make_path will automatically create parent directories, if 
#           they do not exist, i.e. make_path($course."/".$assignment
#           will create $course before creating $assignment if it 
#           doesn't exist.
#----------------------------------------------------------------------


# Define default paths
   my $root = "../";
   my $configPath = $root . "config/";
   my $coursesPath = $root . "courses/";
   my $assignmentsPath = $configPath . "courses/";
   my $studentsPath = $root . "students/";
   my $programPath = $root . "bin/";
   my $docsPath = $root . "docs/";

# Define config filenames
   my $studentsConf = $configPath . "StudentConfig.txt";		# studentname:enrolled_course:...\n
   my $coursesConf = $configPath . "CourseConfig.txt";			# coursename\n
   my $passwordConf = $configPath . "PasswordConfig.txt";		# Length:<LENGTH>\n Type:<[alnum,num]>\n Number:<Number>

# read Courses Config file
   open(my $courses, "<", $coursesConf)
	or die("Unable to open file ". $coursesConf);

# create course and assignment directories
   while (<$courses>) {
	   my $course = $_;
	   chomp($course);
	   make_path($coursesPath.$course, {verbose => 1, mode => 0711});

	# read assignments file for current course
	   open(my $assignments, "<", $assignmentsPath.$course.".txt")
		   or die("Unable to open file ". $assignmentsPath.$course .".txt");

	# create assignments, tinp, and texp directories
	   while (<$assignments>) {
		   my @assignment = split(':', $_);
		   my $assignment = shift(@assignment);
		   make_path($coursesPath.$course."/".$assignment."/tinp", {verbose => 1, mode => 0711});
		   make_path($coursesPath.$course."/".$assignment."/texp", {verbose => 1, mode => 0711});
	   }
   }

# read students config file
   open(my $students, "<", $studentsConf)
	   or die("Unable to open file ". $studentsConf);

# create student directories under students and under assignments
   while (<$students>) {
	   my @student = split(':', $_);
	   my $student = shift(@student);
	   chomp($student);
	   make_path($studentsPath.$student, {verbose => 1, mode => 0711});

	# process enrolled courses and create relevant student directories	
	   while (my $course = shift(@student)) {
		   chomp($course);
		# read assignments file of current course
		   open(my $assignments, $assignmentsPath.$course.".txt")
			   or die("Unable to open file ". $assignmentsPath.$course.".txt");

		# create student and tact directories under assignments
		   while (<$assignments>) {
			   my @assignment = split(':', $_);
			   my $assignment = shift(@assignment);
			   make_path($coursesPath.$course."/".$assignment."/".$student."/tact", {verbose => 1, mode => 0711});
		   }
	   }
   }

# load Password defaults from config
   open(my $parameters, $passwordConf)
	   or die("Unable to open file ". $passwordConf);

   while (<$parameters>) {
	   my @parameter = split(':',$_);
	   if ($parameter[0] eq "Length") {
		   $passLength = $parameter[1];
	   } elsif ($parameter[0] eq "Type") {
		   $passType = $parameter[1];
	   } elsif ($parameter[0] eq "Number") {
		   $passNumber = $parameter[1];
	   } else {
		   die("Errors in $passwordConf file");
	   }
   }
#}
#-------------------------------------------------------------------
#           MAIN Program for userInput
#-------------------------------------------------------------------

#do {
   my $input = "";
   &printHelp();
   print ":";
   while(<>)
   {
      $input = uc;
      chomp $input;

      if($input eq $SERVSTA){
         &Server("start");
      }elsif($input eq $SERVSTO){
         &Server("stop");
      }elsif($input eq $SERVSTAT){
         &Server("stat");
      }elsif($input eq $PASSGENALL){
         print "New passwords will be generated for all students\n";
         &Pass("all");
      }elsif($input eq $PASSGEN){
         print "generate new passwords for student:\n";
         while(<>){
            if(&Pass($_) == 0){
# it failed, bad input
            }else{
               last;
            }
         }
      }elsif($input eq $CPASSALL){
         print "All passwords will be cleard for all students\n";
         &clearPass("all");
      }elsif($input eq $CPASS){
         print "Clear all passwords for student:\n";
         while(<>){
            if(&clearPass($_) == 0){
# bad input, clearPass failed
            }else{
               last;
            }
         }
      }elsif($input eq $REPS){
         &Report("simple");
      }elsif($input eq $REPD){
         &Report("details");
      }elsif($input eq $H){
         &printHelp;
      }elsif($input eq $HELP){
         &printHelp;
      }elsif($input eq $QUIT){
         last;
      }elsif($input eq $EXIT){
         last;
      }else{
         print "Invalid Command, Enter $HELP for help\n";
      }
      print ":";
   }
#}
#------Helper Methods--------------------------------------------------

sub Server
{
   my $arg = shift;

   if($arg eq "start"){
print "not implemented START yet\n";

   }elsif($arg eq "stop"){
print "not implemented STOP yet\n";

   }elsif($arg eq "stat"){
print "not implemented STATUS yet\n";
   }else{
      return -1;
   }
   return 1;
}

 
sub Pass
{
   my $sName;
   $sName = shift;
   
   #verify $sName is a valid student
      # if not valid, return 0
      
      
   chomp($sName);  # Needs to take off the newline before sending it for password generation
   
   my $pass = Passmod->new();
   #$pass->setSetting("length",$passLength);  # Just commented out for testing.
   #$pass->setSetting("type",$passType);
   #$pass->setSetting("number",$passNumber);

   if($sName eq "all"){
      $sName = "all";
      #for all student in /config/stuendt.txt
      $pass->generate($sName);
   }else{
      $pass->generate($sName);
   }

   0;
}

sub clearPass
{
   my $sName;
   $sName = shift @_;

   #verify $sName is a valid student
      # if not valid return 1
      
   my $pass = Passmod->new();
   $pass->setSetting("length",$passLength);
   $pass->setSetting("type",$passType);
   $pass->setSetting("number",0);

   if($sName eq "all"){
      $sName = "all";
      #for all student in /config/stuendt.txt
      $pass->generate($sName);
   }else {
      $pass->generate($sName);
   }

   return 0;
}


sub Report
{
   my $sName;
   my $report;

   $sName = shift;

   if($sName eq "simple"){
      print "Simple Report requested\n";
   }elsif($sName eq "details"){
      print "Detailed Report requested\n";
   }

}

sub printHelp
{
   print "This is the Main Administrive interface to the SubmitionsSystem\n";

   print "The following commands are recognized\n";
   print "Enter $SERVSTA to start the Submition Server\n";
   print "Enter $SERVSTO to stop the Submition Server\n";
   print "Enter $SERVSTAT to display the current status of the Submition Server\n";
   print "Enter $PASSGENALL to generate NEW passwords for all students\n";
   print "Enter $PASSGEN to generate NEW passwords for a single student\n";

   print "Enter $CPASSALL to clear all passwords for all students\n";
   print "Enter $CPASS to clear all passwords for a single student\n";

   print "Enter $REPS to display the summary results of an assignment report\n";
   print "Enter $REPD to display the detailed results of an assignment report\n";
# what is the name of this exectutable? (main.pl)
   print "Enter $QUIT to quit the AdminClient\n";
   print "Enter $HELP to display this message\n";

   return 0;
}


