Name: lilypond
Version: 1.0.15
Release: 1
Copyright: GPL
Group: Applications/Publishing
Source0: ftp.cs.uu.nl:/pub/GNU/LilyPond/development/lilypond-1.0.15.tar.gz
Summary: A program for printing sheet music.
URL: http://www.cs.uu.nl/~hanwen/lilypond
Packager: Han-Wen Nienhuys <hanwen@cs.uu.nl>
Icon: lilypond-icon.gif
BuildRoot: /tmp/lilypond-install
Prereq: tetex

%description 

LilyPond is the GNU Project music typesetter.  This program can print
beautiful sheet music from a music definition file.  It can also play
mechanical performances to a MIDI file.  Features include multiple
staffs, meters, clefs, keys, lyrics, versatile input language, cadenzas,
beams, slurs, triplets, formatting scores, part extraction.  It includes
a nice font of musical symbols.

%prep
%setup
%build
./configure --disable-checking --disable-debugging --enable-printing --prefix=/usr --enable-optimise --enable-shared
make all
make -C Documentation info || true
make htmldoc

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/tmp/lilypond-rpm-doc
tar -C $RPM_BUILD_ROOT/tmp/lilypond-rpm-doc -xzf out/htmldoc.tar.gz

strip lily/out/lilypond mi2mu/out/mi2mu
make prefix="$RPM_BUILD_ROOT/usr" install
cp buildscripts/out/lilypond-profile $RPM_BUILD_ROOT/etc/profile.d/lilypond.sh

%files

%doc /tmp/lilypond-rpm-doc

# hairy to hook it in (possibly non-existing) emacs
%doc mudela-mode.el

# this gets too messy...
# %doc input/*.ly
# verbatim include of input: list the directory without issuing a %dir 

%doc input

/usr/bin/convert-mudela
/usr/bin/mudela-book
/usr/bin/ly2dvi
/usr/bin/lilypond
/usr/bin/mi2mu
/usr/man/man1/mi2mu.1
/usr/man/man1/lilypond.1
/usr/man/man1/mudela-book.1
/usr/man/man1/ly2dvi.1
/usr/man/man1/convert-mudela.1
/usr/info/lilypond.info*
/usr/lib/texmf/texmf/tex/generic/lilypond
/usr/lib/texmf/texmf/fonts/source/public/lilypond
/usr/share/lilypond/
/usr/share/locale/*/LC_MESSAGES/lilypond.mo
/etc/profile.d/lilypond.sh
%post

## ln -s  /usr/lib/texmf/texmf/tex/lilypond  /usr/lib/texmf/texmf/tex/latex/lilypond # suck me plenty
texhash		# takes some time...
touch /tmp/.lilypond-install
rm `find /var/lib/texmf -name 'feta*pk -print' -or -name 'feta*tfm -print'` /tmp/.lilypond-install
