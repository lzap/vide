
vide: multiple-tabs terminal with DBUS support
==============================================

A quick introduction
--------------------

Vim is the best text editor, I use it 10 hours a day. It has many features for developers, but it has quite poor external command execution. While it is possible to run external programs in xterm (or using start.exe on Windows) it would be nice to have integrated terminal for running external programs (Python, Perl, Ruby scripts, compilation scripts etc).

**Vide** is very simple terminal that waits on DBUS. User is able to send commands (using **videx** command) to named tabs, like executing compilation scripts, programs or even debug things in the CLI. It works like in your favourite IDE like Eclipse, Netbeans or IntelliJ IDEA. Vide is very easy to setup and use:

1. Start vide.
2. Start vim.
3. Issue `:!videx tab_name working_dir commands to execute...`
4. Bind this command to your favourite key (e.g. F5, F6, F7).
5. Works with any other text editor.

![vide screenshot](/lzap/vide/raw/master/doc/screens/small_unit_test.png "Vide Terminal")

### Example use

Here are few examples.

    videx compile /my/project gcc -o hello *.c
    videx unit_tests /my/project rake spec
    videx start_gui /my/project python main_app_gui.py
    videx run_webserver /my/project rails server

The **only way** to create tabs at the moment is via videx command. Once you send one videx command to your vide instance, new menu entry will be created. You can select from multiple commands using the dropdown menu and execute commands again using the start ("play") button. Very similar to traditional integrated development environments.

The coolest thing is if you issue videx with the same tab name again. Vide won't create a new tab, but the old tab/term is stopped, terminal is cleared and the command is issued again.

Vide has ordinary interactive terminals - you can do whatever you like. This is good for interactive debugging sessions with gdb or even chatting on IRC if you like.

Vide is nothing and everything. You either like it or hate it. I hope for the former.

News about Vide
---------------

There is no dedicated home page for Vide. This page on Github is its "home", you can subscribe [my blog](http://lukas.zapletalovi.com) to be notified about news, releases and other related stuff.

System requirements
-------------------

DBUS, GTK, VTE and Gee libraries to run it. Most Linux distributions has all the dependencies.

Vala compiler to compile it. Only if you want to develop vide itself.

Downloading
-----------

I am currently working on RPM packages for Fedora Linux. The easiest way to get Vide is to compile it. It's very easy, read the following chapter.

Development setup
-----------------

Install all required libraries and their devel versions. Then:

    git clone git://github.com/lzap/vide.git
    cd vide
    ./autogen.sh --prefix=/tmp/my_path/to/vide
    make install

The last step installs data files in the /tmp dir. Now you can code, hack, compile and run with:

    make && src/vide

I am looking forward your patches!

<!-- vim:se syn=markdown:sw=4:ts=4:et: -->
