# PROJECT captures the filepath for all relevant project data, scripts, documents, etc.
PROJECT=/data/Uncertainty
# SCRIPTS should contain this file, your heuristic.py file (eventually), and your text file containing your list of participants.
SCRIPTS=${PROJECT}/scripts
# DERIV should contain the data that has been preprocessed or modified in some way. It's what we'll usually use to analyze
DERIV=${PROJECT}/data/deriv/pipeline_1/fmriprep
#Contains a list of your subjects, which should match the names of your BIDS folders
SUBJECTS=`cat ${SCRIPTS}/00_participants.txt`

for SUBJECT in $SUBJECTS; do

   echo "Moving $SUBJECT 's smoothed and denoised files"
   
   for RUN in 1 2; do

    cp $DERIV/sub-$SUBJECT/func/sub-${SUBJECT}_run-${RUN}_Average_ROI_n400.csv \
       $PROJECT/data/AvgROI

   done

done