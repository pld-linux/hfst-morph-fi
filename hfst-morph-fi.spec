Summary:	HFST morphological analysis transducer for Finnish language
Summary(pl.UTF-8):	Automat HFST do analizy morfologicznej dla języka fińskiego
Name:		hfst-morph-fi
# or 20110316?
Version:	0
Release:	1
License:	GPL v3
Group:		Applications/Text
# source is at http://gna.org/projects/omorfi
Source0:	http://downloads.sourceforge.net/hfst/hfst-finnish.tar.gz
# Source0-md5:	0820fc6b25d81efe4ecf2eed41818249
# modified english-analyze.sh script from hfst-english-installable
Source1:	finnish-analyze.sh
URL:		http://hfst.sourceforge.net/
Requires:	hfst
BuildRoot:	%{tmpdir}/%{name}-%{version}-root-%(id -u -n)

%description
This is a Finnish morphological analyser transducer for HFST. The
analyser comes from Omorfi project: <http://gna.org/projects/omorfi/>.

%description -l pl.UTF-8
Ten pakiet zawiera automat dla HFST do analizy morfologicznej języka
fińskiego. Analizator pochodzi z projektu Omorfi:
<http://gna.org/projects/omorfi/>.

%prep
%setup -q -n hfst-finnish

%install
rm -rf $RPM_BUILD_ROOT
install -d $RPM_BUILD_ROOT{%{_bindir},%{_datadir}/hfst/fi}

install -p finnish.hfst.olw $RPM_BUILD_ROOT%{_datadir}/hfst/fi/fi-analysis.hfst.ol
install -p %{SOURCE1} $RPM_BUILD_ROOT%{_bindir}/finnish-analyze.sh

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(644,root,root,755)
%doc README
%attr(755,root,root) %{_bindir}/finnish-analyze.sh
%{_datadir}/hfst/fi
