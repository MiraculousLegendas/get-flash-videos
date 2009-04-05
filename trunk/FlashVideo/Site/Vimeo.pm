# Part of get-flash-videos. See get_flash_videos for copyright.
package FlashVideo::Site::Vimeo;

use strict;
use FlashVideo::Utils;

sub find_video {
  my ($self, $browser, $url) = @_;
  my $base = "http://vimeo.com/moogaloop";

  my $has_xml_simple = eval { require XML::Simple };
  if(!$has_xml_simple) {
    die "Must have XML::Simple installed to download Vimeo videos";
  }

  my $id;
  if($url =~ /clip_id=(\d+)/) {
    $id = $1;
  } elsif($url =~ m!/(\d+)!) {
    $id = $1;
  }
  die "No ID found\n" unless $id;

  $browser->get("$base/load/clip:$id/embed?param_fullscreen=1&param_clip_id=$id&param_show_byline=0&param_server=vimeo.com&param_color=cc6600&param_show_portrait=0&param_show_title=1");

  my $xml = eval {
    XML::Simple::XMLin($browser->content)
  };

  if ($@) {
    die "Couldn't parse Vimeo XML : $@";
  }

  my $filename = title_to_filename($xml->{video}->{caption}) || get_video_filename();
  my $request_signature = $xml->{request_signature};
  my $request_signature_expires = $xml->{request_signature_expires};

  # I want to follow redirects now.
  $browser->allow_redirects;

  my $url = "$base/play/clip:$id/$request_signature/$request_signature_expires/?q=sd&type=embed";

  return $url, $filename;
}

1;
