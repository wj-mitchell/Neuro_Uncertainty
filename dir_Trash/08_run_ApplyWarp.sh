#!/bin/bash -x

#Environmental Variables
# PROJECT captures the filepath for all relevant project data, scripts, documents, etc.
PROJECT=/data/Uncertainty
# SCRIPTS should contain this file, your heuristic.py file (eventually), and your text file containing your list of participants.
SCRIPTS=${PROJECT}/scripts
#Contains a list of your subjects, which should match the names of your BIDS folders
SUBJECTS=`cat ${SCRIPTS}/Participants.txt`

for SUBJ in ${SUBJECTS}; do
    echo "+++++ Warping ${SUBJ} +++++"
    
#Manages the number of jobs and cores
  		SCRIPTNAME=${SCRIPTS}/*_script_ApplyWarp.sh
  		NSUBJ=5
  		while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NSUBJ ]; do
  	  		sleep 1m
  		done
  		bash $SCRIPTNAME $SUBJ &
  		sleep 5s
done