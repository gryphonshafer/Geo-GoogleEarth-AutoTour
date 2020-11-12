# NAME

Geo::GoogleEarth::AutoTour - Generate Google Earth Camera Tours from Tracks and Paths

# VERSION

version 1.07

[![build](https://github.com/gryphonshafer/Geo-GoogleEarth-AutoTour/workflows/build/badge.svg)](https://github.com/gryphonshafer/Geo-GoogleEarth-AutoTour/actions?query=workflow%3Abuild)
[![codecov](https://codecov.io/gh/gryphonshafer/Geo-GoogleEarth-AutoTour/graph/badge.svg)](https://codecov.io/gh/gryphonshafer/Geo-GoogleEarth-AutoTour)

# SYNOPSIS

    use Geo::GoogleEarth::AutoTour 'tour';

    my $kml = tour($input);

    tour( $input, {
        doc_name            => 'Tour',
        tour_name           => 'Tour',
        tilt                => 80,
        gap_duration        => 20,
        play_speed          => 20,
        initial_move        => 2,
        initial_wait        => 5,
        start_trim          => 0,
        end_trim            => 0,
        altitude_adjustment => 100,
        altitude_mode       => 'absolute',
    }, $output );

# DESCRIPTION

This module takes input expected to be a Track or Path export data from Google
Earth and produces a Tour. The expected typical case is that you start with a
Track or Path exported from Google Earth as a KMZ or KML file, and you'll get
as output a KMZ file suitable for loading in Google Earth.

## INSPIRATION AND PURPOSE

I'm a pilot, and I enjoy recording flights using a cell phone and a GPS logger.
I can export that data as a KMZ/KML file and view it in Google Earth, which is
all nice and whatever; but I wanted to make Google Earth fly what I flew.

# FUNCTIONS

This module allows for exporting of several functions, but typical usage will
only require "tour" to be exported.

    use Geo::GoogleEarth::AutoTour 'tour';

## tour

This function should do everything you need. It expects some input, which can
be KML XML as a string, or a filehandle of a KML or KMZ file or stream.

You can optionally provide settings as a hashref. Any setting not defined gets
set as the default, which are values I find to be mostly reasonable for the
typical case. You can also optionally provide as a third parameter what should
be used as output: a filehandle or reference to a scalar.

The function will always return the generated tour KML XML, but if an output
filehandle is provided, it'll try to write to that filehandle a KMZ file.

    my $input  = IO::File->new( 'track.kmz', '<' ) or die $!;
    my $output = IO::File->new( 'tour.kmz',  '>' ) or die $!;

    my $kml_xml = tour(
        $input,
        {
            doc_name => 'Moutains Tour from Track',
            altitude_adjustment => 1500,
            altitude_mode => 'agl',
        },
        $output,
    );

See the settings section below for information about the settings.

## kmz\_to\_xml, xml\_to\_kmz

As you might guess, these two functions will take a KMZ filehandle and return
KML XML as a string, or will take KML XML as a string and a KMZ filehandle to
output.

    my $input = IO::File->new( 'track.kmz', '<' ) or die $!;
    my $kml_xml = kmz_to_xml($input);

    my $output = IO::File->new( 'tour.kmz', '>' ) or die $!;
    xml_to_kmz( $kml_xml, $output );

## load\_kml

This is a helper function. It takes KML XML as a string and returns an
[XML::LibXML::XPathContext](https://metacpan.org/pod/XML%3A%3ALibXML%3A%3AXPathContext) object with the OpenGIS namespace (which is the
default XMLNS) set to "g".

    my $xc     = load_kml($kml_xml);
    my $coords = $xc->findvalue('//g:Placemark/g:LineString/g:coordinates');

## read\_path

This function expects an [XML::LibXML::XPathContext](https://metacpan.org/pod/XML%3A%3ALibXML%3A%3AXPathContext) object built by
`load_kml` based on KML XML that contains a Path. It returns an arrayref of
points suitable for use with the `build_tour` function.

    my @points = @{ read_path( load_kml($kml_xml) ) };

## gather\_points

This function expects an [XML::LibXML::XPathContext](https://metacpan.org/pod/XML%3A%3ALibXML%3A%3AXPathContext) object built by
`load_kml()` based on KML XML that contains a Track. It returns an arrayref of
points suitable for use with the `build_tour` function.

    my @points = @{ gather_points( load_kml($kml_xml) ) };

## build\_tour

This function expects settings passed in as either a list or a hashref. The
settings are described below, but there needs to also be a "points" key with
the value being an arrayref of hashrefs created by `read_path` or
`gather_points`.

The function returns KML XML of the generated tour.

    my $kml_xml_0 = build_tour( points => read_path( load_kml($kml_xml) ) );
    my $kml_xml_1 = build_tour({
        points              => read_path( load_kml($kml_xml) ),
        altitude_adjustment => 1500,
        altitude_mode       => 'agl',
    });

# SETTINGS

Settings are required by `tour` and `build_tour`, although you'll likely never
need to use the latter function. Any settings not provided get defaulted to what
I think are reasonable values to produce a Tour that looks reasonable well for
most cases.

    doc_name            => 'Tour',
    tour_name           => 'Tour',
    tilt                => 80,
    gap_duration        => 20,
    play_speed          => 20,
    initial_move        => 2,
    initial_wait        => 5,
    start_trim          => 0,
    end_trim            => 0,
    altitude_adjustment => 100,
    altitude_mode       => 'absolute',

- doc\_name, tour\_name

    These are labels used for the document name and tour name (contained within
    the document).

- tilt

    This is the camera angle in degrees. A tilt of 0 is pointing straight down, and
    a tilt of 90 is perfectly level. Generally, a tilt of 80 seems to produce good
    tours most of the time.

- gap\_duration

    If you're recording a lot of GPS positions with your GPS recording application,
    especially if your GPS hardware is on an old cell phone, you can get a whole
    lot of noise and really, really tight readings fractions of a second apart. This
    isn't useful for tour generation, and in fact, it can sometimes be problematic.

    So the `gap_duration` is a number of seconds of minimum time between each GPS
    record getting included in tour generation. For example, a value of 20 means
    that the GPS records used for tour generation will not be closer than 20 seconds
    apart. This has the effect of making the tour a bit more flight-view realistic.

- play\_speed

    This is how fast you want a Track to run. The default is 20, which means the
    tour plays at about 20 times as fast as it would at a value of 0. Larger numbers
    mean faster playback. A value of 0.5 would mean the playback is at half speed.

- initial\_move

    When Google Earth first loads up a Tour, it tries to move you to the origin
    point of the Tour. The `initial_move` is the number of seconds you want to
    tell Google Earth to do that move. Typically 2 works well.

- initial\_wait

    After moving to the origin point, `initial_wait` instructs Google Earth to
    pause for a number of seconds before beginning movement. Generally, a value of
    5 seconds seems to work well, but this will be highly dependent on your network
    speed and hardware capabilities.

- start\_trim, end\_trim

    When I record a GPS Track for a flight, I tend to do it while I'm parked on the
    ground before I taxi out to the runway. Similarly, I don't shutdown the recorder
    until I'm parked again at the destination airport. To trim out that time, you
    can use `start_trim` and `end_trim` to trim off a certain number of seconds
    from the start or end of the Track.

- altitude\_adjustment

    Some GPS hardware (mine included) isn't consistently accurate about altitude.
    I've noticed I end up recording Tracks about 200 to 300 feet too low. So
    `altitude_adjustment` is the number of feet to adjust the altitude by.

    Note that if you're converting a Path instead of a Track, you really ought to
    set `altitude_adjustment` since a Path is always recorded as being on ground
    level.

- altitude\_mode

    By default, `altitude_mode` is set to absolute altitude, or MSL in pilot-speak.
    However, sometimes you want altitude to be AGL or relative to ground level.
    `altitude_mode` can be set to absolute, MSL, relative, or AGL.

# SEE ALSO

You can look for additional information at:

- [GitHub](https://github.com/gryphonshafer/Geo-GoogleEarth-AutoTour)
- [MetaCPAN](https://metacpan.org/pod/Geo::GoogleEarth::AutoTour)
- [GitHub Actions](https://github.com/gryphonshafer/Geo-GoogleEarth-AutoTour/actions)
- [Codecov](https://codecov.io/gh/gryphonshafer/Geo-GoogleEarth-AutoTour)
- [CPANTS](http://cpants.cpanauthors.org/dist/Geo-GoogleEarth-AutoTour)
- [CPAN Testers](http://www.cpantesters.org/distro/G/Geo-GoogleEarth-AutoTour.html)

# AUTHOR

Gryphon Shafer <gryphon@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2021 by Gryphon Shafer.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
