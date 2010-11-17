package Games::Lacuna::IMAP::RPC;

use aliased Games::Lacuna::IMAP::Conf;
use Games::Lacuna::Client;

use Carp qw(croak);

my $lacuna = Games::Lacuna::Client->new(
    uri      => Conf->uri,
    name     => Conf->name,
    password => Conf->password,
    api_key  => Conf->api_key,
);

sub client {
    return $lacuna;
}
