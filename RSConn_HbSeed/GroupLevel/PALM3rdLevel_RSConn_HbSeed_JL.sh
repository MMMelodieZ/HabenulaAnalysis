#!/bin/bash

module unload fsl
module load fsl/6.0.1
module unload workbench
module load workbench/1.3.2
module unload MATLAB
module load MATLAB/R2017a
module load PALM

GROUP="KTP1_KTP2"
maindir="/nafs/narr/HCP_OUTPUT/Habenula"
RSMaps_DIR="${maindir}/outputs/RSConn_HbSeed/SubjectsDATA"
GroupDATA_DIR="${maindir}/outputs/RSConn_HbSeed/GroupAnalysis/${GROUP}"
Subjlist=$(<${GroupDATA_DIR}/${GROUP}_IDs.txt)

mainoutputdir="${maindir}/GroupDATA"


cluster_thr="2.3"



extension="dscalar.nii"
Fextension="dscalar"
niter="5000"
Y="MEANdenseConnectome_L_shape_optimized_Hb_ROI_merge_clinical"

source ${EnvironmentScript}

workdir="${mainoutputdir}"
#mkdir ${workdir}
#cp ${mainoutputdir}/${group}/design* ${workdir}/
#cp ${mainoutputdir}/${group}/${group}IDs.txt ${workdir}/
cd ${workdir}
echo "${workdir}"
#subjlist=$(<${group}IDs.txt)
#echo "SubjectList: ${subjlist}"


#args=""
#Merge all subjects data#####################################################################################################################
#for subj in ${subjlist}
#do
	#args="${args} -cifti
	#${hcpdir}/${subj}/MNINonLinear/Results/task-carit_acq-PA_run-01/task-carit_acq-PA_run-01_JL_clean_hp200_s5_level1.feat/GrayordinatesStats/${COPE}.dtseries.nii -column 1"
#done


#/usr/local/workbench-1.2.3/bin_rh_linux64/


#Run the Permutation test##################################################################################################
#outputdir="${workdir}/${COPE}"
#mkdir ${outputdir}
#cd ${outputdir}
#echo "$args"
#wb_command -cifti-merge Y.${extension} ${args}
palm -i ${Y}.${extension} -transposedata -o results_cifti -n ${niter} -corrcon -logp -accel tail -zstat -fdr
#palm -i Y.${extension} -transposedata -d design.mat -t design.con -o results_cifti -n ${niter} -corrcon -logp -accel tail -zstat -fdr

#results_cifti_dat_tstat_d?_c?.dscalar.nii: Contains the Student’s t-statistic for each design (‘d?’) and contrast (‘c?’), computed grayordinate-wise.
#results_cifti_dat_tstat_fwep_d?_c?.dscalar.nii: Contains the p-values Family-Wise Error Rate (FWER)-corrected across the 91282 grayordinates.
#results_cifti_dat_tstat_cfwep_d?_c?.dscalar.nii: Contains the p-values FWER-corrected across the 91282 grayordinates and all contrasts from all designs.

#Run Permutation test also with TFCE#################################################################################################
#1-Separate surface and volume of the cifti file######


#wb_command -cifti-separate dtseries.nii COLUMN -volume-all Y_subcortical.nii -label Y_subcortical_label.nii -roi Y_subcortical_roi.nii -metric CORTEX_LEFT Y_left.func.gii -roi left.shape.gii -metric CORTEX_RIGHT Y_right.func.gii -roi right.shape.gii
#wb_command -gifti-convert BASE64_BINARY Y_left.func.gii Y_left.func.gii
#wb_command -gifti-convert BASE64_BINARY Y_right.func.gii Y_right.func.gii
#wb_command -gifti-convert BASE64_BINARY ${maindir_jl}/AverageData/HC_n34/MNINonLinear/fsaverage_LR32k/HC_n34.L.midthickness.32k_fs_LR.surf.gii L_midthickness.surf.gii
#wb_command -gifti-convert BASE64_BINARY ${maindir_jl}/AverageData/HC_n34/MNINonLinear/fsaverage_LR32k/HC_n34.R.midthickness.32k_fs_LR.surf.gii R_midthickness.surf.gii
#2- Run PALM with TFCE For subcortical regions:#################

#palm -i Y_subcortical.nii -d design.mat -t design.con -o results_dense_subcortical -n ${niter} -corrcon -C ${cluster_thr} -Cstat "extent" -logp -accel tail -T -zstat -fdr
#3- Run PALM with TFCE for cortical surfaces:#################
#palm  -i Y_left.func.gii -i Y_right.func.gii -d design.mat -t design.con -o results_dense_cortical -n ${niter} -corrcon -corrmod -C ${cluster_thr} -Cstat "extent" -logp -accel tail -T -tfce2D -s L_midthickness.surf.gii -s R_midthickness.surf.gii -zstat -fdr


#View the results of the permutation test with TFCE.##############################################################
#methodtype="tfce clustere"
#corrtype="fwep fdrp uncp"
#Get nr of contrasts#####
#numCons="`cat ${workdir}/design.con | sed -n 's/.*NumContrasts//p'`"

#for (( c=1; c <= ${numCons}; c++ ))
#do

#	wb_command -cifti-create-dense-scalar results_cifti_dat_ztstat_c${c}.${Fextension}.nii -volume results_dense_subcortical_vox_ztstat_c${c}.nii Y_subcortical_label.nii -left-metric results_dense_cortical_dpv_ztstat_m1_c${c}.gii -right-metric results_dense_cortical_dpv_ztstat_m2_c${c}.gii

#	for method in ${methodtype}
#	do
#		wb_command -cifti-create-dense-scalar results_dense_${method}_ztstat_c${c}.${Fextension}.nii -volume results_dense_subcortical_${method}_ztstat_c${c}.nii Y_subcortical_label.nii -left-metric results_dense_cortical_${method}_ztstat_m1_c${c}.gii -right-metric results_dense_cortical_${method}_ztstat_m2_c${c}.gii

#		for corr in ${corrtype}
#		do
#			if [ ${corr} = "uncp" ]
#			then
# 			wb_command -cifti-create-dense-scalar results_dense_${method}_ztstat_${corr}_c${c}.${Fextension}.nii -volume results_dense_subcortical_${method}_ztstat_${corr}_c${c}.nii Y_subcortical_label.nii -left-metric results_dense_cortical_${method}_ztstat_${corr}_m1_c${c}.gii -right-metric results_dense_cortical_${method}_ztstat_${corr}_m2_c${c}.gii
#			else
#				wb_command -cifti-create-dense-scalar results_dense_${method}_ztstat_c${corr}_c${c}.${Fextension}.nii -volume results_dense_subcortical_${method}_ztstat_c${corr}_c${c}.nii Y_subcortical_label.nii -left-metric results_dense_cortical_${method}_ztstat_mc${corr}_m1_c${c}.gii -right-metric results_dense_cortical_${method}_ztstat_mc${corr}_m2_c${c}.gii
#				wb_command -cifti-create-dense-scalar results_dense_${method}_ztstat_${corr}_c${c}.${Fextension}.nii -volume results_dense_subcortical_${method}_ztstat_${corr}_c${c}.nii Y_subcortical_label.nii -left-metric results_dense_cortical_${method}_ztstat_m${corr}_m1_c${c}.gii -right-metric results_dense_cortical_${method}_ztstat_m${corr}_m2_c${c}.gii
#			fi

#		done
#	done

#done

#cd ${maindir}
