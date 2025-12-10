#!/usr/bin/perl

use warnings;
use strict;
use threads;

use constant TRUE  => 1;
use constant FALSE => 0;

use BACnet::Device;
use Data::Dumper;

# -------------------------------------------------------------------
# Command-line arguments
# -------------------------------------------------------------------

if ( @ARGV < 2 ) {
    die "Usage: $0 <local_ip> <host_ip>\n";
}

my $local_ip = $ARGV[0];
my $host_ip  = $ARGV[1];

# -------------------------------------------------------------------

sub dump {
    my ( $device, $message, @rest ) = @_;
    print "get message: ", Dumper($message), "\n";
}

my %args = (
    addr  => $local_ip,
    sport => 47808,
    id    => 42,
);

sub approve {
    my ( $device, $message, @rest ) = @_;
    $device->send_approve(
        service_choice => 'ConfirmedCOVNotification',
        host_ip        => $host_ip,
        peer_port      => 47808,
        invoke_id      => $message->{invoke_id},
    );
}

# Subscription definition
my %args1 = (
    obj_type                      => 0,
    obj_inst                      => 1,
    issue_confirmed_notifications => FALSE,
    lifetime_in                   => 10,
    host_ip                       => $host_ip,
    peer_port                     => 47808,
    on_COV                        => \&dump,
    on_response                   => \&dump,
);

sub another_sub {
    my ( $device, $message, @rest ) = @_;
    $device->subscribe(%args1);
}

my $mydevice = BACnet::Device->new(%args);

my ( $new_sub, $error ) = $mydevice->subscribe(%args1);

sleep(5);

$mydevice->unsubscribe( $new_sub, \&dump );

$mydevice->run;
