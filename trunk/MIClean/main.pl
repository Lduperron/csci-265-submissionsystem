#!/usr/bin/perl
#
#  1 = sucsess
#  0 = fail
#
#  functions return success status. ie. (1 == good)
#
#


$| = 1;

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin"; # Adds the module folder into the libary string so that it can find PasswordGen (in case we're running the script from a different directory

use IO::File;
use File::Path 'make_path';
use Mod::Passmod;

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

# define all config variables used
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
   my $studentsConf = $configPath . "StudentConfig.txt";	# studentname:enrolled_course:...\n
   my $coursesConf = $configPath . "CourseConfig.txt";		# coursename\n
   my $passwordConf = $configPath . "PasswordConfig.txt";	# Length:<LENGTH>\n Type:<[alnum,num]>\n Number:<Number>

# Define default settings for make_path
   my $verbose = 1;		# 1 = print name of dir when created, 0 = do not print dir
   my $mode = "0777";		# TODO: what does this mean? - user full, group read, everyone read?
   my %mpOptions = ("verbose",$verbose);
   #print {%mpOptions};
# read Courses Config file
   open(my $courses, "<", $coursesConf)
	or die("Unable to open file ". $coursesConf);

# create course and assignment directories
   while (<$courses>) {
	   my $course = $_;
	   chomp($course);
	   make_path($coursesPath.$course, {%mpOptions});

	# read assignments file for current course
	   open(my $assignments, "<", $assignmentsPath.$course.".txt")
		   or die("Unable to open file ". $assignmentsPath.$course .".txt");

	# create assignments, tinp, and texp directories
	   while (<$assignments>) {
		   my @assignment = split(':', $_);
		   my $assignment = shift(@assignment);
		   make_path($coursesPath.$course."/".$assignment."/tinp", {%mpOptions});
		   make_path($coursesPath.$course."/".$assignment."/texp", {%mpOptions});
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
	   #make_path($studentsPath.$student, {%mpOptions});

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
			   make_path($coursesPath.$course."/".$assignment."/".$student."/tact", {%mpOptions});
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
         print "Generate new passwords for student:\n";
         while(<>){
            if(&Pass($_) == 0){
               # it failed, bad input, loop again
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
#----------------------------------------------------------------------
#		Server
#		Start, Stop and show status of Submit Server
#----------------------------------------------------------------------
sub Server
{
# Define Submit Server defaults
	my $submitSvrName = "Mod/SubmitServer.pl";
	my $svrPidFileName = "SubmitServer.pid";
	my $startSvrCmd = "./". $submitSvrName . " &";
	my $getPidCmd = "pidof -s /usr/bin/perl ". $submitSvrName ." > ";
	my $showSvrPidCmd = "cat ". $svrPidFileName;

   my $arg = shift;

   if($arg eq "start"){
   	if (my $status = &getSvrStatus($submitSvrName, $svrPidFileName, $getPidCmd)) {	
   	# if the server is running
			print "Server is already running\n";
			return 1;
		}

		# fork the process so that we can start the server in the background
		my $pid = fork();

		if (not defined $pid) {
			print "Unable to start Submit Server. No resources available.\n";
			return 1;
		} elsif ($pid == 0) {
			# get the process id of Submit Server
			system($getPidCmd . $svrPidFileName);
			exit(0);
		} else {
			# start Submit Server in background
			system($startSvrCmd);
			waitpid($pid,0);
		}

   	if (my $status = &getSvrStatus($submitSvrName, $svrPidFileName, $getPidCmd)) {	
   	# if the server is running
			print "Server started as process ";
			system($showSvrPidCmd);
			print "\n";
		} else {
			print "Server failed to start\n";
		}
		return 1;
				
   }elsif($arg eq "stop"){
		my $pid;
		# check if server not already running
   	if (my $status = &getSvrStatus($submitSvrName, $svrPidFileName, $getPidCmd)) {	
   	# if the server is running
			open(my $svrFile, "<", $svrPidFileName)
				or die("Unable to verify if Submit Server is running.  Please contact support\n"); 

			my @pid = <$svrFile>;
			$pid = @pid;
			chomp($pid);
			close($svrPidFileName);
			
			kill('TERM', $pid);				# try to stop it using TERM first - it's cleaner
			unlink($svrPidFileName);		# get rid of the server pid file    
			sleep(2);							# wait 2 secs to see if it terminates
		} else {
			print "Submit Server is not running\n"; 
			return 1; 
		}	

		# check if kill worked
		if (my $status = &getSvrStatus($submitSvrName, $svrPidFileName, $getPidCmd)) {	
		# if the server is running
			kill('KILL', $pid);					# kill it - forcefully
		}
		unlink($svrPidFileName);			# get rid of the server pid file    
		print "Submit Server stopped\n";
		return 1;
		
   }elsif($arg eq "stat"){
   	# get Submit Server Status
   	if (my $status = &getSvrStatus($submitSvrName, $svrPidFileName, $getPidCmd)) {
		# if the server is running
			print "Submit Server [RUNNING] at process id ";
			system($showSvrPidCmd);
			print "\n";
		} else {
			print "Submit Server [STOPPED]\n";
		}
		return 1;

   }else{
      return -1;
   }
   return 1;
}
#----------------------------------------------------------------------
#		getSvrStatus
#		return 1 if server is running, else 0
#----------------------------------------------------------------------
sub getSvrStatus {
	my $chkPidFileName = "check.pid";
	my $submitSvrName = $_[0];
	my $svrPidFileName =  $_[1];
	my $getPidCmd =  $_[2];

# put the running server pid into a check file
	my @args = ($getPidCmd, $chkPidFileName);
	system(@args);

	if (-e $chkPidFileName) {				# if the file was created
		if (-z $chkPidFileName) {			# but its empty - there's no server
			if (-e $svrPidFileName) {		# if the server pid file exists
				unlink ($svrPidFileName);	# delete it - there's no server
				unlink($chkPidFileName);	# get rid of temp file
				return 0;
			}
		} else {		# the check file is not empty
			# we have a server running!
			move($chkPidFileName, $svrPidFileName);	# rename the file, 
																	# will clobber existing svr file
			return 1;
		}
	}
	return 0;		# no server found
}

 
sub Pass
{
   my $sName;
   $sName = shift;

   chomp($sName);

   my $pass = Passmod->new();
   $pass->setSetting("length",$passLength);
   $pass->setSetting("type",$passType);
   $pass->setSetting("number",$passNumber);
   $pass->setSetting("carboncopy",0);

   open(my $students, "<", $studentsConf)
	   or die("Unable to open file ". $studentsConf);

   if($sName eq "all"){
      while (<$students>) {
	      my @student = split(':', $_);
	     $sName = shift(@student);
	      chomp($sName);
         if($pass->generate($sName)){

         }else{
            print "Error generating passwords for student $sName\n";
         }
      }
      return 1;
   }else{
      while (<$students>) {
	      my @student = split(':', $_);
	      my $tmpStudent = shift(@student);
	      chomp($tmpStudent);
         if($sName eq $tmpStudent){
            $pass->generate($sName);
            return 1;
         }
      }
      print "Error generating passwords for student $sName\n";
      return 0;
   }
}

sub clearPass
{
   my $sName;
   $sName = shift;

   chomp($sName);

   my $pass = Passmod->new();
   $pass->setSetting("length",$passLength);
   $pass->setSetting("type",$passType);
   $pass->setSetting("number",0);
   $pass->setSetting("carboncopy",0);

   open(my $students, "<", $studentsConf)
	   or die("Unable to open file ". $studentsConf);

   if($sName eq "all"){
      while (<$students>) {
	      my @student = split(':', $_);
	     $sName = shift(@student);
	      chomp($sName);
         if($pass->generate($sName)){

         }else{
            print "Error generating passwords for student $sName\n";
         }
      }
      return 1;
   }else{
      while (<$students>) {
	      my @student = split(':', $_);
	      my $tmpStudent = shift(@student);
	      chomp($tmpStudent);
         if($sName eq $tmpStudent){
            $pass->generate($sName);
            return 1;
         }
      }
      print "Error generating passwords for student $sName\n";
      return 0;
   }
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
	print "\033[2J";    		#clear the screen
	print "\033[0;0H"; 		#jump to 0,0

   print "__________________________________________________________________________\n\n";
   print "           Submission System  -  Main Administrative Interface\n";
   print "__________________________________________________________________________\n";
   print "The following commands are recognized:\n\n";
   
   print "$SERVSTA \tStart the Submission Server\n";
   print "$SERVSTO \tStop the Submission Server\n";
   print "$SERVSTAT \tDisplay the current status of the Submission Server\n\n";
   
   print "$PASSGENALL \tGenerate NEW passwords for ALL students\n";
   print "$PASSGEN \tGenerate NEW passwords for a SINGLE student\n\n";

   print "$CPASSALL \tClear all passwords for ALL students\n";
   print "$CPASS \t\tClear all passwords for a SINGLE student\n\n";

   print "$REPS \tDisplay the SUMMARY results of an assignment report\n";
   print "$REPD \t\tDisplay the DETAILED results of an assignment report\n\n";
# what is the name of this exectutable? (main.pl)
   print "$QUIT \t\tQuit the Admin Client\n";
   print "$HELP \t\tDisplay this message\n";
   print "__________________________________________________________________________\n";

   return 0;
}


