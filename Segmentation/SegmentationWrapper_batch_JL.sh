#!/bin/bash

#SBATCH -J HbSeg
#SBATCH -o HbSeg

module unload fsl
module load fsl/6.0.1
module load anaconda/2.7


maindir="/nafs/narr/HCP_OUTPUT/Habenula"


#SubList=$(<${maindir}/outputs/Segmentation/Sublist_Seg.txt)

#. /nafs/narr/asahib/test_multirun_fix/runners2/SetUpUCLAPipeline.sh

#for s in ${SubList}
#do
	
 echo "sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=40G --time=5-00:00:00 \
--job-name=hb${s} --output=${maindir}/outputs/Segmentation/logs/job_logs/HbSeg_${s}.log --export=SUB=${s} ${maindir}/code/Segmentation/SegmentationWrapper_JL.sh"
   
sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=40G --time=5-00:00:00 \
--job-name=seg --output=/${maindir}/outputs/Segmentation/logs/job_logs/HbSeg.log ${maindir}/code/Segmentation/SegmentationWrapper_JL.sh	
	
#done

echo "finished"
