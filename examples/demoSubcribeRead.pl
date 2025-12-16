#!/usr/bin/perl

use warnings;
use strict;
use threads;

use constant TRUE  => 1;
use constant FALSE => 0;

use BACnet::Device;
use Data::Dumper;

# ---------------------------------------------------------------
# Command-line arguments
# ---------------------------------------------------------------
if ( @ARGV < 2 ) {
    die "Usage: $0 <local_ip> <host_ip>\n";
}

my $local_ip = $ARGV[0];
my $host_ip  = $ARGV[1];

# ---------------------------------------------------------------

sub dump {
    my ( $device, $message, @rest ) = @_;
    print "get message: ", Dumper($message), "\n";
}

my %args_dev = (
    addr  => $local_ip,
    sport => 47808,
    id    => 42,
);

my $mydevice = BACnet::Device->new(%args_dev);

# ---------------------------------------------------------------
# Subscription definitions
# ---------------------------------------------------------------

my %args_sub1 = (
    obj_type                      => 0,
    obj_inst                      => 1,
    issue_confirmed_notifications => FALSE,
    lifetime_in                   => 100,
    host_ip                       => $host_ip,
    peer_port                     => 47808,
    on_COV                        => \&dump,
    on_response                   => \&trigger_read,
);


# ReadProperty request parameters
my %args_read_prop = (
    obj_type             => 0,
    obj_instance         => 2,
    property_identifier  => 85,
    property_array_index => undef,
    host_ip              => $host_ip,
    peer_port            => 47808,
    on_response          => \&dump,
);

sub trigger_read {
    my ( $device, $message, @rest ) = @_;
    $device->read_property(%args_read_prop);
}

# ---------------------------------------------------------------
# Perform subscriptions
# ---------------------------------------------------------------

my ( $new_sub,  $error )  = $mydevice->subscribe(%args_sub1);

# If needed, we could print errors:
# print "Error: $error\n"   if defined $error;

# ---------------------------------------------------------------

$mydevice->run;
