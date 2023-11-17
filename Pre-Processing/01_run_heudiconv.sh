#!/bin/bash

# This script is designed to run heudiconv using Docker in order to convert the uncertainty data set to BIDS format. 

# pull the latest version of heudiconv
docker pull nipy/heudiconv:latest

#Environmental Variables
# PROJECT captures the filepath for all relevant project data, scripts, documents, etc.
PROJECT=/data/Uncertainty
# SCRIPTS should contain this file, your heuristic.py file (eventually), and your text file containing your list of participants.
SCRIPTS=${PROJECT}/scripts
# NIFTI  should contain our data that has been cleaned or organized (BIDS) but not modified. 
NIFTI=${PROJECT}/data/nifti
# Contains a list of subjects you want to format into BIDS
SUBJECTS=`cat ${SCRIPTS}/00_batch_subs.txt`

# Iterating through each subject in the batch file
for SUBJ in ${SUBJECTS}; do

	# Some subjects completed a different control task. We'll manually specify those folks
	case "$SUBJ" in
		# These were early participants who completed the fish task ...
		0035 | 4590 | 6943 | 6799 | 6977 | 8746 | 5006 )
		TASK=fish ;;
		# ... but everyone else completed the luma task
		* )
		TASK=luma ;;
	esac
	
	# first, run heudiconv without the converter to read the data according to the heuristic; 
	# this generates the dicominfo.tsv file needed to run heudiconv with the converter
	docker run --rm -it \
	            -v ${PROJECT}/data/raw:/input:ro \
			    -v ${NIFTI}:/output \
			    -v ${SCRIPTS}:/scripts \
			    nipy/heudiconv:latest \
			    -d /input/sub-{subject}/*/DICOM/*.dcm \
				-o /output \
				-f convertall \
			    -s ${SUBJ} \
				-c none \
				--overwrite \


	# then, run heudiconv with the converter to do the actual conversion to BIDS-formatted NIFTIs
	docker run --rm -it \
	            -v ${PROJECT}/data/raw:/input:ro \
			    -v ${NIFTI}:/output \
			    -v ${SCRIPTS}:/scripts \
			    nipy/heudiconv:latest \
			    -d /input/sub-{subject}/*/DICOM/*.dcm \
				-o /output \
				-f /scripts/01_script_heuristic_${TASK}.py \
			    -s ${SUBJ} \
				-c dcm2niix -b \
				--overwrite \
	
	# now, let's unlock all the permissions so I can access my own GD data
	sudo chmod -R 777 ${NIFTI}/sub-* 
	 
done
