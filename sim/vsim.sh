#!/bin/sh -x

vsim -c TB \
    -do 'log -r /*;run -all' \
    -l vsim.log \
    -quiet \
    +nowarnTSCALE
