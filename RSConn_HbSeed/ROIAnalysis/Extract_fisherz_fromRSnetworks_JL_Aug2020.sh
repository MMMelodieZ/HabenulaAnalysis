#!/bin/bash

maindir=/nafs/narr
Habenuladir=${maindir}/HCP_OUTPUT/Habenula

imgsdir=${Habenuladir}/outputs/RSConn_HbSeed/SubjectsDATA_RSConn
logdir=${Habenuladir}/outputs/RSConn_HbSeed/ROIAnalysis_Hb2Nets

#ColeAnticevicAtlas="/nafs/narr/jloureiro/Masks/paper2/ColeAnticevicMasks/MERGED_Cortex_AnticevicNetworks_LR_fromtemplate.dscalar.nii"
ColeAnticevicAtlas="${Habenuladir}/outputs/RSConn_HbSeed/ROIAnalysis_Hb2Nets/TargetNetMasks/MERGED_Cortex_DMN_FPN_CON_SMN_OAN_V1_V2_AUN_LR.dscalar.nii"
RSConndir="${Habenuladir}/outputs/RSConn_HbSeed/SubjectsDATA_RSConn"

subject_list=${Habenuladir}/outputs/RSConn_HbSeed/Sublist_RSConn_v6_ALL_Aug2020.txt
subjects=$( cat ${subject_list} )

module load workbench/1.3.2


wb_command -cifti-merge ${Habenuladir}/outputs/RSConn_HbSeed/ROIAnalysis_Hb2Nets/TargetNetMasks/MERGED_Cortex_DMN_FPN_CON_SMN_OAN_V1_V2_AUN_LR.dscalar.nii -cifti jloureiro/Masks/paper2/ColeAnticevicMasks/Default/Cortex_Default.dscalar.nii -cifti jloureiro/Masks/paper2/ColeAnticevicMasks/Frontoparietal/Cortex_Frontoparietal.dscalar.nii -cifti jloureiro/Masks/paper2/ColeAnticevicMasks/Cingulo-Opercular/Cortex_Cingulo-Opercular.dscalar.nii -cifti jloureiro/Masks/paper2/ColeAnticevicMasks/Somatomotor/Cortex_Somatomotor.dscalar.nii -cifti jloureiro/Masks/paper2/ColeAnticevicMasks/Orbito-Affective/Cortex_Orbito-Affective.dscalar.nii -cifti jloureiro/Masks/paper2/ColeAnticevicMasks/Visual1/Cortex_Visual1.dscalar.nii -cifti jloureiro/Masks/paper2/ColeAnticevicMasks/Visual2/Cortex_Visual2.dscalar.nii -cifti jloureiro/Masks/paper2/ColeAnticevicMasks/Auditory/Cortex_Auditory.dscalar.nii 


wb_command -cifti-create-dense-from-template ${RSConndir}/k000401/RSConn_k000401_drest-MeanAPPA_HbR.dscalar.nii ${Habenuladir}/outputs/RSConn_HbSeed/ROIAnalysis_Hb2Nets/TargetNetMasks/MERGED_Cortex_DMN_FPN_CON_SMN_OAN_V1_V2_AUN_LR.dscalar.nii -cifti ${Habenuladir}/outputs/RSConn_HbSeed/ROIAnalysis_Hb2Nets/TargetNetMasks/MERGED_Cortex_DMN_FPN_CON_SMN_OAN_V1_V2_AUN_LR.dscalar.nii



for ROI in HbL HbR
do

if [ -f "${logdir}/txtfiles/GlasserAtlas_RSNetworks_${ROI}seed.txt" ]; then
	rm ${logdir}/txtfiles/GlasserAtlas_RSNetworks_${ROI}seed.txt
fi

for sub in ${subjects}
do
wb_command -cifti-stats ${RSConndir}/${sub}/RSConn_${sub}_drest-MeanAPPA_${ROI}.dscalar.nii -reduce MEDIAN -roi ${ColeAnticevicAtlas} >> ${logdir}/txtfiles/GlasserAtlas_RSNetworks_${ROI}seed.txt	
done
done
