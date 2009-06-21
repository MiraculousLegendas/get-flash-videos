# Part of get-flash-videos. See get_flash_videos for copyright.
package FlashVideo::Site::Truveo;

use strict;
use FlashVideo::Utils;

sub find_video {
  my($self, $browser, $embed_url) = @_;

  my($videourl) = $browser->content =~ /var videourl = "(.*?)"/;

  # Maybe we were given a direct URL..
  $videourl = $embed_url
    if !$videourl && $browser->uri->host eq 'xml.truveo.com';

  die "videourl not found" unless $videourl;

  $browser->get($videourl);

  if($browser->content =~ /url=(http:.*?)["']/) {
    my $redirect = $1;

    $browser->allow_redirects;
    $browser->get($redirect);

    my($package, $possible_url) = FlashVideo::URLFinder::find_package($redirect, $browser);

    return $package->find_video($browser, $possible_url);
  } else {
    die "Redirect URL not found";
  }
}

1;
