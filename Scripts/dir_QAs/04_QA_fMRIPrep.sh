#!/bin/bash

#Environmental Variables
# PROJECT captures the filepath for all relevant project data, scripts, documents, etc.
PROJECT=/data/Uncertainty
# SCRIPTS should contain this file, your heuristic.py file (eventually), and your text file containing your list of participants.
SCRIPTS=${PROJECT}/scripts
# NIFTI  should contain our data that has been cleaned or organized (BIDS) but not modified. 
NIFTI=${PROJECT}/data/nifti
# DERIV should contain the data that has been preprocessed or modified in some way. It's what we'll usually use to analyze
DERIV=${PROJECT}/data/deriv/pipeline_1/fmriprep
# Contains a list of your subjects, which should match the names of your BIDS folders
SUBJECTS=`cat ${SCRIPTS}/Participants.txt`

# Go back to root directory
cd

# Iterate through each of the participants on our list
for SUBJ in ${SUBJECTS}; do

	# Specifying which tasks participants completed based upon their PIDs
	case "$SUBJ" in
		# These were early participants who completed the fish task, so we'll change the contents of the TASKS array to reflect that
		0035 | 4590 | 6943 | 6799 | 6977 | 8746 | 5006 )
		TASKS=( uncertainty fish recall ) ;;
		#Everyone else completed the luma task, so we'll change the contents of the TASKS array to reflect that
		* )
		TASKS=( uncertainty luma recall ) ;;
	esac

	# We'll want to iterate through the various tasks participants completed
	for TASK in ${TASKS}; do

		# Specifying how many runs are in each task
		case "$TASK" in
		# There were two runs for uncertainty ...
		uncertainty )

			# Iterate through each of the participants' runs
			for RUN in `seq -w 1 2`; do

				# If this file does not exist
				if [ ! -f "${DERIV}/sub-${SUBJ}/func/sub-${SUBJ}_task-${TASK}_run-${RUN}_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz" ]; then

					# Then record that file's PID and run information in a text file
					echo "${SUBJ}; ${TASK} Run ${RUN}" >> ${SCRIPTS}/03_QAresults_fMRIPrep.txt

				fi

			done ;;

		# ... and only one for every other task
		* )
			# If this file does not exist
			if [ ! -f "${DERIV}/sub-${SUBJ}/func/sub-${SUBJ}_task-${TASK}_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz" ]; then

				# Then record that file's PID and run information in a text file
				echo "${SUBJ}; ${TASK}" >> ${SCRIPTS}/03_QAresults_fMRIPrep.txt

			fi ;;

		esac

	done

done