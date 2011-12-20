# configure.ac

# determine version number from the current directory (or set to "" for git)
AC_INIT([Vide],[m4_esyscmd([./get-version|tr -d '\n'])])
AC_CONFIG_SRCDIR([src/vide.vala])
AC_CONFIG_HEADERS([config.h])

AM_INIT_AUTOMAKE
#AM_INIT_AUTOMAKE([no-dist-gzip dist-bzip2])

# Enable silent rules is available
m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])

AM_MAINTAINER_MODE

AC_PROG_CC
AC_PROG_CC_STDC
AM_PROG_VALAC([0.7.0])
AC_PROG_INSTALL
IT_PROG_INTLTOOL([0.35])

pkg_modules="gtk+-2.0 >= 2.14.0 vte >= 0.28.0 gee-1.0 >= 0.6.1 gio-2.0 >= 2.28.0 gconf-2.0 >= 2.1.2"
VIDE_PACKAGES="--pkg gtk+-2.0 --pkg vte --pkg gee-1.0 --pkg gio-2.0 --pkg posix --pkg gconf-2.0"
PKG_CHECK_MODULES(VIDE, [$pkg_modules])
AC_SUBST(VIDE_CFLAGS)
AC_SUBST(VIDE_LIBS)
AC_SUBST(VIDE_PACKAGES)

GETTEXT_PACKAGE=vide
AC_DEFINE_UNQUOTED([GETTEXT_PACKAGE], ["$GETTEXT_PACKAGE"], [Gettext Package])
AC_SUBST(GETTEXT_PACKAGE)
AM_GNU_GETTEXT_VERSION([1.11])
AM_GLIB_GNU_GETTEXT

AS_AC_EXPAND(DATADIR, $datadir)
AC_ARG_WITH(dbus-services, [  --with-dbus-services=<dir>   where D-BUS services directory is])
if ! test -z "$with_dbus_services" ; then
	DBUS_SERVICES_DIR="$with_dbus_services"
else
	DBUS_SERVICES_DIR="$DATADIR/dbus-1/services"
fi
AC_SUBST(DBUS_SERVICES_DIR)
AC_DEFINE_UNQUOTED(DBUS_SERVICES_DIR, "$DBUS_SERVICES_DIR", [Where services dir for DBUS is])

AC_CONFIG_FILES([
	Makefile
  scripts/Makefile
	data/vide.desktop.in
	data/com.github.Vide.service
	data/Makefile
	data/icons/Makefile
	data/icons/16x16/Makefile
	data/icons/22x22/Makefile
	data/icons/24x24/Makefile
	data/icons/32x32/Makefile
	data/icons/48x48/Makefile
	data/icons/scalable/Makefile
	po/Makefile.in
	src/Makefile
	vapi/Makefile
])

AC_CONFIG_FILES([scripts/videx], [chmod +x scripts/videx])
AC_CONFIG_FILES([scripts/videx-last], [chmod +x scripts/videx-last])

AC_OUTPUT
