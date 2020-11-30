#!/bin/bash

maindir=/nafs/narr
Habenuladir=${maindir}/HCP_OUTPUT/Habenula
#export g=${GROUP}

module unload fsl
module load fsl/6.0.0
module unload workbench
module load workbench/1.3.2
module unload MATLAB
module load MATLAB/R2017a
module load PALM
module load freesurfer/6.0.1 


ROIList="HbL HbR"

#ROIList="HbL"

GroupList="KTP1_KTP3 KTP2_KTP3 KTP1_KTP4 KTP2_KTP4"
#GroupList="KTP1_KTP2"
SubtractionDirection="pos neg"

#SubtractionDirection="pos"


cluster_thr="2.3"
extension="dscalar.nii"
Fextension="dscalar"
niter="5000"

for g in ${GroupList}
do

for ROI in ${ROIList}
do	
imgsdir=${Habenuladir}/outputs/RSConn_HbSeed/GroupAnalysis/SubtractedImages/${g}
groupdir=${Habenuladir}/outputs/RSConn_HbSeed/GroupAnalysis/${g}/${ROI}
subject_list=${groupdir}/../${g}_IDs.txt
subjects=$( cat ${subject_list} )



cd ${groupdir}

for DIR in ${SubtractionDirection}; do

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
if [ ${corr} == "uncp" ]
then
wb_command -cifti-create-dense-scalar results_dense_${DIR}_${method}_ztstat_${corr}_c${c}.${Fextension}.nii -volume results_dense_${DIR}_subcortical_${method}_ztstat_${corr}_c${c}.nii Y_${DIR}_subcortical_label.nii -left-metric results_dense_${DIR}_cortical_${method}_ztstat_${corr}_m1_c${c}.gii -right-metric results_dense_${DIR}_cortical_${method}_ztstat_${corr}_m2_c${c}.gii
else		
wb_command -cifti-create-dense-scalar results_dense_${DIR}_${method}_ztstat_c${corr}_c${c}.${Fextension}.nii -volume results_dense_${DIR}_subcortical_${method}_ztstat_c${corr}_c${c}.nii Y_${DIR}_subcortical_label.nii -left-metric results_dense_${DIR}_cortical_${method}_ztstat_mc${corr}_m1_c${c}.gii -right-metric results_dense_${DIR}_cortical_${method}_ztstat_mc${corr}_m2_c${c}.gii
wb_command -cifti-create-dense-scalar results_dense_${DIR}_${method}_ztstat_${corr}_c${c}.${Fextension}.nii -volume results_dense_${DIR}_subcortical_${method}_ztstat_${corr}_c${c}.nii Y_${DIR}_subcortical_label.nii -left-metric results_dense_${DIR}_cortical_${method}_ztstat_m${corr}_m1_c${c}.gii -right-metric results_dense_${DIR}_cortical_${method}_ztstat_m${corr}_m2_c${c}.gii
fi
done
done
done
done
done
done
