package Tetora;
use strict;
use warnings;

use Plack::Request;
use Plack::Response;

sub new {
    my $class = shift;
    my %args  = @_;
    bless { %args }, $class;
}

sub to_app {
    my $self = shift;
    sub {
        my $env = shift;
        my $req = Plack::Request->new($env);

        my $class;
        my $method;
        if (($class, $method) = $req->path =~ m{^/([^/]+)/([^/]+)}) {
        } elsif (($class) = $req->path =~ m{^/([^/]+)/$}) {
            $method = 'index';
        } elsif (($method) = $req->path =~ m{^/([^/]+)$}) {
            $class = 'Root';
        }

        my $klass = sprintf '%s::C::%s', ref($self), ucfirst($class);
        eval "use $klass";
        $@ and die $@;

        my $res = $klass->$method($req);

        $res->finalize
    };
}


1;
__END__
=head1 NAME

Tetora - フレームワーク作るね！

=cut
