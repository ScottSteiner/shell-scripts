#!/usr/bin/perl
#
# Perl Pomf.se Uploader
# Version: 0.1
#
# Requirements: 
# * libwww-perl
#
# If this script stop working for some reason
# please inform kokonoe at irc.rizon.net
#

use strict;
use warnings;
use LWP;

	my $post;
	my $ARGC;
	
	$post = 'http://sugoi.space/upload.php'; # POST url

	$ARGC=@ARGV;

		if ($ARGC < 1) {
			print "Please input a file name after the script name. Ex: script.pl FILENAME\n\n";
			print "This script can upload multiple files too. Ex: script.pl FILENAME1 FILENAME2\n";
			exit(1);
		}

foreach my $file (@ARGV) {
print "filename: $file\n";
	my $data;
	my $rdata;
	my $request;
	my $success;

$request = LWP::UserAgent->new;
$request->agent('Pomf.se-PerlUploader/0.1');

	$data = $request->post(
		$post,
		[ 
			'files[]' => [$file]
		],
			'Content_Type' => 'form-data'
		);

	$rdata = $data->content();
	
	
	if ( $rdata =~ /\{"success":(.*?),"files":\[\{"hash":["|']?(.*?)["|']?,"name":["|']?(.*?)["|']?,"url":["|']?(.*?)["|']?,"size":["|']?(.*?)["|']?\}\]\}/ ) {
		$success = $1;
		if($success eq 'true'){
			my $hash = $2;
			my $original = $3;
			my $uploaded = $4;
			my $size = $5;
			
			print "Successfully uploaded!\n";
			print "url: http://a.sugoi.space/$uploaded\n\n";
		} else {
			print "Error: $rdata\n";
		}
	} else {
		print "Server Response Mismatch: $rdata\n";
	}
}
