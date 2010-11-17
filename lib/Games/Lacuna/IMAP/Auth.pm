package Games::Lacuna::IMAP::Auth;

use base 'Net::IMAP::Server::DefaultAuth';
use aliased Games::Lacuna::IMAP::RPC;

sub auth_plain {
    my ($self, $user, $pass) = @_;

    my $lacuna = RPC->client;

    if ($lacuna->assert_session) {
        return 1;
    } else {
        return;
    }
}

1;
