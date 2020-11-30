#!/bin/bash

#SBATCH -J HbSeg
#SBATCH -o HbSeg

module unload fsl
module load fsl/6.0.1
module unload workbench
module load workbench/1.3.2

maindir="/nafs/narr/HCP_OUTPUT/Habenula"

#SubList=$(<${maindir}/outputs/RSConn_HbSeed/Sublist_RSConn_v2.txt)
SubList=$(<${maindir}/outputs/RSConn_HbSeed/Sublist_RSConn_HC_ECT.txt)

#. /nafs/narr/asahib/test_multirun_fix/runners2/SetUpUCLAPipeline.sh

for s in ${SubList}
do
	
    		echo "sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=40G --time=5-00:00:00 \
--job-name=s${s} --output=${maindir}/outputs/RSConn_HbSeed/logs/job_logs/smooth_noDenoising_${s}.log --export=SUBJ=${s} ${maindir}/code/RSConn_HbSeed/Smooth_noDenoisedRSimages_JL.sh"
   
		sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=40G --time=5-00:00:00 \
--job-name=s${s} --output=${maindir}/outputs/RSConn_HbSeed/logs/job_logs/smooth_noDenoising_${s}.log --export=SUBJ=${s} ${maindir}/code/RSConn_HbSeed/Smooth_noDenoisedRSimages_JL.sh

	
done

echo "finished"
