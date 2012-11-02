USER MANUAL - CSCI265 Submssion System:
==================================================
Table of Contents:
   1.  Introduction
   2.  Getting Started
   3.  Normal Operation
   4.  Available Commands
   4.  Troubleshooting
   5.  Appendix
==================================================
   

   
==================================================
1.  INTRODUCTION
==================================================

Thank you for using the CSCI 265 Submission System!

==================================================
2.  GETTING STARTED
==================================================

Included in this package along with this readme
there is a makefile and a compressed tar.  The makefile
will extract the submission system to the parent folder, 
so please move this folder to the desired installation
directory.  Once you have the folder located in the
correct location, type 'make' and wait while the 
system extracts itself.  Once the extraction completes,
you should modify the config files before executing 
the adminfiles, as the adminclient will create a directory
structure on each run.  The config files come with a default
setup that is used for demonstration.

Configuration you need to do:
   Define your courses in config/CourseConfig.txt, with one course
   on each line
   
   Add assignments to each course, by making a .txt file in
   config/courses with the name of the course.  In that file, 
   one assignment per line, then a : followed by a YYYYMMDD
   due date.
   
   Change the default password settings if you desire
   
   Add students to config/StudentConfig.txt.  One student 
   per line, and the courses that they are allowed to submit 
   files to delimited by :
   
Then, run adminclient to build the directory structure.  The directory
structure will be appended to if you add new courses or assignments on 
any previous runs.

Next, ensure the port in adminclient is not in use on your system.  If it is,
change it to another and then change the matching port in the UserClient that
you distrubute to students.

The copy of UserClient that will be distributed to students must have the 
server's IP or hostname set it in before distrubtion; alternatively, students
can enter it themselves if provided.  

Finally, in the adminclient, you must generate passwords for students.  These
passwords will be put in the students/ folder and should be distrubted so that 
students can submit assignments.

==================================================
3.  NORMAL OPERATION
==================================================

   The server can be started from within adminclient or via running SubmitServer
   from within the bin/Mod directory directly.  Once runnning, it will recieve
   files from students until stopped.  
   
   The proper synxtax for submitting a file to the server is
   ./submit [username] [password] [course] [filename]
   
   Before reports can be generated, the testbench system must be customized for that
   assignment.  After this has been completed, automated tests and reports can be generated
   using the report command.
   
   Adding new students or courses can be accompished simply by appending them to the correct
   files in the config file and starting the adminclient, which will automatically build the
   folders for them.  Passwords must be generated one by one for new students, however, to avoid
   invalidiating passwords for previouslly existing students.

==================================================
4.  AVAILABLE COMMANDS
==================================================

SERVSTART:  Starts the server

SERVSTOP:  Stops the currently running server

SERVSTAT:  Gets the status of the server.  (UP/DOWN)

PASSGENALL:  (Re)generates passwords for all students

PASSGEN: (Re)generates passwords for a student

CPASSALL:  Clears the passwords for all students

CPASS:   Clears the password for a specific student

REPORT:  Generates a report on a specific student's
         submission

QUIT:  Exits the adminclient.  If started, the server
       is independent and not effected by exiting.

EXIT:  Same as quit.

HELP:  Prints out a help menu inside adminclient

==================================================
5.  TROUBLESHOOTING
==================================================

   Error:  There are extra courses and students in the directory tree, such as 'beth'
   Solution:  Delete the predefined users and courses before starting the adminclient.
   If they already exist, remove folders other than /bin and /config, edit the files,
   and then restart the admin client.

   Error:  Students get "Error: Unable to connect to the submission server"
   when attempting to submit files
   Solution:  Verify that you have correctly set the port/Peer Address in the
   userclient before distrubiting, or have instructed students on the correct values.
      
   Error:  Students get invalid username/password when submitting
   Solution:  Ensure students are reading passwords from top to bottom and are crossing out
   a used password.  A password is considered used not only when a file is submitted, but when
   a student gets any message except for 'invalid username/password' or 'unable to connect to server'
   
   Error:  Automated testing does not work, or works in unexpected ways.
   Solution:  Ensure that you have customized the testbench for the specific filetype and assignment
   that is being submitted.
   
==================================================
6.  APPENDIX
==================================================
This system produced by:
     Lochlin Duperron
     Oliver Jourmel
     Marius Loots
     Matthew Cormons
     Meara Kimball
     Evan Seabrook 