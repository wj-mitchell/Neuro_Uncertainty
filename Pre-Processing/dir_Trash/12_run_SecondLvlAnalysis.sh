#!/bin/bash -x

#Environmental Variables
# PROJECT captures the filepath for all relevant project data, scripts, documents, etc.
PROJECT=/data/Uncertainty
# SCRIPTS should contain this file, your heuristic.py file (eventually), and your text file containing your list of participants.
SCRIPTS=${PROJECT}/scripts

for ANALYSIS in Test Control; do
echo "+++++ Second Level Processing ${ANALYSIS} +++++"

    #Manages the number of jobs and cores
    SCRIPTNAME=${SCRIPTS}/*_script_SecondLvlAnalysis.sh
    NSCRIPTS=2
    while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NSCRIPTS ]; do
        sleep 1m
    done
    bash $SCRIPTNAME $ANALYSIS &
    sleep 5s

done