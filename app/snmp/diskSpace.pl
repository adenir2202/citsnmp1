#! /bin/perl

use strict;
use warnings;
use Net::SNMP qw(snmp_dispatcher);

my $diskspaceOID = '1.3.6.1.4.1.2021.9.1.7.1';

foreach my $host (@ARGV)
{
    my ($session, $error) = Net::SNMP->session(
        -hostname    => $host,
        -nonblocking => 0x1,
        );

    if (!defined($session))
    {
        warn "ERROR: $host produced $error - not monitoring\n"
    }
    else
    {
        my ($last_poll) = (0);

        $session->get_request(-varbindlist => [$diskspaceOID],-callback    => [ \&diskspace_cb, \$last_poll ]);
    }
}

snmp_dispatcher();

exit 0;

sub diskspace_cb
{
    my ($session, $last_poll) = @_;

    if (!defined($session->var_bind_list))
    {
        printf("%-15s  ERROR: %s\n", $session->hostname, $session->error);
    }
    else
    {
        my $space = $session->var_bind_list->{$diskspaceOID};

        if ($space < ${$last_poll})
        {
            my $diff = ((${$last_poll}-$space)/${$last_poll})*100;
            printf("WARNING: %s has lost %0.2f%% diskspace)\n",
                   $session->hostname,$diff);
        }

        printf("%-15s  Ok (%s)\n",
               $session->hostname,
               $space
               );

        ${$last_poll} = $space;
    }

    $session->get_request(
        -delay       => 2,
        -varbindlist => [$diskspaceOID]
        );
}
