#!/bin/bash 

module unload fsl
module load fsl/6.0.1
module unload workbench
module load workbench/1.3.2

export DATA_DIR='/nafs/narr/canderson/new_pipeline_test_runs/out'
export STUDY_DIR='/nafs/narr/HCP_OUTPUT/Habenula'
SCRIPT_DIR='/nafs/narr/HCP_OUTPUT/Habenula/code/RSConn_HbSeed'

pedirs="AP PA"

id=${SUBJ:0:5}

args=""

for pe in ${pedirs}; do
	
if [ ${pe} == "AP" ]; then
#dataclean=${DATA_DIR}/${SUBJ}/MNINonLinear/Results/rest_acq-${pe}_run-01/rest_acq-${pe}_run-01_Atlas_MSMAll_Test_hp2000_clean.dtseries.nii
dataclean=
else
dataclean=${DATA_DIR}/${SUBJ}/MNINonLinear/Results/rest_acq-${pe}_run-02/rest_acq-${pe}_run-02_Atlas_MSMAll_Test_hp2000_clean.dtseries.nii
fi
args=" ${args} -cifti ${dataclean} "
done


	
wb_command -cifti-average-roi-correlation ${STUDY_DIR}/outputs/RSConn_HbSeed/${SUBJ}_Hb${ROI}_MEANdenseConnectome.dscalar.nii -vol-roi ${STUDY_DIR}/outputs/Segmentation/4_cpAverageTPs_ROIReplaceWithTemplate/${id}/${id}_${ROI}_shape_optimized_Hb_ROI_ALLTPsAveraged.nii.gz ${args}

