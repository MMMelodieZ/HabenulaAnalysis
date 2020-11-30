#!/bin/bash


module unload fsl
module load fsl/6.0.1
module load anaconda/2.7

export DATA_DIR='/nafs/narr/canderson/new_pipeline_test_runs/out'
export STUDY_DIR='/nafs/narr/HCP_OUTPUT/Habenula'
#export SUBJ="${SUB}"
export LOG_DIR='/nafs/narr/HCP_OUTPUT/Habenula/outputs/Segmentation/logs'
SCRIPT_DIR='/nafs/narr/HCP_OUTPUT/Habenula/code/Segmentation'

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
#SubList=$(<${maindir}/outputs/Segmentation/Sublist_Seg_20Aug2020.txt)
#SubList="k019901 k019903"
SubList=""
for SUBJ in ${SubList}; do
###################################################################
### 1. Automated Hb segmentation from T1w/T2w (Kim et al. 2018) ###
###################################################################

${RUN_PROF} "${SCRIPT_DIR}/1-habenula_batch_script_JL.sh" --StudyFolder="${STUDY_DIR}" --DataFolder="${DATA_DIR}" --Subjlist="${SUBJ}"
  echo "Automated Hb Segmentation for ${SUBJ} finished"
  ${SHOW_PROF}

done


SubListid=$(<${maindir}/outputs/Segmentation/Sublist_noTPs_AverageSeg_Aug2020_v2.txt)
#SubListid="k0199"

for SUBJid in ${SubListid}; do



################################################################################
### 2. Average Habenula Probability Maps across timepoints for each subject ###
################################################################################

${RUN_PROF} "${SCRIPT_DIR}/3-AverageTPs_HbprobSeg_JL.sh" --StudyFolder="${STUDY_DIR}" --DataFolder="${DATA_DIR}" --Subjlist="${SUBJid}"
  echo "AverageProb maps for ${SUBJid} finished"
  ${SHOW_PROF}

##########################################################################################
### 3. Shape optimization and downsample of Hb ROIs after averaging across timepoints ####
##########################################################################################
#This step is done to separate left and right hemisphere from Hb ROIs generated from previous step.the conversion of the lateralized maps from native to MNI and their dilation is just to ensure that all the voxels are kept when these dilated masks are multiplied with the final ROIs for lateralization purposes.

${RUN_PROF} "${SCRIPT_DIR}/4-FinalHbROIs_ShapeOptimize_afterTPsAverage_JL.sh" --StudyFolder="${STUDY_DIR}" --DataFolder="${DATA_DIR}" --Subjlist="${SUBJid}"
  echo "Create shape optimized after average for ${SUBJid} finished"
  ${SHOW_PROF}

done


