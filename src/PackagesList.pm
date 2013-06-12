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

package PackagesList;

sub new {
    my $class = shift;
    my $self = {
        nameFileWithDPKGListing => shift,
        debPackagesList => {},
        };

    bless $self, $class;
    return $self;
}

sub deleteAll { # XXX - implementation is not complete.
    my $self = shift;
    $self->{debPackagesList} = {};

    #print __FILE__ . ":" . __LINE__ . ": have size " . scalar keys(%{$self}) . " but for a local object. This is this function's implementation bug." . "\n";

    bless $self;
    return $self;
}

sub isEqual {
    my ( $self, $foreignObj ) = @_;

    #no warnings 'uninitialized';
    ! $foreignObj
        && return 0;

    ! $self->getSize() eq $foreignObj->getSize()
        && return 0;

    foreach my $singleForeignPack ($foreignObj->getItemsAsObjectRefs()) {
        my $foreignPivotId = $singleForeignPack->getName();
        my $singleLocalPack = $self->getPack($foreignPivotId);

        ! $singleLocalPack
            && return 0;
        ! $singleLocalPack->isEqual($singleForeignPack)
            && return 0;
    }
    return 1;
}

sub isStringDPKGListingCaption {
    my $self = shift;
    my $targetStringOriginal = shift;
    my $captionStringSign = "+++-=";
    my $targetStringWithMaskApplied = substr($targetStringOriginal,
                                        0,
                                        length($captionStringSign));

    $targetStringWithMaskApplied eq $captionStringSign
        && return 1;

    return 0;
}


###
##  Setters
#

sub setItemsFromFile {
    my $self = shift;

    $self->deleteAll();

    open (fileWithDpkgListing, $self->{nameFileWithDPKGListing});
    while (<fileWithDpkgListing>) {
        chomp;
        $self->isStringDPKGListingCaption($_)
            && last
    }

    while (<fileWithDpkgListing>) {
        chomp;
        if($_) {
            my $newPack = PackageDeb->newFromString_dpkg_1_16_1($_);
            $self->setPack($newPack);
        }
    }
    close (fileWithDpkgListing); # XXX - What will happens if another instance will open and close the same file?
}

sub setPack { # Need duplicates check.
    my ( $self, $newPack ) = @_;
    $self->{debPackagesList}->{$newPack->getName()} = $newPack;
}

###
##  Getters
#

sub getSize {
    my $self = shift;
    return scalar keys(%{$self->{debPackagesList}});
}

sub getFileName {
    my $self = shift;
    my $newObjectWithName = $self->{nameFileWithDPKGListing}; # XXX - ???
    return $newObjectWithName;
}

sub getItemsAsKeys {
    my $self = shift;
    return (keys(%{$self->{debPackagesList}}));
}
sub getItemsAsObjectRefs {
    my $self = shift;
    return (values(%{$self->{debPackagesList}}));
}

sub getPack {
    my( $self, $wantedPack ) = @_;
    ! $self->{debPackagesList}->{$wantedPack}
        && return undef ;
    return $self->{debPackagesList}->{$wantedPack} ;
}


1;
