#!perl
use strict;
use lib qw(..);
use constant DEBUG => $ENV{DEBUG};
use Test::More tests => 2;
use FlashVideo::GoogleVideoSearch;

my @results = FlashVideo::GoogleVideoSearch::search('Iron Man trailer');

ok(@results > 1, "Results returned");

# Check to see if the results look sane
my $sane_result_count = 0;

foreach my $result (@results) {
  if ((ref($result) eq 'HASH') and
      $result->{name} and
      $result->{url} =~ m'^http://') {
    $sane_result_count++;
  }
}

ok($sane_result_count == @results, "Results look sane");
