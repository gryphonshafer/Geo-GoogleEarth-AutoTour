use Test2::V0;
use Geo::GoogleEarth::AutoTour;
use IO::File;

my $input  = IO::File->new( 't/0_data.kmz', '<' ) or die $!;
my $tour   = IO::File->new( 't/0_tour.kmz', '<' ) or die $!;
my $output = IO::File->new( 'Geo_GoogleEarth_AutoTour_test_0_tour.kmz', '>' ) or die $!;

my ( $kml_tour, $kml_output );

ok(
    lives {
        $kml_tour = Geo::GoogleEarth::AutoTour::tour( $input, {
            doc_name            => 'Moutains Tour from Path',
            altitude_adjustment => 1000,
            altitude_mode       => 'agl',
        }, $output );
    },
    'tour() execution for path input',
) or note $@;

ok(
    lives {
        $kml_output = Geo::GoogleEarth::AutoTour::kmz_to_xml($tour);
    },
    'kmz_to_xml() stand-alone execution',
) or note $@;

( $kml_tour, $kml_output ) = round_xml( $kml_tour, $kml_output );
is( $kml_tour, $kml_output, 'tour() output correctly built' );

unlink('Geo_GoogleEarth_AutoTour_test_0_tour.kmz');

$input  = IO::File->new( 't/1_data.kmz', '<' ) or die $!;
$tour   = IO::File->new( 't/1_tour.kmz', '<' ) or die $!;
$output = IO::File->new( 'Geo_GoogleEarth_AutoTour_test_1_tour.kmz', '>' ) or die $!;

ok(
    lives {
        $kml_tour = Geo::GoogleEarth::AutoTour::tour( $input, {
            doc_name => 'Puget Sound Tour from Track',
        }, $output );
    },
    'tour() execution for track input',
) or note $@;

ok(
    lives {
        $kml_output = Geo::GoogleEarth::AutoTour::kmz_to_xml($tour);
    },
    'kmz_to_xml() stand-alone execution (2)',
) or note $@;

( $kml_tour, $kml_output ) = round_xml( $kml_tour, $kml_output );
is( $kml_tour, $kml_output, 'tour() output correctly built (2)' );

unlink('Geo_GoogleEarth_AutoTour_test_1_tour.kmz');

done_testing;

sub round_xml {
    return map {
        s/(?<=\D)(\d{2})\d{8,}(?=<)/$1/g;
        $_;
    } @_;
}
