#!/bin/sh -x

if [ ! -d work ]; then
    vlib work
fi

cpu_dir="./rtl_cpu"
mcu_dir="./rtl_mcu"

vlog \
    $cpu_dir/CPU.v \
    $cpu_dir/PcAndIr.v \
    $cpu_dir/OpDecode.v \
    $cpu_dir/TimDecode.v \
    $cpu_dir/AluInput.v \
    $cpu_dir/ALU.v \
    $cpu_dir/Multiply.v \
    $cpu_dir/PtrCalc.v \
    $cpu_dir/BitSetClr.v \
    $cpu_dir/PmCont.v \
    $cpu_dir/DmCont.v \
    $cpu_dir/DmAdConv.v \
    $cpu_dir/DmEnMask.v \
    $cpu_dir/RfRead.v \
    $cpu_dir/RfWrite.v \
    $cpu_dir/RegFile.v \
    $cpu_dir/SregAndSp.v \
    $mcu_dir/RAM.v \
    $mcu_dir/IoReg.v \
    +incdir+$cpu_dir
