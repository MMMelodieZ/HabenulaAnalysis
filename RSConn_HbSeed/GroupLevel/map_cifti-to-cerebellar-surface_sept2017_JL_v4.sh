#!/bin/bash
# script to map cifti volume to colin cerebellar surface.
# DVE 19sep2017 in preparation for possible BALSA release

module load workbench/1.3.2
module load fsl

CEREBELLAR_SURFACE=colin.cerebellum.anatomical_MNI.surf.gii

#Replace with your cerebellar surface directory
CEREBELLAR_SURFACE_DIR=/nafs/narr/jloureiro/CEREBELLUM/cerebellum_colin
LabelVolumeAtlas=/nafs/narr/jloureiro/scripts/Pipelines-3.22.0/global/templates/91282_Greyordinates/Atlas_ROIs.2.nii

#generate left and right nifti volumes

#wb_command -cifti-separate $CIFTI_FILE_DIR/$INPUT_CIFTI_FILE COLUMN -volume CEREBELLUM_LEFT $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum_left.nii -roi $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum_left_roi.nii

#wb_command -cifti-separate $CIFTI_FILE_DIR/$INPUT_CIFTI_FILE COLUMN -volume CEREBELLUM_RIGHT $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum_right.nii -roi $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum_right_roi.nii

wb_command -cifti-separate $CIFTI_FILE_DIR/$INPUT_CIFTI_FILE COLUMN -volume-all $CIFTI_FILE_DIR/${INPUT_CIFTI_FILE}_subcorticalvol.nii -roi $CIFTI_FILE_DIR/${INPUT_CIFTI_FILE}_subcorticalvol_roi.nii -volume CEREBELLUM_RIGHT $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum_right.nii -roi $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum_right_roi.nii -volume CEREBELLUM_LEFT $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum_left.nii -roi $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum_left_roi.nii -metric CORTEX_LEFT $CIFTI_FILE_DIR/${INPUT_PREFIX}_left.func.gii -roi $CIFTI_FILE_DIR/${INPUT_PREFIX}_left.shape.gii -metric CORTEX_RIGHT $CIFTI_FILE_DIR/${INPUT_PREFIX}_right.func.gii -roi $CIFTI_FILE_DIR/${INPUT_PREFIX}_right.shape.gii

#wb_command -cifti-separate Y.dtseries.nii COLUMN -volume-all Y_subcortical.nii -label Y_subcortical_label.nii -roi Y_subcortical_roi.nii -metric CORTEX_LEFT Y_left.func.gii -roi left.shape.gii -metric CORTEX_RIGHT Y_right.func.gii -roi right.shape.gii

#combine into single nifti volume and dilate one step:

wb_command -volume-math 'x+y' $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum.nii -var x $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum_left.nii  -var y $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum_right.nii

wb_command -volume-dilate $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum.nii 1 NEAREST $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum_dilate1.nii

#Map to cerebellar surface, generating a dtseries file

wb_command -volume-to-surface-mapping $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum_dilate1.nii $CEREBELLAR_SURFACE_DIR/$CEREBELLAR_SURFACE $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum.dtseries.nii -cubic

#copy this cifti file to a gifti file 
cp $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum.dtseries.nii $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum.func.gii

wb_command -cifti-create-dense-timeseries $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum.dtseries.nii -cerebellum-metric $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum.func.gii -timestep 1.0 -timestart 1

wb_command -nifti-information $CIFTI_FILE_DIR/$INPUT_PREFIX.dscalar.nii -print-xml | grep MapName | cut -d ">" -f 2 | cut -d "<" -f 1 > tmp.txt

wb_command -cifti-convert-to-scalar $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum.dtseries.nii ROW $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum.dscalar.nii -name-file tmp.txt

wb_command -cifti-create-dense-scalar $CIFTI_FILE_DIR/${INPUT_PREFIX}_wCerebellum.dscalar.nii -volume $CIFTI_FILE_DIR/${INPUT_CIFTI_FILE}_subcorticalvol.nii ${LabelVolumeAtlas} -left-metric $CIFTI_FILE_DIR/${INPUT_PREFIX}_left.func.gii -roi-left $CIFTI_FILE_DIR/${INPUT_PREFIX}_left.shape.gii -right-metric $CIFTI_FILE_DIR/${INPUT_PREFIX}_right.func.gii -roi-right $CIFTI_FILE_DIR/${INPUT_PREFIX}_right.shape.gii -cerebellum-metric $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum.func.gii 


#clean up (but preserve metric file(s) *.func.gii)
rm $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum_left.nii $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum_left_roi.nii $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum_right.nii $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum_right_roi.nii $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum.nii $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum_dilate1.nii $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum.dtseries.nii tmp.txt

echo "finished"

