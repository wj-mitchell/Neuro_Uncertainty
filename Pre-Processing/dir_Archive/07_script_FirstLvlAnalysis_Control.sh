ANALYSIS=$1
SUBJ=$2

# Environmental Variables
# PROJECT captures the filepath for all relevant project data, scripts, documents, etc.
PROJECT=/data/Uncertainty
# SCRIPTS should contain this file, your heuristic.py file (eventually), and your text file containing your list of participants.
SCRIPTS=${PROJECT}/scripts
# DERIV  should contain our data that has been processed through fMRIPrep. 
DERIV=${PROJECT}/data/deriv/pipeline_1/fmriprep

# Creating a folder for each participant to house .fsf's
echo "===> Starting processing of ${SUBJ}"
mkdir ${DERIV}/sub-${SUBJ}/func/DesignFiles

# Creating a design file name
# FILENAME=design_run-${RUN}_ParaMod-T_ParaModDiff-F_TrialLength-${TIME}_${ANALYSIS}.fsf
FILENAME=design_${ANALYSIS}.fsf

# Iterating through each run

echo "===> Creating .fsf file for ${SUBJ}"
			
# Copy the design files into the subject directory to be modified
cp ${SCRIPTS}/*_script_design_lvl1_${ANALYSIS}.fsf \
	${DERIV}/sub-${SUBJ}/func/DesignFiles/${FILENAME}

# Replacing subject ID in each file
# We are using the | character to delimit the patterns
case "$SUBJ" in

0035 | 4590 | 5006 | 6943 | 6799 | 6977 | 8746 )
	sed -i -e "s|0035|${SUBJ}|g" \
			${DERIV}/sub-${SUBJ}/func/DesignFiles/${FILENAME} ;;
* )
	sed -i -e "s|0035|${SUBJ}|g" \
			-e "s|fish|luma|g" \
			-e "s| 240| 210|g" \
			${DERIV}/sub-${SUBJ}/func/DesignFiles/${FILENAME} ;;
esac

# Now everything is set up to run feat
echo "===> Running FEAT for ${SUBJ}, run ${RUN}"
/usr/local/fsl/bin/feat ${DERIV}/sub-${SUBJ}/func/DesignFiles/${FILENAME}