bin_PROGRAMS = vide

vide_SOURCES = \
	vide.vala \
	vide_server.vala \
	keybinding.vala \
	config.vala \
	main_window.vala

INCLUDES = \
	-include config.h \
	$(VIDE_CFLAGS) \
	-DLOCALEDIR=\""$(localedir)"\" \
	-DPKGDATADIR=\""$(pkgdatadir)"\" \
	-DPKGLIBDIR=\""$(pkglibdir)"\"

VALAFLAGS = \
	--vapidir=$(srcdir)/../vapi --pkg config \
	@VIDE_PACKAGES@

AM_CPPFLAGS = \
	-DDATADIR=\"$(datadir)\"

vide_LDADD = \
	$(VIDE_LIBS)
