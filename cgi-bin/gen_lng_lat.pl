#!/usr/bin/perl
#
# gen_lng_lat.pl
#  (uses the Google Maps API to grab geocodes).
#  loads Javascript arrays Lng[], Lat[] with values.
#  
# perl gen_lng_lat.pl "PLAYERID, 2476 Prince St, 94705"
# (ie just address + Zip).
# perl gen_lng_lat.pl "PLAYERID,, 94705"
# (just Zip, gives the 'center' of the Zip). 
#
# manually copy output_points.csv /google_maps/PFILE_name.csv

use strict;

use Getopt::Std;
use vars qw / $opt_D /;

use CGI qw(:standard);      # CGI greatly simplifies the processing of form input
use LWP::Simple qw(!head);  # LWP::Simple does the lifting for the http request.

#boilerplate, used to catch:  ProgramName --  OR -h OR -? as help request
# or a getopts error
if ( ($ARGV[0] && $ARGV[0] =~ m#-[\-h?]#) || ! getopts( 'D' ) )
{
    usage();
}

my $Debug = $opt_D ? 1 : 0;


# --------------------------------------------------------------------
my $GPSQuery;
my $i;
my @address;
my $addr;
my $orig_addr;

open (ADDR, "./points.csv") or die "Can't open points.csv for read. $!\n";
open (OUT,  ">./output_points.csv") or die "Can't open output_points for write. $!\n";

while ( <ADDR> )
{
    chomp();

    #remove any double quotes.
    s/\"//g;

    $orig_addr = $_;
    @address = split ( /,/, $_ );

    #skip the title line (has alphabetic), but add our own header row.
    if ($address[0] =~ m/[a-zA-Z]/ )
    {
        print OUT "$address[0], Lng, Lat\n";
        next;
    }

    #remove pound-sign apt numbers from the address.
    $address[1] =~ s/#.*//g;

    $addr = join( ',', $address[1], $address[2] );
    print STDERR "addr = $addr\n" if ($Debug);

    $GPSQuery = escapeHTML( $addr );
    print STDERR "gpsquery = <$GPSQuery>\n" if ($Debug);

    my $GPSInfo = get(
        "http://maps.google.com/maps/geo?" .
        "q=$GPSQuery" .
        "&output=csv" .
        "&key=ABQIAAAA8XrL78JTD1olQfYHcQcg7RT6oMQXpUMSpomSJltDdoSU0lR7UBRUB_XKc9-L7R5QFlru01DA7eJMXA"
    );

       # It'll work even if your cgi script
       # isn't in the same directory the key was registered to (not even the same computer) -
       # ie you can use this from your local work machine.
       # 
       # It should also be noted that Google provides several options for
       # the format of output. These are documented in the Google Maps API
       # Reference.
       # the csv output is return_code, accuracy, longitude, latitude.
       # kml output is suitable for kml or kmz output.
       # and there is xml output.

    #as csv output
    print STDERR "GPSInfo = $GPSInfo\n";

    my ($lat, $lng);
    my @arr;
    #assumes csv output.

    @arr = split ( /,/, $GPSInfo );

    #check for a 'good' return
    if ( $arr[0] == 200 )
    {
        $lat = $arr[2];
        $lng = $arr[3];
        
        print "lng = $lng, lat = $lat\n" if ($Debug);
        print OUT join( ',', $address[0], $lng, $lat );
        print OUT "\n";
    }
}

close(ADDR);
close(OUT);
exit(0);


# ================  subroutines ====================================
sub usage
{
print STDERR <<EOUSAGE;
usage:
 perl gen_lng_lat.pl [-D]

 Be PATIENT!! - This calls the Google Server for EVERY point!!

  -D for Debug output.

 generates lng, lat from addresses in ./points.csv
 outputs output_points.csv (adding the lng, lat values).
 Output only has ID, lng, lat values.
 
 Copy output_points.csv ../google_maps/rdn_lng_lat.csv (the redeemers)
 Copy output_points.csv ../google_maps/sent_lng_lat.csv (sample of sent)

 points.csv has form
 ID, address, zip

 output_points.csv has form
 ID, lng, lat

 It's up to you to generate the input  file, points.csv from the database,
 and to manually copy & rename output_points.csv to ../google_maps/PFILE_Name.csv

EOUSAGE

    exit(1);
}

