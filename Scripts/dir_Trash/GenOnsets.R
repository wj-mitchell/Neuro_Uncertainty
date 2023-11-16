# GenOnsets | v2022.09.03

# Loading packages
library(tidyverse)

# Denoting our working directory
RawDir <- "/data/Uncertainty/data/raw/"
DerivDir <- "/data/Uncertainty/data/deriv/pipeline_1/fmriprep"

# Denoting our TR
TR <- 2

# Specifying Tasks
Task <- c("3_task-1",
          "5_task-2",
          "7_task-3",
          "8_task-4") %>%
  rep(length(list.files(RawDir)))

# Specifying Participants
PID <- list.files(RawDir) %>%
  rep(length(unique(Task))) %>%
  sort()

# Building a Dataframe
df <- data.frame(PID, Task)

# Adding Number of Files
df$NFiles <- NA
for (row in 1:nrow(df)){
  if (length(list.files(paste0(RawDir, "/", df$PID[row], "/",  df$Task[row], "/DICOM/"))) != 0){
    df$NFiles[row] <- length(list.files(paste0(RawDir, "/", df$PID[row], "/",  df$Task[row], "/DICOM/")))
  }
  if (length(list.files(paste0(RawDir, "/", df$PID[row], "/",  df$Task[row], "/DICOM/"))) == 0){
    df$NFiles[row] <- length(list.files(paste0(RawDir, "/", df$PID[row], "/scans/",  df$Task[row], "/DICOM/")))
  }
}

# Cleaning Our Space 
rm(TR, Task, PID)

# Adding Timing
df$Time_s <- df$NFiles * TR

# Creating a For Loop that will Generate Our Three Column Files
# For each task each participant completed
for (row in 1:nrow(df)){
  
  # Ignore non-uncertainty tasks (for now)
  if (df$Task[row] == "3_task-1" | df$Task[row] == "5_task-2"){
    
    # If the participant's uncertainty task has 759 files 
    if (df$NFiles[row] == 759){
      
      # Create an onset sequence that removes the first 90 and last 90 seconds 
      onset <- seq(107, df$Time_s[row] - 90, 60)
    }
    
    # If the participant's uncertainty task has 729 files
    if (df$NFiles[row] == 729){
      
      # Create an onset sequence that removes the first 60 and last 60 seconds
      onset <- seq(77, df$Time_s[row] - 60, 60)
    }
    
    # Create a duration sequence of 60 across the board
    duration <- rep(60, length(onset))
    
    # Set parametric modulation to 1 across the board
    paramod <- rep(1, length(onset))
    
    # Concatenate onset, duration and parametric modulation into a dataframe
    df_temp <- data.frame(onset, duration, paramod)
    
    # Create a new directory in the participant's raw files called "Onset"
    dir.create(DerivDir, "sub-", df$PID[row], "/","Onset")
    
    # Set our working directory to that onset directory
    setwd(DerivDir, "sub-", df$PID[row], "/","Onset")
    
    # If we're working with the first half video ...
    if (df$Task[row] == "3_task-1"){
      
      # Save our dataframe as a text file with this name
      write.table(df_temp,
                  paste0(df$PID[row], "_task-uncertainty_run-1_timing.txt"),
                  sep = "\t",
                  row.names = FALSE,
                  col.names = FALSE)
    }
    
    # If we're working with the second half video ...
    if (df$Task[row] == "5_task-2"){
      
      # Save our dataframe as a text file with a slightly different name
      write.table(df_temp,
                  paste0(df$PID[row], "_task-uncertainty_run-2_timing.txt"),
                  sep = "\t",
                  row.names = FALSE,
                  col.names = FALSE)
    }
    
    # Cleaning Space
    rm(df_temp, onset, paramod, duration)
  }
}

# Cleaning Our Space 
rm(row, DerivDir, RawDir)