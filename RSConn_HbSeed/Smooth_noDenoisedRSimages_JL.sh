#!/bin/bash

module unload fsl
module load fsl/6.0.1
module load anaconda/2.7
module unload workbench
module load workbench/1.3.2
module unload MATLAB
module load MATLAB

export DATA_DIR='/nafs/narr/canderson/new_pipeline_test_runs/out'
export STUDY_DIR='/nafs/narr/HCP_OUTPUT/Habenula'
#export SUBJ="${SUBJ}"
#SUBJ="k000401"
export LOG_DIR='/nafs/narr/HCP_OUTPUT/Habenula/outputs/Segmentation/logs'
SCRIPT_DIR='/nafs/narr/HCP_OUTPUT/Habenula/code/RSConn_HbSeed'

smooth="4";
smoothingKernel=`echo "${smooth} / ( 2 * ( sqrt ( 2 * l ( 2 ) ) ) )" | bc -l`
outputdir="${STUDY_DIR}/outputs/RSConn_HbSeed/SubjectsDATA_smoothed/${SUBJ}"

for PEDIR in AP PA; do

if [ ! -d ${outputdir} ]; then
mkdir ${outputdir}
fi

if [ ${PEDIR} == "AP" ]; then

wb_command -cifti-smoothing ${DATA_DIR}/${SUBJ}/MNINonLinear/Results/rest_acq-${PEDIR}_run-01/rest_acq-${PEDIR}_run-01_Atlas_MSMAll_Test_hp2000_clean.dtseries.nii ${smoothingKernel} ${smoothingKernel} COLUMN ${outputdir}/s${smooth}rest_acq-${PEDIR}_run-01_Atlas_MSMAll_Test_hp2000_clean.dtseries.nii -left-surface ${DATA_DIR}/${SUBJ}/MNINonLinear/fsaverage_LR32k/${SUBJ}.L.midthickness_MSMAll_Test.32k_fs_LR.surf.gii -right-surface ${DATA_DIR}/${SUBJ}/MNINonLinear/fsaverage_LR32k/${SUBJ}.R.midthickness_MSMAll_Test.32k_fs_LR.surf.gii

else

wb_command -cifti-smoothing ${DATA_DIR}/${SUBJ}/MNINonLinear/Results/rest_acq-${PEDIR}_run-02/rest_acq-${PEDIR}_run-02_Atlas_MSMAll_Test_hp2000_clean.dtseries.nii ${smoothingKernel} ${smoothingKernel} COLUMN ${outputdir}/s${smooth}rest_acq-${PEDIR}_run-02_Atlas_MSMAll_Test_hp2000_clean.dtseries.nii -left-surface ${DATA_DIR}/${SUBJ}/MNINonLinear/fsaverage_LR32k/${SUBJ}.L.midthickness_MSMAll_Test.32k_fs_LR.surf.gii -right-surface ${DATA_DIR}/${SUBJ}/MNINonLinear/fsaverage_LR32k/${SUBJ}.R.midthickness_MSMAll_Test.32k_fs_LR.surf.gii

fi
done


