#!/usr/bin/perl
# call as: 
#  http://francesbrann/cgi-bin/do-upload.pl
# home diretory:
#  /home/frances/httpdocs
# perl is at /usr/bin/perl
# sendmail is at /usr/sbin/sendmail (Apollo Hosting)
#
# pick up downloads at:
#  http://francesbrann/downloads/


use strict;
use CGI qw/:standard/;
use CGI::Carp 'fatalsToBrowser';
$CGI::POST_MAX=1024 * 1024 * 40;  # max 40MB posts
use Digest::MD5 qw(md5_hex);

my $cgi = new CGI;

my $your_name = $cgi->param('your_name');
my $user = $cgi->param('user');
my $password = $cgi->param('password');
my $file0 = $cgi->param('file0');
my $file1 = $cgi->param('file1');
my $file2 = $cgi->param('file2');
my $file3 = $cgi->param('file3');

my $webmaster = "webmistress\@francesbrann.com";

#note: verio requires a valid from address:!!
my $from_user = "webmistress\@francesbrann.com";

#=========================================================
# set the username & password for uploads, here!
#=========================================================
my $UploadPassword = '44d65487ce1f28447794e0e694e9f99a';
my $UploadUsername = 'frances';
#=========================================================

chomp($user);
chomp($password);

#debug output. Switch on for verbose.
my $Debug;

$Debug = 0;
#$Debug = 1;

print $cgi->header();

if ( $Debug )
{
	print "Incoming your_name = $your_name<br>";
	print "Incoming user = ($user)<br>";
	print "Incoming password = ($password)<br>";
	print "Incoming file0 = $file0<br>";
	print "Incoming file1 = $file1<br>";
	print "Incoming file2 = $file2<br>";
	print "Incoming file3 = $file3<br>";
	print "<br>";

	print "webmaster = $webmaster<br>";
	print "from_user = $from_user<br>";
}

#js_alert("Hello there");

#check valid user/password (you set these, above)
unless ( $user eq $UploadUsername && md5_hex($password) eq $UploadPassword )
{
	error_out( "Invalid user/password" );
}


# ====================================================
# run thru $file0, $file1, $file2, $file3
# ====================================================

my $totalbytes = 0;
my $cur_file;
my $file_list;
my $target;

foreach $cur_file ($file0, $file1, $file2, $file3)
{
	my $file = $cur_file;
	last if ( !$file );

	if ( $Debug )
	{
		print "file = $file<br> cur_file = $cur_file<br>";
	}

	#append current file onto comma separated list of files.
	if ( $file_list )
	{
		$file_list .= ", ";
	}

	$file_list .= $file;

	$file=~m/^.*(\\|\/)(.*)/; # strip the remote path and keep the filename
	my $name = $2;

	# Mozilla
	if ( length($name) == 0 )
	{
		$name = $file;
	}

	#substitute underscore for any spaces.
	$name =~ s#\s#_#g;

	#unix - Apollo Hosting requires this form.
	$target = "../httpdocs/downloads/$name";

	if ( $Debug )
	{
		print "rootname = $name<br>";
		print "target = $target<br>";
	}

	if ( !open(LOCAL, "> $target")) 
	{
		print ("error opening LOCAL as $target<br>") if ( $Debug );
		error_out("open [$target] fails. $!");
	}

	if ( $Debug )
	{
		print "past open LOCAL<br>";
	}

	#=============================================================
	# upload the file.
	#=============================================================
	my $buffer;
	my $bytesread;

	#error out if bad file, or user presses CANCEL.
	if (!$file || $cgi->cgi_error) 
	{
		print "erroring out<br>" if ($Debug);
		print "cgi_error = $cgi->cgi_error<br>" if ($Debug);
		error_out( "no file [$file]? or CANCEL.  $cgi->cgi_error" );
	}

	if ( $Debug )
	{
		print "past error_out<br>";
	}

	binmode( $file );
	binmode( LOCAL );

	while ($bytesread=read( $file, $buffer, 1024*4)) 
	{
		$totalbytes += $bytesread;
		print LOCAL $buffer;
	}

	close(LOCAL);

}

#=============================================================
# send email, alerting webmaster
#=============================================================
print "start master_send_mail( $file_list, totalbytes = $totalbytes )<br>" if ( $Debug );
master_send_mail( $file_list, $totalbytes );
print "<br>past master_send_mail<br>" if ( $Debug );

print "<br>start user_ack<br>" if ( $Debug );
user_ack();
print "<br>past user_ack<br>" if ( $Debug );


exit(0);


#=============================================================
# Subroutines
#====================================================================
# acknowledge file send.
sub user_ack
{
	#start new command.
	#doesn't work.
	#print $cgi->end_html() if ( $Debug );

	#NT
	#print ("Location: ./thanx.html\n\n");

	#Unix thanx.html
	#print ("Location: ../httpdocs/thanx.html\n\n");

	#problems with redirect from https to regular http.
	#load new page via javascript window.location command.
	js_location("http://www.francesbrann.com/thanx.html");


}

#====================================================================
#mail to webmaster

sub master_send_mail    #( string filename(s), int totalbytes )
{
	my $fnames = shift(@_);
	my $total_bytes = shift(@_);
	my $subject = "New File(s) were uploaded";

	if ( $total_bytes eq "" )
	{
		$total_bytes = "0";
	}

	open (MAIL, "| /usr/sbin/sendmail -tf $webmaster")
	  || die "Message NOT sent!  Unable to open pipe to sendmail.\n";

	print  MAIL <<EndOfLetter;
to:         $webmaster
from:       $from_user
subject:    $subject

	----------------------------------------------------------
	File(s) $fnames (total: $total_bytes bytes) were uploaded.
	by:  $your_name
	----------------------------------------------------------

EndOfLetter
	close (MAIL) || die "Message NOT sent!  Unable to close pipe to sendmail: $!\n";
}

# =====================================================
sub master_send_err		#( string $err . $fname )
{
	my $err = shift(@_);
	my $subject = "Upload File Error!";

	open (MAIL, "| /usr/sbin/sendmail -tf $webmaster")
	  || die "Message NOT sent!  Unable to open pipe to sendmail.\n";

	print  MAIL <<EndOfError;
	
to:      $webmaster
from:    $from_user
subject: $subject

	----------------------------------------------------------
	A File or Files generated an error during upload.
	err = $err
	uploader was <$your_name>
	----------------------------------------------------------

EndOfError
	close (MAIL) || die "Message NOT sent!  Unable to close pipe to sendmail: $!\n";

}

# =====================================================
sub error_out
{
	my $err = shift (@_);

    #print $cgi->header(-status=>$cgi->cgi_error);

	print "<br>An error occurred during upload.<br>";
	print "err = $err";
	print "<br>";
	print "Error has been sent to the webmaster<br>";

	master_send_err( "$err, during upload of [$target]" );
	#print $cgi->end_html();
    exit 1;
}

#======================================================
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

