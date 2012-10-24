#!/usr/bin/perl
#----------------------------------------------------------------------
#  This file will be incorporated into main.pl  
#
# Comments: make_path will automatically create parent directories, if 
#           they do not exist, i.e. make_path($course."/".$assignment
#           will create $course before creating $assignment if it 
#           doesn't exist.
#----------------------------------------------------------------------
use strict;
use IO::File;
use File::Path 'make_path';

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
	if (@parameter[0] eq "Length") {
		my $passLength = @parameter[1];
	} elsif (@parameter[0] eq "Type") {
		my $passType = @parameter[1];
	} elsif (@parameter[0] eq "Number") {
		my $passNumber = @parameter[1];
	} else {
		die("Errors in $passwordConf file");
	}
}