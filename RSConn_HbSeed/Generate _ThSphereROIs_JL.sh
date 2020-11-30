#!/bin/bash


module unload fsl
module load fsl/6.0.1
module load anaconda/2.7
module load MATLAB


export DATA_DIR='/nafs/narr/canderson/new_pipeline_test_runs/out'
export STUDY_DIR='/nafs/narr/HCP_OUTPUT/Habenula'
SCRIPT_DIR='/nafs/narr/HCP_OUTPUT/Habenula/code/RSConn_HbSeed'

standard='/nafs/apps/fsl/64/6.0.1/data/standard/MNI152_T1_2mm_brain.nii.gz'
ThROIsdir='/nafs/narr/HCP_OUTPUT/Habenula/outputs/RSConn_HbSeed/ROI_Timeseries/ThalamicROIs/ThalamicROI_masks' 



fslmaths ${standard} -mul 0 -add 1 -roi 50 1 51 1 37 1 0 1 ${ThROIsdir}/ThCMpoint_L -odt float
fslmaths ${ThROIsdir}/ThCMpoint_L -kernel sphere 2 -fmean ${ThROIsdir}/ThCM2mmsphere_L -odt float

fslmaths ${standard} -mul 0 -add 1 -roi 40 1 51 1 37 1 0 1 ${ThROIsdir}/ThCMpoint_R -odt float
fslmaths ${ThROIsdir}/ThCMpoint_R -kernel sphere 2 -fmean ${ThROIsdir}/ThCM2mmsphere_R -odt float




fslmaths ${standard} -mul 0 -add 1 -roi 47 1 54 1 37 1 0 1 ${ThROIsdir}/ThDMpoint_L -odt float
fslmaths ${ThROIsdir}/ThDMpoint_L -kernel sphere 2 -fmean ${ThROIsdir}/ThDM2mmsphere_L -odt float

fslmaths ${standard} -mul 0 -add 1 -roi 43 1 54 1 37 1 0 1 ${ThROIsdir}/ThDMpoint_R -odt float
fslmaths ${ThROIsdir}/ThDMpoint_R -kernel sphere 2 -fmean ${ThROIsdir}/ThDM2mmsphere_R -odt float


