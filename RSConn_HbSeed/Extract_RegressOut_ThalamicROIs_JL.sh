#!/bin/bash


module unload fsl
module load fsl/6.0.1
module load anaconda/2.7
module load MATLAB


export DATA_DIR='/nafs/narr/canderson/new_pipeline_test_runs/out'
export STUDY_DIR='/nafs/narr/HCP_OUTPUT/Habenula'
SCRIPT_DIR='/nafs/narr/HCP_OUTPUT/Habenula/code/RSConn_HbSeed'
SUBJ='k000401'
PEDIR="AP"

if [ ${PEDIR} == "AP" ]; then
imgdir="${DATA_DIR}/${SUBJ}/MNINonLinear/Results/rest_acq-${PEDIR}_run-01"
img="${imgdir}/rest_acq-${PEDIR}_run-01_hp2000_clean.nii"
else
imgdir="${DATA_DIR}/${SUBJ}/MNINonLinear/Results/rest_acq-${PEDIR}_run-02"
img="${imgdir}/rest_acq-${PEDIR}_run-02_hp2000_clean.nii"
fi


ThmeanTSoutputdir="${STUDY_DIR}/outputs/RSConn_HbSeed/ROI_Timeseries/ThalamicROIs/${SUBJ}"
if [ ! -d ${ThmeanTSoutputdir} ]; then
mkdir ${ThmeanTSoutputdir}
fi

#Extracting timeseries for the centromedian (CM) and dorsomedial (DM) thalamic ROIs
for name in DM CM; do
for hemi in R L; do
fslmeants -i ${img} -o ${ThmeanTSoutputdir}/Th${name}_${hemi}_${SUBJ}_MeantTS.txt -m ${STUDY_DIR}/outputs/RSConn_HbSeed/ROI_Timeseries/ThalamicROIs/ThalamicROI_masks/Th${name}2mmsphere_${hemi}.nii.gz
done
done

#Create design.mat file with the timeseries of both thalamic ROIs
echo "/NumWaves 2" > ${ThmeanTSoutputdir}/design_header.mat
echo "/NumPoints 478" >> ${ThmeanTSoutputdir}/design_header.mat
echo "/Matrix" >> ${ThmeanTSoutputdir}/design_header.mat
for hemi in R L; do
paste ${ThmeanTSoutputdir}/ThDM_${hemi}_${SUBJ}_MeantTS.txt ${ThmeanTSoutputdir}/ThCM_${hemi}_${SUBJ}_MeantTS.txt | column -s $'\t' -t > ${ThmeanTSoutputdir}/ThCMDM_${hemi}_${SUBJ}_MeantTS.txt
cat ${ThmeanTSoutputdir}/design_header.mat ${ThmeanTSoutputdir}/ThCMDM_${hemi}_${SUBJ}_MeantTS.txt > ${ThmeanTSoutputdir}/design_with_nuisance_${hemi}_${SUBJ}.mat
done

#Regressing out Thalamic ROIs from Habenula timeseries

HbMeanTSdir="${STUDY_DIR}/outputs/RSConn_HbSeed/ROI_Timeseries/HbROIs/${SUBJ}"
for hemi in R L; do
fsl_glm -i ${HbMeanTSdir}/${SUBJ}_Hb${hemi}_ROItimeseries.txt -d ${ThmeanTSoutputdir}/design_with_nuisance_R_${SUBJ}.mat --demean --out_res=${HbMeanTSdir}/${SUBJ}_Hb${hemi}_ROItimeseries_ThROIsreg.txt
#convert txt file into CIFTI sdseries
wb_command -cifti-create-scalar-series ${HbMeanTSdir}/Hb${hemi}_${SUBJ}_ThROIsreg_MeanTS.txt ${HbMeanTSdir}/Hb${hemi}_${SUBJ}_ThROIsreg_MeanTS.sdseries.nii -transpose -series SECOND 0 0.8
done



