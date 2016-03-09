#summary How to install get\_flash\_videos
#labels Featured,Phase-Deploy

# Requirements #

Basic requirements:
  * perl >= 5.8.0
  * WWW::Mechanize (but not for the combined version, see OSX below).
  * Module::Find (but not for the combined version).

Optional requirements (for support for certain sites):
  * rtmpdump (see section below)
  * XML::Simple
  * Data::AMF
  * Compress::Zlib
  * Crypt::Rijndael

# Various operating systems #

## Getting latest code from git ##

We haven't done a release for ages, and get\_flash\_videos often changes pretty frequently as sites constantly update, breaking the code. This means that the easiest approach is often to get the latest code from git.

On a Linux or other UNIX-like operating systems, if you've got git installed, just run:

```
  git clone https://github.com/monsieurvideo/get-flash-videos.git
```

This will produce a get-flash-videos directory. cd into it and from there you can simply run:

```
  ./get_flash_videos
```

To update, use standard git commands. This isn't the right place for a git tutorial, but in general just use:

```
  git pull origin master
```

## Unofficial releases ##

If you don't like the idea of getting get\_flash\_videos from git, njtaylor kindly provides downloads of unofficial get\_flash\_videos releases from [njtaylor's github page](https://github.com/njtaylor/get-flash-videos/releases).

## Debian / Ubuntu packaged version ##

Run the following commands in a terminal, this installs it system-wide.

```
 sudo apt-get install libwww-mechanize-perl libxml-simple-perl
 wget http://get-flash-videos.googlecode.com/files/get-flash-videos_1.24-1_all.deb
 sudo dpkg -i get-flash-videos_1.24-1_all.deb
```

Then, to download something:

```
 get_flash_videos url..
```

See UsageExamples for more.

## Fedora ##

This installs all the dependencies:

```
yum install -y perl-libxml-perl perl-WWW-Mechanize perl-Compress-Raw-Zlib perl-Crypt-Rijndael
```

You can then simply run the downloaded script.

Some sites require Data::AMF. This isn't packaged for Fedora apparently so you'll have to download it off CPAN.

## Other Linux/Unix-like OS ##

Install the Perl modules WWW::Mechanize (required) and XML::Simple (required for some sites). Preferably install the packaged versions of these provided by your distribution. If you can't, install the modules off [CPAN](http://search.cpan.org/) - follow [our short walkthrough](http://code.google.com/p/get-flash-videos/wiki/CPANGuide) or read the [perlmodinstall](http://search.cpan.org/~jhi/perl-5.8.0/pod/perlmodinstall.pod) documentation for more extensive information.

Then run the following commands in a terminal, this installs get-flash-videos system-wide.

```
 sudo wget http://get-flash-videos.googlecode.com/files/get_flash_videos-1.24 -O /usr/local/bin/get_flash_videos
 sudo chmod a+x /usr/local/bin/get_flash_videos
```

Then, to download something:
```
 get_flash_videos url..
```

See UsageExamples for more.

## Windows ##

Install [ActivePerl](http://www.activestate.com/activeperl/), making sure you tell the installer to add perl's bin directory to your PATH.

Install the Perl modules WWW::Mechanize (required), XML::Simple (required for some sites) and Crypt::Rijndael. You can install these using the PPM tool included with ActivePerl, by running commands like these at a command prompt:

```
  ppm install WWW-Mechanize
  ppm install XML-Simple
  ppm install Crypt-Rijndael
```

(To get a command prompt, go to Start, Run and type cmd and press enter.)

You can also try installing them with the CPAN shell, for example by running this at a command prompt:

```
  cpan install Crypt::Rijndael  
```

Save get-flash-videos somewhere on your hard disk, for example c:\flash.

Then, to download something:
```
 Start -> Run -> cmd
 perl c:/flash/get_flash_videos url
```

We haven't tested rtmpdump on win32.

## OSX ##

Run the following commands in a terminal, this installs it in your home directory.

```
 curl -o get_flash_videos http://get-flash-videos.googlecode.com/files/combined-get_flash_videos-1.24
 chmod a+x get_flash_videos
```

Then, to download something:
```
 ./get_flash_videos url..
```

See UsageExamples for more.

Note you may also need to install the Perl modules XML::Simple and Data::AMF for support for some sites.

# rtmpdump #

get\_flash\_videos can download videos from servers over RTMP, this needs rtmpdump. You can get a copy of rtmpdump from http://rtmpdump.mplayerhq.hu. If you compile it or use an unpackaged version you should chmod it as executable and copy this to
somewhere on your PATH (e.g. /usr/local/bin). If you have problems compiling, make sure you have libssl-dev installed.

# Using get\_flash\_videos #

See the [manpage](http://get-flash-videos.googlecode.com/svn/misc/get_flash_videos) for details on how to use get\_flash\_videos.