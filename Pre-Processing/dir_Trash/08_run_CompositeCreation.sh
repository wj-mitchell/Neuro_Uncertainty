# Environmental Variables
# PROJECT captures the filepath for all relevant project data, scripts, documents, etc.
PROJECT=/data/Uncertainty
# SCRIPTS should contain this file, your heuristic.py file (eventually), and your text file containing your list of participants.
SCRIPTS=${PROJECT}/scripts
# DERIV should contain our data that has been processed through fMRIPrep. 
DERIV=${PROJECT}/data/deriv/pipeline_1/fmriprep

ROI_NAMES=(`cat ${SCRIPTS}/ROIs_Schaefer.txt`)                

# Iterate through each cortical parcellation (keeping in mind both bash and FSL use 0 indexing)
for ROI_NUM in `seq 1 136` `seq 201 335`; do

    # Identify the name of the target ROI
    ROI_NAME=${ROI_NAMES[$(eval echo $((${ROI_NUM}))-1)]}

    echo $ROI_NAME

    # This function will create a composite ROI from the parcellations
    fslmaths ${SCRIPTS}/ROIs/NoAudSomVis.nii.gz -add ${SCRIPTS}/ROIs/${ROI_NAME}.nii.gz ${SCRIPTS}/ROIs/NoAudSomVis.nii.gz

done

ROI_NAMES=(`cat ${SCRIPTS}/ROIs_HarvardOxford.txt`)

# Iterate through each cortical parcellation (keeping in mind both bash and FSL use 0 indexing)
for ROI_NUM in `seq 1 21`; do

    # Identify the name of the target ROI
    ROI_NAME=${ROI_NAMES[$(eval echo $((${ROI_NUM}))-1)]}

    # This function will create a composite ROI from the parcellations
    fslmaths ${SCRIPTS}/ROIs/NoAudSomVis.nii.gz -add ${SCRIPTS}/ROIs/${ROI_NAME}.nii.gz ${SCRIPTS}/ROIs/NoAudSomVis..nii.gz

done