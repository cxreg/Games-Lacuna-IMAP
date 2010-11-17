package Games::Lacuna::IMAP::Auth;

use base 'Net::IMAP::Server::DefaultAuth';

use aliased Games::Lacuna::IMAP::Conf;
use Games::Lacuna::Client;

__PACKAGE__->mk_accessors(qw(lacuna));

sub auth_plain {
    my ($self, $user, $pass) = @_;

    $self->lacuna(Games::Lacuna::Client->new(
        uri      => Conf->uri,
        api_key  => Conf->api_key,
        name     => $user,
        password => $pass,
    ));

    if ($self->lacuna->assert_session) {
        $self->user($user);
        return 1;
    } else {
        return;
    }
}

1;
