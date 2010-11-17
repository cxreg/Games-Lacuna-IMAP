package Games::Lacuna::IMAP::Auth;

use base 'Net::IMAP::Server::DefaultAuth';

use aliased Games::Lacuna::IMAP::Conf;
use Games::Lacuna::Client;

sub auth_plain {
    my ($self, $user, $pass) = @_;

    my $self->{lacuna} = Games::Lacuna::Client->new(
        uri      => Conf->uri,
        api_key  => Conf->api_key,
        name     => $user,
        password => $pass,
    );

    if ($self->{lacuna}->assert_session) {
        return 1;
    } else {
        return;
    }
}

1;
