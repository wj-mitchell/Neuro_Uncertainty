SUBJ=$1

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

# Iterate through each run participants have
for RUN in 1 2; do

      # FEAT denotes the filepath to our FEAT directories
      FEAT=${DERIV}/sub-${SUBJ}/func/lvl1_run${RUN}.feat

      # # Create an ROI directory
      mkdir ${FEAT}/ROI

      # # Iterate through the atlases
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
                     
            # # Iterate through each cortical parcellation (keeping in mind both bash and FSL use 0 indexing)
            for ROI_NUM in `seq 1 "$((${ROI_TOTAL}))"`; do

                  # Identify the name of the target ROI
                  ROI_NAME=${ROI_NAMES[$(eval echo $((${ROI_NUM}))-1)]}
            
                  # Noting where we're at
                  echo "++ Isolating ${SUBJ}'s Run ${RUN} - Parcel ${ROI_NAME} ++"

                  # OUTPUT denotes the name of the final cortical parcellation file
                  OUTPUT=standardMask2example_func_${ROI_NAME}.nii.gz

                  # This function moves ROI_NAME into the participant's space and saves that ROI as the filename OUTPUT            
                  flirt -ref ${FEAT}/example_func.nii.gz \
                        -in ${SCRIPTS}/ROIs/${ROI_NAME}.nii.gz \
                        -out ${FEAT}/ROI/${OUTPUT} \
                        -applyxfm \
                        -init ${FEAT}/reg/standard2example_func.mat \
                        -datatype float

                  # If a parcellation is probabilistic, it removes areas that are below 0.5
                  fslmaths ${FEAT}/ROI/${OUTPUT} \
                           -thr 0.5 \
                           ${FEAT}/ROI/${OUTPUT}

                  # For the remaining voxels included, this function binarizes it so we aren't worried about intensiites. 
                  fslmaths ${FEAT}/ROI/${OUTPUT} \
                           -bin \
                           ${FEAT}/ROI/${OUTPUT}  
            
            done
            
      done

done