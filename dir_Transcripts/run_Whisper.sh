#!/bin/bash -x

#Environmental Variables
# PROJECT captures the filepath for all relevant project data, scripts, documents, etc.
PROJECT=/data/Uncertainty
# SCRIPTS should contain this file, your heuristic.py file (eventually), and your text file containing your list of participants.
SCRIPTS=${PROJECT}/scripts
#Contains a list of your subjects, which should match the names of your BIDS folders
FILES=/data/Uncertainty/data/free_recall/*.wav

for FILE in ${FILES}; do
    echo " - WORKING WITH FILE: ${FILE} - "
    
#Manages the number of jobs and cores
  		SCRIPTNAME=${SCRIPTS}/dir_Transcripts/script_Whisper.py
  		NSUBJ=10
  		while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NSUBJ ]; do
  	  		sleep 1m
  		done
  		python $SCRIPTNAME $FILE &
  		sleep 5s
done