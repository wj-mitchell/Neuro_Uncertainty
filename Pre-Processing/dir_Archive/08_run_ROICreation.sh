# Environmental Variables
# PROJECT captures the filepath for all relevant project data, scripts, documents, etc.
PROJECT=/data/Uncertainty
# SCRIPTS should contain this file, your heuristic.py file (eventually), and your text file containing your list of participants.
SCRIPTS=${PROJECT}/scripts
# DERIV should contain our data that has been processed through fMRIPrep. 
DERIV=${PROJECT}/data/deriv/pipeline_1/fmriprep
# These atlases determines which atlas we are pulling our ROIs from.
Schaefer=/data/tools/schaefer_parcellations/MNI/Schaefer2018_400Parcels_Kong2022_17Networks_order_FSLMNI152_1mm.nii.gz
HarvardOxford=/usr/local/fsl/data/atlases/HarvardOxford/HarvardOxford-sub-maxprob-thr50-1mm.nii.gz

mkdir ${SCRIPTS}/ROIs

# Iterate through the atlases
for ATLAS in $Schaefer $HarvardOxford ; do

    # ROI_TOTAL notes how many parcellations are present in the atlas
    case "$ATLAS" in
        # We're using the standard 400 parcellation Schaefer atlas
        $Schaefer )
        ROI_NAMES=(`cat ${SCRIPTS}/ROIs_Schaefer.txt`)
        ROI_TOTAL=400 ;;
        # and the standard 21 ROI subcrotical atlas
        $HarvardOxford )
        ROI_NAMES=(`cat ${SCRIPTS}/ROIs_HarvardOxford.txt`)
        ROI_TOTAL=21 ;;
    esac
                
    # Iterate through each cortical parcellation (keeping in mind both bash and FSL use 0 indexing)
    for ROI_NUM in `seq 0 "$((${ROI_TOTAL}-1))"`; do

        # Identify the name of the target ROI
        ROI_NAME=${ROI_NAMES[$(eval echo $((${ROI_NUM}))-1)]}

        # Noting where we're at
        echo "++ Isolating Parcel ${ROI_NAME} ++"
        
        # This function actually isolates the parcellation ROI_NUM from ATLAS and gives it the name ROI_NAME
        fslmaths ${ATLAS} -thr ${ROI_NUM} -uthr ${ROI_NUM} -bin ${SCRIPTS}/ROIs/${ROI_NAME}

    done

done