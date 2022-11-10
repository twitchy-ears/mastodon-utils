#!/usr/bin/perl

use strict;
use Getopt::Long qw(:config no_ignore_case bundling);
use Data::Dumper::Simple;

our %defaults = (
	debug => 0,
	help => 0,

	mode => 'info',
);
our %config = %defaults;

GetOptions (
	'h|help|version' => \$config{help},
	'debug' => \$config{debug},
	'mode=s' => \$config{mode},
);

if ($config{help}) {
	print <<EOL;
$0 [-hd] [--mode <m>]

 -h --help 
 -version        This text
 --debug         Be more verbose

 --mode          Output mode, default:
                 $defaults{mode}

Available modes 'info' is email, user, and display name.
'alias' is a mail alias file so "user: email"

EOL
}


# Yeah I can probably do this easier from within Ruby, this is a quick hack
#
# TL;DR should probably write a thing to check this against LDAP and
# remove/lock/archive users who don't exist there or something?

my $user_dump_cmd = "psql -A -0 -t -c \"select a.username,a.display_name,u.email from accounts as a JOIN users as U on a.id = u.account_id where domain is NULL AND u.approved = 't';\" mastodon_production";

my $users = qx{ $user_dump_cmd };
if ($? != 0) {
	print "Something is wrong, got '$?' from command\n";
	exit($?);
}
my @users = split(/\0/, $users);
my %users;
foreach my $line (@users) {
	my @d = split(/\s*\|\s*/, $line);
	if ($#d == 2) {
		$users{ $d[2] }{username} = $d[0];
		$users{ $d[2] }{display_name} = $d[1];
		$users{ $d[2] }{email} = $d[2];
	}
}

foreach my $email (sort(keys(%users))) {
	if ($config{mode} eq 'info') {
		print "'$email' -> '$users{$email}{username}' -> '$users{$email}{display_name}'\n";
	}
	elsif ($config{mode} eq 'alias') {
		print lc($users{$email}{username}) . ": $email\n";
	}
}
