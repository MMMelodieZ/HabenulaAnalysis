#!/bin/bash

maindir=/nafs/narr
Habenuladir=${maindir}/HCP_OUTPUT/Habenula
GroupList="KTP1_KTP2"
#GroupList="KTP1_KTP3"
#g="KTP1_KTP3"

module load fsl
module load workbench/1.3.2

for g in $GroupList; do
#groupdir=${Habenuladir}/outputs/RSConn_HbSeed/GroupAnalysis/wSmoothing_noDenoising/SubtractedImages/${g}
groupdir=${Habenuladir}/outputs/RSConn_HbSeed/GroupAnalysis/wSmoothing_wDenoising/SubtractedImages/${g}
subject_list=${groupdir}/${g}_IDs.txt
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


for sub in ${subjects}; do

RSConndir="${Habenuladir}/outputs/RSConn_HbSeed/SubjectsDATA_RSConn"

#if [ ! -f ${RSConndir}/${sub}${TP1}/RSConn_${sub}${TP1}_rest-MeanAPPA_HbR.dscalar.nii ]; then

#wb_command -cifti-average ${RSConndir}/${sub}${TP1}/RSConn_${sub}${TP1}_rest-MeanAPPA_HbR.dscalar.nii -cifti ${RSConndir}/${sub}${TP1}/RSConn_${sub}${TP1}_rest-AP_HbR.dscalar.nii -cifti ${RSConndir}/${sub}${TP1}/RSConn_${sub}${TP1}_rest-PA_HbR.dscalar.nii
#wb_command -cifti-average ${RSConndir}/${sub}${TP1}/RSConn_${sub}${TP1}_rest-MeanAPPA_HbL.dscalar.nii -cifti ${RSConndir}/${sub}${TP1}/RSConn_${sub}${TP1}_rest-AP_HbL.dscalar.nii -cifti ${RSConndir}/${sub}${TP1}/RSConn_${sub}${TP1}_rest-PA_HbL.dscalar.nii

#wb_command -cifti-average ${RSConndir}/${sub}${TP2}/RSConn_${sub}${TP2}_rest-MeanAPPA_HbR.dscalar.nii -cifti ${RSConndir}/${sub}${TP2}/RSConn_${sub}${TP2}_rest-AP_HbR.dscalar.nii -cifti ${RSConndir}/${sub}${TP2}/RSConn_${sub}${TP2}_rest-PA_HbR.dscalar.nii
#wb_command -cifti-average ${RSConndir}/${sub}${TP2}/RSConn_${sub}${TP2}_rest-MeanAPPA_HbL.dscalar.nii -cifti ${RSConndir}/${sub}${TP2}/RSConn_${sub}${TP2}_rest-AP_HbL.dscalar.nii -cifti ${RSConndir}/${sub}${TP2}/RSConn_${sub}${TP2}_rest-PA_HbL.dscalar.nii


#wb_command -cifti-average ${RSConndir}/${sub}${TP1}/RSConn_${sub}${TP1}_drest-MeanAPPA_HbR.dscalar.nii -cifti ${RSConndir}/${sub}${TP1}/RSConn_${sub}${TP1}_drest-AP_HbR.dscalar.nii -cifti ${RSConndir}/${sub}${TP1}/RSConn_${sub}${TP1}_drest-PA_HbR.dscalar.nii
#wb_command -cifti-average ${RSConndir}/${sub}${TP1}/RSConn_${sub}${TP1}_drest-MeanAPPA_HbL.dscalar.nii -cifti ${RSConndir}/${sub}${TP1}/RSConn_${sub}${TP1}_drest-AP_HbL.dscalar.nii -cifti ${RSConndir}/${sub}${TP1}/RSConn_${sub}${TP1}_drest-PA_HbL.dscalar.nii

#wb_command -cifti-average ${RSConndir}/${sub}${TP2}/RSConn_${sub}${TP2}_drest-MeanAPPA_HbR.dscalar.nii -cifti ${RSConndir}/${sub}${TP2}/RSConn_${sub}${TP2}_drest-AP_HbR.dscalar.nii -cifti ${RSConndir}/${sub}${TP2}/RSConn_${sub}${TP2}_drest-PA_HbR.dscalar.nii
#wb_command -cifti-average ${RSConndir}/${sub}${TP2}/RSConn_${sub}${TP2}_drest-MeanAPPA_HbL.dscalar.nii -cifti ${RSConndir}/${sub}${TP2}/RSConn_${sub}${TP2}_drest-AP_HbL.dscalar.nii -cifti ${RSConndir}/${sub}${TP2}/RSConn_${sub}${TP2}_drest-PA_HbL.dscalar.nii


#fi


#wb_command -cifti-math 'x-y' ${groupdir}/RSConn_${sub}_TP${TP1}-TP${TP2}_rest-MeanAPPA_HbR.dscalar.nii -var x ${RSConndir}/${sub}${TP1}/RSConn_${sub}${TP1}_rest-MeanAPPA_HbR.dscalar.nii -var y ${RSConndir}/${sub}${TP2}/RSConn_${sub}${TP2}_rest-MeanAPPA_HbR.dscalar.nii

#wb_command -cifti-math 'x-y' ${groupdir}/RSConn_${sub}_TP${TP1}-TP${TP2}_rest-MeanAPPA_HbL.dscalar.nii -var x ${RSConndir}/${sub}${TP1}/RSConn_${sub}${TP1}_rest-MeanAPPA_HbL.dscalar.nii -var y ${RSConndir}/${sub}${TP2}/RSConn_${sub}${TP2}_rest-MeanAPPA_HbL.dscalar.nii

#wb_command -cifti-math 'x * (-1)' ${groupdir}/RSConn_${sub}_TP${TP2}-TP${TP1}_rest-MeanAPPA_HbR.dscalar.nii -var x ${groupdir}/RSConn_${sub}_TP${TP1}-TP${TP2}_rest-MeanAPPA_HbR.dscalar.nii 
#wb_command -cifti-math 'x * (-1)' ${groupdir}/RSConn_${sub}_TP${TP2}-TP${TP1}_rest-MeanAPPA_HbL.dscalar.nii -var x ${groupdir}/RSConn_${sub}_TP${TP1}-TP${TP2}_rest-MeanAPPA_HbL.dscalar.nii


wb_command -cifti-math 'x-y' ${groupdir}/RSConn_${sub}_TP${TP1}-TP${TP2}_drest-MeanAPPA_HbR.dscalar.nii -var x ${RSConndir}/${sub}${TP1}/RSConn_${sub}${TP1}_drest-MeanAPPA_HbR.dscalar.nii -var y ${RSConndir}/${sub}${TP2}/RSConn_${sub}${TP2}_drest-MeanAPPA_HbR.dscalar.nii

wb_command -cifti-math 'x-y' ${groupdir}/RSConn_${sub}_TP${TP1}-TP${TP2}_drest-MeanAPPA_HbL.dscalar.nii -var x ${RSConndir}/${sub}${TP1}/RSConn_${sub}${TP1}_drest-MeanAPPA_HbL.dscalar.nii -var y ${RSConndir}/${sub}${TP2}/RSConn_${sub}${TP2}_drest-MeanAPPA_HbL.dscalar.nii

wb_command -cifti-math 'x * (-1)' ${groupdir}/RSConn_${sub}_TP${TP2}-TP${TP1}_drest-MeanAPPA_HbR.dscalar.nii -var x ${groupdir}/RSConn_${sub}_TP${TP1}-TP${TP2}_drest-MeanAPPA_HbR.dscalar.nii 
wb_command -cifti-math 'x * (-1)' ${groupdir}/RSConn_${sub}_TP${TP2}-TP${TP1}_drest-MeanAPPA_HbL.dscalar.nii -var x ${groupdir}/RSConn_${sub}_TP${TP1}-TP${TP2}_drest-MeanAPPA_HbL.dscalar.nii

done
done

echo "finished"


