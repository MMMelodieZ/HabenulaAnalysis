if [[ ${HCPPIPEDEBUG} == "true" ]]; then
  set -x
fi


#############################################################################

get_batch_options() {
  local arguments=("$@")

  unset command_line_specified_study_folder
  unset command_line_specified_subj
  unset command_line_specified_run_local

  local index=0
  local numArgs=${#arguments[@]}
  local argument

  while [ ${index} -lt ${numArgs} ]; do
    argument=${arguments[index]}

    case ${argument} in
      --StudyFolder=*)
        STUDY_DIR=${argument#*=}
        index=$(( index + 1 ))
        ;;
      --DataFolder=*)
	DATA_DIR=${argument#*=}
	index=$(( index + 1 ))
	;;
      --Subjlist=*)
        SUBJ=${argument#*=}
        index=$(( index + 1 ))
        ;;
      --runlocal)
        command_line_specified_run_local="TRUE"
        index=$(( index + 1 ))
        ;;
      *)
        echo ""
        echo "ERROR: Unrecognized Option: ${argument}"
        echo ""
        exit 1
        ;;
    esac
  done
}

#################################################

# Function: main
# Description: main processing work of this script
main()
{
	get_batch_options "$@"


cd /nafs/narr/HCP_OUTPUT/Habenula/outputs/Segmentation/2_FinalHbROIs_ShapeOptimized

outputdir="${STUDY_DIR}/outputs/Segmentation/3_AverageTPs_HbprobSeg/${SUBJ}"
if [ ! -d ${outputdir} ]; then
mkdir ${outputdir}
fi

ls -d -1 ${SUBJ}* > ${STUDY_DIR}/outputs/Segmentation/tmp.txt

sublistfile="${STUDY_DIR}/outputs/Segmentation/tmp.txt"
SubIDtmp=$(<${sublistfile})

if [[ $(wc -l <${sublistfile}) -ge 2 ]]; then
echo "${SUBJ} has more than one timepoint"
args=""
for s2 in ${SubIDtmp}; do
args="${args} ${STUDY_DIR}/outputs/Segmentation/2_FinalHbROIs_ShapeOptimized/${s2}/${s2}_bilat_Hb_region_full_prob.nii.gz"
#echo "${sub} ${roi}"
echo "${s2}"
done

fslmerge -t ${outputdir}/${SUBJ}_bilat_Hb_region_full_prob_ALLTPsMerged.nii.gz ${args}
fslmaths ${outputdir}/${SUBJ}_bilat_Hb_region_full_prob_ALLTPsMerged.nii.gz -Tmean ${outputdir}/${SUBJ}_bilat_Hb_region_full_prob_ALLTPsAveraged.nii.gz
fslmaths ${outputdir}/${SUBJ}_bilat_Hb_region_full_prob_ALLTPsAveraged.nii.gz -thr 0.25 -bin ${outputdir}/${SUBJ}_bilat_shape_optimized_Hb_ROI_ALLTPsAveraged.nii.gz

	
	echo "${SUBJ} generate left probabilistic map"
	fslmaths ${STUDY_DIR}/code/Segmentation/habenula_template/habenula_template_HCP_50_native_thr0bin_left_2mminterp.nii.gz -mul ${outputdir}/${SUBJ}_bilat_shape_optimized_Hb_ROI_ALLTPsAveraged.nii.gz ${outputdir}/${SUBJ}_L_shape_optimized_Hb_ROI_ALLTPsAveraged.nii.gz

 
        echo "${SUBJ} generate left probabilistic map"
	fslmaths ${STUDY_DIR}/code/Segmentation/habenula_template/habenula_template_HCP_50_native_thr0bin_right_2mminterp.nii.gz -mul ${outputdir}/${SUBJ}_bilat_shape_optimized_Hb_ROI_ALLTPsAveraged.nii.gz ${outputdir}/${SUBJ}_R_shape_optimized_Hb_ROI_ALLTPsAveraged.nii.gz

else

echo "${SUBJ} only has one TP"
for s2 in ${SubIDtmp}; do

cp ${STUDY_DIR}/outputs/Segmentation/2_FinalHbROIs_ShapeOptimized/${s2}/${s2}_bilat_Hb_region_full_prob.nii.gz ${outputdir}/${SUBJ}_bilat_Hb_region_full_prob_ALLTPsAveraged.nii.gz

cp ${STUDY_DIR}/outputs/Segmentation/2_FinalHbROIs_ShapeOptimized/${s2}/${s2}_R_shape_optimized_Hb_ROI.nii.gz ${outputdir}/${SUBJ}_R_shape_optimized_Hb_ROI_ALLTPsAveraged.nii.gz

cp ${STUDY_DIR}/outputs/Segmentation/2_FinalHbROIs_ShapeOptimized/${s2}/${s2}_L_shape_optimized_Hb_ROI.nii.gz ${outputdir}/${SUBJ}_L_shape_optimized_Hb_ROI_ALLTPsAveraged.nii.gz

done





fi





}

main "$@"

ret=$?; times; exit "${ret}"






