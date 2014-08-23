use warnings;
use strict;

my %positions = ();
my %labels = ();
my $n=0; #no of values
my $c = 0; #number of classes
open (INFILE, "20ng-rec_talk.txt");
open (OUTFILE, ">20ng-rec_talk_features.txt");
open (OUTFILE_Y, ">20ng-rec_talk_labels.txt");
my $linenum = 0;
while (<INFILE>) {
	chomp;
	$linenum++;
	print $linenum."\n";
	my @values_2 = split('\t', $_);
	my @values = split(' ', $values_2[1]);
	my %frequencies = ();
	for (my $i = 0; $i < scalar(@values); $i++) {
		if (exists ($frequencies{$values[$i]})) {
			$frequencies{$values[$i]}++;
		}
		else {
			$frequencies{$values[$i]}=1;
		}
		if (!exists ($positions{$values[$i]})) {
			$n++;
			$positions{$values[$i]} = $n;	
		}
	}
	if (!exists ($labels{$values_2[0]})) {
		$c++;
		$labels{$values_2[0]} = $c;
	}
	print OUTFILE_Y $labels{$values_2[0]}."\n";
	my @keys = sort { $positions{$a} <=> $positions{$b} } keys %positions;
	foreach my $word (@keys) {
		if (exists ($frequencies{$word})) {
			print OUTFILE $linenum."\t".$positions{$word}."\t".$frequencies{$word}."\n";
		}
	}
}
close (INFILE);
close (OUTFILE);

open (OUTFILE, ">wordlist.dat");
my @keys2 = sort { $positions{$a} <=> $positions{$b} } keys %positions;
foreach my $word (@keys2) {
	print OUTFILE $word."\n";
}
close (OUTFILE);

open (OUTFILE_Z, ">labellist.dat");
my @keys3 = sort { $labels{$a} <=> $labels{$b} } keys %labels;
foreach my $label (@keys3) {
	print OUTFILE_Z $label."\n";
}
close (OUTFILE_Z);

