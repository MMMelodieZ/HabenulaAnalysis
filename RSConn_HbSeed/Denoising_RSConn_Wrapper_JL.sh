#!/bin/bash


module unload fsl
module load fsl/6.0.1
module load anaconda/2.7
module unload workbench
module load workbench 1.3.2
module load MATLAB/R2017a

export DATA_DIR='/nafs/narr/canderson/new_pipeline_test_runs/out'
export STUDY_DIR='/nafs/narr/HCP_OUTPUT/Habenula'
#export SUBJ="${SUB}"
SUBJ="k000401"
export LOG_DIR='/nafs/narr/HCP_OUTPUT/Habenula/outputs/Segmentation/logs'
SCRIPT_DIR='/nafs/narr/HCP_OUTPUT/Habenula/code/RSConn_HbSeed'

#################################################################################
## DEBUGGING
##   - 'HCPPIPEDEBUG=true 0-processData.sh $ARG1 $ARG2 ...' for verbose output
##   - 'HCPPIPEDEBUG=true USE_VALGRIND=true 0-processData.sh $ARG1 $ARG2 ...' for
##       verbose output and memory profiling
#################################################################################
HCPPIPEDEBUG="${HCPPIPEDEBUG:-'false'}"
USE_VALGRIND="${USE_VALGRIND:-'false'}"
RUN_PROF=""
SHOW_PROF=""

if [[ ${HCPPIPEDEBUG} == "true" ]]; then
  set -x
  export HCPPIPEDEBUG
  if [[ ${USE_VALGRIND} == "true" ]]; then 
    RUN_PROF="valgrind --tool=massif --pages-as-heap=yes"
    SHOW_PROF="echo -n Peak memory use: "; "grep mem_heap_B $(ls -t "${LOG_DIR}/massif.out.*" | head -n1) | sed -e 's/mem_heap_B=\(.*\)/\1/' | sort -g | tail -n 1"
  fi
fi

# exit on any error
set -Eeuo pipefail

pushd "${LOG_DIR}"

maindir="/nafs/narr/HCP_OUTPUT/Habenula"

#####################################################################################
### 1. Denoise data with COMPCOR and BP filtering using CONN Toolbox ################
#####################################################################################

${RUN_PROF} "${SCRIPT_DIR}/Denoising_CONN/Denoising_CONNToolbox_JL.sh" --Subjlist="${SUBJ}"
  echo "Denoising using CONN toolbox for ${SUBJ} finished"
  ${SHOW_PROF}

#####################################################################################
### 2. Convert denoised volume DATA into CIFTI format ###############################
#####################################################################################
#This step is done to separate left and right hemisphere from Hb ROIs generated from previous step.the conversion of the lateralized maps from native to MNI and their dilation is just to ensure that all the voxels are kept when these dilated masks are multiplied with the final ROIs for lateralization purposes.

${RUN_PROF} "${SCRIPT_DIR}/Convert_Volume2CIFTI_JL.sh" --DataFolder="${DATA_DIR}" --Subjlist="${SUBJ}"
  echo "Convertion of volume to CIFTI format for ${SUBJ} finished"
  ${SHOW_PROF}

#######################################################################################
### 3. Smooth CIFTI DATA ##############################################################
#######################################################################################
#This step is done to separate left and right hemisphere from Hb ROIs generated from previous step.the conversion of the lateralized maps from native to MNI and their dilation is just to ensure that all the voxels are kept when these dilated masks are multiplied with the final ROIs for lateralization purposes.

${RUN_PROF} "${SCRIPT_DIR}/Smooth_RSConnMaps_JL.sh" --StudyFolder="${STUDY_DIR}" --DataFolder="${DATA_DIR}" --Subjlist="${SUBJ}"
  echo "Convertion of volume to CIFTI format for ${SUBJ} finished"
  ${SHOW_PROF}

########################################################################################
### 4. Extract time-series from volume data for the habenula ###########################
########################################################################################
#This step is done to separate left and right hemisphere from Hb ROIs generated from previous step.the conversion of the lateralized maps from native to MNI and their dilation is just to ensure that all the voxels are kept when these dilated masks are multiplied with the final ROIs for lateralization purposes.

${RUN_PROF} "${SCRIPT_DIR}/Extract_HbTimeseries_JL.sh" --StudyFolder="${STUDY_DIR}" --DataFolder="${DATA_DIR}" --Subjlist="${SUBJ}"
  echo "Convertion of volume to CIFTI format for ${SUBJ} finished"
  ${SHOW_PROF}

#########################################################################################
### 5. Regress-out 2 thalamic ROIs from extract time-series #############################
#########################################################################################
#This step is done to separate left and right hemisphere from Hb ROIs generated from previous step.the conversion of the lateralized maps from native to MNI and their dilation is just to ensure that all the voxels are kept when these dilated masks are multiplied with the final ROIs for lateralization purposes.

${RUN_PROF} "${SCRIPT_DIR}/Extract_ResgressOut_ThalamicROIs_JL.sh" --StudyFolder="${STUDY_DIR}" --DataFolder="${DATA_DIR}" --Subjlist="${SUBJ}"
  echo "Convertion of volume to CIFTI format for ${SUBJ} finished"
  ${SHOW_PROF}


#########################################################################################
### 6. Generate RS Connectivity Maps for each subject using the generated time-series and average acrosse pedirs ###
#########################################################################################
#This step is done to separate left and right hemisphere from Hb ROIs generated from previous step.the conversion of the lateralized maps from native to MNI and their dilation is just to ensure that all the voxels are kept when these dilated masks are multiplied with the final ROIs for lateralization purposes.

${RUN_PROF} "${SCRIPT_DIR}/RSConn_HbSeed_volROIs_JL.sh" --DataFolder="${DATA_DIR}" --Subjlist="${SUBJ}" 
  echo "Convertion of volume to CIFTI format for ${SUBJ} finished"
  ${SHOW_PROF}





