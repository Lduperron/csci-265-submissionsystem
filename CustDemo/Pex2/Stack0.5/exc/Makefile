# Makefile to drive cew testing of Perl modules
# P Walsh Feb 2012

# Targets
#   bats --- make batch tester from tb.cew
#   clean
#   submit

# directory where scripts are located and temp files
SD=CewDir

# code beautifier 
INDENT=cat

bats: tb.pl
	perl tb.pl

tb.pl: tb.cew $(SD)/bin/cew.pl
	rm -f $(SD)/tmp/tb.num
	rm -f ./tb.pl
	awk -f $(SD)/bin/addLineNums.awk tb.cew > $(SD)/tmp/tb.num
	m4 -B20000  $(SD)/tmp/tb.num  | $(INDENT) > tb.pl

clean:
	rm -f  $(SD)/tmp/* tb.pl

submit:
	echo "submit not set up"
