#!/bin/bash -x

#Environmental Variables
# PROJECT captures the filepath for all relevant project data, scripts, documents, etc.
PROJECT=/data/Uncertainty
# SCRIPTS should contain this file, your heuristic.py file (eventually), and your text file containing your list of participants.
SCRIPTS=${PROJECT}/scripts
# Denotes which script we want to control
SCRIPTNAME=${SCRIPTS}/Pre-Processing/*_script_SmoothDenoise.py

# Iterate through each ROI resolution
for ROISIZE in 100 200 300 400; do

    # Print our progress
    echo "+++++ Smoothing and Denoising at ${ROISIZE} ROIs +++++"

    # Manages the number of simultaneous jobs and cores
    NJOB=4
    
    # Check how many jobs the linux is currently running of this given script name; if it meets the max set by NJOB ...
    while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NJOB ]; do

        # Sleep for 1 minute and check again 
        sleep 1m

    # If there are fewer than NJOB jobs running
    done

    # Then execute the given script and continue (&)
    python $SCRIPTNAME $ROISIZE &

    # Wait 5 seconds before iterating to the next item in the loop
    sleep 5s

done