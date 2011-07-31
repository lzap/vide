
vide -- multiple-tabs terminal with DBUS support
================================================

A quick introduction
--------------------

Vim is the best text editor, I use it 10 hours a day. It has many features for developers, but it has quite poor external command execution. While it is possible to run external programs in xterm (or using start.exe on Windows) it would be nice to have integrated terminal for running external programs (Python, Perl, Ruby scripts, compilation scripts etc).

*Vide* is very simple terminal that waits on DBUS. User is able to send commands (using *videx* command) to named tabs, like executing compilation scripts, programs or even debug things in the CLI. It works like in your favourite IDE like Eclipse, Netbeans or IntelliJ IDEA. Vide is very easy to setup and use:

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

The coolest thing is if you issue videx with the same tab name again. Vide won't create a new tab, but the old tab/term is stopped, terminal is cleared and the command is issued again.

Vide has ordinary interactive terminals - you can do whatever you like. This is good for interactive debugging sessions with gdb or even chatting on IRC if you like.

Vide is nothing and everything. You either like it or hate it. I hope for the former.

System requirements
-------------------

DBUS, GTK, VTE and Gee libraries to run it.

Vala compiler to compile it.

How to use
----------

Development setup
-----------------

Install all required libraries and their devel versions. Then:

    git clone git://github.com/lzap/vide.git
    cd vide
    ./autogen.sh --prefix=/tmp/vide_devel
    make install

The last step installs data files in the /tmp dir. Now you can code, hack, compile and run with:

    make && src/vide

I am looking forward your patches!

<!-- vim:se syn=markdown:sw=4:ts=4:et: -->
