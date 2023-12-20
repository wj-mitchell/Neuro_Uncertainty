#!/bin/bash -x

#Environmental Variables
# PROJECT captures the filepath for all relevant project data, scripts, documents, etc.
PROJECT=/data/Uncertainty
# SCRIPTS should contain this file, your heuristic.py file (eventually), and your text file containing your list of participants.
SCRIPTS=${PROJECT}/scripts
# Denotes which script we want to control
SCRIPTNAME=${SCRIPTS}/Pre-Processing/*_script_CompositeAtlases.sh
# Denotes the Different Networks Captured here
NETWORKS=(DefaultA DefaultB DefaultC Language ContA ContB ContC SalVenAttnA SalVenAttnB DorsAttnA DorsAttnB Aud SomMotA SomMotB VisualA VisualB VisualC)
# Denotes where the left ROIS in this nework start
LH_START=(1 15 31 42 52 64 76 85 96 109 125 137 147 160 172 185 197)
# Denotes where the left ROIS in this nework end
LH_END=(14 30 41 51 63 75 84 95 108 124 136 146 159 171 184 196 200)
# Denotes where the right ROIS in this nework start
RH_START=(201 215 226 237 245 258 271 285 298 313 324 336 345 358 369 384 397)
# Denotes where the right ROIS in this nework end
RH_END=(214 225 236 244 257 270 284 297 312 323 335 344 357 368 383 396 400)

# Iterate through each ROI resolution
for INDEX in $(seq 1 ${#NETWORKS[@]}); do

    # Zero indexing
    index=$((INDEX-1))

    # Print our progress
    echo "+++++ Creating a Mask for ${NETWORKS[$index]} Network +++++"

    # Manages the number of simultaneous jobs and cores
    NJOB=4
    
    # Check how many jobs the linux is currently running of this given script name; if it meets the max set by NJOB ...
    while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NJOB ]; do

        # Sleep for 1 minute and check again 
        sleep 1m

    # If there are fewer than NJOB jobs running
    done

    # Then execute the given script and continue (&)
    bash $SCRIPTNAME ${NETWORKS[$index]} ${LH_START[$index]} ${LH_END[$index]} ${RH_START[$index]} ${RH_END[$index]} &

    # Wait 5 seconds before iterating to the next item in the loop
    sleep 5s

done