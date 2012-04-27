#!/usr/bin/perl -w
# Copyright (c) 2010-2012 ScottSteiner <nothingfinerthanscottsteiner@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# https://github.com/ScottSteiner/shell-scripts

$input		= "in.txt";
$output		= "out.txt";

open(INPUTFILE, $input) or die("Could not open file.");
@inputlines=<INPUTFILE>;
close(INPUTFILE);
open (OUTPUTFILE, ">$output");
$output		= "";
$position	= 1;

foreach $line (@inputlines) {
	chomp($line);
	$length = length ("$output$line");
	if ($length >= 2000) {
		print OUTPUTFILE "====$position====\n$output";
		$output="$line\n\n";
		$position += 1;
	} else { 
		$output .= "$line\n\n";
	}
}
print OUTPUTFILE "====$position====\n$output";
close (OUTPUTFILE);
