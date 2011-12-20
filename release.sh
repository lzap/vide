#!/bin/bash
make dist
FROM=vide*tar.gz
TO=lzap@fedorapeople.org:/home/fedora/lzap/public_html/projects/vide/releases
rsync -av -e ssh $FROM $TO
