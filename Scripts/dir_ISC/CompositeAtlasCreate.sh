# Environmental Variables
# PROJECT captures the filepath for all relevant project data, scripts, documents, etc.
PROJECT=/data/Uncertainty
# SCRIPTS should contain this file, your heuristic.py file (eventually), and your text file containing your list of participants.
SCRIPTS=${PROJECT}/scripts
# DERIV should contain our data that has been processed through fMRIPrep. 
DERIV=${PROJECT}/data/deriv/pipeline_1/fmriprep

# Atlas path 
ATLAS=/data/tools/schaefer_parcellations/MNI/

# Generating an atlas containing only the first 41 ROIs
fslmaths ${ATLAS}/Schaefer2018_400Parcels_Kong2022_17Networks_order_FSLMNI152_2mm.nii.gz \
         -uthr 41 \
         ${SCRIPTS}/dir_ROIs/Schaefer_400Parcel_L_DMN.nii.gz

# Generating an atlas containing only the 41 right DMN ROIs
fslmaths ${ATLAS}/Schaefer2018_400Parcels_Kong2022_17Networks_order_FSLMNI152_2mm.nii.gz \
         -thr 201 -uthr 236 \
         ${SCRIPTS}/dir_ROIs/Schaefer_400Parcel_R_DMN.nii.gz

# Repositioning values from the right hemisphere
fslmaths ${SCRIPTS}/dir_ROIs/Schaefer_400Parcel_R_DMN.nii.gz \
         -sub 159 \
         ${SCRIPTS}/dir_ROIs/Schaefer_400Parcel_R_DMN.nii.gz

# Repositioning values from the right hemisphere
fslmaths ${SCRIPTS}/dir_ROIs/Schaefer_400Parcel_R_DMN.nii.gz \
         -thr 0 \
         ${SCRIPTS}/dir_ROIs/Schaefer_400Parcel_R_DMN.nii.gz

# Combining the Atlases
fslmaths ${SCRIPTS}/dir_ROIs/Schaefer_400Parcel_L_DMN.nii.gz \
         -add ${SCRIPTS}/dir_ROIs/Schaefer_400Parcel_R_DMN.nii.gz \
         ${SCRIPTS}/dir_ROIs/Schaefer_400Parcel_DMN.nii.gz