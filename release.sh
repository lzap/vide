#!/bin/bash
make distclean
./configure
make dist
FROM=vide*tar.gz
TO=lzap@fedorapeople.org:/home/fedora/lzap/public_html/projects/vide/releases
rsync -av -e ssh $FROM $TO
# man releasers.conf for more info about how to automate this using tito/fedpkg
