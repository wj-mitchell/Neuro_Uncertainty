#!/bin/bash -x

#Environmental Variables
# PROJECT captures the filepath for all relevant project data, scripts, documents, etc.
PROJECT=/data/Uncertainty
# SCRIPTS should contain this file, your heuristic.py file (eventually), and your text file containing your list of participants.
SCRIPTS=${PROJECT}/scripts

# Iterating through the two conditions 
for GROUP in 1 2; do

    # Choose the PIDs based upon the condition we're on
    case "$GROUP" in

        1 )
            SUBJECTS=`cat ${SCRIPTS}/CondA.txt` ;;
        2 )
            #Contains a list of your subjects, which should match the names of your BIDS folders
            SUBJECTS=`cat ${SCRIPTS}/CondB.txt` ;;
	esac

    # This will run our ROI creation script in parallel much as it had above
    for SUBJ in ${SUBJECTS}; do
        echo "+++++ ISOLATING PARCELLATIONS FOR ${SUBJ} +++++"
        
    #Manages the number of jobs and cores
            SCRIPTNAME=${SCRIPTS}/*_script_ParcellationIsolation_H1.sh
            NSUBJ=7
            while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NSUBJ ]; do
                sleep 1m
            done
            bash $SCRIPTNAME $SUBJ &
            sleep 5s

    done

done