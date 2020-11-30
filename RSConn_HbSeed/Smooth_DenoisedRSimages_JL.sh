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
smooth="4";
smoothingKernel=`echo "${smooth} / ( 2 * ( sqrt ( 2 * l ( 2 ) ) ) )" | bc -l`
outputdir="${STUDY_DIR}/outputs/RSConn_HbSeed/SubjectsDATA_smoothed/${SUBJ}"

for PEDIR in AP PA; do

if [ ! -d ${outputdir} ]; then
mkdir ${outputdir}
fi

if [ ${PEDIR} == "AP" ]; then

wb_command -cifti-smoothing ${DATA_DIR}/${SUBJ}/MNINonLinear/Results/rest_acq-${PEDIR}_run-01/drest_acq-${PEDIR}_run-01_Atlas_MSMAll_Test_hp2000_clean.dtseries.nii ${smoothingKernel} ${smoothingKernel} COLUMN ${outputdir}/s${smooth}drest_acq-${PEDIR}_run-01_Atlas_MSMAll_Test_hp2000_clean.dtseries.nii -left-surface ${DATA_DIR}/${SUBJ}/MNINonLinear/fsaverage_LR32k/${SUBJ}.L.midthickness_MSMAll_Test.32k_fs_LR.surf.gii -right-surface ${DATA_DIR}/${SUBJ}/MNINonLinear/fsaverage_LR32k/${SUBJ}.R.midthickness_MSMAll_Test.32k_fs_LR.surf.gii

else

wb_command -cifti-smoothing ${DATA_DIR}/${SUBJ}/MNINonLinear/Results/rest_acq-${PEDIR}_run-02/drest_acq-${PEDIR}_run-02_Atlas_MSMAll_Test_hp2000_clean.dtseries.nii ${smoothingKernel} ${smoothingKernel} COLUMN ${outputdir}/s${smooth}drest_acq-${PEDIR}_run-02_Atlas_MSMAll_Test_hp2000_clean.dtseries.nii -left-surface ${DATA_DIR}/${SUBJ}/MNINonLinear/fsaverage_LR32k/${SUBJ}.L.midthickness_MSMAll_Test.32k_fs_LR.surf.gii -right-surface ${DATA_DIR}/${SUBJ}/MNINonLinear/fsaverage_LR32k/${SUBJ}.R.midthickness_MSMAll_Test.32k_fs_LR.surf.gii

fi
done

}

main "$@"

ret=$?; times; exit "${ret}"

