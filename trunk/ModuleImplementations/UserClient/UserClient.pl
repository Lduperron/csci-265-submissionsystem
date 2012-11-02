#!/usr/bin/perl

$| = 1;

use IO::Socket; 
use warnings;

$sock = new IO::Socket::INET (
                              PeerAddr => 'localhost',
                              PeerPort => '8585', 
                              Proto => 'tcp'
                             );
#If a socket cannot be created the program prints out "Error: Unable to 
#connect to the submission server.\n" to STDOUT and exits the program 
#with a value of 1 since the program failed to submit a program.
if (!$sock) {
        print "Error: Unable to connect to the submission server.\n";
        exit(1);
}

#NOTE: It is assumed that the user will provide the username, password, class name,
#and file name parameters into the command line in the proper order.
if (scalar(@ARGV) == 0) {
    #If no command line arguments are received the program outputs an error 
    #message to STDOUT and exits the program with a value of 1 since no files were 
    #submitted.
    print "Error: No username, password, class name, or file name submitted.\n"; 
    exit(1);
} elsif (scalar(@ARGV) == 1) {
    #If 1 command line argument is provided the program assumes that password,
    #class name, and file name were not submitted.  The program therefore
    #outputs an error message to STDOUT and exits the program with a value of
    #1 since no file was submitted. 
    print "Error: No password, class name, or file name submitted.\n";
    exit(1);
} elsif (scalar(@ARGV) == 2) {
    #If 2 command line arguments are provided the program assumes that
    #class name and file name were not submitted.  The program 
    #therefore outputs an error message to STDOUT and exits the program
    #with a value of 1 since no file was submitted.
    print "Error: No class name or file name submitted.\n";
    exit(1);
} elsif (scalar(@ARGV) == 3) {
    #If 3 command line arguments are provided the program assumes that
    #no file name was submitted.  The program therefore outputs an error 
    #message to STDOUT and exits the program with a value of 1 since
    #no file was submitted.
    print "Error: No file name submitted.\n";
    exit(1);
} elsif (scalar(@ARGV) >= 5) {
    #If 5 or more parameters were provided the program has received too
    #many input values.  It therefore prints out an error message to 
    #STDOUT and exits with a value of 1 since the program was unable to
    #submit a file.
    print "Error: Too many input parameters.\n";
    exit(1);
}

#Joins username, password, and class name into a single scalar with
#a : between $ARGV[0] and $ARGV[1] and $ARGV[1] and $ARGV[2].
#NOTE:
#$ARGV[0] = username
#$ARGV[1] = password
#$ARGV[2] = class name

$tline = join(":", $ARGV[0], $ARGV[1], $ARGV[2]);

#Split the file name provided by the user at the / and stores the 
#results in the array tmpFile
#NOTE:
#$ARGV[3] = filename
@tmpFile = split('/', $ARGV[3]); 

#Grabs the last value out of @tmpFile which should be the name of
#the file to be submitted
$fname = $tmpFile[(scalar(@tmpFile)-1)];

#Store $tline and $fname into the holding array @tmpArr
@tmpArr = ($tline, $fname);

#Open the file name in $ARGV[3] with the file handle DATA
#If the file cannot be opened an error message is output
#and the program exits with a value of 1 since no file
#was submitted.
if (!open(DATA, $ARGV[3])) {
    print "Can't open $ARGV[3] $!\n";  #hard enough??
    exit(1);
}

#'0' is a placeholder for $sizeArr that will be calculated 
#later in the code
$tmpArr[2] = '0';

#Go through the file in DATA line by line and copy said line
#into the array @tmpArr
for ($i = 3; <DATA>; $i++) {

     $tmpArr[$i] = $_;

}  

close DATA;

#Calculates the size of the file.  -3 is included since
#three items in the array are not related to the file and
#thus should not be calculated in its (the files) size
$sizeArr = scalar(@tmpArr) - 3;

#Store $sizeArr in the @tmpArr at the array element occupied
#by the placeholder.
$tmpArr[2] = $sizeArr."\n";

#Send the user name, password, and class name to the server
print $sock "$tmpArr[0]\n";

#Grab a line out of the socket and remove its new line 
#character
$valid = <$sock>;
chomp($valid);

#If the username, password, and class name are valid move
#into the conditional statement.  Otherwise, proceed the 
#server code evaluation conditional block.
if($valid eq "400")
{
   #Send file name to the server, receive a result from the server, 
   #and remove its new line character
   print $sock "$tmpArr[1]\n";
   $valid = <$sock>;
   chomp($valid);
   
   #If the file name is valid proceed into the conditional block
   if($valid eq "400")
   {

      #Pass the file in @tmpArr line by line to the server
      for ($i = 2; $i < scalar(@tmpArr); $i++) 
      {
          print $sock "$tmpArr[$i]";
      }
      #Send an end of file to the server so it knows to stop receiving
      #data
      print $sock "^D\n";
      
      #Get the code returned by the server and remove its new line
      #character
      $valid = <$sock>;
      chomp($valid);
      
   }
}


#Evaluate the codes passed from the server
if (defined($valid)) { 
    if ($valid eq "0") { 
        print "Error: Username/password is not valid.\n";

    } elsif ($valid eq "1") { 
        print "Error: Class name is not valid.\n";

    } elsif ($valid eq "2") {
        print "Error: Filename is not valid.\n";

    } elsif ($valid eq "3") {
        print "Error: Assignment is late.\n";

    } elsif ($valid eq "4") {
        print "File submit failed.\n";

    } elsif ($valid eq "5") {
        #If the file submit was successful print a success message
        #to STDOUT, close the socket and exit with 0 since a file 
        #was submitted.
        print "File submit successful.\n";
        close($sock);
        exit(0);
    }
    
    #If one of the conditional blocks above containing an error code
    #has their contents printed close the socket and exit with a 
   #value of 1 since no file was submitted. 
    close($sock);
    exit(1);
}

#If the function gets here it must have failed so exit
#with a value of 1 since no file submit has occurred
exit(1); 