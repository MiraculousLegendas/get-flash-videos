#summary Adding support for a site
#labels Phase-Implementation

Support for a site is added by creating the relevant `FlashVideo::Site::` module.

The name is important, because get\_flash\_videos searches through the parts of the
hostname in the given URL to download to find the module.

For example given: 'http://www.example.com/video/1234' it will search for:

  * `FlashVideo::Site::Www`
  * `FlashVideo::Site::Example`
  * `FlashVideo::Site::Com`

(The first letter is capitalised as is the convention for Perl modules, the rest is lowercase.)

In this case the best match will be achieved by using
`FlashVideo::Site::Example`. So for this example we'll create that. You can do
the following even with the combined version, as get\_flash\_videos will still
attempt to load the modules from disk:

```
 mkdir -p FlashVideo/Site
 $EDITOR FlashVideo/Site/Example.pm
```

Now in Example.pm put something like this:

```
# Part of get-flash-videos. See get_flash_videos for copyright.
package FlashVideo::Site::Videolectures;

use strict;
use FlashVideo::Utils;

sub find_video {
  my ($self, $browser, $embed_url) = @_;

  ... code here ...

  return $url, $filename;
}

1;

```

As you can see this consists of a module with one subroutine 'find\_video' which
will be called when a video needs downloading.

When find\_video is called you can rely on on `WWW::Mechanize` object `$browser`
being at the page the user provided on the command line, so matching on
`$browser->content` needs nothing special. `$embed_url` will normally be the same
as the page, but in the case of embedded content it may differ (see the
Brightcove support for example).

For Flash video distributed over HTTP, the subroutine should return the URL
where the FLV video can be found. For sites which use RTMP, a hash reference
describing the parameters to rtmpdump should be returned. See a module like
Brightcove which uses RTMP as an example. In both cases, a filename to use
(this should ideally be something descriptive, not necessarily the filename
used by the video site) should be returned as the second item. Multiple,
alternative filenames can also be specified as additional items in the return
list.

Going back to the example, say that the site embedded a file in the page, like
so: `file: 'some-video'`.

It would be possible to parse out the filename with some code like the
following:

```
   # Grab the file from the page..
   my $file = ($browser->content =~ /file:\s*'([^']+)'/)[0];
   die "Unable to extract file" unless $file;

   # Construct the full URL based on the path..
   my $url = URI->new_abs($file, $browser->uri);
```

Now we have the URL, next is getting a sensible filename for it, we'll just use
the title of the HTML page for that..

```
  my $filename = title_to_filename(extract_title($browser));

  $filename ||= get_video_filename();
```

(`title_to_filename`, `extract_title` and `get_video_filename` are methods provided by `FlashVideo::Utils`. **Please** make sure you use these methods for naming files, particularly if you can't extract the title of the page. get\_video\_filename() returns a date-based filename like <tt>video20081111213736.mp4</tt>, which although not ideal, is better than "default" or similar. Both functions take a type parameter for use as the file's extension. This defaults to flv, but should be set to mp4 if the downloaded file is an MPEG-4 container.)

To make it easy to debug your plugin, you should use the `info` and `debug` functions from `FlashVideo::Utils` like this:

```
  info "Informative message shown unless --quiet is supplied";
  debug "Debugging message shown when --debug is enabled";
```

All these messages are written to STDERR. Newlines are automatically appended to the messages.

`FlashVideo::Utils` has several other useful functions for various things like
extracting titles out of pages (titles are often a good starting point for
video filenames) and SWF hashing (some sites use this for authentication).

That is all there is to creating a site module, except obviously working out
what the site actually does. [Firebug](http://www.getfirebug.com/), [Wireshark](http://www.wireshark.org/), [Tamper data (Firefox extension)](http://tamperdata.mozdev.org/), [Burp](http://portswigger.net/proxy/) and so on are useful here.

## Other tips ##

Some sites use XML to store video details and metadata. Instead of trying to parse XML yourself or grab the relevant parts using a regular expression, consider using `from_xml` from `FlashVideo::Utils`.

Similarly, sites are increasingly also using JSON for video details and metadata. To process this, use `FlashVideo::JSON`.