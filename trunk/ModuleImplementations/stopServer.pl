#!/usr/bin/perl
my $submitSvrName = "passServer";
my $svrPidFileName = "passServer.pid";
my $chkPidFileName = "check.pid";
my $startSvrCmd = "./". $submitSvrName . " &";
my $getPidCmd = "pidof -s /usr/bin/perl ". $submitSvrName ." > ";
my $showSvrPidCmd = "cat ". $submitSvrName;

my $pid;
# check if server not already running
if (-e $svrPidFileName) {			# if the file exists
	open(my $svrFile, "<", $svrPidFileName)
		or die("Unable to verify if Submit Server is running.  Please contact support"); 

	while (<$svrFile>) {
		$pid = $_;
		chomp($pid);
		kill('TERM', $pid);             # try to stop it using TERM first - cleaner
	    sleep(2);                       # wait 2 secs to see if it terminates
    }
    close($svrPidFileName);
    unlink($svrPidFileName);		# get rid of the server pid file
} else {
	return "Submit Server is not running";  # TODO: confirm this 
}	

# check if kill worked
# get the process id of Submit Server
system($getPidCmd . $svrPidFileName);

if (-e $svrPidFileName && -z $svrPidFileName) {		# if true, the server is still running
# TODO: this could be a different server, but shouldn't be
    unlink($svrPidFileName);		# get rid of the server pid file    
	kill('KILL', $pid);								# kill it forcefully
}
print "Submit Server stopped";


