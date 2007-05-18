#!/usr/bin/perl -w

use strict;
use lib qw(lib);
use CGI::Carp qw(fatalsToBrowser);
use Class::CGI;
use HTTP::Date;
use XML::RSS;
use StoneCold;




my $cgi   = Class::CGI->new;
my $user  = $cgi->param('user') || 'default';
my $sc    = StoneCold->new(user => $user);
my $state = $cgi->param('state');

my $name  = $sc->name;

if ("add" eq $state) {
    my $file = $cgi->param('file');
    $sc->add($file);
} elsif ("delete" eq $state) {
    my $id = $cgi->param('id');
    $sc->delete($id);
}

print $cgi->header( "-type"          => 'text/plain', 
                    "-Last-Modified" =>  time2str($sc->changed));

my $rss = XML::RSS->new( version => '2.0' );
    
$rss->channel( title => "${name}'s Music" );
foreach my $entry ($sc->entries)
{
    $rss->add_item( 
        guid  => $entry->id,
        title => $entry->title,
        enclosure => {
                url    => $entry->uri,
                type   => $entry->type,
                length => $entry->size,
        },
    );
}
print $rss->as_string;
exit(0);

