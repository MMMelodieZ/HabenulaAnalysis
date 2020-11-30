#!/bin/bash

maindir=/nafs/narr
Habenuladir=${maindir}/HCP_OUTPUT/Habenula
export g=${GROUP}

module unload fsl
module load fsl/6.0.0
module unload workbench
module load workbench
module unload MATLAB
module load MATLAB/R2017a
module load PALM
module load freesurfer/6.0.1 




imgsdir=${Habenuladir}/outputs/RSConn_HbSeed/GroupAnalysis/wSmoothing_wDenoising/SubtractedImages/KTP1_KTP3
groupdir=${Habenuladir}/outputs/RSConn_HbSeed/GroupAnalysis/wSmoothing_wDenoising/${g}/${ROI}

if [ ! -d ${groupdir} ]; then
mkdir ${groupdir}
fi

rm ${Habenuladir}/outputs/RSConn_HbSeed/GroupAnalysis/wSmoothing_wDenoising/${g}/${ROI}/*


subject_list=${groupdir}/../${g}_IDs.txt
subjects=$( cat ${subject_list} )

cluster_thr="2.3"
extension="dscalar.nii"
Fextension="dscalar"
niter="5000"

#if [ ! -f "${groupdir}/Y_${DIR}.dscalar.nii" ] 
#then

args=""

if [ ${DIR} == "pos" ]; then
#if [ ${g} == "RemchangeTP3_NonRemchangeTP3" ]; then
TP1="01"; TP2="03"	

for sub in ${subjects}; do
args="${args} -cifti 
${imgsdir}/RSConn_${sub}_TP${TP1}-TP${TP2}_drest-MeanAPPA_${ROI}.dscalar.nii -column 1"
done

elif [ ${DIR} == "neg" ]; then
#if [ ${g} == "RemchangeTP3_NonRemchangeTP3" ]; then
TP1="03"; TP2="01"
	
for sub in ${subjects}; do
args="${args} -cifti 
${imgsdir}/RSConn_${sub}_TP${TP2}-TP${TP1}_drest-MeanAPPA_${ROI}.dscalar.nii -column 1"
done
fi




cd ${groupdir}
echo "$args"
wb_command -cifti-merge Y_${DIR}.dscalar.nii ${args}

#fi
palm -i Y_${DIR}.${extension} -transposedata -d ../design.mat -t ../design.con -o results_cifti -n ${niter} -corrcon -logp -accel tail -zstat -fdr 
#Run Permutation test also with TFCE#################################################################################################
#1-Separate surface and volume of the cifti file######

cd ${groupdir}
wb_command -cifti-separate Y_${DIR}.dscalar.nii COLUMN -volume-all Y_${DIR}_subcortical.nii -label Y_${DIR}_subcortical_label.nii -roi Y_${DIR}_subcortical_roi.nii -metric CORTEX_LEFT Y_${DIR}_left.func.gii -roi left.shape.gii -metric CORTEX_RIGHT Y_${DIR}_right.func.gii -roi right.shape.gii

wb_command -gifti-convert BASE64_BINARY Y_${DIR}_left.func.gii Y_${DIR}_left.func.gii
wb_command -gifti-convert BASE64_BINARY Y_${DIR}_right.func.gii Y_${DIR}_right.func.gii
wb_command -gifti-convert BASE64_BINARY ${maindir}/jloureiro/AverageData/HC_n34/MNINonLinear/fsaverage_LR32k/HC_n34.L.midthickness.32k_fs_LR.surf.gii L_midthickness.surf.gii
wb_command -gifti-convert BASE64_BINARY ${maindir}/jloureiro/AverageData/HC_n34/MNINonLinear/fsaverage_LR32k/HC_n34.R.midthickness.32k_fs_LR.surf.gii R_midthickness.surf.gii



#2- Run PALM with TFCE For subcortical regions:#################

palm -i Y_${DIR}_subcortical.nii -n ${niter} -corrcon -C ${cluster_thr} -Cstat "extent" -logp -accel tail -T -zstat -fdr -ise -o results_dense_${DIR}_subcortical

#3- Run PALM with TFCE for cortical surfaces:#################
palm  -i Y_${DIR}_left.func.gii -i Y_${DIR}_right.func.gii -o results_dense_${DIR}_cortical -n ${niter} -corrcon -corrmod -C ${cluster_thr} -Cstat "extent" -logp -accel tail -T -tfce2D -s L_midthickness.surf.gii -s R_midthickness.surf.gii -zstat -fdr

#View the results of the permutation test with TFCE.##############################################################
methodtype="tfce clustere"
corrtype="fwep fdrp uncp"
#Get nr of contrasts#####
#numCons="`cat ${workdir}/design.con | sed -n 's/.*NumContrasts//p'`"
numCons=2

for (( c=1; c <= ${numCons}; c++ ))
do
wb_command -cifti-create-dense-scalar results_cifti_dat_${DIR}_ztstat_c${c}.${Fextension}.nii -volume results_dense_${DIR}_subcortical_vox_ztstat_c${c}.nii Y_${DIR}_subcortical_label.nii -left-metric results_dense_${DIR}_cortical_dpv_ztstat_m1_c${c}.gii -right-metric results_dense_${DIR}_cortical_dpv_ztstat_m2_c${c}.gii
for method in ${methodtype}
do
wb_command -cifti-create-dense-scalar results_dense_${DIR}_${method}_ztstat_c${c}.${Fextension}.nii -volume results_dense_${DIR}_subcortical_${method}_ztstat_c${c}.nii Y_${DIR}_subcortical_label.nii -left-metric results_dense_${DIR}_cortical_${method}_ztstat_m1_c${c}.gii -right-metric results_dense_${DIR}_cortical_${method}_ztstat_m2_c${c}.gii
for corr in ${corrtype}
do
if [ ${corr} = "uncp" ]
then
wb_command -cifti-create-dense-scalar results_dense_${DIR}_${method}_ztstat_${corr}_c${c}.${Fextension}.nii -volume results_dense_${DIR}_subcortical_${method}_ztstat_${corr}_c${c}.nii Y_${DIR}_subcortical_label.nii -left-metric results_dense_${DIR}_cortical_${method}_ztstat_${corr}_m1_c${c}.gii -right-metric results_dense_${DIR}_cortical_${method}_ztstat_${corr}_m2_c${c}.gii
else		
wb_command -cifti-create-dense-scalar results_dense_${DIR}_${method}_ztstat_c${corr}_c${c}.${Fextension}.nii -volume results_dense_${DIR}_subcortical_${method}_ztstat_c${corr}_c${c}.nii Y_${DIR}_subcortical_label.nii -left-metric results_dense_${DIR}_cortical_${method}_ztstat_mc${corr}_m1_c${c}.gii -right-metric results_dense_${DIR}_cortical_${method}_ztstat_mc${corr}_m2_c${c}.gii
wb_command -cifti-create-dense-scalar results_dense_${DIR}_${method}_ztstat_${corr}_c${c}.${Fextension}.nii -volume results_dense_${DIR}_subcortical_${method}_ztstat_${corr}_c${c}.nii Y_${DIR}_subcortical_label.nii -left-metric results_dense_${DIR}_cortical_${method}_ztstat_m${corr}_m1_c${c}.gii -right-metric results_dense_${DIR}_cortical_${method}_ztstat_m${corr}_m2_c${c}.gii
fi
done
done
done

palm -i ${groupdir}/Y_${DIR}.dscalar.nii -transposedata -o results_cifti -n ${niter} -corrcon -logp -accel tail -zstat -fdr



cd ${maindir}

