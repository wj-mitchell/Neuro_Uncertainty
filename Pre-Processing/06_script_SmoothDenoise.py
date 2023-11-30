# This script has been adapted from Luke Chang's naturalistic-data.org tutorial. 
# Dependent Packages
import os
import sys
import glob
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import datetime
from nltools.stats import regress, zscore
from nltools.data import Brain_Data, Design_Matrix
from nltools.stats import find_spikes 
from nltools.mask import expand_mask
from nilearn.image import index_img

# Defining our directories
data_dir = '/data/Uncertainty/data/deriv/pipeline_1/fmriprep'

# Quick-customize Variables
fwhm = 6                  # Size of the smoothing kernel
tr = 2                  # Task TR value
outlier_cutoff = 3      # Spike cutoff rate
task = "uncertainty"    # Name of the task
ROIsize = sys.argv[1]   # Which ROI resolution to use

# Defining our motion covariate generator function
def make_motion_covariates(mc, tr):
    z_mc = zscore(mc)
    all_mc = pd.concat([z_mc, z_mc**2, z_mc.diff(), z_mc.diff()**2], axis=1)
    all_mc.fillna(value=0, inplace=True)
    return Design_Matrix(all_mc, sampling_freq=1/tr)

# ----- GENEARTING FOR LOOP -----


# ----- CLEANING BEGINS -----
print("Smoothing and Denoising has begun! | " + str(datetime.datetime.now()))

# Reading in cortical parcellations
# This is the Schaefer Parcellation
parcellation = '/data/tools/schaefer_parcellations/MNI/Schaefer2018_'+ ROIsize + 'Parcels_Kong2022_17Networks_order_FSLMNI152_1mm.nii.gz'
mask = Brain_Data(parcellation)
print("Neurosynth parcellations have downloaded! | " + str(datetime.datetime.now()))

# Identifying all preprocessed bold files
file_list = [x for x in glob.glob(os.path.join(data_dir, 'sub-*/func/*uncertainty_run*preproc_bold*gz'))] 

# Identifying all preprocessed bold files that have already been denoised
completed_list = [x for x in glob.glob(os.path.join(data_dir, 'sub-*/func/*uncertainty_run*preproc_bold*gz')) if ('denoise_smooth'+ str(fwhm) + 'mm_nROI-' + ROIsize) in x] 

# Removing participants who have already completed their denoising
for f in completed_list:

    sub = os.path.basename(f).split('_')[0]

    file_list = [x for x in file_list if sub not in x] 

# Iterating through all of the previously identified files
for f in file_list:

    # Identifying this participant's ID (which will be the first element in this array)
    sub = os.path.basename(f).split('_')[0]

    # Identifying this file's run number (which will be the third element in this array)
    run = os.path.basename(f).split('_')[2]

    # Reading in the data for this file
    data = Brain_Data(f)
    print(str(sub) + "'s " + str(run) + " data has loaded | " + str(datetime.datetime.now()))

    # Smoothing the brain data according to our defined kernel size
    smoothed = data.smooth(fwhm=6)
    print(str(sub) + "'s " + str(run) + " data has been smoothed | " + str(datetime.datetime.now()))    

    # Identifying and removing spikes in the data according to our outlier cutoff
    spikes = smoothed.find_spikes(global_spike_cutoff=outlier_cutoff, diff_spike_cutoff=outlier_cutoff)
    print(str(sub) + "'s " + str(run) + " data has been despiked | " + str(datetime.datetime.now()))    

    # Reading in covariate information from the fMRIPrep output
    covariates = pd.read_csv(glob.glob(os.path.join(data_dir, sub, 'func', '*uncertainty*timeseries.tsv'))[0], sep='\t')
    print("Read in " + str(sub) + "'s " + str(run) + " covariate data | " + str(datetime.datetime.now()))  

    # Creating a new dataframe called mc with these specific motion covariates in mind
    mc = covariates[['trans_x','trans_y','trans_z','rot_x', 'rot_y', 'rot_z']]

    # Running our custom function which will z-score, concatenate, and remove NAs from the variables above  
    mc_cov = make_motion_covariates(mc, tr)

    # Creating an array of csf values from the fmriprep output
    csf = covariates['csf']
    dm = Design_Matrix(pd.concat([csf, mc_cov, spikes.drop(labels='TR', axis=1)], axis=1), sampling_freq=1/tr)
    
    # Add Intercept, Linear and Quadratic Trends
    dm = dm.add_poly(order=2, include_lower=True) 
    print("Completed " + str(sub) + "'s " + str(run) + " covariate data | " + str(datetime.datetime.now()))     

    smoothed.X = dm
    stats = smoothed.regress()

    # cast as float32 to reduce storage space
    stats['residual'].data = np.float32(stats['residual'].data)

    # Saving data as a denoised nifti file
    stats['residual'].write(os.path.join(data_dir, sub, 'func', f'{sub}_task-{task}_{run}_space-MNI152NLin2009cAsym_desc-preproc_bold_denoise_smooth{fwhm}mm_nROI-{ROIsize}.nii.gz'))
    print("Writing " + str(sub) + "'s " + str(run) + " .hdf5 data | " + str(datetime.datetime.now()))  

    # Converting the nifti file to .hdf5 files 
    stats['residual'].write(os.path.join(data_dir, sub, 'func', f'{sub}_task-{task}_{run}_space-MNI152NLin2009cAsym_desc-preproc_bold_denoise_smooth{fwhm}mm_nROI-{ROIsize}.hdf5'))
    print("Writing " + str(sub) + "'s " + str(run) + " average ROI data | " + str(datetime.datetime.now()))

    # Reading in the cortical parcellations as masks 
    roi = stats['residual'].extract_roi(mask)

    # Calculating the average activation value of each of the 400 ROIs across all timepoints and saving it as a .csv
    pd.DataFrame(roi.T).to_csv(os.path.join(os.path.dirname(f), f"{sub}_{run}_nROI-{ROIsize}_avgROI.csv" ), index=False)
    print(str(sub) + " " + str(run) + " Complete ! | " + str(datetime.datetime.now()))