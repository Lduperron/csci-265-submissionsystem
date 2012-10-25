nothing:
	echo "enter 'make stage' create a StageArea"
	echo "enter 'make clean' to remove your StageArea"

stage: 
	mkdir ../StageArea
	cp -r StageREQ/bin ../StageArea/bin
	cp -r StageREQ/config ../StageArea/config
	mkdir ../StageArea/bin/Mod
	cp StageREQ/PASS/makefile ../StageArea/bin/Mod/makefile
	cp StageREQ/PASS/Session-Token-0.82.tar.gz ../StageArea/bin/Mod/Session-Token-0.82.tar.gz
	tar -xf ../StageArea/bin/Mod/Session-Token-0.82.tar.gz ../StageArea/bin/Mod/Session-Token-0.82
	cd ../StageArea/bin/Mod/Session-Token-0.82 ; perl Makefile.PL ; make ; cp -r blib/arch/auto $
	rm -rf ../StageArea/bin/Mod/Session-Token-0.82
	cp MIClean/main.pl ../StageArea/bin/main.pl
	cp MIClean/Passmod.pm ../StageArea/bin/Mod/Passmod.pm
	cp MICLean/SubmitServer.pl ../StageArea/bin/Mod/SubmitServer.pl

clean:
	rm -f -r ../StageArea
   
