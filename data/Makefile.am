# Makefile.am

SUBDIRS = icons

desktopdir = $(datadir)/applications
desktop_in_files = vide.desktop.in
desktop_DATA = $(desktop_in_files:.desktop.in=.desktop)
@INTLTOOL_DESKTOP_RULE@

servicedir   = $(DBUS_SERVICES_DIR)
service_DATA = com.github.Vide.service

EXTRA_DIST = \
	$(desktop_in_files) \
	$(service_DATA)

CLEANFILES = \
	$(desktop_DATA) \
	$(service_DATA)
