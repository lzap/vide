Name:           vide
Version:        0.1.2
Release:        1%{?dist}
Summary:        Multiple-tabs terminal with DBUS support

Group:          Development/Tools
License:        GPLv3+
URL:            https://github.com/lzap/vide
Source0:        %{name}-%{version}.tar.bz2

BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

Requires:       gtk2

BuildRequires:  glib2-devel gtk2-devel
BuildRequires:  desktop-file-utils


%description
Vide is very simple terminal that waits on DBUS. User is able to send commands
(using videx command) to named tabs, like executing compilation scripts,
programs or even debug things in the CLI. It works like in your favourite IDE
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
#%{_datadir}/%{name}/
%{_datadir}/icons/hicolor/*/apps/%{name}.*
%{_datadir}/applications/%{name}.desktop


%changelog
* Mon Aug 01 2011 Lukas Zapletal <lzap+git@redhat.com> 0.1.2-1
- got tito working with autotools
- getting spec working
- add dummy README

* Sun Jul 31 2011 Lukas Zapletal 0.1.1-1
- initial version
