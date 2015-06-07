#!/usr/bin/perl

use strict;
use warnings;

use English qw(-no_match_vars);
use JSON;

our $VERSION = 0.1;

sub generate
{
	my ($results, $filename) = @_;

	my $json_text = q{};
	if (open FH, '<', $filename) {
		local $INPUT_RECORD_SEPARATOR = undef;
		$json_text = <FH>;
		close FH;
	}

	# Trim any whitespace
	$json_text =~ s/^\s+|\s+$//g;

	if ($json_text ne q{}) {
		my $json = JSON->new;
		my $data = $json->decode ($json_text);

		foreach my $row (@{$data}) {
			if (!defined $row->{'hostname'}) {
				next;
			}
			my $hostname = $row->{'hostname'};
			if (defined ${$results}->{$hostname}) {
				my $old_et = ${$results}->{$hostname}->{'expiry-time'};
				my $new_et = $row->{'expiry-time'};
				if ($old_et >= $new_et) {
					next;
				}
			}

			${$results}->{$row->{'hostname'}} = $row;
		}
	}

	return;
}

sub main
{
	my $results = {};

	foreach (@ARGV) {
		generate (\$results, $_);
	}

	# printf "# DNS for VM hosts using DHCP\n";
	foreach (sort keys %{$results}) {
		my $row = $results->{$_};
		# printf "%-18s%-12s%15s%30s # %s\n", $row->{'ip-address'}, $row->{'hostname'}, $row->{'hostname'} . '.vm', $row->{'hostname'} . '.vm.flatcap.org', $row->{'mac-address'};
		printf "%-18s%s.vm\n", $row->{'ip-address'}, $row->{'hostname'};
	}
	# printf "\n";

	return 0;
}

exit main();

