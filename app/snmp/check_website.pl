#!/usr/bin/perl

#
# By Cyril Menigoz

use Nagios::Plugin;
my $shinken;
my $curl;
my $critical=10.000;
my $warning=1.000;
my $code="200";
my $url;
my @value=();
my $shinCode;
my $shinMess;

$shinken = Nagios::Plugin->new(
        plugin                   => 'check_website',
        shortname        => 'Website access',
        version                => '1.0',
        usage                   => 'Usage: %s  -u <Url>  [-C <HTTP code expected>]  [-w <warning access time>] [-c <critical access time >]  ',
        blurb                    => 'This plugin check the http returned code and the access time of a website ',
        license                 => 'This nagios plugin is free software, and comes with ABSOLUTELY no WARRANTY!'
);

$shinken->add_arg(spec => 'code|C=s',
                          help => "default : 200",
                          required => 0);
                          
$shinken->add_arg(spec => 'url|u=s',
                          help => "the url of the website to check",
                          required => 1);
                          
$shinken->add_arg(spec => 'warning|w=f',
                          help => "access time warning threshold, default 1 second ",
                          required => 0);

$shinken->add_arg(spec => 'critical|c=f',
                          help => "access time critical threshold, default 5 seconds ",
                          required => 0);







$shinken->getopts;


$url=$shinken->opts->url;


if(defined($shinken->opts->critical))
{
	$critical=$shinken->opts->critical;
}

if(defined($shinken->opts->warning))
{
	$warning=$shinken->opts->warning;
}

if(defined($shinken->opts->code))
{
	$code=$shinken->opts->code;
}

#$tmp1=`curl -I dakhira.com - w 'TIME '%{time_total} |grep -E 'HTTP|TIME' |awk '{print \$2}'`;
$tmp1=`curl  -I $url -w 'SHIN '%{time_total} 2>/dev/null |grep -E 'HTTP|SHIN' |awk '{print \$2}'`;

@value=split("\n",$tmp1);
@value[1] =~ s/,/./g;


if($code!=@value[0])
{
	$shinCode=2;
	$shinMess= $url. " NOT AVAILABLE !";
	@value[1]=-1;
}
else
 {
	  $shinCode = $shinken->check_threshold
	  (
		    check => @value[1],
		    warning => $warning,
		    critical => $critical,
	  );

	  $shinMess = $url. " available, access time : ".@value[1]." s";
}

$shinken->add_perfdata(
        label => "Access time to ".$url,
        value => @value[1],
);

$shinken->nagios_exit($shinCode,$shinMess);
