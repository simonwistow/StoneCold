package StoneCold::Entry;

use strict;
use StoneCold::Thumbnail;

sub new {
    my $class = shift;
    my %opts  = @_;
    $opts{thumbnail} = StoneCold::Thumbnail->new($opts{path});
    return bless \%opts, $class;
}


sub id {
    return $_[0]->{id};
}
sub name {
    return $_[0]->{name};
}
sub path {
    return $_[0]->{path};
}

sub uri_base {
    return $_[0]->{uri};
}

sub title {
    # maybe do MP3 titling shennigans later?
    return $_[0]->name;
}

sub type {
    return "audio/mpeg";
}

sub size {
    my $self = shift;
    return (stat($self->file))[7];
}

sub file {
    my $self = shift;
    # TODO cross platform
    return $self->path."/".$self->name;
}

sub uri {
    my $self = shift;
    return $self->{uri}."/".$self->name;
}

sub thumbnail {
    return $_[0]->{thumbnail};
}
1;
