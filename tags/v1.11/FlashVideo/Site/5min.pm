# Part of get-flash-videos. See get_flash_videos for copyright.
package FlashVideo::Site::5min;

use strict;
use FlashVideo::Utils;

sub find_video {
  my ($self, $browser) = @_;

  my $filename = title_to_filename(extract_info($browser)->{meta_title});

  my $url;
  if ($browser->content =~ m{videoID=(\d+)}) {
    my $id = $1;

    my $res = $browser->post(
      "http://www.5min.com/handlers/smartplayerhandler.ashx", {
        referrerURL => "none",
        autoStart   => "None",
        sid         => 0,
        func        => "InitializePlayer",
        overlay     => "None",
        videoID     => $id,
        isEmbed     => "false"
      }
    );
    $url = $1 if $res->content =~ /vidURL\W+([^"]+)/;
  }

  return $url, $filename;
}

1;
