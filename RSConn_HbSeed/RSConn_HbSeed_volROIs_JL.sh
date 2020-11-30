#!/bin/bash 

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
dataclean=${STUDY_DIR}/outputs/RSConn_HbSeed/SubjectsDATA_smoothed/${SUBJ}/s4drest_acq-${PEDIR}_run-01_Atlas_MSMAll_Test_hp2000_clean.dtseries.nii 
#dataclean=${STUDY_DIR}/outputs/RSConn_HbSeed/SubjectsDATA_smoothed/${SUBJ}/s4rest_acq-${PEDIR}_run-01_Atlas_MSMAll_Test_hp2000_clean.dtseries.nii
else
dataclean=${STUDY_DIR}/outputs/RSConn_HbSeed/SubjectsDATA_smoothed/${SUBJ}/s4drest_acq-${PEDIR}_run-02_Atlas_MSMAll_Test_hp2000_clean.dtseries.nii 
#dataclean=${STUDY_DIR}/outputs/RSConn_HbSeed/SubjectsDATA_smoothed/${SUBJ}/s4rest_acq-${PEDIR}_run-02_Atlas_MSMAll_Test_hp2000_clean.dtseries.nii 
fi
#args=" ${args} -cifti ${dataclean} "

for hemi in R L; do

#MeanTS="${STUDY_DIR}/outputs/RSConn_HbSeed/ROI_Timeseries/HbROIs/${SUBJ}/Hb${hemi}_${SUBJ}_MeanTS_rest-${PEDIR}.sdseries.nii"
MeanTS="${STUDY_DIR}/outputs/RSConn_HbSeed/ROI_Timeseries/HbROIs/${SUBJ}/Hb${hemi}_${SUBJ}_MeanTS_drest-${PEDIR}.sdseries.nii"

outputdir="${STUDY_DIR}/outputs/RSConn_HbSeed/SubjectsDATA_RSConn/${SUBJ}"

if [ ! -d ${outputdir} ]; then
mkdir ${outputdir}
fi

#2- Generate cross correlation maps between the timeseries and the RS CIFTI data
#wb_command -cifti-cross-correlation ${dataclean} ${MeanTS} ${outputdir}/RSConn_${SUBJ}_rest-${PEDIR}_Hb${hemi}.dscalar.nii -fisher-z
wb_command -cifti-cross-correlation ${dataclean} ${MeanTS} ${outputdir}/RSConn_${SUBJ}_drest-${PEDIR}_Hb${hemi}.dscalar.nii -fisher-z

done
done
}

main "$@"

ret=$?; times; exit "${ret}"

