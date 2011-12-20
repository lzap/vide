# Makefile.am

SUBDIRS = \
	data \
	src \
	vapi \
	scripts \
	po

EXTRA_DIST = \
	intltool-extract.in \
	intltool-merge.in \
	intltool-update.in \
	vide.spec

DISTCLEANFILES = \
	intltool-extract \
	intltool-merge \
	intltool-update

#	store tito version number in a file for tarballs
dist-hook:
	./get-version > $(distdir)/.version
