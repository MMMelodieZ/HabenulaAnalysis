#!/bin/bash

#SBATCH -J HbSeg
#SBATCH -o HbSeg

module unload fsl
module load fsl/6.0.1
module unload workbench
module load workbench/1.3.2

maindir="/nafs/narr/HCP_OUTPUT/Habenula"

#Run RS connectivity for right and left habenula:
ROIlist="L R"


SubList=$(<${maindir}/outputs/RSConn_HbSeed/Sublist_RSConn_v4_extraSubs.txt)

#. /nafs/narr/asahib/test_multirun_fix/runners2/SetUpUCLAPipeline.sh

for s in ${SubList}
do

	for r in ${ROIlist}
	do
	
    		echo "sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=40G --time=5-00:00:00 \
--job-name=cr${s} --output=/${maindir}/outputs/RSConn_HbSeed/logs/job_logs/RSConn_HbSeed_${s}_${r}.log --export=SUB=${s},ROI=${r} ${maindir}/code/RSConn_HbSeed/RSConn_HbSeed_JL.sh"
   
		sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=40G --time=5-00:00:00 \
--job-name=cr${s} --output=${maindir}/outputs/RSConn_HbSeed/logs/job_logs/newdRSConn_HbSeed_${s}_${r}.log --export=SUBJ=${s},ROI=${r} ${maindir}/code/RSConn_HbSeed/RSConn_HbSeed_JL2.sh
	done	
	
done

echo "finished"
