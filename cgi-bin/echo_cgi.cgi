#!/usr/bin/perl
#
# echoes ENV variables passed to a cgi script.

use CGI;

my $q;
$q = new CGI;

$|=1;
print "Content-Type: text/plain\n\n";
print "CGI Test Script\n";

print "\n";

#=========================
# print CGI params

print "PATH_INFO ";
print $q->path_info();
print "\n";
print "QUERY_STRING ";
print $q->query_string();

@names = $q->param();
print "\nname  values: \n";
foreach (@names)
{
	print $_ . "\t" . $q->param($_) . "\n";
}
print "\n\n";


print "SERVER_SOFTWARE = $ENV{'SERVER_SOFTWARE'}\n";
print "SERVER_NAME = $ENV{'SERVER_NAME'}\n";
print "GATEWAY_INTERFACE = $ENV{'GATEWAY_INTERFACE'}\n";
print "SERVER_PROTOCOL = $ENV{'SERVER_PROTOCOL'}\n";
print "SERVER_PORT = $ENV{'SERVER_PORT'}\n";
print "SERVER_ROOT = $ENV{'SERVER_ROOT'}\n";
print "REQUEST_METHOD = $ENV{'REQUEST_METHOD'}\n";
print "HTTP_ACCEPT = $ENV{'HTTP_ACCEPT'}\n";
print "PATH_INFO = $ENV{'PATH_INFO'}\n";
print "PATH = $ENV{'PATH'}\n";
print "PATH_TRANSLATED = $ENV{'PATH_TRANSLATED'}\n";
print "SCRIPT_NAME = $ENV{'SCRIPT_NAME'}\n";
print "QUERY_STRING = $ENV{'QUERY_STRING'}\n";
print "REMOTE_HOST = $ENV{'REMOTE_HOST'}\n";
print "REMOTE_IDENT = $ENV{'REMOTE_IDENT'}\n";
print "REMOTE_ADDR = $ENV{'REMOTE_ADDR'}\n";
print "REMOTE_USER = $ENV{'REMOTE_USER'}\n";
print "AUTH_TYPE = $ENV{'AUTH_TYPE'}\n";
print "CONTENT_TYPE = $ENV{'CONTENT_TYPE'}\n";
print "CONTENT_LENGTH = $ENV{'CONTENT_LENGTH'}\n";
print "DOCUMENT_ROOT = $ENV{'DOCUMENT_ROOT'}\n";
print "DOCUMENT_URI = $ENV{'DOCUMENT_URI'}\n";
print "DOCUMENT_NAME = $ENV{'DOCUMENT_NAME'}\n";
print "DATE_LOCAL = $ENV{'DATE_LOCAL'}\n";
print "DATE_GMT = $ENV{'DATE_GMT'}\n";
print "LAST_MODIFIED = $ENV{'LAST_MODIFIED'}\n";


