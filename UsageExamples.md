#summary Examples of usage
#labels Phase-Implementation

Play a video (may prompt for filename still, override with -y):

> get\_flash\_videos -p http://some.site/video

Download a video (note quotes are required for URLs with special characters like '&' in):

> get\_flash\_videos "http://some.site/video?f=1&v=1234"

Play the URL on the clipboard (UNIX):

> xclip -o | xargs get\_flash\_videos -y -p

Play the URL on the clipboard (OSX):

> pbpaste | xargs get\_flash\_videos -y -p

(Note if there is text on the clipboard rather than a URL above then get\_flash\_videos will search for it).

Play the first video matching "Open Source":

> get\_flash\_videos -y -p Open Source

Install a plugin:

> get\_flash\_videos --add-plugin http://website.com/PluginName.pm

Download all videos from file containing a list of URLs separated by new lines:
> cat urls | while read line; do get\_flash\_videos "$line"; done