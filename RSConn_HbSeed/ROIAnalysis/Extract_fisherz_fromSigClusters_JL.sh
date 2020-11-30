#!/bin/bash

maindir=/nafs/narr
Habenuladir=${maindir}/HCP_OUTPUT/Habenula

imgsdir=${Habenuladir}/outputs/RSConn_HbSeed/SubjectsDATA_RSConn
logdir=${Habenuladir}/outputs/RSConn_HbSeed/ROIAnalysis_Sigclusters
GroupAnalysisdir=${Habenuladir}/outputs/RSConn_HbSeed/GroupAnalysis/wSmoothing_wDenoising

#ColeAnticevicAtlas="/nafs/narr/jloureiro/Masks/paper2/ColeAnticevicMasks/MERGED_Cortex_AnticevicNetworks_LR_fromtemplate.dscalar.nii"
ColeAnticevicAtlas="${Habenuladir}/outputs/RSConn_HbSeed/ROIAnalysis_Hb2Nets/TargetNetMasks/MERGED_Cortex_DMN_FPN_CON_SMN_OAN_V1_V2_AUN_LR.dscalar.nii"
RSConndir="${Habenuladir}/outputs/RSConn_HbSeed/SubjectsDATA_RSConn"

subject_list=${Habenuladir}/outputs/RSConn_HbSeed/Sublist_RSConn_v6_ALL_Aug2020.txt
subjects=$( cat ${subject_list} )

module load workbench/1.3.2


#Generate ROIs to extract from:###############################

#a)Threshold and binarize maps

wb_command -cifti-math 'x>1.3' ${logdir}/ROIs/HC-KTP1_HbL_thr1.3TFCEFWE.dscalar.nii -var 'x' -cifti ${GroupAnalysisdir}/HC_KTP1/HbR/results_dense_tfce_ztstat_fwep_c1.dscalar.nii

wb_command -cifti-math 'x>1.3' ${logdir}/ROIs/KTP1-HC_HbR_thr1.3TFCEFWE.dscalar.nii -var 'x' -cifti ${GroupAnalysisdir}/HC_KTP1/HbL/results_dense_tfce_ztstat_fwep_c2.dscalar.nii

wb_command -cifti-math 'x>1.3' ${logdir}/ROIs/Remchange-NonReemchange_HbL_thr1.3TFCEFWE.dscalar.nii -var 'x' -cifti ${GroupAnalysisdir}/RemchangeTP3_NonRemchangeTP3/HbL/results_dense_tfce_ztstat_fwep_c1.dscalar.nii

#b) Multiply with atlas ROIs

wb_command -cifti-math 'x*y' ${logdir}/ROIs/SensoryC.L_HC-KTP1_HbL_thr1.3TFCEFWE.dscalar.nii -var 'x' -cifti ${logdir}/ROIs/HC-KTP1_HbL_thr1.3TFCEFWE.dscalar.nii -var 'y' -cifti 


logfile_R="${logdir}/MERGEDROIs_${PPIROI}_AvBOLD_${net}_wcereb_R.txt"
logfile_L="${logdir}/MERGEDROIs_${PPIROI}_AvBOLD_${net}_wcereb_L.txt"
if [ -f ${logfile} ]; then
#rm ${logfile_RL}
rm ${logfile_R}
rm ${logfile_L}

fi
for sub in ${Subjlist}
do
imagesdir="${hcpdir}/${sub}/MNINonLinear"
betaimgsdir="${imagesdir}/Results/task-carit_acq-PA_run-01/task-carit_acq-PA_run-01_JL_clean_PPIAnalysis_${PPIROI}_hp200_s5_level1.feat/GrayordinatesStats"

wb_command -cifti-stats ${betaimgsdir}/${cope}.dtseries.nii -reduce MEAN -roi ${CombinedMasksdir}/${net}/MERGEDROIs_AvBOLD_${net}_wcereb_R.dscalar.nii >> ${logfile_R}
wb_command -cifti-stats ${betaimgsdir}/${cope}.dtseries.nii -reduce MEAN -roi ${CombinedMasksdir}/${net}/MERGEDROIs_AvBOLD_${net}_wcereb_L.dscalar.nii >> ${logfile_L}


done



