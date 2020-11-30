#!/bin/bash


module unload fsl
module load fsl/6.0.1
module load anaconda/2.7

maindir="/nafs/narr/HCP_OUTPUT/Habenula"
DATA_DIR='/nafs/narr/canderson/new_pipeline_test_runs/out'
#SubList=$(<${maindir}/outputs/RSConn_HbSeed/Sublist_Denoising.txt)

for SUBJ in ${SubList}; do
if [ -f ${DATA_DIR}/${SUBJ}/MNINonLinear/Results/rest_acq-AP_run-01/rest_acq-AP_run-01_hp2000_clean.nii ]; then
rm ${DATA_DIR}/${SUBJ}/MNINonLinear/Results/rest_acq-AP_run-01/rest_acq-AP_run-01_hp2000_clean.nii
elif [ -f ${DATA_DIR}/${SUBJ}/MNINonLinear/Results/rest_acq-PA_run-02/rest_acq-PA_run-02_hp2000_clean.nii ]; then
rm ${DATA_DIR}/${SUBJ}/MNINonLinear/Results/rest_acq-PA_run-02/rest_acq-PA_run-02_hp2000_clean.nii
fi
done
