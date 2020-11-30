#!/bin/bash



maindir="/nafs/narr/jloureiro"
#GroupList="KTP2_KTP3"
#copeList="cope1 cope2 cope3 cope4 cope5 cope10"

#Replace with your file prefix
#input_prefix=results_dense_tfce_ztstat_uncp_c2
input_prefix=results_dense_neg_clustere_ztstat_c1
#INPUT_PREFIX=results_dense_tfce_ztstat_fwep_c1
#Replace with your input dscalar or dtseries data file
input=${input_prefix}.dscalar.nii
#INPUT_IFTI_FILE=${input_prefix}.dscalar.nii

#for cope in ${copeList}
#do

	#Replace with your input directory 
	file_dir=/nafs/narr/HCP_OUTPUT/Habenula/outputs/RSConn_HbSeed/GroupAnalysis/wSmoothing_wDenoising/KTP1_KTP3/HbL
	#CIFTI_FILE_DIR=/nafs/narr/asahib/Task_fmri/CARIT/KTP1_KTP3/cope6
    	echo "sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=500G --time=7-00:00:00 --qos=largemem \
--job-name=N5000_${g} --output=/nafs/narr/jloureiro/projects/paper2/CreateCerebellumSurface/KTP1_KTP2_${cope}_tfce_fwep_c1.log --export INPUT_CIFTI_FILE=${g} /nafs/narr/jloureiro/scripts/fMRI/PALMAnalysis/paper_FM/PALM3rdLevel_TFCE_JL_4slurm_wFIX_MDDchange_groupChange.sh"

	
	sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=30G --time=02:00:00 \
--job-name=Cmap --output=/nafs/narr/HCP_OUTPUT/Habenula/outputs/RSConn_HbSeed/GroupAnalysis/wSmoothing_wDenoising/logs/map_cerebellarsurface.log --export=INPUT_CIFTI_FILE=${input},INPUT_PREFIX=${input_prefix},CIFTI_FILE_DIR=${file_dir} /nafs/narr/HCP_OUTPUT/Habenula/code/RSConn_HbSeed/GroupLevel/map_cifti-to-cerebellar-surface_sept2017_JL_v4.sh

	
#done
