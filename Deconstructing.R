# pacman::p_load(R.matlab,
#                tidyverse)
# 
# df <- readMat("C:/Users/Administrator/Desktop/NarrativeEngagement-main/data/hyperparameters.mat") %>%
#       as.data.frame()
# 
# df <- readMat("C:/Users/Administrator/Desktop/NarrativeEngagement-main/data/behavior-engagement-paranoia.mat") %>%
#   as.data.frame()
# Setup
if (require("pacman") == FALSE){
  install.packages("pacman")
}

# Loading in my packages with my pacman manager
pacman::p_load(here,
               MASS,
               signal,
               tidyverse)

# Adding custom functions
source("HRF_convolve.R")

# Setting Working Directory
WorkDir <- here::here()

# Setting Seed
set.seed(123)

# Loading Data 
df <- as.data.frame(matrix(data = NA, 
                           nrow = 660, 
                           ncol = 20))
for (COL in 1:ncol(df)){
  example <- c(0, sample(seq(-5, 5, 5), 659, replace = T))
  for (INDEX in 2:length(example)){
    example[INDEX] <- example[INDEX -1] + example[INDEX]
    if (example[INDEX] > 100){
      example[INDEX] <- 100
    }
    if (example[INDEX] < -100){
      example[INDEX] <- -100
    }
  }
  rm(INDEX)
  df[,COL] <- example
}

# Specifying window size, sigma, step size, TR and number of Timepoints
window_size <- c(32, 40, 48)
sigma <- 3
step_size <- 1
TR <- 2
nVols <- (1337 - 17)/2 
 
# Z-Score each participants data relative to themselves
for (COL in 1:ncol(df)){
  df[,COL] <- scale(df[,COL]) %>%
              as.numeric()
}

# Calculate the mean z-score within each time point across participants to represent average engagement, uncertainty, etc.
average <- rep(NA, nrow(df))
for (INDEX in 1:nrow(df)){
  average[INDEX] <- mean(as.numeric(df[INDEX,]))
}

# Generate an HRF convolution that sums to 1
weight <- c(0,
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

# Resampling the convlution based upon the TR as needed
weight = 

# Linearly convolving the average signal with the HRF weights
conv_average <- convolve(y = average, 
                         x = weight, 
                         type="open") %>%
                .[1:nVols]

# Checking if the time series is of a different length 
if (length(timeseries) != nVols){
  stop('The length of the timeseries should match the number of volumes present');
}

# Generating a Gaussian distribution for convolution
## Generating the median and series indices 
if ((nVols %% 2) != 0){
  median <- ceiling(nVols/2)
  series_index <- 0:nVols
}
if ((nVols %% 2) == 0){
  median <- nVols/2
  series_index <- 0:(nVols-1)
}

## Defining the radius of the sliding window
window <- round(window_size/2)
## Creating a Gaussian window
gauss_window <- t(exp(-((c(series_index-median)^2) / (2 * sigma^2))))
## Creating a sample series on which to apply the window
series_sample <- rep(0, nVols)
## Applying the window (i.e., changing 0's to 1's)
series_sample[(median - window + 1):(median + window)] <- 1

convolution <- convolve(y = gauss_window, 
                       x= series_sample, 
                       type = "open")
convolution <- convolution/max(convolution)
convolution <- convolution[(median + 1):(length(convolution) - median + 1)]
convolution <- convolution[1:nVols]

convmat <- matrix(convolution)
nWindow <- nVols - window_size
FNCdyn <- rep(0, nWindow)
tcwin <- as.data.frame(matrix(data = 0, 
                              nrow = nWindow,
                              ncol = nVols))

# Define a function that mimics MATLAB's circshift for vectors
circshift <- function(x, shift) {
  n <- length(x)
  shift <- shift %% n  # This ensures that the shift is within the vector length
  c(tail(x, n - shift), head(x, shift))
}

for (WINDOW in 1:nWindow){
  # slide Gaussian centered on [1+ window_size/2, nVols - window_size / 2]
  convmat_shift <- circshift(convmat, 
                     round(-nVols/2) + round(window_size/2) + WINDOW)

    # when using "circshift", prevent spillover of the gaussian to either the beginning or an end of the timeseries
    if (WINDOW < floor(nWindow/2) & convmat_shift[length(convmat_shift)] != 0){
      convmat_shift[ceiling(nWindow/2):length(convmat_shift)] <- 0
      convmat_shift <- c(convmat_shift) * (sum(convmat)/sum(convmat_shift[1:floor(nWindow/2)]))
    }
        
    if (WINDOW > floor(nWindow/2) & convmat_shift[1] != 0){
        convmat_shift[1:floor(nWindow/2)] <- 0
        convmat_shift <- c(convmat_shift) * (sum(convmat)/sum(convmat_shift[ceiling(nWindow/2):length(convmat_shift)]))
    }
    
    # apply gaussian weighted sliding window of the timeseries
    tcwin[WINDOW,]  <- ts * convmat_shift
}

# normalize for a final round after sliding-window
# Sum across rows
sliding_ts <- scale(sum(tcwin, na.rm = T))
}

# sliding window apply: see function below
sliding_engagement = slidingwindow(conv_engagement, nVols, window_size(ws), sigma)