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


	#Habenula_fMRI_ROIs.sh --sub=subject_ID --segL=segmented_Hb_left.nii.gz --segR=segmented_Hb_right.nii.gz --func=example_functional.nii.gz --odir=output_directory [--warp=warpfield.nii.gz]

	${STUDY_DIR}/code/Segmentation/Habenula_fMRI_ROIs/Habenula_fMRI_ROIs.sh --sub=${SUBJ} --segL=${STUDY_DIR}/outputs/Segmentation/1_habenula_segmentation/hbseg_${SUBJ}_probability_L.nii.gz --segR=${STUDY_DIR}/outputs/Segmentation/1_habenula_segmentation/hbseg_${SUBJ}_probability_R.nii.gz --func=${DATA_DIR}/${SUBJ}/MNINonLinear/Results/rest_acq-PA_run-02/rest_acq-PA_run-02_SBRef.nii.gz --odir=${STUDY_DIR}/outputs/Segmentation/2_FinalHbROIs_ShapeOptimized --warp=${DATA_DIR}/${SUBJ}/MNINonLinear/xfms/standard2acpc_dc.nii.gz

	#Now separate final ROIs into right and left:

	echo "generate $SUBJ L Hb ROI"
	flirt -in ${STUDY_DIR}/outputs/Segmentation/1_habenula_segmentation/dilateNativeSpace/hbseg_${SUBJ}_Ldil.nii.gz -ref /nafs/apps/fsl/64/6.0.0/data/standard/MNI152_T1_2mm.nii.gz -applyxfm -usesqform -interp nearestneighbour -out ${STUDY_DIR}/outputs/Segmentation/1_habenula_segmentation/dilateMNI/${SUBJ}_shape_optimized_Ldil.nii.gz
	
	fslmaths ${STUDY_DIR}/outputs/Segmentation/1_habenula_segmentation/dilateMNI/${SUBJ}_shape_optimized_Ldil.nii.gz -dilM -kernel 3D -bin ${STUDY_DIR}/outputs/Segmentation/1_habenula_segmentation/dilateMNI/${SUBJ}_shape_optimized_Ldil2.nii.gz

	fslmaths ${STUDY_DIR}/outputs/Segmentation/1_habenula_segmentation/dilateMNI/${SUBJ}_shape_optimized_Ldil2.nii.gz -mul ${STUDY_DIR}/outputs/Segmentation/2_FinalHbROIs_ShapeOptimized/${SUBJ}_bilat_shape_optimized_Hb_ROI.nii.gz ${STUDY_DIR}/outputs/Segmentation/2_FinalHbROIs_ShapeOptimized/${SUBJ}_L_shape_optimized_Hb_ROI.nii.gz


	echo "generate $SUBJ R Hb ROI"
	 flirt -in ${STUDY_DIR}/outputs/Segmentation/1_habenula_segmentation/dilateNativeSpace/hbseg_${SUBJ}_Rdil.nii.gz -ref /nafs/apps/fsl/64/6.0.0/data/standard/MNI152_T1_2mm.nii.gz -applyxfm -usesqform -interp nearestneighbour -out ${STUDY_DIR}/outputs/Segmentation/1_habenula_segmentation/dilateMNI/${SUBJ}_shape_optimized_Rdil.nii.gz

	fslmaths ${STUDY_DIR}/outputs/Segmentation/1_habenula_segmentation/dilateMNI/${SUBJ}_shape_optimized_Rdil.nii.gz -dilM -kernel 3D -bin ${STUDY_DIR}/outputs/Segmentation/1_habenula_segmentation/dilateMNI/${SUBJ}_shape_optimized_Rdil2.nii.gz

        fslmaths ${STUDY_DIR}/outputs/Segmentation/1_habenula_segmentation/dilateMNI/${SUBJ}_shape_optimized_Rdil2.nii.gz -mul ${STUDY_DIR}/outputs/Segmentation/2_FinalHbROIs_ShapeOptimized/${SUBJ}_bilat_shape_optimized_Hb_ROI.nii.gz ${STUDY_DIR}/outputs/Segmentation/2_FinalHbROIs_ShapeOptimized/${SUBJ}_R_shape_optimized_Hb_ROI.nii.gz

}

# Invoke the main function to get things started
main "$@"

ret=$?; times; exit "${ret}"

