#!/bin/sh

stime=`LANG=C date`

run_sim="./run_sim.sh"

out_dir="./sim_out"
dm_dat_dir="$out_dir/DM"
run_log_dir="$out_dir/log"

#
# Start Message
#
echo ""
echo "Starting \"$0\""

#
# Delete Previous Output Directories
#
echo ""
echo "Deleting previous output directories..."
echo "rm -rf $dm_dat_dir"
echo "rm -rf $run_log_dir"

rm -rf $dm_dat_dir
rm -rf $run_log_dir

#
# Run Simulation
#
$run_sim fn10
$run_sim fn11
$run_sim fn12
$run_sim fn13
$run_sim fn14
$run_sim fn15
$run_sim fn16
$run_sim fn17
$run_sim fn20
$run_sim fn21
$run_sim fn22
$run_sim fn23
$run_sim fn24
$run_sim fn25
$run_sim fn26
$run_sim fn30
$run_sim fn31
$run_sim fn32
$run_sim fn33
$run_sim fn40
$run_sim fn41
$run_sim fn42
$run_sim fn43
$run_sim fn44
$run_sim fn45
$run_sim fn46
$run_sim fn50
$run_sim fn51
$run_sim fn52
$run_sim fn53
$run_sim fn54
$run_sim fn55
$run_sim fn60
$run_sim fn61
$run_sim fn62
$run_sim fn63
$run_sim fn64
$run_sim fn65
$run_sim fn66
$run_sim fn67

#
# Check Result
#
echo ""
echo "Checking running log files..."

echo ""
echo "grep PASSED $run_log_dir/*"
grep PASSED $run_log_dir/*

npass=`grep PASSED $run_log_dir/* | wc -l`
echo ""
echo "$npass test function passed."

echo ""
echo "grep FAILED $run_log_dir/*"
grep FAILED $run_log_dir/*

nfail=`grep FAILED $run_log_dir/* | wc -l`
echo ""
echo "$nfail test function failed."

#
# End Message
#
echo ""
echo "Ended \"$0\""

etime=`LANG=C date`

echo ""
echo "Start time: $stime"
echo "End   time: $etime"
