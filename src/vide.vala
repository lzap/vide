/*
 ** Copyright (C) 2011 Lukas Zapletal <lzap_at_seznam-cz>
 **
 ** This program is free software; you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation; either version 2 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program; if not, write to the Free Software
 ** Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */

using Vide;

void on_bus_aquired(DBusConnection conn) {
  try {
    conn.register_object("/com/github/vide", Server.get_instance());
  } catch (IOError e) {
    stderr.printf ("Could not register DBUS service\n");
  }
}

int main( string[] args ) {
  Intl.bindtextdomain( Config.GETTEXT_PACKAGE, Config.LOCALEDIR );
  Intl.bind_textdomain_codeset( Config.GETTEXT_PACKAGE, "UTF-8" );
  Intl.textdomain( Config.GETTEXT_PACKAGE );

  Bus.own_name (BusType.SESSION, "com.github.Vide", BusNameOwnerFlags.NONE,
      on_bus_aquired,
      () => {},
      () => stderr.printf ("Could not aquire DBUS name\n"));

  Gtk.init( ref args );
  var main_window = new MainWindow();
  Server.get_instance().main_window = main_window;
  main_window.show_all();

  Gtk.main();

  return( 0 );
}
