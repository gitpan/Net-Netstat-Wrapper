
use Test::More tests => 1;
BEGIN { use_ok('Net::Netstat::Wrapper') };

use strict;
use Net::Netstat::Wrapper;

my @netstat = Net::Netstat::Wrapper->only_port();
print "@netstat\n";

@netstat = Net::Netstat::Wrapper->ip_port();
print "@netstat\n";

exit(0);
