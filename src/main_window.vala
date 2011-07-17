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

using Gtk;
using Cairo;
using Vte;
using Gee;

public class Vide.MainWindow: Window {

  private HashMap<string, Terminal> terminals = new HashMap<string, Terminal>();

  private Notebook notebook;

  public MainWindow() {
    set_title(_("Vide Terminal"));
    set_default_size(800, 600);
    this.destroy.connect(Gtk.main_quit);

    notebook = new Notebook();

    var toolbar = new Toolbar ();
    var combo = new MenuToolButton.from_stock(Stock.MEDIA_PLAY);
    combo.is_important = true;
    //combo.clicked.connect(() => {});
    toolbar.add(combo);
    var quit_button = new ToolButton.from_stock(Stock.QUIT);
    quit_button.is_important = true;
    quit_button.clicked.connect(Gtk.main_quit);
    toolbar.add(quit_button);

    var vbox = new VBox(false, 0);
    vbox.pack_start(toolbar, false, true, 0);
    vbox.pack_start(notebook, true, true, 0);
    add(vbox);
  }

  public int execute_tab(string tab_name, string work_dir, string[] command) {
    Terminal term = null;

    if (! terminals.has_key(tab_name)) {
      term = new Terminal();
      //term.child_exited.connect ( (t)=> { Gtk.main_quit(); } );
      term.show();
      notebook.append_page(term, new Label(tab_name));

      terminals[tab_name] = term;
    } else {
      term = terminals[tab_name];
    }

    term.fork_command(null,null,null,null, true, true,true);
    return 0;
  }

}
