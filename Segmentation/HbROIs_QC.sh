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

SubList=$(<${maindir}/outputs/Segmentation/Sublist_withSeg_QC_v2.txt)

args=""
for roi in ${ROIlist}; do
for sub in ${SubList}; do
args="${args} ${maindir}/outputs/Segmentation/2_FinalHbROIs_ShapeOptimized/${sub}_${roi}_shape_optimized_Hb_ROI.nii.gz"
#echo "${sub} ${roi}"
echo "${sub}"
done
done

fslmerge -t ${maindir}/outputs/Segmentation/Merged_HbRL_ALLsubs.nii.gz ${args}

fslstats -t  ${maindir}/outputs/Segmentation/Merged_HbRL_ALLsubs.nii.gz  -V >> ${maindir}/outputs/Segmentation/SegmentationQC_nrvoxels.txt


#QC after TP average###############################################

SubList=$(<${maindir}/outputs/Segmentation/Sublist_noTPs_QC_AverageSeg_Aug2020.txt)
args=""
rm ${maindir}/outputs/Segmentation/SegmentationQC_nrvoxels_AverageTPs_Aug2020.txt
rm ${maindir}/outputs/Segmentation/Merged_HbRL_ALLsubs_AverageTPs_Aug2020.nii.gz
ROIlist="R L"
for roi in ${ROIlist}; do
for subid in ${SubList}; do
args="${args} ${maindir}/outputs/Segmentation/3_AverageTPs_HbprobSeg/${subid}/${subid}_${roi}_shape_optimized_Hb_ROI_ALLTPsAveraged.nii.gz"
#echo "${sub} ${roi}"
echo "${subid}"
done
done

fslmerge -t ${maindir}/outputs/Segmentation/Merged_HbRL_ALLsubs_AverageTPs_Aug2020.nii.gz ${args}

fslstats -t  ${maindir}/outputs/Segmentation/Merged_HbRL_ALLsubs_AverageTPs_Aug2020.nii.gz  -V >> ${maindir}/outputs/Segmentation/SegmentationQC_nrvoxels_AverageTPs_Aug2020.txt


