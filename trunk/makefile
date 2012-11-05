nothing:
	@echo "Enter 'make install' create a SubmissionSystem"
	@echo "Enter 'make uninstall' to remove your SubmissionSystem"

install: 
	mkdir ../SubmissionSystem
	mkdir ../SubmissionSystem/bin
	cp -r StageREQ/config ../SubmissionSystem/config
	mkdir ../SubmissionSystem/bin/Mod
	cp StageREQ/PASS/makefile ../SubmissionSystem/bin/Mod/makefile
	cp StageREQ/PASS/Session-Token-0.82.tar.gz ../SubmissionSystem/bin/Mod/Session-Token-0.82.tar.gz
	cd ../SubmissionSystem/bin/Mod; make

	cp MIClean/main.pl ../SubmissionSystem/bin/adminClient
	chmod u+x ../SubmissionSystem/bin/adminClient

	cp MIClean/Passmod.pm ../SubmissionSystem/bin/Mod/Passmod.pm
	cp MIClean/SubmitServer.pl ../SubmissionSystem/bin/Mod/SubmitServer
	chmod u+x ../SubmissionSystem/bin/Mod/SubmitServer

	cp MIClean/UserClient.pl ../SubmissionSystem/bin/submit
	chmod u+x ../SubmissionSystem/bin/submit

	cp MIClean/report.csh ../SubmissionSystem/bin/Mod/report
	cp StageREQ/report_evaluate.csh ../SubmissionSystem/bin/Mod/report_evaluate
	chmod u+x ../SubmissionSystem/bin/Mod/report
	chmod u+x ../SubmissionSystem/bin/Mod/report_evaluate

uninstall:
	@echo "Are you sure you want to REVOME the SubmissionSystem?"
	@echo "Type make uninstallConfirm to REMOVE the SubissionSystem"

uninstallConfirm:
	make remove

remove:
	rm -f -r ../SubmissionSystem
   
reinstall:
	make remove
	make install
