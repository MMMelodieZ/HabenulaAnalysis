SubList=$(</nafs/narr/HCP_OUTPUT/Habenula/outputs/Segmentation/Sublist_Seg.txt)

for SUB in ${SubList}; do

mkdir /nafs/narr/HCP_OUTPUT/Habenula/outputs/Segmentation/1_habenula_segmentation/${SUB}

mv /nafs/narr/HCP_OUTPUT/Habenula/outputs/Segmentation/1_habenula_segmentation/hbseg_${SUB}* /nafs/narr/HCP_OUTPUT/Habenula/outputs/Segmentation/1_habenula_segmentation/${SUB}/

done

cd /nafs/narr/HCP_OUTPUT/Habenula/outputs/Segmentation/1_habenula_segmentation/

rm -r e005201 e003402 s004402 s004401 h004302 h003502 h003501 h0019


for SUB in ${SubList}; do

mkdir /nafs/narr/HCP_OUTPUT/Habenula/outputs/Segmentation/2_FinalHbROIs_ShapeOptimized/${SUB}

mv /nafs/narr/HCP_OUTPUT/Habenula/outputs/Segmentation/2_FinalHbROIs_ShapeOptimized/${SUB}_* /nafs/narr/HCP_OUTPUT/Habenula/outputs/Segmentation/2_FinalHbROIs_ShapeOptimized/${SUB}/

done

for SUB in ${SubList}; do
DIR="/nafs/narr/HCP_OUTPUT/Habenula/outputs/Segmentation/2_FinalHbROIs_ShapeOptimized/${SUB}/${SUB}_Hb_ROI_workdir"
if [ ! "$(ls -A $DIR)" ]; then
    echo "$DIR is empty"

fi
done

#Subjects that the Shape optimization failed but the first step of segmentation did not - error with hb_tmpinit.nii 
#k004902 h003502 h004302 s004401 s004402 e003402 e005201 h0019 h003501
cd /nafs/narr/HCP_OUTPUT/Habenula/outputs/Segmentation/2_FinalHbROIs_ShapeOptimized/
rm -r k004902 h003502 h004302 s004401 s004402 e003402 e005201 h0019 h003501



