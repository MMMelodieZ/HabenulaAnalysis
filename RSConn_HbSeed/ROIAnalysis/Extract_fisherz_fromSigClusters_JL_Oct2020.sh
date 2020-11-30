#!/bin/bash

maindir=/nafs/narr
Habenuladir=${maindir}/HCP_OUTPUT/Habenula

imgsdir=${Habenuladir}/outputs/RSConn_HbSeed/SubjectsDATA_RSConn
logdir=${Habenuladir}/outputs/RSConn_HbSeed/ROIAnalysis/ROIAnalysis_SigClusters
GroupAnalysisdir=${Habenuladir}/outputs/RSConn_HbSeed/GroupAnalysis/wSmoothing_wDenoising

#ColeAnticevicAtlas="/nafs/narr/jloureiro/Masks/paper2/ColeAnticevicMasks/MERGED_Cortex_AnticevicNetworks_LR_fromtemplate.dscalar.nii"
#ColeAnticevicAtlas="${Habenuladir}/outputs/RSConn_HbSeed/ROIAnalysis_Hb2Nets/TargetNetMasks/MERGED_Cortex_DMN_FPN_CON_SMN_OAN_V1_V2_AUN_LR.dscalar.nii"
GlasserAtlas="${Habenuladir}/outputs/RSConn_HbSeed/ROIAnalysis/ROIAnalysis_SigClusters/ROImasks/AtlasROIs/Glasser_NetworkPartition_v9_RL.dlabel.nii"
AAL3Atlas="${Habenuladir}/outputs/RSConn_HbSeed/ROIAnalysis/ROIAnalysis_SigClusters/ROImasks/AtlasROIs/AAL3v1.nii"
RSConndir="${Habenuladir}/outputs/RSConn_HbSeed/SubjectsDATA_RSConn"

subject_list=${logdir}/txtfiles/Sublist_Oct2020.txt
subjects=$( cat ${subject_list} )

module load workbench/1.3.2
module load fsl


#Generate ROIs to extract from:###############################

#a)Threshold and binarize maps

wb_command -cifti-math 'x>1.3' ${logdir}/ROImasks/funcMasks/results_HC_KTP1_HbL_dense_tfce_ztstat_fwep_c1_thr1.3.dscalar.nii -var 'x' ${logdir}/ROImasks/funcMasks/results_HC_KTP1_HbL_dense_tfce_ztstat_fwep_c1.dscalar.nii

wb_command -cifti-math 'x>1.3' ${logdir}/ROImasks/funcMasks/results_HC_KTP1_HbR_dense_tfce_ztstat_fwep_c2_thr1.3.dscalar.nii -var 'x' ${logdir}/ROImasks/funcMasks/results_HC_KTP1_HbR_dense_tfce_ztstat_fwep_c2.dscalar.nii

wb_command -cifti-math 'x>2' ${logdir}/ROImasks/funcMasks/results_HC_KTP1_HbL_dense_tfce_ztstat_uncp_c1_thr2.dscalar.nii -var 'x' ${logdir}/ROImasks/funcMasks/results_HC_KTP1_HbL_dense_tfce_ztstat_uncp_c1.dscalar.nii

wb_command -cifti-math 'x>2' ${logdir}/ROImasks/funcMasks/results_HC_KTP1_HbR_dense_tfce_ztstat_uncp_c1_thr2.dscalar.nii -var 'x' ${logdir}/ROImasks/funcMasks/results_HC_KTP1_HbR_dense_tfce_ztstat_uncp_c1.dscalar.nii

wb_command -cifti-math 'x>2' ${logdir}/ROImasks/funcMasks/results_HC_KTP1_HbR_dense_tfce_ztstat_uncp_c2_thr2.dscalar.nii -var 'x' ${logdir}/ROImasks/funcMasks/results_HC_KTP1_HbR_dense_tfce_ztstat_uncp_c2.dscalar.nii

wb_command -cifti-math 'x>1.3' ${logdir}/ROImasks/funcMasks/results_RemchangetP3_NonReemchangeTP3_HbL_dense_pos_tfce_ztstat_fwep_c2_thr1.3.dscalar.nii -var 'x' ${logdir}/ROImasks/funcMasks/results_RemchangetP3_NonReemchangeTP3_HbL_dense_pos_tfce_ztstat_fwep_c2.dscalar.nii

wb_command -cifti-math 'x>2' ${logdir}/ROImasks/funcMasks/results_RemchangetP3_NonReemchangeTP3_HbL_dense_pos_tfce_ztstat_uncp_c2_thr2.dscalar.nii -var 'x' ${logdir}/ROImasks/funcMasks/results_RemchangetP3_NonReemchangeTP3_HbL_dense_pos_tfce_ztstat_uncp_c2.dscalar.nii



fslmaths ${logdir}/ROImasks/funcMasks/results_HC_KTP1_HbL_dense_subcortical_tfce_ztstat_fwep_c1.nii -thr 1.3 -bin ${logdir}/ROImasks/funcMasks/results_HC_KTP1_HbL_dense_subcortical_tfce_ztstat_fwep_c1_thr1.3.nii

fslmaths ${logdir}/ROImasks/funcMasks/results_HC_KTP1_HbL_dense_subcortical_tfce_ztstat_uncp_c1.nii -thr 2 -bin ${logdir}/ROImasks/funcMasks/results_HC_KTP1_HbL_dense_subcortical_tfce_ztstat_uncp_c1_thr2.nii

fslmaths ${logdir}/ROImasks/funcMasks/results_HC_KTP1_HbR_dense_subcortical_tfce_ztstat_fwep_c2.nii -thr 1.3 -bin ${logdir}/ROImasks/funcMasks/results_HC_KTP1_HbR_dense_subcortical_tfce_ztstat_fwep_c2_thr1.3.nii

fslmaths ${logdir}/ROImasks/funcMasks/results_HC_KTP1_HbR_dense_subcortical_tfce_ztstat_uncp_c1.nii -thr 2 -bin ${logdir}/ROImasks/funcMasks/results_HC_KTP1_HbR_dense_subcortical_tfce_ztstat_uncp_c1_thr2.nii

fslmaths ${logdir}/ROImasks/funcMasks/results_HC_KTP1_HbR_dense_subcortical_tfce_ztstat_uncp_c2.nii -thr 2 -bin ${logdir}/ROImasks/funcMasks/results_HC_KTP1_HbR_dense_subcortical_tfce_ztstat_uncp_c2_thr2.nii


#b)Isolate Atlas ROIs

fslmaths ${AAL3Atlas} -thr 103 -uthr 103 -bin ${logdir}/ROImasks/AtlasROIs/AAL3_cerebellumVI_L_103.nii
fslmaths ${AAL3Atlas} -thr 128 -uthr 128 -bin ${logdir}/ROImasks/AtlasROIs/AAL3_thalamusVL_128.nii
fslmaths ${AAL3Atlas} -thr 160 -uthr 160 -bin ${logdir}/ROImasks/AtlasROIs/AAL3_VTA_R_160.nii
fslmaths ${AAL3Atlas} -thr 162 -uthr 162 -bin ${logdir}/ROImasks/AtlasROIs/AAL3_SN_R_162.nii
fslmaths ${AAL3Atlas} -thr 158 -uthr 158 -bin ${logdir}/ROImasks/AtlasROIs/AAL3_NcAccumb_R_158.nii
fslmaths ${AAL3Atlas} -thr 41 -uthr 41 -bin ${logdir}/ROImasks/AtlasROIs/AAL3_hipp_L_41.nii
fslmaths ${AAL3Atlas} -thr 42 -uthr 42 -bin ${logdir}/ROImasks/AtlasROIs/AAL3_hipp_R_42.nii
fslmaths ${AAL3Atlas} -thr 109 -uthr 109 -bin ${logdir}/ROImasks/AtlasROIs/AAL3_cerebellumIX_L_109.nii
fslmaths ${AAL3Atlas} -thr 75 -uthr 75 -bin ${logdir}/ROImasks/AtlasROIs/AAL3_caudate_L_75.nii
fslmaths ${AAL3Atlas} -thr 76 -uthr 76 -bin ${logdir}/ROImasks/AtlasROIs/AAL3_caudate_R_76.nii

wb_command -cifti-label-to-roi ${GlasserAtlas} ${logdir}/ROImasks/AtlasROIs/SOM-87.dscalar.nii -name SOM-87 -map 1
wb_command -cifti-label-to-roi ${GlasserAtlas} ${logdir}/ROImasks/AtlasROIs/CON-146.dscalar.nii -name CON-146 -map 1
wb_command -cifti-label-to-roi ${GlasserAtlas} ${logdir}/ROImasks/AtlasROIs/CON-136.dscalar.nii -name CON-136 -map 1
wb_command -cifti-label-to-roi ${GlasserAtlas} ${logdir}/ROImasks/AtlasROIs/VIS-32.dscalar.nii -name VIS-32 -map 1
wb_command -cifti-label-to-roi ${GlasserAtlas} ${logdir}/ROImasks/AtlasROIs/SOM-63.dscalar.nii -name SOM-63 -map 1

#c) Multiply with atlas ROIs

#wb_command -cifti-create-dense-from-template ${logdir}/ROImasks/AtlasROIs/CON-136.dscalar.nii ${logdir}/ROImasks/funcMasks/results_HC_KTP1_HbR_dense_tfce_ztstat_uncp_c1_thr2.dscalar.nii -cifti ${logdir}/ROImasks/funcMasks/results_HC_KTP1_HbR_dense_tfce_ztstat_uncp_c1_thr2.dscalar.nii

wb_command -cifti-math 'x*y'  ${logdir}/ROImasks/CombinedMasks/Combined_results_HC_KTP1_HbR_dense_tfce_ztstat_fwep_c2_thr1.3_SOM-87.dscalar.nii -var 'x' ${logdir}/ROImasks/funcMasks/results_HC_KTP1_HbR_dense_tfce_ztstat_fwep_c2_thr1.3.dscalar.nii -var 'y' ${logdir}/ROImasks/AtlasROIs/SOM-87.dscalar.nii

wb_command -cifti-math 'x*y'  ${logdir}/ROImasks/CombinedMasks/Combined_results_HC_KTP1_HbR_dense_tfce_ztstat_uncp_c1_thr2_CON-146.dscalar.nii -var 'x' ${logdir}/ROImasks/funcMasks/results_HC_KTP1_HbR_dense_tfce_ztstat_uncp_c1_thr2.dscalar.nii -var 'y' ${logdir}/ROImasks/AtlasROIs/CON-146.dscalar.nii

wb_command -cifti-math 'x*y'  ${logdir}/ROImasks/CombinedMasks/Combined_results_HC_KTP1_HbR_dense_tfce_ztstat_uncp_c1_thr2_CON-136.dscalar.nii -var 'x' ${logdir}/ROImasks/funcMasks/results_HC_KTP1_HbR_dense_tfce_ztstat_uncp_c1_thr2.dscalar.nii -var 'y' ${logdir}/ROImasks/AtlasROIs/CON-136.dscalar.nii


wb_command -cifti-math 'x*y'  ${logdir}/ROImasks/CombinedMasks/Combined_results_RemchangetP3_NonReemchangeTP3_HbL_dense_pos_tfce_ztstat_fwep_c2_thr1.3_VIS-32.dscalar.nii -var 'x' ${logdir}/ROImasks/funcMasks/results_RemchangetP3_NonReemchangeTP3_HbL_dense_pos_tfce_ztstat_fwep_c2_thr1.3.dscalar.nii -var 'y' ${logdir}/ROImasks/AtlasROIs/VIS-32.dscalar.nii

wb_command -cifti-math 'x*y'  ${logdir}/ROImasks/CombinedMasks/Combined_results_RemchangetP3_NonReemchangeTP3_HbL_dense_pos_tfce_ztstat_uncp_c2_thr2_SOM-63.dscalar.nii -var 'x' ${logdir}/ROImasks/funcMasks/results_RemchangetP3_NonReemchangeTP3_HbL_dense_pos_tfce_ztstat_uncp_c2_thr2.dscalar.nii -var 'y' ${logdir}/ROImasks/AtlasROIs/SOM-63.dscalar.nii


fslmaths ${logdir}/ROImasks/AtlasROIs/AAL3_VTA_R_160.nii.gz -mul ${logdir}/ROImasks/funcMasks/results_HC_KTP1_HbL_dense_subcortical_tfce_ztstat_uncp_c1_thr2.nii ${logdir}/ROImasks/CombinedMasks/Combined_results_HC_KTP1_HbL_dense_tfce_ztstat_uncp_c1_thr2_VTA_R.nii

fslmaths ${logdir}/ROImasks/AtlasROIs/AAL3_SN_R_162.nii.gz -mul ${logdir}/ROImasks/funcMasks/results_HC_KTP1_HbL_dense_subcortical_tfce_ztstat_uncp_c1_thr2.nii ${logdir}/ROImasks/CombinedMasks/Combined_results_HC_KTP1_HbL_dense_tfce_ztstat_uncp_c1_thr2_SN_R.nii

fslmaths ${logdir}/ROImasks/AtlasROIs/AAL3_thalamusVL_128.nii.gz -mul ${logdir}/ROImasks/funcMasks/results_HC_KTP1_HbL_dense_subcortical_tfce_ztstat_uncp_c1_thr2.nii ${logdir}/ROImasks/CombinedMasks/Combined_results_HC_KTP1_HbL_dense_tfce_ztstat_uncp_c1_thr2_thalamusVL.nii

fslmaths ${logdir}/ROImasks/AtlasROIs/AAL3_NcAccumb_R_158.nii.gz -mul ${logdir}/ROImasks/funcMasks/results_HC_KTP1_HbL_dense_subcortical_tfce_ztstat_uncp_c1_thr2.nii ${logdir}/ROImasks/CombinedMasks/Combined_results_HC_KTP1_HbL_dense_tfce_ztstat_uncp_c1_thr2_NcAccumb_R.nii

fslmaths ${logdir}/ROImasks/AtlasROIs/AAL3_cerebellumVI_L_103.nii.gz -mul ${logdir}/ROImasks/funcMasks/results_HC_KTP1_HbL_dense_subcortical_tfce_ztstat_fwep_c1_thr1.3.nii ${logdir}/ROImasks/CombinedMasks/Combined_results_HC_KTP1_HbL_dense_subcortical_tfce_ztstat_fwep_c1_thr1.3_cerebellumVI_L.nii

fslmaths ${logdir}/ROImasks/AtlasROIs/AAL3_hipp_L_41.nii.gz  -mul ${logdir}/ROImasks/funcMasks/results_HC_KTP1_HbR_dense_subcortical_tfce_ztstat_uncp_c2_thr2.nii ${logdir}/ROImasks/CombinedMasks/Combined_results_HC_KTP1_HbR_dense_subcortical_tfce_ztstat_uncp_c2_thr2_hipp_L.nii

fslmaths ${logdir}/ROImasks/AtlasROIs/AAL3_hipp_R_42.nii.gz  -mul ${logdir}/ROImasks/funcMasks/results_HC_KTP1_HbR_dense_subcortical_tfce_ztstat_uncp_c2_thr2.nii ${logdir}/ROImasks/CombinedMasks/Combined_results_HC_KTP1_HbR_dense_subcortical_tfce_ztstat_uncp_c2_thr2_hipp_R.nii

fslmaths ${logdir}/ROImasks/AtlasROIs/AAL3_cerebellumIX_L_109.nii.gz  -mul ${logdir}/ROImasks/funcMasks/results_HC_KTP1_HbR_dense_subcortical_tfce_ztstat_uncp_c2_thr2.nii ${logdir}/ROImasks/CombinedMasks/Combined_results_HC_KTP1_HbR_dense_subcortical_tfce_ztstat_uncp_c2_thr2_cerebellumIX_L.nii

fslmaths ${logdir}/ROImasks/AtlasROIs/AAL3_caudate_R_76.nii.gz   -mul ${logdir}/ROImasks/funcMasks/results_HC_KTP1_HbR_dense_subcortical_tfce_ztstat_uncp_c1_thr2.nii ${logdir}/ROImasks/CombinedMasks/Combined_results_HC_KTP1_HbR_dense_subcortical_tfce_ztstat_uncp_c1_thr2_caudate_R.nii

fslmaths ${logdir}/ROImasks/AtlasROIs/AAL3_caudate_L_75.nii.gz   -mul ${logdir}/ROImasks/funcMasks/results_HC_KTP1_HbR_dense_subcortical_tfce_ztstat_uncp_c1_thr2.nii ${logdir}/ROImasks/CombinedMasks/Combined_results_HC_KTP1_HbR_dense_subcortical_tfce_ztstat_uncp_c1_thr2_caudate_L.nii

#d) merge Combined ROIs

wb_command -cifti-merge ${logdir}/ROImasks/CombinedMasks/ALLCombinedMasks_Ctx.dscalar.nii -cifti ${logdir}/ROImasks/CombinedMasks/Combined_results_HC_KTP1_HbR_dense_tfce_ztstat_fwep_c2_thr1.3_SOM-87.dscalar.nii -cifti ${logdir}/ROImasks/CombinedMasks/Combined_results_HC_KTP1_HbR_dense_tfce_ztstat_uncp_c1_thr2_CON-146.dscalar.nii -cifti ${logdir}/ROImasks/CombinedMasks/Combined_results_HC_KTP1_HbR_dense_tfce_ztstat_uncp_c1_thr2_CON-136.dscalar.nii -cifti ${logdir}/ROImasks/CombinedMasks/Combined_results_RemchangetP3_NonReemchangeTP3_HbL_dense_pos_tfce_ztstat_fwep_c2_thr1.3_VIS-32.dscalar.nii -cifti ${logdir}/ROImasks/CombinedMasks/Combined_results_RemchangetP3_NonReemchangeTP3_HbL_dense_pos_tfce_ztstat_uncp_c2_thr2_SOM-63.dscalar.nii



fslmerge -t ${logdir}/ROImasks/CombinedMasks/ALLCombinedMasks_Subcortical.nii ${logdir}/ROImasks/CombinedMasks/Combined_results_HC_KTP1_HbL_dense_tfce_ztstat_uncp_c1_thr2_VTA_R.nii ${logdir}/ROImasks/CombinedMasks/Combined_results_HC_KTP1_HbL_dense_tfce_ztstat_uncp_c1_thr2_SN_R.nii ${logdir}/ROImasks/CombinedMasks/Combined_results_HC_KTP1_HbL_dense_tfce_ztstat_uncp_c1_thr2_thalamusVL.nii ${logdir}/ROImasks/CombinedMasks/Combined_results_HC_KTP1_HbL_dense_tfce_ztstat_uncp_c1_thr2_NcAccumb_R.nii ${logdir}/ROImasks/CombinedMasks/Combined_results_HC_KTP1_HbL_dense_subcortical_tfce_ztstat_fwep_c1_thr1.3_cerebellumVI_L.nii ${logdir}/ROImasks/CombinedMasks/Combined_results_HC_KTP1_HbR_dense_subcortical_tfce_ztstat_uncp_c2_thr2_hipp_L.nii ${logdir}/ROImasks/CombinedMasks/Combined_results_HC_KTP1_HbR_dense_subcortical_tfce_ztstat_uncp_c2_thr2_hipp_R.nii ${logdir}/ROImasks/CombinedMasks/Combined_results_HC_KTP1_HbR_dense_subcortical_tfce_ztstat_uncp_c2_thr2_cerebellumIX_L.nii ${logdir}/ROImasks/CombinedMasks/Combined_results_HC_KTP1_HbR_dense_subcortical_tfce_ztstat_uncp_c1_thr2_caudate_R.nii ${logdir}/ROImasks/CombinedMasks/Combined_results_HC_KTP1_HbR_dense_subcortical_tfce_ztstat_uncp_c1_thr2_caudate_L.nii

#e)Cifti separate the connectivity images 
for ROI in HbL HbR
do

for sub in ${subjects}
do

wb_command -cifti-separate ${RSConndir}/${sub}/RSConn_${sub}_drest-MeanAPPA_${ROI}.dscalar.nii COLUMN -volume-all ${RSConndir}/${sub}/RSConn_${sub}_drest-MeanAPPA_${ROI}_volume.nii 

done
done

#e) Extract connectivity values from combined ROIs:

logfiledir="${logdir}/txtfiles"

#if [ -f ${logfiledir}/Ctx_${ROI}.txt ]; then
#rm ${logfile_RL}
#rm ${logfiledir}/Ctx_*
#rm ${logfiledir}/VTA_*

#fi

for ROI in HbL #HbR
do

for sub in ${subjects}
do
wb_command -cifti-stats ${RSConndir}/${sub}/RSConn_${sub}_drest-MeanAPPA_${ROI}.dscalar.nii -reduce MEAN -roi ${logdir}/ROImasks/CombinedMasks/ALLCombinedMasks_Ctx.dscalar.nii >> ${logfiledir}/Ctx_${ROI}.txt
fslstats ${RSConndir}/${sub}/RSConn_${sub}_drest-MeanAPPA_${ROI}_volume.nii -k ${logdir}/ROImasks/CombinedMasks/Combined_results_HC_KTP1_HbL_dense_tfce_ztstat_uncp_c1_thr2_VTA_R.nii.gz -M  >> ${logfiledir}/VTA_${ROI}.txt
fslstats ${RSConndir}/${sub}/RSConn_${sub}_drest-MeanAPPA_${ROI}_volume.nii -k ${logdir}/ROImasks/CombinedMasks/Combined_results_HC_KTP1_HbL_dense_subcortical_tfce_ztstat_fwep_c1_thr1.3_cerebellumVI_L.nii.gz -M  >> ${logfiledir}/cerebellumVI_${ROI}.txt
fslstats ${RSConndir}/${sub}/RSConn_${sub}_drest-MeanAPPA_${ROI}_volume.nii -k ${logdir}/ROImasks/CombinedMasks/Combined_results_HC_KTP1_HbR_dense_subcortical_tfce_ztstat_uncp_c2_thr2_hipp_R.nii.gz -M  >> ${logfiledir}/hippR_${ROI}.txt
fslstats ${RSConndir}/${sub}/RSConn_${sub}_drest-MeanAPPA_${ROI}_volume.nii -k ${logdir}/ROImasks/CombinedMasks/Combined_results_HC_KTP1_HbL_dense_tfce_ztstat_uncp_c1_thr2_thalamusVL.nii.gz -M  >> ${logfiledir}/thalamusVL_${ROI}.txt

done
done


 


