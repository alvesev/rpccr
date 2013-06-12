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

use File::Basename;
use lib dirname(__FILE__) . "/..";

use PackageDeb;
use PackagesList;

#
##
#

print __FILE__ . ":" . __LINE__ . ": ---- PackageDeb ---------------------------------\n";

my $singlePack = new PackageDeb();
my $nextPack = PackageDeb->newFromString_dpkg_1_16_1("ii  abiword                                2.9.2+svn20120213-1                                 efficient, featureful word processor with collaboration");

$singlePack->setStatus("ii");
$singlePack->setName("name-1");
$singlePack->setVersion("ver-1");
$singlePack->setArch("amd64");
$singlePack->setDescription("descriptive text");

print __FILE__ . ":" . __LINE__ . ": single pack info: " . $singlePack->getStatus("name-1") . "\n";
print __FILE__ . ":" . __LINE__ . ": single pack info: " . $singlePack->getName("name-1") . "\n";
print __FILE__ . ":" . __LINE__ . ": single pack info: " . $singlePack->getVersion("name-1") . "\n";
print __FILE__ . ":" . __LINE__ . ": single pack info: " . $singlePack->getArch("name-1") . "\n";
print __FILE__ . ":" . __LINE__ . ": single pack info: " . $singlePack->getDescription("name-1") . "\n";

print __FILE__ . ":" . __LINE__ . ": next pack info: " . $nextPack->getStatus("abiword") . "\n";
print __FILE__ . ":" . __LINE__ . ": next pack info: " . $nextPack->getName("abiword") . "\n";
print __FILE__ . ":" . __LINE__ . ": next pack info: " . $nextPack->getVersion("abiword") . "\n";
print __FILE__ . ":" . __LINE__ . ": next pack info: " . "'not defined'" . "\n";
print __FILE__ . ":" . __LINE__ . ": next pack info: " . $nextPack->getDescription("abiword") . "\n";

print __FILE__ . ":" . __LINE__ . ": ---- comparisions - single objects ---------------------------------\n";

my $leftPack = PackageDeb->newFromString_dpkg_1_16_1("ii  abiword                                2.9.2+svn20120213-1                                 efficient, featureful word processor with collaboration");
my $rightPack = PackageDeb->newFromString_dpkg_1_16_1("ii  abiword                                2.9.2+svn20120213-1                                 efficient, featureful word processor with collaboration");
my $rightPackModified = PackageDeb->newFromString_dpkg_1_16_1("nn  abiword                                2.9.2+svn20120213-1                                 efficient, featureful word processor with collaboration");

my $rightPackPartialInfo = new PackageDeb();
$rightPackPartialInfo->setName("right-partial");

if($leftPack->isEqual($rightPack)) {
    print __FILE__ . ":" . __LINE__ . ": have equal packs.\n";
} else {
    print __FILE__ . ":" . __LINE__ . ": packs are not equal.\n";
}

if($leftPack->isEqual($rightPackModified)) {
    print __FILE__ . ":" . __LINE__ . ": have equal packs.\n";
} else {
    print __FILE__ . ":" . __LINE__ . ": packs are not equal.\n";
}

if($leftPack->isEqual($rightPackPartialInfo)) {
    print __FILE__ . ":" . __LINE__ . ": have equal packs.\n";
} else {
    print __FILE__ . ":" . __LINE__ . ": packs are not equal.\n";
}

print __FILE__ . ":" . __LINE__ . ": _____________________________________\n\n";

#
##
#

print __FILE__ . ":" . __LINE__ . ": ---- simple tests ---------------------------------\n";

my $pack_1 = new PackageDeb();
my $pack_2 = new PackageDeb();
my $pack_3 = new PackageDeb();
$pack_1->setName("name-1");
$pack_2->setName("name-2");
$pack_3->setName("name-3");

my $nameFileWithDPKGListing = dirname(__FILE__)  . "/" . "exa.txt";
my $packsList = new PackagesList($nameFileWithDPKGListing);
print __FILE__ . ":" . __LINE__ . ": will work with file '" . $packsList->getFileName() . "'\n";

$packsList->setPack($pack_1);
$packsList->setPack($pack_2);
$packsList->setPack($pack_3);
print __FILE__ . ":" . __LINE__ . ": list size: " . $packsList->getSize() . "\n";
print __FILE__ . ":" . __LINE__ . ": have just single item: " . $packsList->getPack("name-1")->getName() . "\n";

print __FILE__ . ":" . __LINE__ . ": ---- enumeration by names ---------------------------------\n";

print __FILE__ . ":" . __LINE__ . ": all items in scalar(?) context: " . $packsList->getItemsAsKeys() . "\n";
foreach my $item ($packsList->getItemsAsKeys()) {
    print __FILE__ . ":" . __LINE__ . ": enumerate via getter: " . $item . "\n";
}

print __FILE__ . ":" . __LINE__ . ": ---- enumeration by objects ---------------------------------\n";
foreach my $item ($packsList->getItemsAsObjectRefs()) {
    print __FILE__ . ":" . __LINE__ . ": object: " . $item . " is '" . $item->getName() . "'.\n";
}

print __FILE__ . ":" . __LINE__ . ": ---- file related operations ---------------------------------\n";
$packsList->setItemsFromFile();
print __FILE__ . ":" . __LINE__ . ": after file loaded size: " . $packsList->getSize() . "\n";
foreach my $item ($packsList->getItemsAsObjectRefs()) {
    print __FILE__ . ":" . __LINE__ . ": object: " . $item . " is '" . $item->getName() . "'.\n";
}

print __FILE__ . ":" . __LINE__ . ": ---- wiping ---------------------------------\n";

#$packsList = new PackagesList();
$packsList->deleteAll();
print __FILE__ . ":" . __LINE__ . ": list size: " . $packsList->getSize() . "\n";

print __FILE__ . ":" . __LINE__ . ": _____________________________________\n\n";

#
##
#

print __FILE__ . ":" . __LINE__ . ": ---- comparisions - LISTS ---------------------------------\n";

my $nameFile_A = dirname(__FILE__)  . "/" . "exa.txt";
my $nameFile_B = dirname(__FILE__)  . "/" . "exa-exact-copy.txt";
my $nameFile_C = dirname(__FILE__)  . "/" . "exa-modified.txt";

my $packsList_1 = new PackagesList($nameFile_A);
my $packsList_2 = new PackagesList($nameFile_B);
my $packsList_3 = new PackagesList($nameFile_C);

$packsList_1->setItemsFromFile();
$packsList_2->setItemsFromFile();
$packsList_3->setItemsFromFile();

if($packsList_1->isEqual($packsList_1)) {
    print __FILE__ . ":" . __LINE__ . ": have equal LISTS.\n";
} else {
    print __FILE__ . ":" . __LINE__ . ": LISTS are not equal.\n";
}

if($packsList_1->isEqual($packsList_2)) {
    print __FILE__ . ":" . __LINE__ . ": have equal LISTS.\n";
} else {
    print __FILE__ . ":" . __LINE__ . ": LISTS are not equal.\n";
}

if($packsList_1->isEqual($packsList_3)) {
    print __FILE__ . ":" . __LINE__ . ": have equal LISTS.\n";
} else {
    print __FILE__ . ":" . __LINE__ . ": LISTS are not equal.\n";
}

print __FILE__ . ":" . __LINE__ . ": _____________________________________\n\n";
