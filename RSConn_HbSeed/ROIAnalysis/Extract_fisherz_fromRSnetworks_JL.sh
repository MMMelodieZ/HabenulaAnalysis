#!/bin/bash

maindir=/nafs/narr
Habenuladir=${maindir}/HCP_OUTPUT/Habenula

g="RemchangeTP3_NonRemchangeTP3"

imgsdir=${Habenuladir}/outputs/RSConn_HbSeed/GroupAnalysis/wSmoothing_wDenoising/SubtractedImages/KTP1_KTP3
logdir=${Habenuladir}/outputs/RSConn_HbSeed/ROI_Timeseries/RSNetworks

ColeAnticevicAtlas="/nafs/narr/jloureiro/Masks/paper2/ColeAnticevicMasks/MERGED_Cortex_AnticevicNetworks_LR_fromtemplate.dscalar.nii"
RSConndir="${Habenuladir}/outputs/RSConn_HbSeed/SubjectsDATA_RSConn"

subject_list=${Habenuladir}/outputs/RSConn_HbSeed/Sublist_RSConn_v3_ALL.txt
subjects=$( cat ${subject_list} )

module load workbench/1.3.2


#wb_command -cifti-merge jloureiro/Masks/paper2/ColeAnticevicMasks/MERGED_Cortex_AnticevicNetworks_LR.dscalar.nii -cifti jloureiro/Masks/paper2/ColeAnticevicMasks/Default/Cortex_Default.dscalar.nii -cifti jloureiro/Masks/paper2/ColeAnticevicMasks/Frontoparietal/Cortex_Frontoparietal.dscalar.nii -cifti jloureiro/Masks/paper2/ColeAnticevicMasks/Dorsal-attention/Cortex_Dorsal-attention.dscalar.nii -cifti jloureiro/Masks/paper2/ColeAnticevicMasks/Cingulo-Opercular/Cortex_Cingulo-Opercular.dscalar.nii -cifti jloureiro/Masks/paper2/ColeAnticevicMasks/Somatomotor/Cortex_Somatomotor.dscalar.nii -cifti jloureiro/Masks/paper2/ColeAnticevicMasks/Language/Cortex_Language.dscalar.nii -cifti jloureiro/Masks/paper2/ColeAnticevicMasks/Orbito-Affective/Cortex_Orbito-Affective.dscalar.nii -cifti jloureiro/Masks/paper2/ColeAnticevicMasks/Posterior-Multimodal/Cortex_Posterior-Multimodal.dscalar.nii -cifti jloureiro/Masks/paper2/ColeAnticevicMasks/Ventral-Multimodal/Cortex_Ventral-Multimodal.dscalar.nii -cifti jloureiro/Masks/paper2/ColeAnticevicMasks/Visual1/Cortex_Visual1.dscalar.nii -cifti jloureiro/Masks/paper2/ColeAnticevicMasks/Visual2/Cortex_Visual2.dscalar.nii -cifti jloureiro/Masks/paper2/ColeAnticevicMasks/Auditory/Cortex_Auditory.dscalar.nii 


#wb_command -cifti-create-dense-from-template ${RSConndir}/k000401/RSConn_k000401_drest-MeanAPPA_HbR.dscalar.nii /nafs/narr/jloureiro/Masks/paper2/ColeAnticevicMasks/MERGED_Cortex_AnticevicNetworks_LR_fromtemplate.dscalar.nii -cifti /nafs/narr/jloureiro/Masks/paper2/ColeAnticevicMasks/MERGED_Cortex_AnticevicNetworks_LR.dscalar.nii 



for ROI in HbL HbR
do

if [ -f "${logdir}/GlasserAtlas_RSNetworks_${ROI}.txt" ]; then
	rm ${logdir}/GlasserAtlas_RSNetworks_${ROI}.txt
fi

for sub in ${subjects}
do
wb_command -cifti-stats ${RSConndir}/${sub}/RSConn_${sub}_drest-MeanAPPA_HbR.dscalar.nii -reduce MEAN -roi ${ColeAnticevicAtlas} >> ${logdir}/GlasserAtlas_RSNetworks_${ROI}.txt	
done
done
