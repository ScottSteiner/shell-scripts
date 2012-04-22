#!/usr/bin/perl
# Copyright (c) 2007-2012 ScottSteiner <nothingfinerthanscottsteiner@gmail.com>
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

use warnings;
use strict;

my @badshit = (
	"assassination of civil rights leaders",
	"child prostitution",
	"genocide",
	"GRIDS",
	"illegal wars",
	"incest",
	"internment camps",
	"interracial rape",
	"interspecies rape",
	"KKK",	
	"lynching",
	"Neo Nazis",
	"nuclear holocaust",
	"segregation",
	"slavery",
	"Trail of Tears",
	"unprovoked wars",
	"white slavery"
);

my @colors = (
"amber","apricot","auburn","beige","black","blue","bronze","brown","burgundy","celadon","cerulean","cinnabar","cobalt","copper","crimson",
"cyan","emerald","fuchsia","green","grey","indigo","ivory","jade","lavender","lemon","lilac","magenta","maroon","mauve","mustard","olive","orange",
"peach","ping","pumpkin","purple","red","rose","ruby","rust","saffron","sapphire","tan","tangerine","vermilion","violet","white","wisteria","yellow"
);

my @countries = (
"Afghanistan","Albania","Algeria","Azerbaijan","Bahrain","Bosnia","Brunei","Chad","Djibouti","Egypt","Ethiopia","Gambia","Ghana",
"Guinea","Haiti","Indonesia","Iran","Iraq","Jordan","Kazakhstan","Kenya","Kosovo","Kuwait","Lebanon","Liberia","Libya","Malaysia","Morocco","Niger",
"Nigeria","North Korea","Omar","Pakistan","Palestine","Panama","Qatar","Rwanda","Saudi Arabia","Senegal","Sierra Leone","Somalia","Sudan","Syria",
"Tunisia","Turkey","Turkmenistan","Uganda","United Arab Emirates","Uzbekistan","Vietnam","Yemen"
);

my @holidays = (
"9/11","Arbor Day","Ash Wednesday","Black Friday","Christmas","Columbus Day","Easter","Father's Day","Flag Day", "Fourth of July","Good Friday",
"Groundhog Day","Halloween","Hanukkah","Inauguration Day","Independence Day","Labor Day","Mardi Gras","Martin Luther King Day","Memorial Day",
"Mother's Day","New Year's Eve","Patriot's Day","President's Day","September the Eleventh","St Patrick's Day","Super Bowl Sunday","Thanksgiving","Valentine's Day",
"Veterans' Day"
);

my @jobs = (
	"city manager",
	"cultural attaché",
	"governor",
	"Keeper of the Seals",
	"King of Arms",
	"Last King of Scotland",
	"mayor",
	"military attaché",
	"National Statistician",
	"Prime Minister",
	"Supreme Allied Commander",
	"treasurer"
);


my $badshit	= $badshit[ int rand @badshit ];
my $color	= uc $colors[ int rand @colors ];
my $country	= $countries[ int rand @countries ];
my $holiday	= $holidays[ int rand @holidays ];
my $job		= $jobs[ int rand @jobs ];

my $num_years 	= int(rand(17)) + 3;
my $num_medals	= int(rand(7)) + 3;

print $ARGV[0] . ": You son of a hag! I didn't serve as $job for " . $num_medals . "-odd years in " . $country . ", defending our precious American $holiday and " . $badshit . ", just tew read such smart-mouthed assertions from the likes of a psycho like you! I'VE GOT $num_medals $color HEARTS, MONSIEUR!!!"
