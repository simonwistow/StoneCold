#!/usr/bin/perl -w

use strict;
use lib qw(lib);
use CGI::Carp qw(fatalsToBrowser);
use Class::CGI;
use HTTP::Date;
use XML::RSS;
use StoneCold;




my $cgi   = Class::CGI->new;
my $list  = $cgi->param('playlist')  || 'default';
my $sc    = StoneCold->new(playlist => $list);
my $state = $cgi->param('state') || "";

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
$rss->add_module( prefix => 'media', uri => 'http://search.yahoo.com/mrss/' );
    
$rss->channel( title => "The ${name} Playlist" );
foreach my $entry ($sc->entries)
{

    my %item = (
        guid  => $entry->id,
        title => $entry->title,
        enclosure => {
                url    => $entry->uri,
                type   => $entry->type,
                length => $entry->size,
        },
    );
    my $thumb = $entry->thumbnail;
    if ($thumb) 
    {
        $item{media} = { thumbnail =>  {
            url    => $entry->uri_base."/".$thumb->filename,
            width  => $thumb->width,
            height => $thumb->height,
        }};
    }
    $rss->add_item(%item); 
        

}
print $rss->as_string;
exit(0);

