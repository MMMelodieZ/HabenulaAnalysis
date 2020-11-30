#!/bin/bash

#SBATCH -J PALM_RSHb
#SBATCH -o PALM_RSHb

hcpdir="/nafs/narr/HCP_OUTPUT"
maindir="/nafs/narr/HCP_OUTPUT/Habenula"

ROIList="HbL HbR"
#ROIList="HbL"

#GroupList="KTP1_KTP2 KTP1_KTP3 KTP3_KTP4 KTP2_KTP3 KTP1_KTP4"
#GroupList="KTP1_KTP2 KTP1_KTP3"
#GroupList="HCTP1_KTP1_Average HCTP1_Average KTP1_Average"
#GroupList="RemchangeTP3_NonRemchangetP3 RemTP1_NonRemTP1"
GroupList="RemTP1_NonRemTP1"
#GroupList="RemchangeTP3_NonRemchangeTP3"
#GroupList="HC_KTP1"
#SubtractionDirection="pos neg"

#SubtractionDirection="pos"

for group in ${GroupList}
do
	for r in ${ROIList}
	do
		#for d in ${SubtractionDirection}; do

		
    			echo "sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=30G --time=4-00:00:00 \
--job-name=${group}${r}${d} --output=${maindir}/outputs/RSConn_HbSeed/GroupAnalysis/logs/job_logs/${group}_${r}_${d}_PALM_RSConn.log --export=ROI=${r},GROUP=${group},DIR=${d} ${maindir}/code/RSConn_HbSeed/GroupLevel/PALM3rdLevel_1samplettests_RSConn_HbSeed_JL.sh"
   
			#sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=50G --time=4-00:00:00 \
#--job-name=${group}${r} --output=${maindir}/outputs/RSConn_HbSeed/GroupAnalysis/wSmoothing_wDenoising/logs/${group}_${r}_PALM_RSConn.log --export=ROI=${r},GROUP=${group} ${maindir}/code/RSConn_HbSeed/GroupLevel/PALM3rdLevel_1samplettestsAverege_noSubtraction_RSConn_HbSeed_JL.sh


			#sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=40G --time=7-00:00:00 \
#--job-name=${group}${r}${d} --output=${maindir}/outputs/RSConn_HbSeed/GroupAnalysis/wSmoothing_wDenoising/logs/${group}_${r}_${d}_PALM_RSConn.log --export=ROI=${r},GROUP=${group},DIR=${d} ${maindir}/code/RSConn_HbSeed/GroupLevel/PALM3rdLevel_1samplettests_RSConn_HbSeed_JL.sh 

			sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=40G --time=7-00:00:00 \
--job-name=${group}${r} --output=${maindir}/outputs/RSConn_HbSeed/GroupAnalysis/wSmoothing_wDenoising/logs/${group}_${r}_PALM_RSConn.log --export=ROI=${r},GROUP=${group},DIR=${d} ${maindir}/code/RSConn_HbSeed/GroupLevel/PALM3rdLevel_2samplettests_RSConnTP1_HbSeed_JL.sh

			#sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=40G --time=7-00:00:00 \
#--job-name=${group}${r}${d} --output=${maindir}/outputs/RSConn_HbSeed/GroupAnalysis/wSmoothing_wDenoising/logs/${group}_${r}_${d}_PALM_RSConn.log --export=ROI=${r},GROUP=${group},DIR=${d} ${maindir}/code/RSConn_HbSeed/GroupLevel/PALM3rdLevel_2samplettests_RSConn_HbSeed_JL.sh 

			#sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=40G --time=7-00:00:00 \
#--job-name=${group}${r} --output=${maindir}/outputs/RSConn_HbSeed/GroupAnalysis/wSmoothing_wDenoising/logs/${group}_${r}_PALM_RSConn.log --export=ROI=${r},GROUP=${group},DIR=${d} ${maindir}/code/RSConn_HbSeed/GroupLevel/PALM3rdLevel_2samplettests_RSConn_HC_KTP1_HbSeed_JL.sh

		#done

	done
done

