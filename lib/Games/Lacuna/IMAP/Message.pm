package Games::Lacuna::IMAP::Message;

use base 'Net::IMAP::Server::Message';

__PACKAGE__->mk_accessors(qw(msg_id));

sub fetch {
    my $self = shift;

    # If the client is requesting actual body data, go get it
    if (grep { /BODY\[\d+\]/ } @_) {
        unless (@{$self->mime->parts}) {

            my $inbox = Net::IMAP::Server->connection->auth->lacuna->inbox;
            my $data  = $inbox->read_message($self->msg_id);
            my $body  = $data->{message}->{body};
            $self->mime->parts_set([ Email::MIME->create(parts => [$body]) ]);
        }
    }

    $self->SUPER::fetch(@_);
}

1;
