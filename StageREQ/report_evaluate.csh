#!/bin/csh
#Receives input from report csh script
# argument 1 = course
# argument 2 = assignment
# argument 3 = student name
set courseDir = ../courses/$1/$2
set course = $1
set assignement = $2
set sName = $3
set errorCount = 0
rm $courseDir/$3/tact/*
mkdir $courseDir/$3/tact

rm $courseDir/$3/errors.txt
rm $courseDir/$3/summary.txt
cp $courseDir/makefile $courseDir/$3/makefile
(cd $courseDir/$3; make -f makefile)
set numOfCases = `ls -l $courseDir/tinp | wc -l`; 
@ numOfCases = $numOfCases - 1; 
set coursecounter = 0;
while($coursecounter < $numOfCases)
      set line = `cat $courseDir/tinp/$coursecounter.txt`
      $courseDir/$3/$line >>& $courseDir/$3/tact/$coursecounter.txt
      diff -f $courseDir/texp/$coursecounter.txt $courseDir/$3/tact/$coursecounter.txt   
     if($status != 0) then
         @ errorCount++
         diff $courseDir/texp/$coursecounter.txt $courseDir/$3/tact/$coursecounter.txt >>& $courseDir/$3/errors.txt
      endif
      @ coursecounter++
end
echo "Number of test cases ran: $numOfCases" >> $courseDir/$3/summary.txt
echo "Number of errors encountered: $errorCount" >> $courseDir/$3/summary.txt