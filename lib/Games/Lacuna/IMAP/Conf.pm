package Games::Lacuna::IMAP::Conf;

use JSON::Any;
use File::Slurp qw(slurp);

my $CONFIG = './config.json';

my $json_parser = JSON::Any->new;
my $conf_json   = slurp($CONFIG);
my $CONF = $json_parser->from_json($conf_json);

sub AUTOLOAD {
    my $key = $AUTOLOAD;
    $key =~ s/.*://;

    return $CONF->{$key};
}

sub DESTROY {}

1;
