#!/bin/bash
SRPM=$(tito build --offline --test --srpm | tail -n1 | sed 's/^Wrote: //g')
koji build --scratch --nowait dist-rawhide $SRPM
