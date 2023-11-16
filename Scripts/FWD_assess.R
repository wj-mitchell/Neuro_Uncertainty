library(assertthat)
library(dplyr)
library(stringr)
source("/data/tools/stinkR/make_df.R", local = T)

# Identifying where the data exists
path <- "/data/Uncertainty/data/deriv/pipeline_1/fmriprep/"
output <- "/data/Uncertainty/scripts/"

# Identifying the different participant IDs
pts <- list.files(path = path) %>%
       str_extract(pattern = "sub-....") %>% 
       subset(!is.na(.)) %>%
       unique()

# Naming the number of runs
runs <- paste0("run-",1:2)

# Creating a dataframe to house the percentage of FWD for each participant
df_FWD <- make_df(rows = 1:(length(pts) * length(runs)),
                  cols = c("PTS", "Run", "FWD_rate"))

# Loading pt IDs
df_FWD$PTS <- rep(pts, length(runs)) %>%
  sort()

# Loading runs
df_FWD$Run <- rep(runs, length(pts))

# Iterating through each of the participants
for (i in pts){
  
  # Iterate through the runs in the study
  for (j in runs){
    
    # Create a variable to capture the file name for this run
    filename <- paste0(path, "/", i, "/func/", i, "_task-uncertainty_", j,"_desc_confounds_FWD.txt")
    
    # If it does exist . . . 
    if (file.exists(filename)){
      
      # And if the file isn't empty . . .
      if (file.info(filename)$size > 0){
        
        # Read in the file as a dataframe
        df <- read.delim(file = filename,
                         sep = "",
                         header = T) 
        # Create a row to track the number of FWDs
        df$count <- 0
        
        # Go through each row and count FWDs
        for (k in 1:length(rownames(df))){
          if (any(df[k,] == 1)){
            df$count[k] <- 1
          }
        }
        
        # Calculate the rate of FWDs
        df_FWD$FWD_rate[df_FWD$PTS == i & df_FWD$Run == j] <- (length(rownames(df)) - sum(df$count))/length(rownames(df))
      }
    }
  }
}

exclude_FWD <- subset(df_FWD, df_FWD$FWD_rate < 0.85)
no_FWD <- subset(df_FWD, is.na(df_FWD$FWD_rate))

write.csv(exclude_FWD, paste0(output,"FWD_exclude.csv"))
