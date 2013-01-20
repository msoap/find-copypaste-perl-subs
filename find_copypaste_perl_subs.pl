#!/usr/bin/perl

use warnings;
use strict;

use PPI;

our %exlude_subs = map {$_ => 1} qw/handler new/;

#................................................
sub main {
    my %all_subs;

    my $limit = shift @ARGV;

    for my $pm_file (@ARGV) {
        my $perl_doc = PPI::Document->new($pm_file) or next;

        my $sub_nodes = $perl_doc->find(
            sub {$_[1]->isa('PPI::Statement::Sub') and $_[1]->name}
        );

        next unless ref($sub_nodes) eq 'ARRAY';

        for my $node (@{$sub_nodes}) {
            my $sub_text = $node->content() or next;
            my ($name) = $sub_text =~ /sub \s+ (\w+)/x;
            next unless $name;
            next if $exlude_subs{$name};

            my $prev_word = '';
            my %stat = map {
                my $old_prev_word = $prev_word;
                $prev_word = $_;
                $old_prev_word . $_ => 1
            } split /\s+/, $sub_text;

            $all_subs{"${pm_file}::$name"} = \%stat;
        }
    }

    my %already_checked;
    for my $sub1 (sort keys %all_subs) {
        for my $sub2 (sort keys %all_subs) {
            next if $already_checked{"$sub1$sub2"};
            next if $sub1 eq $sub2;

            my $count1 = scalar keys %{$all_subs{$sub1}};
            next unless $count1;
            my $count2 = scalar keys %{$all_subs{$sub2}};
            next unless $count2;

            my $count_equal1 = scalar grep {$all_subs{$sub2}->{$_}} keys %{$all_subs{$sub1}};
            my $count_equal2 = scalar grep {$all_subs{$sub1}->{$_}} keys %{$all_subs{$sub2}};
            my $procent1 = $count_equal1 / $count1 * 100;
            my $procent2 = $count_equal2 / $count2 * 100;

            if ($procent1 > $limit && $procent2 > $limit) {
                printf "$sub1 - $sub2 : %02.1f / %02.1f\n", $procent1, $procent2;
            }

            $already_checked{"$sub1$sub2"}++;
            $already_checked{"$sub2$sub1"}++;
        }
    }
}

#................................................
main();
