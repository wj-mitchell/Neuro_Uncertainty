SUBJECT=$1

# PROJECT captures the filepath for all relevant project data, scripts, documents, etc.
PROJECT=/data/Uncertainty
# SCRIPTS should contain this file, your heuristic.py file (eventually), and your text file containing your list of participants.
SCRIPTS=${PROJECT}/scripts
# DERIV should contain the data that has been preprocessed or modified in some way. It's what we'll usually use to analyze
DERIV=${PROJECT}/data/deriv/pipeline_1/fmriprep

# Iterating through each run
for RUN in 1 2; do

	# Create a path that changes with each new run iteration. 
	rPATH=${DERIV}/sub-${SUBJECT}/func/lvl1_run${RUN}.feat

    # Iterate through the ROIs
    for ROI in `cat ${SCRIPTS}/ROIs_Schaefer.txt` `cat ${SCRIPTS}/ROIs_HarvardOxford.txt` ; do 

		# Iterate through the copes  
		for COPE in `seq 1 22`; do

			echo "===> Extracting cope for sub-${SUBJECT}, run ${RUN}, parcel ${ROI}, cope ${COPE}"

			# run FSL mean timeseries with -i (inputs) being the copes,
			# -m (masks) obviously being the mask files, and showall being
			# the output filename and location.
			/usr/local/fsl/bin/fslmeants -i ${rPATH}/stats/cope${COPE}.nii.gz \
					-m ${rPATH}/ROI/standardMask2example_func_${ROI}.nii.gz \
					--showall > ${PROJECT}/copes/sub-${SUBJECT}_run-${RUN}_roi-${ROI}_cope-${COPE}_networks-17_parcels-400.csv
		
		done
							
    done

done
