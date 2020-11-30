#!/bin/bash

maindir=/nafs/narr
Habenuladir=${maindir}/HCP_OUTPUT/Habenula


module load fsl
module load workbench/1.3.2

#subject_list=${Habenuladir}/outputs/RSConn_HbSeed/Sublist_RSConn_v5_Aug2020.txt
subject_list=${Habenuladir}/outputs/RSConn_HbSeed/Sublist_RSConn_v8_Sept2020.txt
subjects=$( cat ${subject_list} )
#subjects="k007801"
RSConndir="${Habenuladir}/outputs/RSConn_HbSeed/SubjectsDATA_RSConn"

for sub in ${subjects}; do



#if [ ! -f ${RSConndir}/${sub}/RSConn_${sub}_drest-MeanAPPA_HbR.dscalar.nii ]; then

rm ${RSConndir}/${sub}/RSConn_${sub}_drest-MeanAPPA_HbR.dscalar.nii
rm ${RSConndir}/${sub}/RSConn_${sub}_drest-MeanAPPA_HbL.dscalar.nii

wb_command -cifti-average ${RSConndir}/${sub}/RSConn_${sub}_drest-MeanAPPA_HbR.dscalar.nii -cifti ${RSConndir}/${sub}/RSConn_${sub}_drest-AP_HbR.dscalar.nii -cifti ${RSConndir}/${sub}/RSConn_${sub}_drest-PA_HbR.dscalar.nii


wb_command -cifti-average ${RSConndir}/${sub}/RSConn_${sub}_drest-MeanAPPA_HbL.dscalar.nii -cifti ${RSConndir}/${sub}/RSConn_${sub}_drest-AP_HbL.dscalar.nii -cifti ${RSConndir}/${sub}/RSConn_${sub}_drest-PA_HbL.dscalar.nii

echo ${sub} finished
#fi

done
