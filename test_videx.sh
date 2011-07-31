#!/bin/bash
(make && src/vide &)
for i in {1..8}
do
  sleep 1s
  videx "test $i" /tmp echo test
done
