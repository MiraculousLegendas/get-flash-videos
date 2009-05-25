MAIN = get_flash_videos
COMBINE = utils/combine-perl.pl
VERSION := $(shell ./$(MAIN) --version 2>&1 | awk '{print $$3}')

TARGETS = combined-$(MAIN) combined-$(MAIN)-$(VERSION) \
	  $(MAIN)-$(VERSION) $(MAIN).1 $(MAIN).1.gz

all: $(MAIN)-$(VERSION)

clean:
	rm -f $(TARGETS) .sitemodules

# Build the main get_flash_videos, by combining the modules and sites into one
# file, for easier download and installation.

$(MAIN)-$(VERSION): $(COMBINE) $(MAIN) FlashVideo/* .sitemodules \
  utils/combine-header
	$(COMBINE) --name="$(MAIN)" --include="^FlashVideo::" \
	  utils/combine-header .sitemodules $(MAIN) > $@
	chmod a+x $@

# This makes sure to 'use' all the Site modules, so that the combiner can pick
# them all up.

.sitemodules: FlashVideo/Site/*.pm
	(echo FlashVideo/Site/Megavideo.pm; ls $^) \
	  | sed -e 's!/!::!g' -e 's/\.pm$$/ ();/' -e 's/^/use /' > $@

# Build a combined version which also includes our dependencies, this makes it
# easier for people who cannot install Perl modules. (Note that it does still
# need HTML::Parser, as this is XS, and optionally XML::Simple, but LWP and
# Mechanize are included by this).

COMBINED_SOURCES = utils/combine-head .sitemodules $(MAIN)

combined-$(MAIN)-$(VERSION): combined-get_flash_videos
	cp -p $^ $@

combined-$(MAIN): $(COMBINE) $(COMBINED_SOURCES)
	$(COMBINE) --name="$@" $(COMBINED_SOURCES) > $@
	chmod a+x $@

# Run our Perl tests.
check: $(MAIN)-$(VERSION)
	$(MAKE) -C t $@ SCRIPT=$^

# Manpage
$(MAIN).1: $(MAIN).pod
	pod2man -c "User commands" -r "$(MAIN)-$(VERSION)" $^ > $@

$(MAIN).1.gz: $(MAIN).1
	gzip $^

# Install
DESTDIR ?=
install: $(MAIN)-$(VERSION) $(MAIN).1.gz
	mkdir -p $(DESTDIR)/usr/bin
	cp -p $(MAIN)-$(VERSION) $(DESTDIR)/usr/bin/$(MAIN)
	mkdir -p $(DESTDIR)/usr/share/man/man1
	cp -p $(MAIN).1.gz $(DESTDIR)/usr/share/man/man1

# For project people to easily make releases.

# Put this in ~/bin:
#  http://code.google.com/p/support/source/browse/trunk/scripts/googlecode_upload.py

release: release-main deb
	svn commit -m "Version $(VERSION)" wiki/Installation.wiki wiki/Version.wiki

release-main: $(MAIN)-$(VERSION) changelog-update wiki-update release-combined
	googlecode_upload.py -l "Featured,OpSys-All" -s "Version $(VERSION)" -p get-flash-videos $<
	svn commit -m "Version $(VERSION)" debian/changelog
	svn cp -m "Version $(VERSION)" https://get-flash-videos.googlecode.com/svn/trunk https://get-flash-videos.googlecode.com/svn/tags/v$(VERSION)

release-combined: combined-$(MAIN)-$(VERSION)
	googlecode_upload.py -l "OpSys-All" -s "Version $(VERSION) -- combined version including some required modules." -p get-flash-videos $^

wiki:
	svn checkout https://get-flash-videos.googlecode.com/svn/wiki/ $@

changelog-update:
	@fgrep -q '$(MAIN) ($(VERSION)-1)' debian/changelog || dch -v $(VERSION)-1

wiki-update: wiki
	@cd wiki && svn up
	@perl -pi -e's/(get[-_]flash[-_]videos[-_])\d+\.\d+/$${1}$(VERSION)/g' wiki/Installation.wiki
	@perl -pi -e's/\d+\.\d+/$(VERSION)/g' wiki/Version.wiki
	@svn diff wiki/Installation.wiki wiki/Version.wiki | grep -q . || (echo "Version already released" && exit 1)
	@svn diff wiki/Installation.wiki wiki/Version.wiki && echo "OK? (ctrl-c to abort)" && read F

deb: release-main
	mkdir -p /tmp/deb
	svn co https://get-flash-videos.googlecode.com/svn/tags/v$(VERSION) /tmp/deb/$(VERSION)
	cd /tmp/deb/$(VERSION) && (dpkg-buildpackage || echo "Ignoring return value..")
	googlecode_upload.py -l "Type-Package,OpSys-Linux" -s "Version $(VERSION) -- Debian package, for Debian and Ubuntu" -p get-flash-videos /tmp/deb/get-flash-videos_$(VERSION)-1_all.deb
	rm -rf /tmp/deb/$(VERSION)

.PHONY: all clean release release-main release-combined check wiki-update install deb
