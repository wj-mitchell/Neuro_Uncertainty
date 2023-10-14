SUBJ=$1

# PROJECT captures the filepath for all relevant project data, scripts, documents, etc.
PROJECT=/data/Uncertainty
# SCRIPTS should contain this file, your heuristic.py file (eventually), and your text file containing your list of participants.
SCRIPTS=${PROJECT}/scripts
# NIFTI  should contain our data that has been cleaned or organized (BIDS) but not modified. 
NIFTI=${PROJECT}/data/nifti
# DERIV should contain the data that has been preprocessed or modified in some way. It's what we'll usually use to analyze
DERIV=${PROJECT}/data/deriv/pipeline_1


docker run --cpus 20 --rm -e DOCKER_VERSION_8395080871=19.03.12 \
			-v ${SCRIPTS}/license.txt:/opt/freesurfer/license.txt:ro \
			-v ${NIFTI}:/data:ro \
			-v ${DERIV}:/out \
			nipreps/fmriprep:20.2.6 \
			/data /out \
			participant --participant-label ${SUBJ} \
			--fs-no-reconall 