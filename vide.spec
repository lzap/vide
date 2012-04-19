Name:           vide
Version:        0.1.15
Release:        1%{?dist}
Summary:        Multiple-tabs programmer's terminal for vim

Group:          Development/Tools
License:        GPLv3+
URL:            https://github.com/lzap/vide
Source0:        http://lzap.fedorapeople.org/projects/vide/releases/%{name}-%{version}.tar.gz

Requires:       dbus gtk2 vte libgee glib2 GConf2

BuildRequires:  intltool gettext desktop-file-utils
BuildRequires:  vala-devel >= 0.12
BuildRequires:  gtk2-devel vte-devel libgee-devel glib2-devel GConf2-devel


%description
Vide is very simple terminal that waits on DBUS. User is able to send commands
(using videx command) to named tabs, like executing compilation scripts,
programs or even debug things in the CLI. It works like in your favorite IDE
like Eclipse, Netbeans or IntelliJ IDEA.


%prep
%setup -q


%build
%configure
make %{?_smp_mflags}


%install
make install DESTDIR=$RPM_BUILD_ROOT

desktop-file-install --delete-original  \
        --dir $RPM_BUILD_ROOT%{_datadir}/applications   \
        --remove-category Application \
        $RPM_BUILD_ROOT%{_datadir}/applications/%{name}.desktop

%find_lang %{name}

%post
touch --no-create %{_datadir}/icons/hicolor &>/dev/null || :


%postun
if [ $1 -eq 0 ] ; then
    touch --no-create %{_datadir}/icons/hicolor &>/dev/null
    gtk-update-icon-cache %{_datadir}/icons/hicolor &>/dev/null || :
fi


%posttrans
gtk-update-icon-cache %{_datadir}/icons/hicolor &>/dev/null || :


%clean
%{__rm} -rf $RPM_BUILD_ROOT


%files -f %{name}.lang
%doc AUTHORS COPYING INSTALL README
%{_bindir}/%{name}
%{_bindir}/%{name}x
%{_bindir}/%{name}x-last
%{_datadir}/icons/hicolor/*/apps/%{name}.*
%{_datadir}/applications/%{name}.desktop
%{_datadir}/dbus-1/services/com.github.Vide.service


%changelog
* Tue Dec 20 2011 Lukas Zapletal <lzap+git@redhat.com> 0.1.15-1
- using only git for version now

* Tue Dec 20 2011 Lukas Zapletal <lzap+git@redhat.com> 0.1.14-1
- using own approach to create VERSION

* Tue Dec 20 2011 Lukas Zapletal <lzap+git@redhat.com> 0.1.13-1
- better determination of the version number
- modifing release script - now works

* Tue Dec 20 2011 Lukas Zapletal <lzap+git@redhat.com> 0.1.12-1
- use name and version in the window title
- version number now set from tito rel-eng dir

* Mon Dec 19 2011 Lukas Zapletal <lzap+git@redhat.com> 0.1.11-1
- adding vide-last to the spec file - fix

* Mon Dec 19 2011 Lukas Zapletal <lzap+git@redhat.com> 0.1.10-1
- adding vide-last to the spec file

* Mon Dec 19 2011 Lukas Zapletal <lzap+git@redhat.com> 0.1.9-1
- disabling quit pid waiting (does not work well)
- introducing videx-last command - reexecutes the last command
- execute_selected returns integer (for dbus)
- introducing reexecute dbus method
- refactoring - introduce method execute_selected
- reformatting
- icon loading plus some code reformatting
- fixed: run_on_startup terminals did not save settings correctly
- saved terminal can be now also executed when vide starts up
- vide now remembers all open terminals during shutdown and creates them during
  startup
- fixing spec summary and url in readme

* Thu Oct 06 2011 Lukas Zapletal <lzap+git@redhat.com> 0.1.8-1
- adding proper URL to the spec
- release script, typos, readme

* Thu Oct 06 2011 Lukas Zapletal <lzap+git@redhat.com> 0.1.7-1
- dependency fix

* Thu Oct 06 2011 Lukas Zapletal <lzap+git@redhat.com> 0.1.6-1
- README update
- fixing tarball name in our spec

* Thu Oct 06 2011 Lukas Zapletal <lzap+git@redhat.com> 0.1.5-1
- properly terminate all terms and wait for exit of all
- return pid of the process rather than zero
- set focus to the term when created
- reformatting
- adding new file to the RPM

* Tue Aug 16 2011 Lukas Zapletal <lzap+git@redhat.com> 0.1.4-1
- added close button to terminal tab
- reset execute button to initial state when last tab is closed
- menu items are no longer duplicated, menuItem is removed from menu on tab
  close
- added: Ctrl+PageUP/PageDown accells for switching tabs
- added D-BUS service file

* Mon Aug 01 2011 Lukas Zapletal <lzap+git@redhat.com> 0.1.3-1
- spec - requires

* Mon Aug 01 2011 Lukas Zapletal <lzap+git@redhat.com> 0.1.2-1
- got tito working with autotools
- getting spec working
- add dummy README

* Sun Jul 31 2011 Lukas Zapletal 0.1.1-1
- initial version
