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

struct VideTerminal {
  string name;
  Terminal term;
  int tab_number;
}

public class Vide.MainWindow: Window {

  private HashMap<string, VideTerminal?> terminals = new HashMap<string, VideTerminal?>();

  private Notebook notebook;

  public MainWindow() {
    set_title(_("Vide Terminal"));
    set_default_size(800, 600);
    this.destroy.connect(Gtk.main_quit);

    notebook = new Notebook();

    var toolbar = new Toolbar ();
    var combo = new MenuToolButton.from_stock(Stock.MEDIA_PLAY);
    combo.is_important = true;
    combo.clicked.connect(() => {
      string[] command = {"echo", "test"};
      execute_tab("test", "/tmp", command);
    });
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
    var vterm = VideTerminal();
    vterm.name = tab_name;

    if (! terminals.has_key(tab_name)) {
      vterm.term = new Terminal();
      vterm.term.child_exited.connect( (term) => {
        close_tab(tab_name);
      });
      vterm.term.eof.connect( (term) => {
        close_tab(tab_name);
      });
      vterm.term.show();
      vterm.tab_number = notebook.append_page(vterm.term, new Label(tab_name));

      terminals[tab_name] = vterm;
    } else {
      vterm = terminals[tab_name];
    }

    vterm.term.fork_command( (string) 0, (string[]) 0, new string[]{}, Environment.get_variable( "HOME" ), true, true, true);
    vterm.term.feed_child("echo test\n", 10);
      
    return 0;
  }

  public void close_tab(string tab_name) {
    var vterm = terminals[tab_name];
    notebook.remove_page(vterm.tab_number);
    terminals.remove(tab_name);
  }

}
