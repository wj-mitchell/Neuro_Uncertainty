#!/usr/bin/env bash

# this script will convert your BIDS *events.tsv files into the 3-col format for FSL
# it relies on Tom Nichols' converter, which we store locally under /data/tools 
# https://github.com/bids-standard/bidsutils

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
        NRUNS=2 ;;
      # ... and only one for every other task
      * )
        NRUNS=1 ;;
    esac

    # Iterate through each of the participants' runs
    for RUN in `seq -w 1 ${NRUNS}`; do

      # Defining the file we feed into the script
      input=${NIFTI}/sub-${SUBJ}/func/sub-${SUBJ}_task-${TASK}_run-${RUN}_events.tsv

      # Defining where the output should be stored
      output=${DERIV}/sub-${SUBJ}/func/3col_onsets

      # Create the output director, and create its parent directories as needed (-p)
      mkdir -p $output

      # If the file exists, run the script
      if [ -e $input ]; then
        bash /data/tools/bidsutils/BIDSto3col.sh $input ${output}/${TASK}_run-${run}
      
      # If it doesn't, output an error
      else
        echo "PATH ERROR: cannot locate ${input}."
        exit
      fi

    done
    
  done

done