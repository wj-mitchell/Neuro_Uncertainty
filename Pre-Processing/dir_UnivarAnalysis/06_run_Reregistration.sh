#!/bin/bash -x

#Environmental Variables
# PROJECT captures the filepath for all relevant project data, scripts, documents, etc.
PROJECT=/data/Uncertainty
# SCRIPTS should contain this file, your heuristic.py file (eventually), and your text file containing your list of participants.
SCRIPTS=${PROJECT}/scripts
DERIV=${PROJECT}/data/deriv/pipeline_1/fmriprep

# for ANALYSIS in ParaMod Condition; do
for ANALYSIS in CPA Spline; do
echo "+ ANALYSIS: ${ANALYSIS} +" 
        
    for GROUP in 1 2; do

        case "$GROUP" in

            1 )
                SUBJECTS=`cat ${SCRIPTS}/00_condB.txt` ;;
            2 )
                #Contains a list of your subjects, which should match the names of your BIDS folders
                SUBJECTS=`cat ${SCRIPTS}/00_condA.txt` ;;
        esac

        # This will run our first level analysis in parallel much as it had above
        for SUBJ in ${SUBJECTS}; do
            echo "+ Fixing Registration For ${SUBJ}'s ${ANALYSIS} Data (Run ${GROUP})+" 
            
            FEATPATH=${DERIV}/sub-${SUBJ}/func/lvl-1_run-${GROUP}_${ANALYSIS}.feat

            rm ${FEATPATH}/reg/*.mat
            
            cp $FSLDIR/etc/flirtsch/ident.mat \
                ${FEATPATH}/reg/example_func2standard.mat

            cp ${FEATPATH}/mean_func.nii.gz \
                ${FEATPATH}/reg/standard.nii.gz
            
            if [ ! -f "${FEATPATH}/reg/standard.nii.gz" ]; then

                echo "sub-${SUBJ}; ${ANALYSIS} Run ${GROUP} standard.nii.gz"
            fi

            if [ ! -f "${FEATPATH}/reg/example_func2standard.mat" ]; then

                echo "sub-${SUBJ}; ${ANALYSIS} Run ${GROUP} example_func2standard.mat"
            fi
        done
    done
done