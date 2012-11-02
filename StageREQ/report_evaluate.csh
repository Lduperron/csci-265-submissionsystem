#!/bin/csh
#Receives input from report csh script
# argument 1 = course
# argument 2 = assignment
# argument 3 = student name
set courseDir = ../courses/$1/$2
set course = $1
set assignement  = $2
set sName = $3
set errorCount = 0
rm $courseDir/$3/tact/*

rm $courseDir/$3/errors.txt
rm $courseDir/$3/summary.txt 
cp $courseDir/makefile $courseDir/$3/makefile
make -f $courseDir/$3/makefile
make clean -f $courseDir/$3/makefile

set numOfCases = `ls -l $courseDir/tinp | wc -l`
@ numOfCases-- 
set coursecounter = 0;
while($coursecounter < $numOfCases)
   foreach line(cat ./$courseDir/tinp/$coursecounter.txt)
      ./$courseDir/tinp/$line >> ./$courseDir/$3/tact/$coursecounter.txt
         
     if({ diff -f ./$courseDir/texp/$coursecounter.txt ./$courseDir/$3/tact/$coursecounter.txt } != 0) then
         @ errorCount++
         diff ./$courseDir/texp/$coursecounter.txt ./$courseDir/$3/tact/$coursecounter.txt >> ./$courseDir/$3/errors.txt
      endif
      @ coursecounter++
   end
end
echo "Number of test cases ran: $numOfCases" >> $courseDir/$3/summary.txt
echo "Number of errors encountered: $errorCount" >> $courseDir/$3/summary.txt
