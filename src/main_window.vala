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
    try {
      set_icon_from_file("/usr/share/pixmaps/gnome-term.png");
    } catch (Error er) {
      stderr.printf(er.message);
    }
    this.destroy.connect(Gtk.main_quit);

    notebook = new Notebook();

    var toolbar = new Toolbar ();
    var combo = new MenuToolButton.from_stock(Stock.MEDIA_PLAY);
    combo.is_important = true;
    combo.clicked.connect(() => {
      execute_tab("test", "echo test");
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

  public int execute_tab(string tab_name, string command, string? work_dir = null) {
    var vterm = VideTerminal();
    vterm.name = tab_name;

    if (! terminals.has_key(tab_name)) {
      // new terminal
      vterm.term = new Terminal();
      vterm.term.child_exited.connect( (term) => {
        close_tab(tab_name);
      });
      vterm.term.eof.connect( (term) => {
        close_tab(tab_name);
      });
      // set history length
      vterm.term.set_scrollback_lines(9999);
      vterm.term.show();
      // create scroller
      var scroll = new ScrolledWindow (null, null);
      scroll.set_policy(PolicyType.AUTOMATIC, PolicyType.ALWAYS);
      scroll.add(vterm.term);
      vterm.tab_number = notebook.append_page(scroll, new Label(tab_name));

      terminals[tab_name] = vterm;
    } else {
      // existing terminal
      vterm = terminals[tab_name];
      // clear history
      vterm.term.reset(true, true);
    }

    // change to the tab
    notebook.show_all();
    notebook.set_current_page(vterm.tab_number);

    string wd = work_dir ?? Environment.get_variable("HOME");
    vterm.term.fork_command( (string) 0, (string[]) 0, new string[]{}, wd, true, true, true);
    vterm.term.feed_child(command + "\n", command.length + 1);
      
    return 0;
  }

  public void close_tab(string tab_name) {
    var vterm = terminals[tab_name];
    notebook.remove_page(vterm.tab_number);
    terminals.remove(tab_name);
  }

}
