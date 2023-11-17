SUBJ=$1

# PROJECT captures the filepath for all relevant project data, scripts, documents, etc.
PROJECT=/data/Uncertainty
# SCRIPTS should contain this file, your heuristic.py file (eventually), and your text file containing your list of participants.
SCRIPTS=${PROJECT}/scripts
# NIFTI  should contain our data that has been cleaned or organized (BIDS) but not modified. 
NIFTI=${PROJECT}/data/nifti
# DERIV should contain the data that has been preprocessed or modified in some way. It's what we'll usually use to analyze
DERIV=${PROJECT}/data/deriv/pipeline_1/fmriprep
# SUBJECT adds the sub-prefix
SUBJECT="sub-${SUBJ}"

mkdir ${DERIV}/${SUBJECT}/func/ROI/

for RUN in `seq -w 1 2`; do

	echo "===> Warping mask for ${SUBJ}, run ${RUN}"

	sPATH=${DERIV}/${SUBJECT}/func
	rPath=lvl1_run${RUN}.feat
	mPATH=/data/tools/Schaefer_Parcellations/MNI/Schaefer2018_400Parcels_17Networks_order_FSLMNI152_1mm.nii.gz
	applywarp -r ${sPATH}/${rPath}/mean_func.nii.gz \
			  -i ${mPATH} \
			  -o ${sPATH}/ROI/${SUBJECT}_Run-${RUN}_Parcels-400_Networks-17_Res-1mm

done
