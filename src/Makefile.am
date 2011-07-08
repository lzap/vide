bin_PROGRAMS = vide

vide_SOURCES = \
	vide.vala \
	vide-gauge.vala \
	vide-app.vala

INCLUDES = \
	-include config.h \
	$(SAMPALA_CFLAGS) \
	-DLOCALEDIR=\""$(localedir)"\" \
	-DPKGDATADIR=\""$(pkgdatadir)"\" \
	-DPKGLIBDIR=\""$(pkglibdir)"\"

VALAFLAGS = \
	--vapidir=$(srcdir)/../vapi --pkg config \
	@SAMPALA_PACKAGES@

vide_LDADD = \
	$(SAMPALA_LIBS)
