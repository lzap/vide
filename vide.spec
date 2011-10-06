Name:           vide
Version:        0.1.8
Release:        1%{?dist}
Summary:        Multiple-tabs programmer's terminal for vim

Group:          Development/Tools
License:        GPLv3+
URL:            https://github.com/lzap/vide
Source0:        http://lzap.fedorapeople.org/projects/vide/releases/%{name}-%{version}.tar.gz

BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

Requires:       dbus

BuildRequires:  intltool gettext desktop-file-utils
BuildRequires:  vala-devel >= 0.12
BuildRequires:  pkgconfig(gtk+-2.0)
BuildRequires:  pkgconfig(vte)
BuildRequires:  pkgconfig(gee-1.0)
BuildRequires:  pkgconfig(gio-2.0)


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
%{__rm} -rf $RPM_BUILD_ROOT
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
%defattr(-,root,root,-)
%doc AUTHORS COPYING INSTALL README
%{_bindir}/%{name}
%{_bindir}/%{name}x
%{_datadir}/icons/hicolor/*/apps/%{name}.*
%{_datadir}/applications/%{name}.desktop
%{_datadir}/dbus-1/services/com.github.Vide.service


%changelog
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
