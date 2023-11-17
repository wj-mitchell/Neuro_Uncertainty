#!/bin/bash
SUBJ=$1

# Environmental Variables
PROJECT=/data/Uncertainty
NIFTI=${PROJECT}/data/nifti
SCRIPTS=${PROJECT}/scripts
DERIV=${PROJECT}/data/deriv/pipeline_1/fmriprep

INPUT=${NIFTI}/sub-${SUBJ}/func
OUTPUT=${DERIV}/sub-${SUBJ}/func

# Chaning permissions to ensure we can write new files
echo "===> Started processing of ${SUBJ}"
sudo chmod -R 777 ${OUTPUT}

# Iterating through each run
for RUN in `seq -w 1 2` ; do

	# Noting our progress
	echo "===> Started processing of Run ${RUN}"

	# Running the FSL motion outlier function
	fsl_motion_outliers -i ${INPUT}/sub-${SUBJ}_task-uncertainty_run-${RUN}_bold.nii.gz \
						-o ${OUTPUT}/sub-${SUBJ}_task-uncertainty_run-${RUN}_desc_confounds_FWD.txt \
						--fd --thresh=0.9 -p ${OUTPUT}/sub-${SUBJ}_task-uncertainty_run-${RUN}_desc_confounds_plot \
						-v ${OUTPUT}/sub-${SUBJ}_task-uncertainty_run-${RUN}_desc_confounds_FWD_notes.txt \

done