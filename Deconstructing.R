pacman::p_load(R.matlab,
               tidyverse)

df <- readMat("C:/Users/Administrator/Desktop/NarrativeEngagement-main/data/hyperparameters.mat") %>%
      as.data.frame()

df <- readMat("C:/Users/Administrator/Desktop/NarrativeEngagement-main/data/behavior-engagement-paranoia.mat") %>%
  as.data.frame()

# Setting Working Directory

# Loading Data 

# Specifying window size, sigma, step size, TR and number of Timepoints
## Note that they played around with varying window sizes of 8 and 6

# Z-Score each participants data relative to themselves

# Calculate the mean z-score within each time point across participants to represent average engagement, uncertainty, etc.

# Generate an HRF convolution that sums to 1
sum(0,
    0.000354107958396228,
    0.0220818694830938,
    0.116001537001027,
    0.221299059999514,
    0.242353095826523,
    0.186831750619196,
    0.113041009515928,
    0.0572809597709863,
    0.0253492394574127,
    0.0100814114758446,
    0.00367740475539297,
    0.00124901102357508,
    0.000399543113110135,
    0)
