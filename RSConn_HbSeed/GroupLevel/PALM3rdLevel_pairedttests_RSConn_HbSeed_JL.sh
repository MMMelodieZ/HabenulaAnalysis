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



groupdir=${Habenuladir}/outputs/RSConn_HbSeed/GroupAnalysis/${g}/${ROI}
if [ ! -d ${groupdir} ]; then
mkdir ${groupdir}
fi
imgsdir=${Habenuladir}/outputs/RSConn_HbSeed/SubjectsDATA
subject_list=${groupdir}/../${g}_IDs.txt
subjects=$( cat ${subject_list} )

cluster_thr="2.3"
extension="dscalar.nii"
Fextension="dscalar"
niter="5000"

args=""

for sub in ${subjects}; do

	args="${args} -cifti 
	${imgsdir}/${sub}_${ROI}_MEANdenseConnectome.dscalar.nii -column 1"
	
	echo $sub
done 

cd ${groupdir}
echo "$args"
wb_command -cifti-merge Y.dscalar.nii ${args}



#Run Permutation test also with TFCE#################################################################################################
#1-Separate surface and volume of the cifti file######


wb_command -cifti-separate Y.dscalar.nii COLUMN -volume-all Y_subcortical.nii -label Y_subcortical_label.nii -roi Y_subcortical_roi.nii -metric CORTEX_LEFT Y_left.func.gii -roi left.shape.gii -metric CORTEX_RIGHT Y_right.func.gii -roi right.shape.gii

wb_command -gifti-convert BASE64_BINARY Y_left.func.gii Y_left.func.gii
wb_command -gifti-convert BASE64_BINARY Y_right.func.gii Y_right.func.gii
wb_command -gifti-convert BASE64_BINARY ${maindir}/jloureiro/AverageData/HC_n34/MNINonLinear/fsaverage_LR32k/HC_n34.L.midthickness.32k_fs_LR.surf.gii L_midthickness.surf.gii
wb_command -gifti-convert BASE64_BINARY ${maindir}/jloureiro/AverageData/HC_n34/MNINonLinear/fsaverage_LR32k/HC_n34.R.midthickness.32k_fs_LR.surf.gii R_midthickness.surf.gii



#2- Run PALM with TFCE For subcortical regions:#################

palm -i Y_subcortical.nii -n ${niter} -d ../design.mat -t ../design.con -corrcon -C ${cluster_thr} -Cstat "extent" -logp -accel tail -T -zstat -fdr -o results_dense_subcortical

#3- Run PALM with TFCE for cortical surfaces:#################
palm  -i Y_left.func.gii -i Y_right.func.gii -d ../design.mat -t ../design.con -o results_dense_cortical -n ${niter} -corrcon -corrmod -C ${cluster_thr} -Cstat "extent" -logp -accel tail -T -tfce2D -s L_midthickness.surf.gii -s R_midthickness.surf.gii -zstat -fdr

#View the results of the permutation test with TFCE.##############################################################
methodtype="tfce clustere"
corrtype="fwep fdrp uncp"
Get nr of contrasts#####
numCons="`cat ${workdir}/design.con | sed -n 's/.*NumContrasts//p'`"

for (( c=1; c <= ${numCons}; c++ ))
do

	wb_command -cifti-create-dense-scalar results_cifti_dat_ztstat_c${c}.${Fextension}.nii -volume results_dense_subcortical_vox_ztstat_c${c}.nii Y_subcortical_label.nii -left-metric results_dense_cortical_dpv_ztstat_m1_c${c}.gii -right-metric results_dense_cortical_dpv_ztstat_m2_c${c}.gii

	for method in ${methodtype}
	do
		wb_command -cifti-create-dense-scalar results_dense_${method}_ztstat_c${c}.${Fextension}.nii -volume results_dense_subcortical_${method}_ztstat_c${c}.nii Y_subcortical_label.nii -left-metric results_dense_cortical_${method}_ztstat_m1_c${c}.gii -right-metric results_dense_cortical_${method}_ztstat_m2_c${c}.gii

		for corr in ${corrtype}
		do
			if [ ${corr} = "uncp" ]
			then
 				wb_command -cifti-create-dense-scalar results_dense_${method}_ztstat_${corr}_c${c}.${Fextension}.nii -volume results_dense_subcortical_${method}_ztstat_${corr}_c${c}.nii Y_subcortical_label.nii -left-metric results_dense_cortical_${method}_ztstat_${corr}_m1_c${c}.gii -right-metric results_dense_cortical_${method}_ztstat_${corr}_m2_c${c}.gii

			else		

				wb_command -cifti-create-dense-scalar results_dense_${method}_ztstat_c${corr}_c${c}.${Fextension}.nii -volume results_dense_subcortical_${method}_ztstat_c${corr}_c${c}.nii Y_subcortical_label.nii -left-metric results_dense_cortical_${method}_ztstat_mc${corr}_m1_c${c}.gii -right-metric results_dense_cortical_${method}_ztstat_mc${corr}_m2_c${c}.gii
				wb_command -cifti-create-dense-scalar results_dense_${method}_ztstat_${corr}_c${c}.${Fextension}.nii -volume results_dense_subcortical_${method}_ztstat_${corr}_c${c}.nii Y_subcortical_label.nii -left-metric results_dense_cortical_${method}_ztstat_m${corr}_m1_c${c}.gii -right-metric results_dense_cortical_${method}_ztstat_m${corr}_m2_c${c}.gii
			fi

		done
	done
done

palm -i ${groupdir}/Y.dscalar.nii -d ../design.mat -t ../design.con -transposedata -o results_cifti -n ${niter} -corrcon -logp -accel tail -zstat -fdr



cd ${maindir}

