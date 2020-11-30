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
	
	if [ -f ${DATA_DIR}/${SUBJ}/T1w/T1wDividedByT2w_habenula_centers_from_template.nii.gz ]; then
		echo y|rm ${DATA_DIR}/${SUBJ}/T1w/T1wDividedByT2w_habenula_centers_from_template.nii.gz
	fi
	outputdir=${STUDY_DIR}/outputs/Segmentation/1_habenula_segmentation/${SUBJ}
	if [ ! -d ${outputdir} ]; then
	mkdir ${outputdir}
	fi
	
	${STUDY_DIR}/code/Segmentation/src/seg_hb.py -1 ${DATA_DIR}/${SUBJ}/T1w/T1w_acpc_dc.nii.gz -2 ${DATA_DIR}/${SUBJ}/T2w/T2w_acpc.nii.gz -w ${DATA_DIR}/${SUBJ}/MNINonLinear/xfms/standard2acpc_dc.nii.gz -m ${DATA_DIR}/${SUBJ}/T1w/T1wDividedByT2w.nii.gz -o ${outputdir}/hbseg_${SUBJ}.nii.gz


	echo "split bilateral habenula mask to left and right" >> ${STUDY_DIR}/outputs/Segmentation/logs/habenula_coreg.log
	fslmaths ${outputdir}/hbseg_${SUBJ}.nii.gz -uthr 1.5 ${outputdir}/hbseg_${SUBJ}_R.nii.gz
	fslmaths ${outputdir}/hbseg_${SUBJ}.nii.gz -thr 1.5 ${outputdir}/hbseg_${SUBJ}_L.nii.gz

	echo "${SUBJ} dilate lef"
	fslmaths ${outputdir}/hbseg_${SUBJ}_L.nii.gz -dilM -kernel 3D -bin ${STUDY_DIR}/outputs/Segmentation/1_habenula_segmentation/dilateNativeSpace/hbseg_${SUBJ}_Ldil.nii.gz
	echo ${SUBJ} generate left probabilistic map
	fslmaths ${STUDY_DIR}/outputs/Segmentation/1_habenula_segmentation/dilateNativeSpace/hbseg_${SUBJ}_Ldil.nii.gz -mul ${outputdir}/hbseg_${SUBJ}_probability.nii.gz ${outputdir}/hbseg_${SUBJ}_probability_L.nii.gz

 	echo "${SUBJ} dilate right"
        fslmaths ${outputdir}/hbseg_${SUBJ}_R.nii.gz -dilM -kernel 3D -bin ${STUDY_DIR}/outputs/Segmentation/1_habenula_segmentation/dilateNativeSpace/hbseg_${SUBJ}_Rdil.nii.gz
        echo "${SUBJ} generate right probabilistic map"
        fslmaths ${STUDY_DIR}/outputs/Segmentation/1_habenula_segmentation/dilateNativeSpace/hbseg_${SUBJ}_Rdil.nii.gz -mul ${outputdir}/hbseg_${SUBJ}_probability.nii.gz ${outputdir}/hbseg_${SUBJ}_probability_R.nii.gz

}

main "$@"

ret=$?; times; exit "${ret}"

