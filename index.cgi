#!/usr/bin/perl -w 

use strict;
use lib qw(lib);

use CGI::Carp qw(fatalsToBrowser);
use Class::CGI;
use Template;
use StoneCold;


my $cgi      = Class::CGI->new;
my $playlist = $cgi->param('new_playlist') || $cgi->param('playlist') || $cgi->cookie('stonecold_playlist') || 'default';
my $cookie   = $cgi->cookie( -name  => 'stonecold_playlist', -value => $playlist );
print $cgi->header( -cookie => $cookie );


my $sc     = StoneCold->new( playlist => $playlist );


my $template = Template->new;
$template->process('templates/index', { stonecold => $sc, theme => 'daringly_stolen' }) || die $template->error();

