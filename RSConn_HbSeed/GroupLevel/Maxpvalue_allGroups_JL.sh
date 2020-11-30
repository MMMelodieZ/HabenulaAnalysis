#!/bin/bash
hcpdir="/nafs/narr/HCP_OUTPUT"
Habenuladir="/nafs/narr/HCP_OUTPUT/Habenula"

module unload fsl
module load fsl/6.0.0
module unload workbench
module load workbench
module unload MATLAB
module load MATLAB/R2017a
module load PALM
module load freesurfer/6.0.1 

ROIList="HbL HbR"
#ROIList="HbL"

GroupList="KTP1_KTP2 KTP1_KTP3 KTP3_KTP4 KTP1_KTP4"
#GroupList="KTP1_KTP2"
SubtractionDirection="pos neg"

#SubtractionDirection="pos"
contrasts="c1 c2"

for g in ${GroupList}
do
for r in ${ROIList}
do
groupdir=${Habenuladir}/outputs/RSConn_HbSeed/GroupAnalysis/wSmoothing_wDenoising/${g}/${r}
cd ${groupdir}
for d in ${SubtractionDirection}; do
for con in ${contrasts}; do
echo "${g}_${r}_${d}_TFCEfwep_${con}:`wb_command -cifti-stats results_dense_${d}_tfce_ztstat_fwep_${con}.dscalar.nii -reduce MAX`" 
echo "${g}_${r}_${d}_TFCEuncp_${con}:`wb_command -cifti-stats results_dense_${d}_tfce_ztstat_uncp_${con}.dscalar.nii -reduce MAX`" 
echo "${g}_${r}_${d}_TFCEfdrp_${con}:`wb_command -cifti-stats results_dense_${d}_tfce_ztstat_fdrp_${con}.dscalar.nii -reduce MAX`" 
echo "${g}_${r}_${d}_Clusterefwep_${con}:`wb_command -cifti-stats results_dense_${d}_clustere_ztstat_fwep_${con}.dscalar.nii -reduce MAX`" 

done
done
done
done
