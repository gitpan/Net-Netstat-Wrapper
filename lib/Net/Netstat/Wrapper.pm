package Net::Netstat::Wrapper;

# Copyright (c) 2005 Matteo Cantoni. All rights reserved.
# This program is free software; you can redistribute it
# and/or modify it under the same terms as Perl itself.

use strict;
use Carp;
use vars qw($VERSION);
$VERSION = 0.03;

$|=1;

my $so = $^O;
my $cmd = 'netstat';
$cmd = '/bin/netstat' if $so ne 'MSWin32';
my $flags = '-na';
my @tcp;

my @output = `$cmd $flags`;
chomp @output;

foreach (@output){
	push @tcp, "$_" if ($_ =~ m/tcp/i);
}

sub only_port{
	my @only_port;

	foreach (@tcp){
		my @tcpsplit = split(/\s+/, $_);
		if ($so =~ /linux/){
			if ($tcpsplit[5] =~ m/LISTEN/){
				if ($tcpsplit[3] =~ m/^:::/){
					my @tmp = split(/:::/,$tcpsplit[3]);
					push @only_port,$tmp[1];
				} else {
					my @tmp = split(/:/,$tcpsplit[3]);
					push @only_port,$tmp[1];
				}
			}
		} elsif ($so =~ /cygwin|MSWin32/){
			if ($tcpsplit[4] =~ m/LISTENING/){
				if ($tcpsplit[2] =~ m/^:::/){
					my @tmp = split(/:::/,$tcpsplit[2]);
					push @only_port,$tmp[1];
				} else {
					my @tmp = split(/:/,$tcpsplit[2]);
					push @only_port,$tmp[1];
				}
			}
		}
	}
	chomp @only_port;
	return @only_port;
}

sub ip_port{
	my @ip_port;
	foreach (@tcp){
		my @tcpsplit = split(/\s+/, $_);
		if ($so =~ /linux/){
			if ($tcpsplit[5] =~ m/LISTEN/){
				push @ip_port,"$tcpsplit[3]\n";
			}
		} elsif ($so =~ /cygwin|MSWin32/){
			if ($tcpsplit[4] =~ m/LISTENING/){
				push @ip_port,"$tcpsplit[2]\n";
			}
		}
	}
	chomp @ip_port;
	return @ip_port;
}

sub pid_pname{
	if ($so =~ /linux/){
		$flags = '-punta';
		@output = `$cmd $flags`;
		chomp @output;

		undef @tcp;
		foreach (@output){
			push @tcp, "$_" if ($_ =~ m/tcp/i);
		}

		my @pid_pname;
		foreach (@tcp){
			my @tcpsplit = split(/\s+/, $_);
			if ($so =~ /linux/){
				if ($tcpsplit[5] =~ m/LISTEN/){
					for ($tcpsplit[6]) { s/\:$//; }
						push @pid_pname,$tcpsplit[6];
					}
				}
			}
		chomp @pid_pname;
		return @pid_pname;
	} elsif ($so =~ /cygwin|MSWin32/){
		croak "'pid_pname' method works only on Linux system.";
	}
}

1;


__END__

=head1 NAME

  Net::Netstat::Wrapper - Perl module for getting the current tcp open ports 

=head1 DESCRIPTION

  Netstat module provides to you a simple way for getting the current tcp open ports
  (ports, ip address interfaces) on a local system (Linux, Win*, Mac OS X 10.3.9).

=head1 SYNOPSIS

  use Net::Netstat::Wrapper;

  print "\nTcp open ports:\n\n";
  @netstat = Net::Netstat::Wrapper->only_port();
  for (@netstat) { print "$_\n"; }

  print "\nLocal address and tcp open ports:\n\n";
  @netstat = Net::Netstat::Wrapper->ip_port();
  for (@netstat) { print "$_\n"; }

  print "\n- PID/Program name:\n\n";
  @netstat = Net::Netstat::Wrapper->pid_pname();
  for (@netstat) { print "$_\n"; }

=head1 METHODS

=head2 only_port()

  @netstat = Net::Netstat::Wrapper->only_port();

  Get the tcp open ports. 

=head2 ip_port()

  @netstat = Net::Netstat::Wrapper->ip_port();

  Get the local address and tcp open ports.

=head2 pid_pname()

  @netstat = Net::Netstat::Wrapper->pid_pname();

  Get the pid and process's name that bind a tcp port. This method works only on Linux.

=head1 SYSTEM REQUIREMENTS

  This module requires "netstat" binary.  

=head1 SEE ALSO

  man netstat

=head1 AUTHOR

  Matteo Cantoni goony@nothink.org
  http://www.nothink.org

=head1 COPYRIGHT

  Copyright (c) 2005 Matteo Cantoni. All rights reserved.
  This program is free software; you can redistribute it
  and/or modify it under the same terms as Perl itself.

=cut
