#!/bin/bash 

module load workbench/1.3.2

#SubjList=$(</nafs/narr/sachang/sachang/habenula/code/habenula_RSconnectivity/habenula_subList.txt)
Subjlist=$(</nafs/narr/sachang/sachang/habenula/code/habenula_RSconnectivity/habenula_subList_clinical_RSgenerated.txt)
datadir=/nafs/narr/sachang/sachang/habenula/outputs/3_RSConnectivity/SubjectsDATA

extension="dscalar.nii"
args_L=""
args_R=""

for i in ${Subjlist}; do
	args_L="${args_L} -cifti 
	${datadir}/${i}/MEANdenseConnectome_L_shape_optimized_Hb_ROI_${i}.dscalar.nii -column 1"
	echo $i
done 

wb_command -cifti-merge /nafs/narr/sachang/sachang/habenula/outputs/3_RSConnectivity/GroupDATA/MEANdenseConnectome_L_shape_optimized_Hb_ROI_merge_clinical.${extension} ${args_L}


for i in ${Subjlist}; do
        args_R="${args_R} -cifti 
        ${datadir}/${i}/MEANdenseConnectome_R_shape_optimized_Hb_ROI_${i}.dscalar.nii -column 1"
done

wb_command -cifti-merge /nafs/narr/sachang/sachang/habenula/outputs/3_RSConnectivity/GroupDATA/MEANdenseConnectome_R_shape_optimized_Hb_ROI_merge_clinical.${extension} ${args_R}

