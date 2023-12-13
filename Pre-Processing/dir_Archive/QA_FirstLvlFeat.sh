#!/bin/bash

# Environmental Variables
# STAGE represents which stage of the analysis pipeline we're currently at (Primay vs. Pilot)
STAGE=Pipeline_2_Analysis
# RAW will contain your BIDS-formatted NifTis. To start, it should contain your code folder
RAW=/data/RSA_moral/rawdata
# CODE should contain this file, your heuristic.py file (eventually), and your text file containing your list of participants.
CODE=${RAW}/code/${STAGE}
# DERIV is the output for your preprocessed data
DERIV=/data/RSA_moral/derivatives/pipeline_1/fmriprep/
# Contains a list of your subjects, which should match the names of your BIDS folders
SUBJECTS=`cat ${CODE}/Participants.txt`


for i in ${SUBJECTS}; do

	# Specifying the number of runs based on each participant
	case "$i" in
	    CU10698 | SC01490 | SC01601 )
	        NRUNS=4 ;;
	    CU13033 | CU13069 )
	        NRUNS=3 ;;
	    * )
	        NRUNS=5 ;;
	esac

	for j in `seq -w 1 ${NRUNS}` ; do

		if [ ! -d "${DERIV}/sub-${i}/ses-1/func/Aver_run-${j}.feat/stats" ]; then

			echo "sub-${i}; Run ${j}" >> ${CODE}/QAing/MissingFeatStats.txt

		fi

	done

done