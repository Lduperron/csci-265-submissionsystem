#!/usr/bin/perl
my $submitSvrName = "passServer";
my $svrPidFileName = "passServer.pid";
my $chkPidFileName = "check.pid";
my $startSvrCmd = "./". $submitSvrName . " &";
my $getPidCmd = "pidof -s /usr/bin/perl ". $submitSvrName ." > ";
my $showSvrPidCmd = "cat ". $submitSvrName;
# check if server not already running
if (-e $svrPidFileName) {			# if the file exists
	unless (-z $svrPidFileName) {	# unless the file is empty 
		@args = ($getPidCmd, $chkPidFileName);
		system(@args);				# get the running server pid	
		
		open(my $chkFile, "<", $chkPidFileName)
			or die("Unable to verify if Submit Server is running.  Please contact support"); 
		while (<$chkFile>) {
			my $cPid = $_;
			chomp($cPid);
			open(my $svrFile, "<", $svrPidFileName)
				or die("Unable to verify if Submit Server is running.  Please contact support"); 
			while (<$svrFile>) {
				my $sPid = $_;
				chomp($sPid);
				if ($cPid == $sPid) {
					# server is already running
					close($svrFile);
					close($chkFile);
					return -1;			# TODO: need to confirm this.
				}
			}
			close($svrFile);
		}
		close($chkFile);
	}	# server pid is not empty
	# the existing server pid file must be old junk - delete it
	unlink($svrPidFileName);
}	# server pid file exists

# fork the process so that we can start the server in the background
my $pid = fork();
if (not defined $pid) {
	print "Unable to start Submit Server. No resources available.\n";
} elsif ($pid == 0) {
	# get the process id of Submit Server
	system($getPidCmd . $svrPidFileName);
	exit(0);
} else {
	# start Submit Server in background
	system($startSvrCmd);
	waitpid($pid,0);
}
# check if pid exists, else error we weren't successful
print "Server started as process ";
system($showSvrPidCmd);
print "\n";
