#!/bin/bash 

module load workbench/1.3.2

#Specify the name of the folder where the outputs of PALM will be stored:
GROUP="HC_MDDT1"

maindir="/nafs/narr/HCP_OUTPUT/Habenula"
RSMaps_DIR="${maindir}/outputs/RSConn_HbSeed/SubjectsDATA"
Subjlist=$(<${maindir}/outputs/RSConn_HbSeed/GroupAnalysis/${GROUP}/${GROUP}_IDs.txt)


extension="dscalar.nii"
args_L=""
args_R=""

for sub in ${Subjlist}; do
	args_L="${args_L} -cifti 
	${RSMaps_DIR}/${sub}_HbL_MEANdenseConnectome.dscalar.nii -column 1"

	args_R="${args_R} -cifti 
	${RSMaps_DIR}/${sub}_HbR_MEANdenseConnectome.dscalar.nii -column 1"
	echo $i
done 

wb_command -cifti-merge ${maindir}/outputs/RSConn_HbSeed/GroupAnalysis/${GROUP}/MERGED_MEANdenseConnectome_HbL_${GROUP}.dscalar.nii ${args_L}

wb_command -cifti-merge ${maindir}/outputs/RSConn_HbSeed/GroupAnalysis/${GROUP}/MERGED_MEANdenseConnectome_HbR_${GROUP}.dscalar.nii ${args_R}

