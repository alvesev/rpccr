#!/usr/bin/perl

#
#  Copyright 2013 Alex Vesev
#
#  This file is part of Repository Processor - RPCCR.
#
#  RPCCR is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  RPCCR is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with RPCCR.  If not, see <http://www.gnu.org/licenses/>.
#
##

use strict;
use warnings;

package PackageDeb;

sub new {
    my $class = shift;
    my $self = {
        status => undef,
        name => undef,
        version => undef,
        arch => undef,
        description => undef,
    };

    bless $self, $class;
    return $self;
}

sub newFromString_dpkg_1_16_1 {
    # This function is specific for 'dpkg' version 1.16.1 listing format.
    # XXX - Is dpkg have a way to specify exact number and types of output columns?
    my $class = shift;

    my $dpkgOutputColumnsQuantity = 4;
    my ($newStatus, $newName, $newVersion, $newDescription)
                = split(/\s+/, shift, $dpkgOutputColumnsQuantity);
    my $self = {
        status      => $newStatus,
        name        => $newName,
        version     => $newVersion,
        arch        => undef,
        description => $newDescription,
    };

    bless $self, $class;
    return $self;
}

sub isEqual {
    my ( $self, $targetPack ) = @_;

    no warnings 'uninitialized';

    ! $targetPack
        && return 0;

    # XXX - Arch. is not going to be compared.
    $self->{status} eq $targetPack->getStatus()
        && $self->{name} eq $targetPack->getName()
        && $self->{version} eq $targetPack->getVersion()
        && $self->{description} eq $targetPack->getDescription()
        && return 1;

    return 0;
}

###
##  Setters
#

sub setStatus {
    my ( $self, $newStatus ) = @_;
    $self->{status} = $newStatus;
}
sub setName {
    my ( $self, $newName ) = @_;
    $self->{name} = $newName;
}
sub setVersion {
    my ( $self, $newVersion ) = @_;
    $self->{version} = $newVersion;
}
sub setArch {
    my ( $self, $newArch ) = @_;
    $self->{arch} = $newArch;
}
sub setDescription {
    my ( $self, $newDescription ) = @_;
    $self->{description} = $newDescription;
}

###
##  Getters
#

sub getStatus {
    my( $self ) = shift;
    return $self->{status} ;
}

sub getName {
    my( $self ) = shift;
    return $self->{name} ;
}

sub getVersion {
    my( $self ) = shift;
    return $self->{version} ;
}

sub getArch {
    my( $self ) = shift;
    return $self->{arch} ;
}

sub getDescription {
    my( $self ) = shift;
    return $self->{description} ;
}

1;
