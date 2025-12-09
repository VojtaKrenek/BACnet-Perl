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

sub approve {
    my ( $device, $message, @rest ) = @_;
    $device->send_approve(
        service_choice => 'ConfirmedCOVNotification',
        host_ip        => 'X.X.X.X',
        peer_port      => 47808,
        invoke_id      => $message->{invoke_id},
    );
}

my $mydevice = BACnet::Device->new(%args);

my %args1 = (    #sub_COV
    obj_type                      => 0,
    obj_inst                      => 1,
    issue_confirmed_notifications => FALSE,
    lifetime_in                   => 100,
    host_ip                       => 'X.X.X.X',
    peer_port                     => 47808,
    on_COV                        => \&dump,
    on_response                   => \&dump,
);

my %args2 = (    #sub_COV
    obj_type                      => 0,
    obj_inst                      => 2,
    issue_confirmed_notifications => TRUE,
    lifetime_in                   => 100,
    host_ip                       => 'X.X.X.X',
    peer_port                     => 47808,
    on_COV                        => \&dump,
    on_response                   => \&dump,
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


sub another_sub {
    my ( $device, $message, @rest ) = @_;
    $device->subscribe(%args1);
}

my ($new_sub, $error) = $mydevice->subscribe(%args1);
my ($new_sub2, $error2) = $mydevice->subscribe(%args2);

$mydevice->run;
