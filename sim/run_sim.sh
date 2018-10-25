#!/bin/sh

stime=`LANG=C date`

if [ "$1" = "" ] || [ "$1" = "--help" ]; then
    echo "Usage: `basename $0` TESTNAME"
    exit
fi

fn="$1"

#
# Test File Definitions
#
vlog_dut="./vlog_dut.sh"
vlog_tb="./vlog_tb.sh"
vsim_sh="./vsim.sh"

pm_dat="PM.dat"
dm_dat="DM.dat"
dm_exp="DM_exp.dat"
stim_v="stim.v"
vsim_log="vsim.log"
run_log="run_sim.log"

in_dir="./sim_in"
pm_dat_fn="$in_dir/PM/${fn}.lst"
dm_exp_fn="$in_dir/DM_exp/${fn}.dat"
stim_v_fn="$in_dir/stim/${fn}.v"
stim_v_tb="./tb/stim.v"

out_dir="./sim_out"
dm_dat_fn="$out_dir/DM/${fn}.dat"
run_log_fn="$out_dir/log/${fn}.log"

# Execute with subshell to use pipe
{
    #
    # Start Message
    #
    echo ""
    echo "Starting \"$0 $1\""
    echo ""
    echo "TESTNAME=$fn"

    #
    # Delete Previous Test Files
    #
    echo ""
    echo "Deleting previous test files..."
    echo "rm -f $pm_dat"
    echo "rm -f $dm_dat"
    echo "rm -f $dm_exp"
    echo "rm -f $stim_v"
    echo "rm -f $vsim_log"

    rm -f $pm_dat
    rm -f $dm_dat
    rm -f $dm_exp
    rm -f $stim_v
    rm -f $vsim_log

    #
    # Copy Input Files
    #
    echo ""
    echo "Copying input files..."

    # copy pm_dat
    if [ -f $pm_dat_fn ]; then
        echo "cp $pm_dat_fn $pm_dat"
        cp $pm_dat_fn $pm_dat
    else
        echo "[FAILED] Can't find file \"$pm_dat_fn\""
        exit
    fi

    # copy dm_exp
    if [ -f $dm_exp_fn ]; then
        echo "cp $dm_exp_fn $dm_exp"
        cp $dm_exp_fn $dm_exp
        tb_opt="+define+VERIFY"
    else
        echo "[NOTICE] Can't find file \"$dm_exp_fn\""
        tb_opt=""
    fi

    # copy stim_v
    if [ -f $stim_v_fn ]; then
        echo "cp $stim_v_fn $stim_v"
        cp $stim_v_fn $stim_v
    else
        if [ -f $stim_v_tb ]; then
            echo "cp $stim_v_tb $stim_v"
            cp $stim_v_tb $stim_v
        else
            echo "[FAILED] Can't find file \"$stim_v_tb\""
            exit
        fi
    fi

    #
    # Compile
    #
    echo ""
    echo "Compiling HDL files..."

    if [ ! -d work ]; then
        if [ -f $vlog_dut ]; then
            echo "$vlog_dut"
            $vlog_dut
        else
            echo "[FAILED] Can't find file \"$vlog_dut\""
            exit
        fi
    fi

    if [ -f $vlog_tb ]; then
        echo "$vlog_tb $tb_opt"
        $vlog_tb $tb_opt
    else
        echo "[FAILED] Can't find file \"$vlog_tb\""
        exit
    fi

    #
    # Run Simulation
    #
    echo ""
    echo "Running simulation..."

    if [ -f $vsim_sh ]; then
        echo "$vsim_sh"
        $vsim_sh
    else
        echo "[FAILED] Can't find file \"$vsim_sh\""
        exit
    fi

    #
    # Save Output Files
    #
    echo ""
    echo "Saving output files..."

    if [ ! -d $out_dir ]; then
        echo "mkdir $out_dir"
        mkdir $out_dir
    fi

    # save dm_dat
    if [ ! -d ${dm_dat_fn%/*} ]; then
        echo "mkdir ${dm_dat_fn%/*}"
        mkdir ${dm_dat_fn%/*}
    fi
    if [ -f $dm_dat ]; then
        echo "cp $dm_dat $dm_dat_fn"
        cp $dm_dat $dm_dat_fn
    else
        echo "[NOTICE] Can't find file \"$dm_dat\""
    fi

    #
    # End Message
    #
    echo ""
    echo "Ended \"$0 $1\""

    etime=`LANG=C date`

    echo ""
    echo "Start time: $stime"
    echo "End   time: $etime"

} |& tee $run_log

#
# Save Running Log
#
echo ""
echo "Saving copy of running log..."

if [ ! -d $out_dir ]; then
    echo "mkdir $out_dir"
    mkdir $out_dir
fi
if [ ! -d ${run_log_fn%/*} ]; then
    echo "mkdir ${run_log_fn%/*}"
    mkdir ${run_log_fn%/*}
fi

echo "cp $run_log $run_log_fn"
cp $run_log $run_log_fn
