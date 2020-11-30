#!/bin/bash

#SBATCH -J HbSeg
#SBATCH -o HbSeg

module unload fsl
module load fsl/6.0.1
module unload workbench
module load workbench/1.3.2

maindir="/nafs/narr/HCP_OUTPUT/Habenula"

#Run RS connectivity for right and left habenula:
ROIlist="R L"

SubList=$(<${maindir}/outputs/Segmentation/Sublist_Seg_4volanalysis_JL.txt)


for roi in ${ROIlist}; do
args=""
for sub in ${SubList}; do
args="${args} ${maindir}/outputs/Segmentation/1_habenula_segmentation/${sub}/hbseg_${sub}_${roi}.nii.gz"
#echo "${sub} ${roi}"
echo "${sub}"
done


fslmerge -t ${maindir}/outputs/Segmentation/Merged_Hb${roi}_t1space_ALLsubs.nii.gz ${args}

if [ -f ${maindir}/outputs/Segmentation/t1space_volAnalysis_${roi}_JL.txt ]; then
rm ${maindir}/outputs/Segmentation/t1space_volAnalysis_${roi}_JL.txt
fi

fslstats -t  ${maindir}/outputs/Segmentation/Merged_Hb${roi}_t1space_ALLsubs.nii.gz  -V >> ${maindir}/outputs/Segmentation/t1space_volAnalysis_${roi}_JL.txt
done

#QC after TP average###############################################

SubList=$(<${maindir}/outputs/Segmentation/Sublist_noTPs_QC_AverageSeg.txt)
args=""
for roi in R L; do
for subid in ${SubList}; do
args="${args} ${maindir}/outputs/Segmentation/3_AverageTPs_HbprobSeg/${subid}/${subid}_${roi}_shape_optimized_Hb_ROI_ALLTPsAveraged.nii.gz"
#echo "${sub} ${roi}"
echo "${subid}"
done
done

fslmerge -t ${maindir}/outputs/Segmentation/Merged_HbRL_ALLsubs_AverageTPs.nii.gz ${args}

fslstats -t  ${maindir}/outputs/Segmentation/Merged_HbRL_ALLsubs_AverageTPs.nii.gz  -V >> ${maindir}/outputs/Segmentation/SegmentationQC_nrvoxels_AverageTPs.txt


