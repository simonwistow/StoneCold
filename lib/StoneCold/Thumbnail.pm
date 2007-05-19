package StoneCold::Thumbnail;

use strict;
use File::Type;
use Image::Info qw(image_info dim);

=head1 NAME 

StoneCold::Thumbnail - represent an album thumbnail

=head1 SYNOPSIS

    my $thumb = StoneCold::Thumbnail->new($path);
    die "No thumbnail in $path" unless $thumb;

    print "Thumbnail file is ".$thumb->filename;
    print "Width:  ".$thumb->width;
    print "Height: ".$thumb->height;

=head1 METHODS

=cut

=head2 new <path> 

Find the thumbnail in the given path.

Returns undef if there isn't a thumbnail.

=cut

sub new {
    my $class  = shift;
    my $path   = shift;
    my $file   = $class->find_thumbnail($path) || return undef;
    my %params = ( path     => $path,
                   filename => $file, );
    my ($width, $height)    = $class->fetch_size("$path/$file"); 
    $params{width}  = $width;
    $params{height} = $height;
    return bless \%params, $class;
    
}

=head2 filename 

Return the filename of the thumbnail

=cut

sub filename {
    return $_[0]->{filename};
}


=head2 width 

Returns the width of 

=cut

sub width { 
    return $_[0]->{width};
}


=head2 height

Returns the height of the thumbnail

=cut

sub height {
    return $_[0]->{height};
}

=head2 find_thumbnail <path>

Return the filename of a thumbnail in the path, if there is one.

=cut

sub find_thumbnail  {
    my $self = shift;
    my $path = shift;
    my $ft   = File::Type->new;
    my $thumb;
    foreach my $file (<$path/*.*>) {
        my $short = $file;
        $short =~ s!.*/(.+)$!$1!;
        next unless $short =~ m!^album!;
        my $type = $ft->mime_type($file);
        next unless $type =~ m!^image/!;
        $thumb = $short;
        last;
    }
    return $thumb;

}

=head2 fetch_size <full path>

Return the width and height of an image;

=cut

sub fetch_size {
    my $self = shift;
    my $file = shift;
    return dim(image_info($file));
}
1;
