package Games::Lacuna::IMAP::RPC;

use aliased Games::Lacuna::IMAP::Conf;
use Games::Lacuna::Client;

use Carp qw(croak);

sub new {
    my $class = shift;
    my %args = @_;

    my $self = bless \%args, $class;
    $self->{lacuna} = Games::Lacuna::Client->new(
        uri      => Conf->uri,
        api_key  => Conf->api_key,
        name     => $self->{name},
        password => $self->{password},
    );
    return $self;
}

sub DESTROY {}

sub AUTOLOAD {
    my $self = shift;
    my $func = $AUTOLOAD;
    $func =~ s/.*://;
    $self->{lacuna}->$func(@_);
}

1;
