#!/bin/sh

module load workbench/1.3.2
module load fsl

maindir="/nafs/narr/HCP_OUTPUT/Habenula"
txtfilesdir="${maindir}/outputs/RSConn_HbSeed/GroupAnalysis/wSmoothing_wDenoising/RSConn_SignificantROIs_extracted"
group="KTP1_KTP3"
hbROI="HbL"
pmapExtraction="results_dense_neg_clustere_ztstat_fwep_c1.dscalar.nii"
groupAnalysisdir="${maindir}/outputs/RSConn_HbSeed/GroupAnalysis/wSmoothing_wDenoising/${group}/${hbROI}"

Subjlist_ALL=$(<$txtfilesdir/ALLSubs_ROIExtract.txt) #Space delimited list of subject IDs
Subjlist_TP1_3=$(<$txtfilesdir/Subs_ROIExtract_TP1_TP3.txt)
#Subjlist="k000801 k000802"
echo "$Subjlist" 



wb_command -cifti-math 'x > 1.42' ${txtfilesdir}/Masks_Significant_ROIs/cerebellumROI_TP1_TP3_clustere_thr1.4_c1.dscalar.nii -var x ${groupAnalysisdir}/${pmapExtraction}

#1- Create ROI to extract RSConn values:

Maskdir="${txtfilesdir}/Masks_Significant_ROIs/cerebellumROI_TP1_TP3_clustere_thr1.4_c1.dscalar.nii"
imagesmaindir="${maindir}/outputs/RSConn_HbSeed/SubjectsDATA_RSConn"

for sub in ${Subjlist_ALL}
do

imagedir="${imagesmaindir}/${sub}/RSConn_${sub}_drest-MeanAPPA_${hbROI}.dscalar.nii"

wb_command -cifti-create-dense-from-template ${Maskdir} ${imagedir} -cifti ${imagedir}

wb_command -cifti-stats ${imagedir} -reduce MEAN -roi ${Maskdir} >> ${txtfilesdir}/ExtractedValues_txtfiles/ALLSubs_${group}_${hbROI}_neg_c1.txt
done

rm ${txtfilesdir}/ExtractedValues_txtfiles/KTP1TP3Subs_${group}_${hbROI}_neg_c1.txt
for sub in ${Subjlist_TP1_3}
do
imagedir="${imagesmaindir}/${sub}/RSConn_${sub}_drest-MeanAPPA_${hbROI}.dscalar.nii "
wb_command -cifti-stats ${imagedir} -reduce MEAN -roi ${Maskdir} >> ${txtfilesdir}/ExtractedValues_txtfiles/KTP1TP3Subs_${group}_${hbROI}_neg_c1.txt
done

