#!/bin/bash
make || exit 1
src/vide &
for i in {1..8}
do
  sleep 1s
  videx "test $i" /tmp echo test
done
