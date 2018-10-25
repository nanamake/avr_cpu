#!/bin/sh -x

if [ ! -d work ]; then
    vlib work
fi

tb_dir="./tb"

vlog \
    $tb_dir/TB.v \
    +incdir+$tb_dir \
    $1
