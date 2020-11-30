#!/bin/bash 

module unload fsl
module load fsl/6.0.1
module unload workbench
module load workbench/1.3.2

export DATA_DIR='/nafs/narr/canderson/new_pipeline_test_runs/out'
export STUDY_DIR='/nafs/narr/HCP_OUTPUT/Habenula'
SCRIPT_DIR='/nafs/narr/HCP_OUTPUT/Habenula/code/RSConn_HbSeed'

pedirs="AP PA"


args=""

for pe in ${pedirs}; do
	
if [ ${pe} == "AP" ]; then
dataclean=${DATA_DIR}/${SUBJ}/MNINonLinear/Results/rest_acq-${pe}_run-01/rest_acq-${pe}_run-01_Atlas_MSMAll_Test_hp2000_clean.dtseries.nii
else
dataclean=${DATA_DIR}/${SUBJ}/MNINonLinear/Results/rest_acq-${pe}_run-02/rest_acq-${pe}_run-02_Atlas_MSMAll_Test_hp2000_clean.dtseries.nii
fi
args=" ${args} -cifti ${dataclean} "
done


	
wb_command -cifti-average-roi-correlation ${STUDY_DIR}/outputs/RSConn_HbSeed/SubjectsDATA/${SUBJ}_Hb${ROI}_MEANdenseConnectome.dscalar.nii -vol-roi ${STUDY_DIR}/outputs/Segmentation/2_FinalHbROIs_ShapeOptimized/${SUBJ}_${ROI}_shape_optimized_Hb_ROI.nii.gz ${args}

