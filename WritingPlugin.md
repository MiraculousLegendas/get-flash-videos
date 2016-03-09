#summary Writing a plugin
#labels Phase-Implementation

# Introduction #

Writing a plugin is practically the same as adding support for a site (see AddingSite).

Currently plugins can only implement the same functionality as normal site modules. We are planning on adding support for other types of plugin in future.

# List of plugins #

Once you've written and tested your plugin, please contact us and we'll add it to the PluginList page to help people find it.

# Developing and testing #

To develop and test your plugin, we recommend using a check-out of our git repository. You could use the 'standalone' script, but this makes it harder to figure out why your plugin doesn't compile.

Place your plugin (called say 'Channel4.pm' for `FlashVideo::Site::Channel4`) in your personal get\_flash\_videos plugins directory. On Linux and other Unix-like operating systems, this in `~/.get_flash_videos/plugins`. On Windows, this is in `get_flash_videos/plugins` in your 'application data' directory. Then run get\_flash\_videos with the `--debug` option. When it starts, it should show output like:

```
  2 plugins installed:
  - Test.pm
  - Foo.pm
```

If you don't see your plugin listed here, make sure you've copied it into the correct location. You can see where get\_flash\_videos is looking for plugins by looking further into the debug output:

```
  Trying to open plugin /home/zak/.get_flash_videos/plugins/Brightcove.pm
```

If get\_flash\_videos doesn't use your plugin for downloading the video you've specified, check that the package name matches part of the hostname. (For example, 'channel4' matches 'Channel4'.) If your plugin supports several different hosts, or supports embedded videos which use a particular kind of player, define a `can_handle` method. If get\_flash\_videos still doesn't use your plugin for downloading the video you've specified, check that your code compiles. The easiest way of doing this is by running, from your get\_flash\_videos git checkout directory:

```
  perl -c ~/.get_flash_videos/plugins/Plugin.pm
```

(If you're in your get\_flash\_videos git checkout directory, you don't need to alter Perl's search path to find get\_flash\_videos' modules.)

## Adding support for updating ##

Once you've written your site module, you can add support for get\_flash\_videos updating it automatically when a user supplies the `--update` option. Updating plugins works in a very simple way. Simply define `@update_urls` at package level, specifying a list of URLs for your plugin:

```
  our @update_urls = (
	'http://somesite.com/code/PluginFile.pm'
  );
```

Whether you need multiple URLs or not depends on the nature of your plugin and where you're hosting it. If you think there's a chance that your plugin might be taken off whatever site you're hosting it on, or the site has poor reliability, you can define multiple URLs. If you do this though, be sure to keep the different files in sync. get\_flash\_videos determines whether it needs to update your plugin by comparing the plugin's modification time on disk with the Last-Modified-Date that the server returns in response to a HEAD request. Some code hosting sites set this to the date and time of your last commit, which is handy.

If this kind of updating isn't flexible enough for your plugin, you can define your own `update` method. In this case, the `@update_urls` array is ignored. In this situation, you'll need to call `install_plugin` method to actually update the plugin on disk.

## Adding support for search ##

For some sites/plugins, having a search feature is useful. If a plugin defines a search method, get\_flash\_videos will call its search method and combine the results with Google Video search results (except in one specific case, see later).

Your search method will be passed in the user's search string as the first parameter (after self):

```
sub search {
  my ($self, $search) = @_;
}
```

Return results in order of relevance (from highest to lowest) as a list of hash references with these keys:

  * `name`: textual name of the search result like "Funny video 123".
  * `url`: absolute URL to the page on which the video is found.
  * `description`: textual description of the search result. Will be shown in search results, possibly truncated.

Results from plugins are always shown before Google Video search results in the result list. Google Video will always be searched unless a user restricts their search to your site. This happens when a user's search string includes the name of your plugin as the first item in their search string. For example, if your plugin is called Funvideo, if a user runs:

```
get_flash_videos Funvideo something
```

Then only your plugin's search method will be called. Note that the name of your plugin is removed from the search string before it's passed to your search method, so you don't need to remove it.

Some other general tips:

  * Remember to decode HTML entities in search result names/titles.
  * `WWW::Mechanize`'s `find_all_links` method is useful for retrieving all links matching flexible criteria from the page.
  * Think about how your search results will be presented. Will they include enough information for users to make an informed decision? Depending on the site that you're supporting, the length of the video might be important, so include that if possible.
  * Try to put the most relevant result first, as when a user searches with the `--yes` option, the first result is automatically downloaded.

## Subtitles ##

If possible, please add support for subtitles. (But use the preferences object, passed in to your plugin or site's `find_video` method as the 4th argument, to control whether or not your plugin downloads subtitles.) Subtitles actually make videos useful to people who are deaf or hard of hearing, and can be useful otherwise for finding old videos in future. Please convert subtitles to [SubRip format](http://en.wikipedia.org/wiki/SubRip#SubRip_text_file_format). The `convert_sami_subtitles_to_srt` function in `FlashVideo::Utils` might be useful. Please use the same base name for the subtitle file as for the video (for example, for "foo.flv", use "foo.srt"), so media players like mplayer and VLC can find subtitles.

General subtitle tips:

  * Avoid (where possible) having text in uppercase.
  * Preserve formatting where possible. Several media players like VLC support limited subtitle formatting (like bold, italic and so on), but are very sensitive to tag case and format. For example `<I>` may not work, but `<i>` might. Create a trivial subtitle file to test.
  * Encode subtitles in UTF-8 if possible.