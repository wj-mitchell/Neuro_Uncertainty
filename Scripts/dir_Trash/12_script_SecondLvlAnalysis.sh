ANALYSIS=$1

# Environmental Variables
# PROJECT captures the filepath for all relevant project data, scripts, documents, etc.
PROJECT=/data/Uncertainty
# SCRIPTS should contain this file, your heuristic.py file (eventually), and your text file containing your list of participants.
SCRIPTS=${PROJECT}/scripts
# DERIV  should contain our data that has been processed through fMRIPrep. 
DERIV=${PROJECT}/data/deriv/pipeline_1/fmriprep

# Creating the Directory
mkdir ${DERIV}/lvl-2_${ANALYSIS}

# Copy the design files into the subject directory to be modified
cp ${SCRIPTS}/*_script_design_lvl2_${ANALYSIS}.fsf \
	${DERIV}/lvl-2_${ANALYSIS}/design_lvl-2.fsf

# Now everything is set up to run feat
echo "===> Running FEAT for ${ANALYSIS}"
/usr/local/fsl/bin/feat ${DERIV}/lvl-2_${ANALYSIS}/design_lvl-2.fsf
