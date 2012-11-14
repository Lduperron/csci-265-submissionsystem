#! /bin/csh

#$| = 1;

set test_count
set error_count
@ test_count = 0
@ error_count = 0

   rm -f errors.txt
   rm -f summary.txt

foreach F (tinp/*)
   rm -f tact/$F:t
   
   @ test_count++
# the back quotes are the key
   set switch = `cat $F`

   ./rndpassword $switch >& tact/$F:t
   echo >> errors.txt
# prints a new line to errors.txt


   ./custDiff.pl tact/$F:t texp/$F:t >> errors.txt
   if ($status) then
      @ error_count = $error_count + 1
      echo $F:t " FAIL">> errors.txt
   else
      echo $F:t " PASS">> errors.txt
   endif





end #end for loop

echo "**********Summary**********" > summary.txt
echo "Total number of test case = " $test_count >> summary.txt
echo "Total number of test cases in error = " $error_count >> summary.txt 

cat summary.txt







