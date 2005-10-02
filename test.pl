use Net::Netstat::Wrapper;
my @netstat;

print "\n- Tcp open ports:\n\n";
@netstat = Net::Netstat::Wrapper->only_port();
for (@netstat) { print "$_\n"; }

print "\n- Local address and tcp open ports:\n\n";
@netstat = Net::Netstat::Wrapper->ip_port();
for (@netstat) { print "$_\n"; }

print "\n- PID/Program name:\n\n";
@netstat = Net::Netstat::Wrapper->pid_pname();
for (@netstat) { print "$_\n"; }

print "\n";
