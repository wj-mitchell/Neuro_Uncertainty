#!/bin/bash -x

#Environmental Variables
# PROJECT captures the filepath for all relevant project data, scripts, documents, etc.
PROJECT=/data/Uncertainty
# SCRIPTS should contain this file, your heuristic.py file (eventually), and your text file containing your list of participants.
SCRIPTS=${PROJECT}/scripts

# for ANALYSIS in ParaMod Condition; do
for ANALYSIS in Test; do
echo "+ ANALYSIS: ${ANALYSIS} +" 

    if [ ${ANALYSIS} == Test ]; then

        for GROUP in 1 2; do

            case "$GROUP" in

                1 )
                    SUBJECTS=`cat ${SCRIPTS}/00_condA.txt` ;;
                2 )
                    #Contains a list of your subjects, which should match the names of your BIDS folders
                    SUBJECTS=`cat ${SCRIPTS}/00_condB.txt` ;;
            esac

            # This will run our first level analysis in parallel much as it had above
            for SUBJ in ${SUBJECTS}; do
                echo "+++++ First Level Processing ${SUBJ} +++++"
            
                #Manages the number of jobs and cores
                SCRIPTNAME=${SCRIPTS}/*_script_FirstLvlAnalysis_${ANALYSIS}_HighPass.sh
                NSUBJ=12
                while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NSUBJ ]; do
                    sleep 1m
                done
                bash $SCRIPTNAME $ANALYSIS $SUBJ $GROUP &
                sleep 5s
            done
        done
    else

        #Contains a list of your subjects, which should match the names of your BIDS folders
        SUBJECTS=`cat ${SCRIPTS}/00_participants.txt`

        # This will run our first level analysis in parallel much as it had above
        for SUBJ in ${SUBJECTS}; do
            echo "+++++ First Level Processing ${SUBJ} +++++"
        
            #Manages the number of jobs and cores
            SCRIPTNAME=${SCRIPTS}/*_script_FirstLvlAnalysis_${ANALYSIS}.sh
            NSUBJ=12
            while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NSUBJ ]; do
                sleep 1m
            done
            bash $SCRIPTNAME $ANALYSIS $SUBJ &
            sleep 5s
        done
    fi
done