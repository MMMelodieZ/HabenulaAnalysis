#!/bin/bash 

module load workbench/1.3.2

#Specify the name of the folder where the outputs of PALM will be stored:
GROUP="KTP1_KTP3"

Habenuladir="/nafs/narr/HCP_OUTPUT/Habenula"


for g in $GroupList; do
groupdir=${Habenuladir}/outputs/RSConn_HbSeed/GroupLevel/SubtractedImages/${g}
SubjList=${groupdir}/${g}_IDs.txt
subjects=$( cat ${subject_list} )

if [ ${g} == "KTP1_KTP2" ]; then
TP1="01"; TP2="02"	
elif [ ${g} == "KTP1_KTP3" ]; then
TP1="01"; TP2="03"
elif [ ${g} == "KTP1_KTP4" ]; then
TP1="01"; TP2="04"
elif [ ${g} == "KTP3_KTP4" ]; then
TP1="03"; TP2="04"
elif [ ${g} == "KTP2_KTP4" ]; then
TP1="02"; TP2="04"
elif [ ${g} == "KTP3_KTP4" ]; then
TP1="03"; TP2="04"
fi

args_L=""
args_R=""
args_L_neg=""
args_R_neg=""

for sub in ${subjects}; do
	args_L="${args_L} -cifti 
	${groupdir}/${sub}_TP${TP1}-TP${TP2}_HbL_MEANdenseConnectome.dscalar.nii -column 1"

	args_R="${args_R} -cifti 
	${groupdir}/${sub}_TP${TP1}-TP${TP2}_HbR_MEANdenseConnectome.dscalar.nii -column 1"

	args_L_neg="${args_L_neg} -cifti 
	${groupdir}/${sub}_TP${TP2}-TP${TP1}_HbL_MEANdenseConnectome.dscalar.nii -column 1"

	args_R_neg="${args_R_neg} -cifti 
	${groupdir}/${sub}_TP${TP2}-TP${TP1}_HbR_MEANdenseConnectome.dscalar.nii -column 1"

	echo $sub
done 

wb_command -cifti-merge ${maindir}/outputs/RSConn_HbSeed/GroupAnalysis/${GROUP}/MERGED_MEANdenseConnectome_HbL_TP${TP1}-TP${TP2}.dscalar.nii ${args_L}

wb_command -cifti-merge ${maindir}/outputs/RSConn_HbSeed/GroupAnalysis/${GROUP}/MERGED_MEANdenseConnectome_HbL_TP${TP1}-TP${TP2}.dscalar.nii ${args_R}

wb_command -cifti-merge ${maindir}/outputs/RSConn_HbSeed/GroupAnalysis/${GROUP}/MERGED_MEANdenseConnectome_HbL_TP${TP2}-TP${TP1}.dscalar.nii ${args_L_neg}

wb_command -cifti-merge ${maindir}/outputs/RSConn_HbSeed/GroupAnalysis/${GROUP}/MERGED_MEANdenseConnectome_HbL_TP${TP2}-TP${TP1}.dscalar.nii ${args_R_neg}

