#!/bin/bash

maindir=/nafs/narr
Habenuladir=${maindir}/HCP_OUTPUT/Habenula

imgsdir=${Habenuladir}/outputs/RSConn_HbSeed/SubjectsDATA_RSConn
subject_list=${imgsdir}/../Sublist_RSConn_v6_ALL_Aug2020.txt
subjects=$( cat ${subject_list} )

module unload fsl
module load fsl/6.0.0
module unload workbench
module load workbench
module unload MATLAB
module load MATLAB/R2017a
module load PALM
module load freesurfer/6.0.1 
args_R=""
args_L=""

for sub in ${subjects}; do

	args_R="${args_R} -cifti 
	${imgsdir}/${sub}/RSConn_${sub}_drest-MeanAPPA_HbR.dscalar.nii -column 1"
	args_L="${args_L} -cifti 
	${imgsdir}/${sub}/RSConn_${sub}_drest-MeanAPPA_HbL.dscalar.nii -column 1"
	
	echo $sub
done 

cd ${imgsdir}
echo "$args_R"
echo "$args_L"

for sub in ${subjects}; do
wb_command -cifti-create-dense-from-template ${imgsdir}/k004101/RSConn_k004101_drest-MeanAPPA_HbL.dscalar.nii ${imgsdir}/${sub}/RSConn_${sub}_drest-MeanAPPA_HbL.dscalar.nii -cifti ${imgsdir}/${sub}/RSConn_${sub}_drest-MeanAPPA_HbL.dscalar.nii 
done

#wb_command -cifti-merge QC_Conn_HbR_Aug2020.dscalar.nii ${args_R}

wb_command -cifti-merge QC_Conn_HbL_Aug2020.dscalar.nii ${args_L}


