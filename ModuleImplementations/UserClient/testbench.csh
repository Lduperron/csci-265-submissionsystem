#!/bin/csh

set test_count = 0
set error_count = 0
set serv = "./testservserofDOOM &"
echo $serv > file.csh
csh file.csh >& dump.txt

#Test 1#####################################################################
echo "BAKC FROM THE DEAD"
set pidofstub
$pidofstub < `pgrep testservserofDOOM` 
echo $pidofstub
foreach F (tinp/*) 
    @ test_count++
    set T = $F:t
      
    `cat tinp/$T` >! tact/$T    

    diff texp/$T tact/$T  
    if ($status) then
        echo Error in test $test_count
        @ error_count++
    endif 
end

set ckill = "killall testservserofDOOM"
echo $ckill > ckill.csh
csh ckill.csh


#Test 2######################################################################
@ test_count++
set F = tinp2/11
set T = ${F:t}      
      
`cat tinp2/$T` >! tact2/$T    

diff texp2/$T tact2/$T   
if ($status) then
    echo Error in test $test_count
    @ error_count++
endif

#Test 3#######################################################################
set pidofstub2
$pidofstub2 < `pgrep stub2`
echo $pidofstub2

@ test_count++
set F = tinp2/12
set T = ${F:t}      
      
`cat tinp2/$T` >! tact2/$T    

diff texp2/$T tact2/$T   
if ($status) then
    echo Error in test $test_count
    @ error_count++
endif 

set ckill = "killall stub2"
echo $ckill > ckill.csh
csh ckill.csh

echo UserClient Test Results:
echo $test_count tests were performed with $error_count errors found.
