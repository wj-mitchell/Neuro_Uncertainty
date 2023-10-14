#!/bin/bash -x

#Environmental Variables
# PROJECT captures the filepath for all relevant project data, scripts, documents, etc.
PROJECT=/data/Uncertainty
# SCRIPTS should contain this file, your heuristic.py file (eventually), and your text file containing your list of participants.
SCRIPTS=${PROJECT}/scripts
#Contains a list of your subjects, which should match the names of your BIDS folders
SUBJECTS=`cat ${SCRIPTS}/00_participants.txt`

cd ${PROJECT}/data/deriv/pipeline_1/fmriprep/

for RUN in 1 2; do
    for SUBJ in ${SUBJECTS}; do
        # Specifying which tasks participants completed based upon their PIDs
        case "$SUBJ" in
            0035 )
                cp sub-0035/func/sub-0035_task-uncertainty_run-${RUN}_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz \
                   MergedData_Run${RUN}.nii.gz
                echo "Run - ${RUN}; sub-${SUBJ}" ;;
            * )
                fslmerge -t MergedData_Run${RUN}.nii.gz MergedData_Run${RUN}.nii.gz sub-${SUBJ}/func/sub-${SUBJ}_task-uncertainty_run-${RUN}_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz
                echo "Run - ${RUN}; sub-${SUBJ}" ;;
        esac
    done
    fslmaths MergedData_Run${RUN}.nii.gz -Tmean -sqr MergedData_Run${RUN}_tmsq.nii.gz 
    fslmaths MergedData_Run${RUN}_tmsq.nii.gz -fft fft_Run${RUN}
done