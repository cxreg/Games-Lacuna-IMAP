package Games::Lacuna::IMAP::Model;

use base 'Net::IMAP::Server::DefaultModel';
use Games::Lacuna::IMAP::Mailbox;

sub init {
    my ($self) = @_;

    $self->root(Games::Lacuna::IMAP::Mailbox->new);
    $self->root->add_child(name => 'INBOX');
}

1;
