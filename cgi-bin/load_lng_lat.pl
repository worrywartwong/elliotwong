#!/usr/bin/perl
#
# load_lng_lat.pl
# loads javascript arrays Lng[], Lat[] with point data.
#
# Apollo Hosting:
#  "https://mydomain.com/cgi-bin/do_upload.cgi"
#
# Apollo Hosting requires this form (from cgi-bin).
#$target = "../httpdocs/downloads/$name";
#  
#  data is expected to be in ../google_maps/[PFILE] (where PFILE is in the GET param).

use strict;

use Getopt::Std;
use vars qw / $opt_D /;

use CGI qw(:standard);      # CGI greatly simplifies the processing of form input

#boilerplate, used to catch:  ProgramName --  OR -h OR -? as help request
# or a getopts error
if ( ($ARGV[0] && $ARGV[0] =~ m#-[\-h?]#) || ! getopts( 'D' ) )
{
    usage();
}

my $Debug = $opt_D ? 1 : 0;

my $q = CGI->new();
my $pfile;

$pfile = $q->param('pfile');
# a default value.
$pfile = 'points.csv' if ( !$pfile );

print $q->header();

my $i = 0;
my @address;

open (POINTS, "../httpdocs/google_maps/$pfile") or 
  die "Can't open ../httpdocs/google_maps/$pfile for read $!\n";

print '//<![CDATA[';
print "\n";
while (<POINTS>)
{
    chomp();
    @address = split( /,/, $_ );

    #skip the title line (has alphabetic).
    next if ($address[0] =~ m/[a-zA-Z]/ );

    print "Lng[$i] = $address[1];";
    print "Lat[$i] = $address[2];";
    print "\n";

    ++$i;

    #last if ($i == 35);
}

close(POINTS);

print '//]]>';
print "\n";

# ================  subroutines ====================================
sub usage
{
print STDERR <<EOUSAGE;
usage:
 perl load_lng_lat.pl [-D]

  -D for Debug output.

 loads (javascript arrays) Lng[], Lat[] from points_lng_lat.csv 
 (use gen_lng_lat and points.csv to generate points_lng_lat.csv).

 points.csv has form
 PLAYERID, address, zip

 points_lng_lat has form
 PLAYERID, lng, lat

 in the html file: (don't forget to add the pfile name to the query).
    <script language="JavaScript" type="text/javascript"
        src="http://www.mydomain.com/cgi-bin/load_lng_lat.pl?pfile=rdn_lng_lat.csv">
    </script>

 will load the javascript variables.

EOUSAGE

    exit(1);
}

