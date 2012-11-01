#!/bin/csh
# argument 1 = course
# argument 2 = assignment
# argument 3 = student name
# argument 4 = is detailed, 0=no, 1=yes
set myHome = Mod
set course = $1
set assignement  = $2
set sName = $3


rm -f $myHome/reportlog.txt

(./$myHome/report_evaluate $1 $2 $3) >>& $myHome/reportlog.txt


