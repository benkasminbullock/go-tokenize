#!/home/ben/software/install/bin/perl
use warnings;
use strict;
use FindBin '$Bin';
use Trav::Dir;
use Go::Tokenize 'tokenize';
my @files;
my $td = Trav::Dir->new (
    only => qr!\.go$!,
);
binmode STDOUT, ":encoding(utf8)";
$td->find_files ($Bin, \@files);
for my $file (@files) {
    my $text = read_text ($file);
    my $orig = $text;
    my $tokens = tokenize ($text);
    for my $token (@$tokens) {
	if ($token->{type} ne 'comment') {
	    next;
	}
	my $c = $token->{contents};
	if ($c =~ /doofus\.(\w+)/) {
	    my $what = $1;
	    if ($what eq 'go') {
		# A reference to doofus.go
		next;
	    }
	    my $d = quotemeta ("doofus.$what");
	    my $new = $c;
	    $new =~ s!$d!\l$what!;
	    $text =~ s!\Q$c\E!$new!;
	}
    }
    if ($text ne $orig) {
	write_text ($file, $text);
    }
}
