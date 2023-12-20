NETWORK=$1
LH_START=$2
LH_END=$3
RH_START=$4
RH_END=$5

# Environmental Variables
# PROJECT captures the filepath for all relevant project data, scripts, documents, etc.
PROJECT=/data/Uncertainty
# SCRIPTS should contain this file, your heuristic.py file (eventually), and your text file containing your list of participants.
SCRIPTS=${PROJECT}/scripts/Pre-Processing
# DERIV should contain our data that has been processed through fMRIPrep. 
DERIV=${PROJECT}/data/deriv/pipeline_1/fmriprep

# Atlas path 
ATLAS=/data/tools/schaefer_parcellations/MNI/

    # Generating an atlas containing only the left network ROIs
    fslmaths ${ATLAS}/Schaefer2018_400Parcels_Kong2022_17Networks_order_FSLMNI152_1mm.nii.gz \
            -thr ${LH_START} -uthr ${LH_END} \
            ${SCRIPTS}/dir_ROIs/Network_L_${NETWORK}.nii.gz

    # Generating an atlas containing only the right network ROIs
    fslmaths ${ATLAS}/Schaefer2018_400Parcels_Kong2022_17Networks_order_FSLMNI152_1mm.nii.gz \
            -thr ${RH_START} -uthr ${RH_END} \
            ${SCRIPTS}/dir_ROIs/Network_R_${NETWORK}.nii.gz

    # Repositioning values from the right hemisphere
    fslmaths ${SCRIPTS}/dir_ROIs/Network_R_${NETWORK}.nii.gz \
            -sub $((RH_START - LH_END - 1)) \
            ${SCRIPTS}/dir_ROIs/Network_R_${NETWORK}.nii.gz

    # Repositioning values from the right hemisphere
    fslmaths ${SCRIPTS}/dir_ROIs/Network_R_${NETWORK}.nii.gz \
            -thr 0 \
            ${SCRIPTS}/dir_ROIs/Network_R_${NETWORK}.nii.gz

    # Combining the Atlases
    fslmaths ${SCRIPTS}/dir_ROIs/Network_L_${NETWORK}.nii.gz \
            -add ${SCRIPTS}/dir_ROIs/Network_R_${NETWORK}.nii.gz \
            ${SCRIPTS}/dir_ROIs/Network_${NETWORK}.nii.gz

    # Binarizing the Mask
    fslmaths ${SCRIPTS}/dir_ROIs/Network_${NETWORK}.nii.gz -bin ${SCRIPTS}/dir_ROIs/Network_${NETWORK}.nii.gz

    # Cleaning space
    rm ${SCRIPTS}/dir_ROIs/Network_R_${NETWORK}.nii.gz
    rm ${SCRIPTS}/dir_ROIs/Network_L_${NETWORK}.nii.gz