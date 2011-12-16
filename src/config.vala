/*
 ** Copyright (C) 2011 Libor Zoubek <lzoubek_at_jezzovo-net>
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

using GConf;
using Gee;
using Vide;

class VideProject {
	public string name {get;set;}
	public HashMap<string,VideTerminal> terminals {get;set;}

	public VideProject() {
		terminals = new HashMap<string,VideTerminal>();
	}
}

public class Vide.VideConfig {

	private GConf.Client gc;
	private string root = "/apps/vide";

	private Gee.List<VideProject> projects;
	private string recent = "default";

	public VideConfig() {
		open();
		try {
			projects = loadProjects();
		} catch (GLib.Error e) {
			warning("%s", e.message);
			projects = new ArrayList<VideProject>();
			projects.add(createDefaultProject());
		} finally {
			close();
		}
	}
	public void loadRecent(Vide.MainWindow win) {
		debug("Loading terminals\n");
		foreach (VideTerminal term in getRecentProject().terminals.values) {
			debug("Creating terminal: "+term.name+" "+term.command+" "+term.work_dir+"\n");
			if (term.run_on_startup) {
				win.execute_tab(term.name,term.command,term.work_dir);
			}
			else {
				win.create_tab(term.name,term.command,term.work_dir);
			}
		}
	}

	public void save(HashMap<string, VideTerminal?> terminals) {
		debug("Saving terminals");
		open();
		VideProject recent = getRecentProject();
		try {
			gc.recursive_unset (root+"/projects/"+recent.name, GConf.UnsetFlags.NAMES);

			recent.terminals.clear();
			foreach (VideTerminal? term in terminals.values) {
				recent.terminals[term.name] = term;
			}
			saveProject(recent);
			debug("Done");
		} catch (GLib.Error e) {
			warning("%s", e.message);
		} finally {
			close();
		}
	}

	private VideProject getRecentProject() {
		foreach (VideProject vp in projects) {
			if (vp.name == recent) {
				debug("Found recent project: %s \n",recent);
				return vp;
			}
		}
		warning("Recent %s project not found",recent);
		return createDefaultProject();
	}
	private void close() {
		gc.unref();
	}
	private void open() {
		gc = GConf.Client.get_default();
	}

	private void saveProject(VideProject vp) throws GLib.Error{
		foreach (VideTerminal term in vp.terminals.values) {
			gc.set_string(root+"/projects/"+vp.name+"/"+term.name+"/command",term.command);
			gc.set_string(root+"/projects/"+vp.name+"/"+term.name+"/workdir",term.work_dir);
			gc.set_bool(root+"/projects/"+vp.name+"/"+term.name+"/startup",term.run_on_startup);
		}
	}
	private string getLeaf(string path) {
		int index = path.last_index_of("/");
		if (index>0) {
			return path.substring(index+1);
		}
		return path;
	}

	private VideProject createDefaultProject() {
		VideProject vp = new VideProject();
		vp.name=recent;
		return vp;
	}

	private Gee.List<VideProject> loadProjects() throws GLib.Error {
		Gee.List<VideProject> vProjects = new ArrayList<VideProject>();
		gc.set_string(root+"/projects/recent",recent);
		SList<string> projs = gc.all_dirs (root+"/projects");
		foreach (weak string projPath in projs) {
			string proj = getLeaf(projPath);
			VideProject vp = new VideProject();
			vp.name = proj;
			foreach(weak string termPath in gc.all_dirs(root+"/projects/"+proj)) {
				string term = getLeaf(termPath);
				VideTerminal vt = new VideTerminal();
				vt.name = term;
				foreach (weak GConf.Entry entry in gc.all_entries(root+"/projects/"+proj+"/"+term)) {
					string key = getLeaf(entry.get_key());
					if (key == "command") {
						vt.command = entry.get_value().get_string();
					}
					if (key == "workdir") {
						vt.work_dir = entry.get_value().get_string();
					}
					if (key == "startup") {
						vt.run_on_startup = entry.get_value().get_bool();
					}
				}
				if (vt.command != null) {
					// we must check whether term command was found, GConf caches recently deleted dirs
					vp.terminals[term] = vt;
				}
			}
			vProjects.add(vp);
		}
		if (vProjects.size==0) {
			vProjects.add(createDefaultProject());
		}
		return vProjects;
	}
}
