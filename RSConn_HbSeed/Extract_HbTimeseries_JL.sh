if [[ ${HCPPIPEDEBUG} == "true" ]]; then
  set -x
fi


#############################################################################

get_batch_options() {
  local arguments=("$@")

  unset command_line_specified_subj

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
for PEDIR in AP PA; do

if [ ${PEDIR} == "AP" ]; then
imgdir="${DATA_DIR}/${SUBJ}/MNINonLinear/Results/rest_acq-${PEDIR}_run-01"
#img="${imgdir}/drest_acq-${PEDIR}_run-01_hp2000_clean.nii"
img="${imgdir}/rest_acq-${PEDIR}_run-01_hp2000_clean.nii"
else
imgdir="${DATA_DIR}/${SUBJ}/MNINonLinear/Results/rest_acq-${PEDIR}_run-02"
#img="${imgdir}/drest_acq-${PEDIR}_run-02_hp2000_clean.nii"
img="${imgdir}/rest_acq-${PEDIR}_run-02_hp2000_clean.nii"
fi


outputdir="${STUDY_DIR}/outputs/RSConn_HbSeed/ROI_Timeseries/HbROIs/${SUBJ}"
if [ ! -d ${outputdir} ]; then
mkdir ${outputdir}
fi

SUBID=`echo ${SUBJ:0:5}`

for hemi in R L; do
#fslmeants -i ${img} -o ${outputdir}/Hb${hemi}_${SUBJ}_MeanTS_rest-${PEDIR}.txt -m ${STUDY_DIR}/outputs/Segmentation/4_cpAverageTPs_ROIReplaceWithTemplate/${SUBID}/${SUBID}_${hemi}_shape_optimized_Hb_ROI_ALLTPsAveraged.nii.gz
fslmeants -i ${img} -o ${outputdir}/Hb${hemi}_${SUBJ}_MeanTS_drest-${PEDIR}.txt -m ${STUDY_DIR}/outputs/Segmentation/4_cpAverageTPs_ROIReplaceWithTemplate/${SUBID}/${SUBID}_${hemi}_shape_optimized_Hb_ROI_ALLTPsAveraged.nii.gz

#wb_command -cifti-create-scalar-series ${outputdir}/Hb${hemi}_${SUBJ}_MeanTS_rest-${PEDIR}.txt ${outputdir}/Hb${hemi}_${SUBJ}_MeanTS_rest-${PEDIR}.sdseries.nii -transpose -series SECOND 0 0.8
wb_command -cifti-create-scalar-series ${outputdir}/Hb${hemi}_${SUBJ}_MeanTS_drest-${PEDIR}.txt ${outputdir}/Hb${hemi}_${SUBJ}_MeanTS_drest-${PEDIR}.sdseries.nii -transpose -series SECOND 0 0.8
done

done


}

main "$@"

ret=$?; times; exit "${ret}"

