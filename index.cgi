#!/usr/bin/perl -w 

use strict;
use lib qw(lib);

use CGI::Carp qw(fatalsToBrowser);
use Class::CGI;
use Template;
use StoneCold;


my $cgi    = Class::CGI->new;
my $user   = $cgi->param('new_user') || $cgi->param('user') || $cgi->cookie('player_user') || 'default';
my $cookie = $cgi->cookie( -new_user => $user );
print $cgi->header( -cookie => $cookie );


my $sc     = StoneCold->new( user => $user );


my $template = Template->new;
$template->process('templates/index', { stonecold => $sc, theme => 'daringly_stolen' }) || die $template->error();

