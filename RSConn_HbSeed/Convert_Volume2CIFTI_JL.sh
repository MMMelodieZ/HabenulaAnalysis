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
	

for PEDIR in AP PA; do

if [ ${PEDIR} = "AP" ]; then
volumeIn="${DATA_DIR}/${SUBJ}/MNINonLinear/Results/rest_acq-${PEDIR}_run-01/drest_acq-${PEDIR}_run-01_hp2000_clean.nii"
volumeOut="${DATA_DIR}/${SUBJ}/MNINonLinear/Results/rest_acq-${PEDIR}_run-01/${SUBJ}_AtlasSubcortical_JL.nii.gz"
roiVolume="${DATA_DIR}/${SUBJ}/MNINonLinear/Results/rest_acq-${PEDIR}_run-01/RibbonVolumeToSurfaceMapping/goodvoxels.nii.gz"
else
volumeIn="${DATA_DIR}/${SUBJ}/MNINonLinear/Results/rest_acq-${PEDIR}_run-02/drest_acq-${PEDIR}_run-02_hp2000_clean.nii"
volumeOut="${DATA_DIR}/${SUBJ}/MNINonLinear/Results/rest_acq-${PEDIR}_run-02/${SUBJ}_AtlasSubcortical_JL.nii.gz"
roiVolume="${DATA_DIR}/${SUBJ}/MNINonLinear/Results/rest_acq-${PEDIR}_run-02/RibbonVolumeToSurfaceMapping/goodvoxels.nii.gz"
fi

currentParcel="${DATA_DIR}/${SUBJ}/MNINonLinear/ROIs/ROIs.2.nii.gz"
newParcel="${DATA_DIR}/${SUBJ}/MNINonLinear/ROIs/Atlas_ROIs.2.nii.gz"
kernel="1"
Flag="-fix-zeros"
VolROI="-volume-roi $roiVolume"


wb_command -volume-parcel-resampling $volumeIn $currentParcel $newParcel $kernel $volumeOut ${Flag}

for Hemisphere in L R ; do

surface="${DATA_DIR}/${SUBJ}/MNINonLinear/Native/${SUBJ}.${Hemisphere}.midthickness.native.surf.gii"
metricOut="${DATA_DIR}/${SUBJ}/MNINonLinear/Native/${SUBJ}.${Hemisphere}.native.func.gii"
ribbonInner="${DATA_DIR}/${SUBJ}/MNINonLinear/Native/${SUBJ}.${Hemisphere}.white.native.surf.gii"
ribbonOutter="${DATA_DIR}/${SUBJ}/MNINonLinear/Native/${SUBJ}.${Hemisphere}.pial.native.surf.gii"
wb_command -volume-to-surface-mapping $volumeIn $surface $metricOut -ribbon-constrained $ribbonInner $ribbonOutter ${VolROI}
	
metric="${DATA_DIR}/${SUBJ}/MNINonLinear/Native/${SUBJ}.${Hemisphere}.native.func.gii"
distance="20"
metricOut="${DATA_DIR}/${SUBJ}/MNINonLinear/Native/${SUBJ}.${Hemisphere}.native.func.gii"
wb_command -metric-dilate $metric $surface $distance $metricOut -nearest

metric="${DATA_DIR}/${SUBJ}/MNINonLinear/Native/${SUBJ}.${Hemisphere}.native.func.gii"
mask="${DATA_DIR}/${SUBJ}/MNINonLinear/Native/${SUBJ}.${Hemisphere}.roi.native.shape.gii"
metricOut="${DATA_DIR}/${SUBJ}/MNINonLinear/Native/${SUBJ}.${Hemisphere}.native.func.gii"
wb_command -metric-mask $metric $mask $metricOut

metricIn="${DATA_DIR}/${SUBJ}/MNINonLinear/Native/${SUBJ}.${Hemisphere}.native.func.gii"
currentSphere="${DATA_DIR}/${SUBJ}/MNINonLinear/Native/${SUBJ}.${Hemisphere}.sphere.reg.reg_LR.native.surf.gii"
newSphere="${DATA_DIR}/${SUBJ}/MNINonLinear/fsaverage_LR32k/${SUBJ}.${Hemisphere}.sphere.MSMAll_InitalReg_1_d40_WRN.32k_fs_LR.surf.gii"
method="ADAP_BARY_AREA"
metricOut="${DATA_DIR}/${SUBJ}/MNINonLinear/fsaverage_LR32k/${SUBJ}-MSMAll.${Hemisphere}.32k_fs_LR.func.gii"
currentArea="${DATA_DIR}/${SUBJ}/MNINonLinear/Native/${SUBJ}.${Hemisphere}.midthickness.native.surf.gii"
newArea="${DATA_DIR}/${SUBJ}/MNINonLinear/fsaverage_LR32k/${SUBJ}.${Hemisphere}.midthickness_MSMAll_Test.32k_fs_LR.surf.gii"
roiMetric="${DATA_DIR}/${SUBJ}/MNINonLinear/Native/${SUBJ}.${Hemisphere}.roi.native.shape.gii"
wb_command -metric-resample $metricIn $currentSphere $newSphere $method $metricOut -area-surfs $currentArea $newArea -current-roi $roiMetric
	
metric="${DATA_DIR}/${SUBJ}/MNINonLinear/fsaverage_LR32k/${SUBJ}-MSMAll.${Hemisphere}.32k_fs_LR.func.gii"
mask="${DATA_DIR}/${SUBJ}/MNINonLinear/fsaverage_LR32k/${SUBJ}.${Hemisphere}.atlasroi.32k_fs_LR.shape.gii"
metricOut="${DATA_DIR}/${SUBJ}/MNINonLinear/fsaverage_LR32k/${SUBJ}-MSMAll.${Hemisphere}.32k_fs_LR.func.gii"
wb_command -metric-mask $metric $mask $metricOut
	
done

if [ ${PEDIR} == "AP" ]; then
ciftiOut="${DATA_DIR}/${SUBJ}/MNINonLinear/Results/rest_acq-${PEDIR}_run-01/drest_acq-${PEDIR}_run-01_Atlas_MSMAll_Test_hp2000_clean.dtseries.nii"
volumeData="${DATA_DIR}/${SUBJ}/MNINonLinear/Results/rest_acq-${PEDIR}_run-01/${SUBJ}_AtlasSubcortical_JL.nii.gz"
else
ciftiOut="${DATA_DIR}/${SUBJ}/MNINonLinear/Results/rest_acq-${PEDIR}_run-02/drest_acq-${PEDIR}_run-02_Atlas_MSMAll_Test_hp2000_clean.dtseries.nii"
volumeData="${DATA_DIR}/${SUBJ}/MNINonLinear/Results/rest_acq-${PEDIR}_run-02/${SUBJ}_AtlasSubcortical_JL.nii.gz"
fi

labelVolume="${DATA_DIR}/${SUBJ}/MNINonLinear/ROIs/Atlas_ROIs.2.nii.gz"
lMetric="${DATA_DIR}/${SUBJ}/MNINonLinear/fsaverage_LR32k/${SUBJ}-MSMAll.L.32k_fs_LR.func.gii"
lRoiMetric="${DATA_DIR}/${SUBJ}/MNINonLinear/fsaverage_LR32k/${SUBJ}.L.atlasroi.32k_fs_LR.shape.gii"
	
rMetric="${DATA_DIR}/${SUBJ}/MNINonLinear/fsaverage_LR32k/${SUBJ}-MSMAll.R.32k_fs_LR.func.gii"
      
rRoiMetric="${DATA_DIR}/${SUBJ}/MNINonLinear/fsaverage_LR32k/${SUBJ}.R.atlasroi.32k_fs_LR.shape.gii"

wb_command -cifti-create-dense-timeseries $ciftiOut -volume $volumeData $labelVolume -left-metric $lMetric -roi-left $lRoiMetric -right-metric $rMetric -roi-right $rRoiMetric

done
			
}

main "$@"

ret=$?; times; exit "${ret}"












