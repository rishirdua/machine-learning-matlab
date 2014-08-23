use warnings;
use strict;

my %positions = ();
my $n = 0;
my $spam = -1;

open (INFILE, "q4train.dat");
open (OUTFILE, ">q4train_mod.dat");
while (<INFILE>) {
	chomp;
	my @values = split(' ', $_);
	my %frequencies = ();
	for (my $i = 0; $i < scalar(@values); $i = $i+2) {
		if ($i==0) {
			if ($values[1] eq 'spam') {
				$spam = 1;
			}
			else {
				$spam = -1;
			}
		}
		else {
			$frequencies{$values[$i]} = $values[$i+1];
			if (!exists ($positions{$values[$i]})) {
				$n++;
				$positions{$values[$i]} = $n;	
			}
		}
	}
	print OUTFILE $spam." ";
	my @keys = sort { $positions{$a} <=> $positions{$b} } keys %positions;
	foreach my $word (@keys) {
		if (exists ($frequencies{$word})) {
			print OUTFILE " ".$positions{$word}.":".$frequencies{$word};
		}
	}
	print OUTFILE "\n";
}
close (INFILE);
close (OUTFILE);

open (INFILE, "q4test.dat");
open (OUTFILE, ">q4test_mod.dat");
while (<INFILE>) {
	chomp;
	my @values = split(' ', $_);
	my %frequencies = ();
	for (my $i = 0; $i < scalar(@values); $i = $i+2) {
		if ($i==0) {
			if ($values[1] eq 'spam') {
				$spam = 1;
			}
			else {
				$spam = -1;
			}
		}
		else {
			$frequencies{$values[$i]} = $values[$i+1];
			if (!exists ($positions{$values[$i]})) {
				$n++;
				$positions{$values[$i]} = $n;
			}
		}
	}
	print OUTFILE $spam." ";
	my @keys = sort { $positions{$a} <=> $positions{$b} } keys %positions;
	foreach my $word (@keys) {
		if (exists ($frequencies{$word})) {
			print OUTFILE " ".$positions{$word}.":".$frequencies{$word};
		}
	}
	print OUTFILE "\n";
}
close (INFILE);
close (OUTFILE);

open (OUTFILE, ">wordlist.dat");
my @keys = sort { $positions{$a} <=> $positions{$b} } keys %positions;
foreach my $word (@keys) {
	print OUTFILE $word."\n";
}