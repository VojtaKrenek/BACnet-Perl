#!/usr/bin/perl

use warnings;
use strict;
use threads;

use constant TRUE  => 1;
use constant FALSE => 0;

use BACnet::Device;

use Data::Dumper;

sub dump {
    my ( $device, $message, @rest ) = @_;

    print "get message: ", Dumper($message), "\n";
}

my %args = (
    addr  => 'X.X.X.X',
    sport => 47808,
    id    => 42,
);

my %args_read_prop = (
    obj_type             => 0,
    obj_instance         => 2,
    property_identifier  => 85,
    property_array_index => undef,
    host_ip              => 'X.X.X.X',
    peer_port            => 47808,
    on_response          => \&dump,
);

my $mydevice = BACnet::Device->new(%args);

$mydevice->read_property(%args_read_prop);

$mydevice->run;
