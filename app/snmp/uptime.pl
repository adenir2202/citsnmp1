#! /usr/local/bin/perl

use strict;

use Net::SNMP;

my $uptimeOID = '1.3.6.1.2.1.1.3.0';
my $sysDescrOID = '1.3.6.1.2.1.1.1.0';
#sysObjectId.0   1.3.6.1.2.1.1.2.0
#sysUpTime.0     1.3.6.1.2.1.1.3.0
my $sysContactOID = '1.3.6.1.2.1.1.4.0';
#sysName.0       1.3.6.1.2.1.1.5.0
#sysLocation.0   1.3.6.1.2.1.1.6.0
#sysServices.0   1.3.6.1.2.1.1.7.0
#ifNumber.0      1.3.6.1.2.1.2.1.0
 
foreach my $host (@ARGV)
{
    my ($session, $error) = Net::SNMP->session(
        -hostname  =>  $host,
        -community => 'public',
        -port      => 161
        );

    warn ("ERROR for $host: $error\n") unless (defined($session));

    my $result = $session->get_request(-varbindlist => [$uptimeOID]);

    if (!defined($result))
    {
        warn ("ERROR: " . $session->error . "\n");
    }
    else
    {
        printf("Uptime for %s: %s\n",$host, $result->{$uptimeOID});
    }

    $session->close;

    my $result = $session->get_request(-varbindlist => [$sysDescrOID]);

    if (!defined($result))
    {
        warn ("ERROR: " . $session->error . "\n");
    }
    else
    {
        printf("Uptime for %s: %s\n",$host, $result->{$uptimeOID});
    }

    $session->close;
}

   my ($session, $error) = Net::SNMP->session(
      -hostname  => shift || 'localhost',
      -community => shift || 'public',
      -port      => shift || 161 
   );

   if (!defined($session)) {
      printf("ERROR: %s.\n", $error);
      exit 1;
   }

   my $sysUpTime = '1.3.6.1.2.1.1.3.0';

   my $result = $session->get_request(-varbindlist => [$sysUpTime] );

   if (!defined($result)) {
      printf("ERROR: %s.\n", $session->error);
      $session->close;
      exit 1;
   }

   printf("sysUpTime for host '%s' is %s\n", $session->hostname, $result->{$sysUpTime} );

   $session->close;

   exit 0;

