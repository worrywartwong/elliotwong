#!/usr/bin/perl
#  test 'open' call to various directories


use strict;
use CGI qw/:standard/;
use CGI::Carp 'fatalsToBrowser';

my $cgi = new CGI;


#debug output. Switch on for verbose.
my $Debug;

#$Debug = 0;
$Debug = 1;

print $cgi->header();


#js_alert("Hello there");


# ====================================================
# run thru various target directories.  Print errors.
# ====================================================

my $Target;
my $Name = "test.txt";		# try opening this file in various directories


#direct path to the target directory, we'd like to use. (rwxrwxrwx)
$Target = "http://francesbrann.com/downloads";
test_open ( $Target, $Name );

#yes!
$Target = "../httpdocs/downloads";
test_open ( $Target, $Name );

#direct path to a test directory (rwxrwxrwx)
$Target = "http://francesbrann.com/dl1";
test_open ( $Target, $Name );

#yes!
$Target = "../httpdocs/dl1";
test_open ( $Target, $Name );


#call via the hostname URL - to target directory 
$Target  = "http://site9.apollohosting.com/francesbrann.com/downloads";
test_open ( $Target, $Name );

#call via the hostname URL - to a test directory (rwxrwxrwx)
$Target  = "http://site9.apollohosting.com/francesbrann.com/dl1";
test_open ( $Target, $Name );

#call via https to target directory
$Target = "https://site9.apollohosting.com/francesbrann.com/httpdocs/downloads";
test_open ( $Target, $Name );

#call via https to test directory
$Target = "https://site9.apollohosting.com/francesbrann.com/httpdocs/dl1";
test_open ( $Target, $Name );

# where is sendmail?
$Name = "sendmail";
$Target = "/usr/lib";
test_file ( $Target, $Name );

$Target = "/usr/sbin";
test_file ( $Target, $Name );

# ===============================================================
# try directories directly.
# ===============================================================
#what about the top level dirs?
$Target = "http://francesbrann.com/cgi-bin";
test_dir($Target);

$Target = "/cgi-bin";
test_dir($Target);

#yes
$Target = "../cgi-bin";
test_dir($Target);

$Target = "../downloads";
test_dir($Target);

#yes
$Target = "../httpdocs";
test_dir($Target);

#yes
$Target = "../httpdocs/downloads";
test_dir($Target);



#======================================================
# Subroutines
#======================================================
sub test_open		# ($target, $name)
{
	#just test to see if an open call will succeed.
	#in: $target == a directory
	#    $name   == a test file name.

	my ($target, $name) = @_;

	print "<br>";

	#test existence of the directory.
	print "$target is ";
	unless ( -d $target )
	{
		print "NOT ";
	}
	
	print "a directory<br>";

	#make a directory + name.
	$target .= '/' . $name;

	if ( !open(LOCAL, "> $target")) 
	{
		print ("error opening LOCAL as $target <br>$!<br>") if ( $Debug );
	}
	else
	{
		if ( $Debug )
		{
			print "success! opened LOCAL as $target<br>";
		}

		close(LOCAL);
	}
}

sub test_dir		# ($target)
{
	my $target = shift(@_);

	print "<br>";
	print "$target (dir) is ";
	unless ( -d $Target )
	{
		print "NOT ";
	}

	print "a directory<br>";
}

sub test_file 		# ($target, $name)
{
	my ($target, $name) = @_;

	$target .= '/' . $name;

	print "<br>$target is ";
	unless ( -f $target )
	{
		print "NOT ";
	}

	print "a file<br>";
}

sub js_alert		# ( smsg )
{
	my $msg = shift(@_);

	print <<END_JSALERT
	<script language="JavaScript" type="text/JavaScript">
		alert(\"$msg\");
	</script>

END_JSALERT
}

#=======================================================
sub js_location		# ( new_url )
{
	my $url = shift(@_);	# the new url.

	print <<END_JSLOCATION
	<script language="JavaScript" type="text/JavaScript">
		location.replace( \"$url\" );
	</script>

END_JSLOCATION
}

