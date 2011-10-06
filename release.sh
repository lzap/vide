#!/bin/bash
tito build --srpm || exit 1
FROM="/data/temp/koji/vide-*"
TO=lzap@fedorapeople.org:/home/fedora/lzap/public_html/projects/vide/releases
rsync -av -e ssh $FROM $TO
