package Games::Lacuna::IMAP::Mailbox;

use base 'Net::IMAP::Server::Mailbox';
use aliased Games::Lacuna::IMAP::Conf;

use DateTime::Format::Strptime;
use DateTime::Format::Mail;

use constant LACUNADATE_PARSER => DateTime::Format::Strptime->new(pattern => "%e %m %Y %T %z");
use constant HEADERDATE_PARSER => DateTime::Format::Mail->new->loose;

sub load_data {
    my $self = shift;

    my $inbox = Net::IMAP::Server->connection->auth->lacuna->inbox;
    my $inbox_data = $inbox->view_inbox;

    for my $message_summary (@{$inbox_data->{messages} || []}) {
        my $from      = $message_summary->{from};
        my $to        = $message_summary->{to};
        my $subject   = $message_summary->{subject};
        my $date      = $message_summary->{date};
        my $from_addr = "$from\@lacuna.expanse";
        my $to_addr   = "$to\@lacuna.expanse";
        $from_addr    =~ tr/ /_/;
        $to_addr      =~ tr/ /_/;

        # Fix date, which looks like '17 11 2010 01:09:42 +0000'
        if ($date =~ /^(\d+) (\d+) (\d+) ([\d:]+) ([\+\d]+)/) {
            my $dt = $self->LACUNADATE_PARSER->parse_datetime($date);
            $dt->set_time_zone(Conf->time_zone || 'America/Los_Angeles');
            $date = $self->HEADERDATE_PARSER->format_datetime($dt);
        }

        # my $message_data = $inbox->read_message($message_summary->{id});
        # my $body      = $message_data->{message}->{body};

        my $msg = Net::IMAP::Server::Message->new(<<DATA);
From: "$from" <$from_addr>
To: "$to" <$to_addr>
Subject: $subject
Date: $date

$body
DATA

        if ($message_summary->{has_read}) {
            $msg->set_flag('\\Seen', 1);
        }

        if ($message_summary->{has_replied}) {
            $msg->set_flag('\\Answered', 1);
        }

        $self->add_message($msg);
    }
}

1;
