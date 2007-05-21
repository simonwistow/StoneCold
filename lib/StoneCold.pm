package StoneCold;

use strict;
use DBM::Deep;
use StoneCold::Entry;

=head1 NAME

StoneCold - stuff for a player

=head1 SYNOPSIS

    my $sc = StoneCold->new;

    # the current playlist
    my $playlist = $sc->playlist;
    # .. and its name
    my $name     = $sc->name;
    
    # all the playlists
    my @lists    = $sc->playlists;

    # the files available
    my @files    = $sc->files

    # when the playlist was last modified
    my $modified = $sc->changed

    # add a file to the playlist
    $sc->add($file);

    # delete a file from the playlist
    $sc->delete($id);
    
    # get all the entries in the playlist
    foreach my $entry ($sc->entries) {
        print $entry->id;
        print $entry->url;
        print $entry->file;
        print $entry->size;
        print $entry->type;
    }
    

=head1 METHODS

=cut


=head2 new [opt[s]]

=cut

sub new {
    my $class  = shift;
    my %opts   = @_;
    my $cgi    = Class::CGI->new;

    $opts{dbfile}       ||= 'db/playlist.db';
    $opts{playlist}     ||= 'default';
    $opts{path}         ||= '/virtual/thegestalt.org/www/html/warez';
    $opts{uri}          ||= 'http://thegestalt.org/warez';
    $opts{default_name} ||= 'simon';
    
    $opts{_db} = DBM::Deep->new( file      => $opts{dbfile},
#                         locking   => 1,
                          autoflush => 1,
                          type      => DBM::Deep->TYPE_ARRAY,
                        );

    my $self = bless \%opts, $class;


    return $self;
}

=head2 playlist

Return the current playlist

=cut

sub playlist {
    my $self = shift;
    return $self->{playlist};    
}

=head2 name

Return's the name of the current playlist

=cut

sub name {
    my $self = shift;
    my $name = $self->playlist;
    $name = $self->{default_name} if ($name eq 'default');
    return ucfirst(lc($name));
}

=head2 playlists

Return all the playlists.

=cut

sub playlists {
    my $self = shift;
    my $db   = $self->{_db};
    my %people = ( $self->playlist => 1 );
    for (my $i=0; $i<$db->length; $i++) {
        my $entry =  $db->get($i);
        next unless defined $entry;
        $people{$entry->{playlist}}++;
    }
    return sort keys %people;

}

=head2 files 

Return all the files available

=cut

sub files {
    my $self = shift;
    my $path = $self->{path};
    my @files = sort map { s!.*/(.+)$!$1!; $_ } <$path/*.mp3>;
    return @files;
}

=head2 changed

When the playlist last changed.

=cut

sub changed {
    my $self = shift;
    # this is per db, not playlist
    return (stat($self->{dbfile}))[9];

}

=head2 add <file>

Add a file to the current playlist

=cut

sub add {
    my $self = shift;
    my $file = shift;
    $self->{_db}->push({ file => $file, playlist => $self->playlist });

}

=head2 delete  <id>

Delete a file from the playlist

=cut

sub delete {
    my $self = shift;
    my $id   = shift;
    $self->{_db}->delete($id);
}


=head2 entries 

Get all the entries in this playlist as C<StoneCold::Entry> object.

=cut

sub entries {
    my $self = shift;
    my $db   = $self->{_db};
    my $list = $self->playlist;
    my $path = $self->{path};
    my $uri  = $self->{uri};

    my @entries;
    for (my $i=0; $i<$db->length; $i++) {
        my $entry =  $db->get($i);
        next unless defined $entry;
        next unless $entry->{playlist} eq $list;
        my $obj   = StoneCold::Entry->new( path     => $path,
                                           uri      => $uri,
                                           name     => $entry->{file},
                                           playlist => $list,
                                           id       => $i );
        push @entries, $obj;
    }
    return @entries;

}

=head1 AUTHOR

Simon Wistow <simon@thegestalt.org>

=head1 COPYRIGHT

Copyright, Simon Wistow - 2007

=cut

1;
