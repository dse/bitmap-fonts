#!/usr/bin/env perl
use warnings;
use strict;
use Unicode::UCD qw(charblocks charinfo);

our $charblocks = charblocks();
our @block_names = sort { $charblocks->{$a}[0][0] - $charblocks->{$b}[0][0] } keys %$charblocks;

die("not enough arguments\n") if !scalar @ARGV;
my $arg = join(" ", @ARGV);
my $block = find_charblock($arg);
die("no such block: $arg\n") if !$block;
printf("# %s %s %s\n", $block->[0][2], u($block->[0][0]), u($block->[0][1]));
for (my $codepoint = $block->[0][0]; $codepoint <= $block->[0][1]; $codepoint += 1) {
    my $charinfo = charinfo($codepoint);
    next if !defined $charinfo;
    printf("STARTCHAR %s %s\n", u($codepoint), $charinfo->{name});
    print("|       |\n");
    print("|       |\n");
    print("^       ^\n");
    print("|       |\n");
    print("|       |\n");
    print("|       |\n");
    print("|       |\n");
    print("|       |\n");
    print("|       |\n");
    print("|       |\n");
    print("+       +\n");
    print("|       |\n");
    print("|       |\n");
    printf("ENDCHAR\n");
}

sub find_charblock {
    my ($query) = @_;
    if (exists $charblocks->{$query}) {
        return $charblocks->{$query};
    }
    my $result;
    if (defined ($result = parse_number($query))) {
        return find_charblock_by_codepoint($result);
    }
    if (defined ($result = parse_block_name($query))) {
        return $charblocks->{$result};
    }
}

sub u {
    my ($codepoint) = @_;
    return sprintf("U+%04X", $codepoint);
}

sub find_charblock_by_codepoint {
    my ($codepoint) = @_;
    my @block_names = grep { $charblocks->{$_}[0][0] <= $codepoint && $codepoint <= $charblocks->{$_}[0][1] } @block_names;
    return $charblocks->{$block_names[0]} if scalar @block_names == 1;
    return;
}

sub parse_number {
    my ($str) = @_;
    return hex($1) if $str =~ /^(?:u\+|0x)([[:xdigit:]]+)$/i;
    return oct($1) if $str =~ /^0(\d+)$/;
    return 0 + $1  if $str =~ /^\d+$/;
    return;
}

sub parse_block_name {
    my ($block_name) = @_;
    my $normalized_block_name = normalize($block_name);
    my @block_names = grep { $normalized_block_name eq normalize($_) } @block_names;
    return $block_names[0] if scalar @block_names == 1;
    return;
}

sub normalize {
    my ($str) = @_;
    $str = lc $str;
    $str =~ s/[^A-Za-z0-9]+//g;
    return $str;
}
