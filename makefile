nothing:
	@echo "enter 'make stage' create a StageArea"
	@echo "enter 'make clean' to remove your StageArea"

stage: 
	mkdir ../StageArea
	mkdir ../StageArea/bin
	cp -r StageREQ/config ../StageArea/config
	mkdir ../StageArea/bin/Mod
	cp StageREQ/PASS/makefile ../StageArea/bin/Mod/makefile
	cp StageREQ/PASS/Session-Token-0.82.tar.gz ../StageArea/bin/Mod/Session-Token-0.82.tar.gz
	cd ../StageArea/bin/Mod; make

	cp MIClean/main.pl ../StageArea/bin/adminClient
	chmod u+x ../StageArea/bin/adminClient

	cp MIClean/Passmod.pm ../StageArea/bin/Mod/Passmod.pm
	cp MIClean/SubmitServer.pl ../StageArea/bin/Mod/SubmitServer
	chmod u+x ../StageArea/bin/Mod/SubmitServer

	cp MIClean/UserClient.pl ../StageArea/bin/submit
	chmod u+x ../StageArea/bin/submit

	cp MIClean/report.csch ../StageArea/bin/Mod/report
	cp StageREQ/report_evaluate.csch ../StageArea/bin/Mod/report_evaluate
	chmod u+x ../StageArea/bin/Mod/report
	chmod u+x ../StageArea/bin/Mod/report_evaluate

clean:
	rm -f -r ../StageArea
   
cleanStage:
	make clean
	make stage
