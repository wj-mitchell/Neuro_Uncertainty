#!/bin/bash -x

#Environmental Variables
# PROJECT captures the filepath for all relevant project data, scripts, documents, etc.
PROJECT=/data/Uncertainty
# SCRIPTS should contain this file, your heuristic.py file (eventually), and your text file containing your list of participants.
SCRIPTS=${PROJECT}/scripts

# Create a single directory to store all of the copes 
mkdir ${PROJECT}/copes/

# Iterate through all of the subjects
for SUBJECT in `cat ${SCRIPTS}/Participants.txt`; do

    #Manages the number of jobs and cores
    SCRIPTNAME=${SCRIPTS}/*_script_CopeExtraction.sh
    NCOPES=10
    while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCOPES ]; do
        sleep 30s
    done
    bash $SCRIPTNAME $SUBJECT &
    sleep 5s

done