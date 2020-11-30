#!/bin/bash
module load fsl/6.0.1

basepath=/nafs/narr/canderson/new_pipeline_test_runs/out/
#subpaths=($(ls $basepath | grep ^[eskh]0))
subpaths=($(ls $basepath | grep ^[esk]0.*3$))

#for b in ${subpaths[@]}; do
	#echo $b
	#fslmaths /nafs/narr/sachang/sachang/habenula/outputs/hbseg_${b}.nii.gz -thr 1.5 /nafs/narr/sachang/sachang/habenula/outputs/hbseg_${b}_L.nii.gz
	#fslmaths /nafs/narr/sachang/sachang/habenula/outputs/hbseg_${b}.nii.gz -uthr 1.5 /nafs/narr/sachang/sachang/habenula/outputs/hbseg_${b}_R.nii.gz
#done

for i in ${subpaths[@]}; do
	echo ${i} split L and R
	fslmaths /nafs/narr/sachang/sachang/habenula/outputs/1_habenula_segmentation/hbseg_${i}.nii.gz -thr 1.5 /nafs/narr/sachang/sachang/habenula/outputs/1_habenula_segmentation/hbseg_${i}_L.nii.gz
        fslmaths /nafs/narr/sachang/sachang/habenula/outputs/1_habenula_segmentation/hbseg_${i}.nii.gz -uthr 1.5 /nafs/narr/sachang/sachang/habenula/outputs/1_habenula_segmentation/hbseg_${i}_R.nii.gz
	
	echo ${i} dilate left
	fslmaths /nafs/narr/sachang/sachang/habenula/outputs/1_habenula_segmentation/hbseg_${i}_L.nii.gz -dilM -kernel 3D -bin /nafs/narr/sachang/sachang/habenula/outputs/dilateNativeSpace/hbseg_${i}_Ldil.nii.gz
	echo ${i} generate left probabilistic map
	fslmaths /nafs/narr/sachang/sachang/habenula/outputs/dilateNativeSpace/hbseg_${i}_Ldil.nii.gz -mul /nafs/narr/sachang/sachang/habenula/outputs/1_habenula_segmentation/hbseg_${i}_probability.nii.gz /nafs/narr/sachang/sachang/habenula/outputs/1_habenula_segmentation/hbseg_${i}_probability_L.nii.gz

 	echo ${i} dilate right
        fslmaths /nafs/narr/sachang/sachang/habenula/outputs/1_habenula_segmentation/hbseg_${i}_R.nii.gz -dilM -kernel 3D -bin /nafs/narr/sachang/sachang/habenula/outputs/dilateNativeSpace/hbseg_${i}_Rdil.nii.gz
        echo ${i} generate right probabilistic map
        fslmaths /nafs/narr/sachang/sachang/habenula/outputs/dilateNativeSpace/hbseg_${i}_Rdil.nii.gz -mul /nafs/narr/sachang/sachang/habenula/outputs/1_habenula_segmentation/hbseg_${i}_probability.nii.gz /nafs/narr/sachang/sachang/habenula/outputs/1_habenula_segmentation/hbseg_${i}_probability_R.nii.gz


done


