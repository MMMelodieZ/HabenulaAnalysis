#!/bin/bash
module load fsl/6.0.1
module load anaconda/2.7

#Habenula_fMRI_ROIs.sh --sub=subject_ID --segL=segmented_Hb_left.nii.gz --segR=segmented_Hb_right.nii.gz --func=example_functional.nii.gz --odir=output_directory [--warp=warpfield.nii.gz]


basepath=/nafs/narr/canderson/new_pipeline_test_runs/out/
subpaths=($(ls $basepath | grep ^[h]0019))


for i in ${subpaths[@]}; do
	echo ${i}
	./Habenula_fMRI_ROIs.sh --sub=$i --segL=/nafs/narr/sachang/sachang/habenula/outputs/hbseg_${i}_probability_L.nii.gz --segR=/nafs/narr/sachang/sachang/habenula/outputs/hbseg_${i}_probability_R.nii.gz --func=/nafs/narr/canderson/new_pipeline_test_runs/out/${i}/MNINonLinear/Results/rest_acq-PA_run-02/rest_acq-PA_run-02_SBRef.nii.gz --odir=/nafs/narr/sachang/sachang/habenula/outputs --warp=/nafs/narr/canderson/new_pipeline_test_runs/out/${i}/MNINonLinear/xfms/standard2acpc_dc.nii.gz


done
 
