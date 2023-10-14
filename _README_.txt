# Overview

This analysis pipeline will:
01) reorganize our data into BIDS format using heudiconv
02) pre-process our data with the standard fMRIPrep pipeline
03) generate a confound file based upon fMRIPrep output in R
04) automatically generate unique person-specific onset files with minimal input using a custom R function
05) run first level analyses within run using FSL's FEAT
06) register the data using the Mumford workaround
07) run second level analyses using FSL's FEAT

# Running analyses

This directory follows a few simple organizational rules and keeping these rules in mind will allow you to navigate the directory and use the scripts with relative ease. 

- First, all relevant background information, text files, participant lists, etc. are affixed with a prefix of 0's so that they are conveniently listed at the top of the directory list. These participant lists should be updated regularly with the PIDs of the project. These .txt files are where the subsequently  listed scripts pull PID information from. 

- Second, each of the seven previously mentioned steps are affixed with a non-zero numbered prefix, or index (e.g., 01_*, 02_*, 03_*). These indexes correspond to the order in which scripts should be ran. Each step might contain multiple scripts (this is especially true of steps that require running something in parallel). For example, Step 01 includes the files `01_run_heudiconv.sh`, `01_script_heuristic_fish.py`, `01_script_heuristic_luma.py`. The category immediately following the index is either "SCRIPT" or "RUN". **SCRIPT** files contain code to carry out a specific action, but are never *ran*. **RUN** files often control **SCRIPT** files; they might contain commands to execute the **SCRIPT** file. As such, for each step, all you should need to do is enter the command `bash 0*_run_*`, replacing the asterisks with whatever specific step you are on, and the script will do the rest. For example, if I wanted to run heudiconv I would just enter `bash 01_run_heudiconv` and that script would include commands for what to do to the two 01_script_* files. 

- Third, directories containing old code, ROIs, QA checks or other analyses are affixed with the prefix `dir_`. 

- Fourth, the license.txt file refers to the FreeSurfer license required to operate fMRIPrep. 