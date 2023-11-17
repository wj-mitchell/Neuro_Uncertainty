#!/usr/bin/env Rscript
# ---
# title: "01_DFCreation"
# author: "William J Mitchell"
# date: 2022.10.06
# ---

## If the pacman package manager is not currently installed on this system, install it.
if (require("pacman") == FALSE){
  install.packages("pacman")
}

## Loading Packages
pacman::p_load(here,
               tidyverse)

# Specifying Our Directories
{
  ## Accepting command arguments
  PID = as.character(commandArgs(trailingOnly = TRUE)[1])

  ## Identifying our main directory
  WorkDir <- "/data/Uncertainty"
  
  ## Identifying specific directories to read and write from
  Raw <- paste0(WorkDir, "/copes/")
}
  
# Reading In Data
{
  ## List all of the files to read in
  files <- list.files(path = Raw,
                      full.names = F,
                      pattern = PID)

  ## Creating a variable to track the iteration
  progress = 0

  ## Iterating through each of those files
  for (FILE in files){

    ## Tracking progress in a time-conservative way (I'd normally use which and search the array but it takes a long time with a set this large)
    progress <- progress + 1

    ## Recording the start time of the loop  
    if (progress == 1){
      start_time <- Sys.time()
    }

    ## Create an object to track empty copes
    df_empty <- NULL
      
    ## If the file is of a size that suggests it's empty
    if (file.size(paste0(Raw, FILE)) <= 5){
      
      ## Append its name to the end of the empty dataframe tracker
      df_empty <- c(df_empty, FILE)
    }
    
    ## If the file is of a size that suggests it actually had data
    if (file.size(paste0(Raw, FILE)) > 5){
    
      ## Reading in the first three rows, which contain coordinate information in MNI space (I think)
      df_temp <- read.csv(paste0(Raw, FILE),
                          header = F, 
                          sep = " ",
                          row.names = c("X","Y","Z","Value"))[1:3,] %>%
        
        ## Transposing that dataframe so that it's three columns instead of three rows
        t() %>%
        
        ## Fixing transpose's restructuring to make sure it's a dataframe
        as.data.frame() %>%
        
        ## Removing NA values that might occur due to the separator
        subset(!is.na(.$X))
      
      ## Creating a series of coordinate objects; one for each dimension 
      x <- paste0("X", df_temp$X)
      y <- paste0("Y", df_temp$Y)
      z <- paste0("Z", df_temp$Z)
      
      ## Concatenating all of those objects together into a single array of coordinates which we'll feed into a dataframe
      coords <- paste(x,y,z, sep = "_")
      
      ## Reading in the values only, tranposing, saving as a dataframe, and removing NAs
      df_temp <- read.csv(paste0(Raw, FILE),
                          header = F, 
                          sep = " ",
                          row.names = c("X","Y","Z","Value"))[4,] %>%
        t() %>%
        as.data.frame() %>%
        subset(!is.na(.$Value))
      
      ## Creating a new column of coordinates for each of the values
      df_temp$Voxel <- coords
      
      ## Creating a new column recording the cope name
      df_temp$Cope <- FILE %>% 
        str_replace_all(pattern = "\\.csv$",
                        replacement = "")
      
      ## If this is the first file
      if (FILE == files[1]){
        
        ## Save it as dataframe DF
        df <- df_temp
      }
      
      ## If this is not the first file
      if (FILE != files[1]){
        
        ## Append it to the end of dataframe DF
        df <- rbind(df, df_temp)
      }
      
      ## Clean our space
      rm(x,y,z,df_temp,coords)
      
    }
    
    ## Every 500 iterations and the first that we cycle through
    if (progress == 1 | progress %% 500 == 0){
      
      ## Recording the time it took to complete this iteration 
      end_time <- Sys.time()
            
      ## If it's a later one, just incorporate into the object
      mean_run_time <- as.numeric(end_time - start_time) / progress
      
      ## Calculate how far we've come 
      percent <- round(progress/length(files) * 100, 1)
      
      ## Calculate how much time is remaining 
      remaining_time <- round((mean_run_time * (length(files) - progress)), 1)
      
      ## Output our progress report
      paste0(percent, "% Completed at ", Sys.time(), " || Estimated Time Remaining: ", remaining_time, " minutes") %>%
        print()
    }
  }
}

# Separating Our Cope Strings
{
  ## Extracting PID
  df$PID <- str_extract_all(string = df$Cope,
                            pattern = "^sub\\-[0-9][0-9][0-9][0-9]") %>%
            unlist()
  
  ## Extracting Run
  df$Run <- str_extract_all(string = df$Cope,
                            pattern = "run-[1-2]") %>%
            unlist()
  
  ## Extracting Parcels
  df$Parcels <- str_extract_all(string = df$Cope,
                                pattern = "parcels-[0-9][0-9][0-9]") %>%
                unlist()
  
  ## Extracting Networks
  df$Networks <- str_extract_all(string = df$Cope,
                                 pattern = "networks-[0-9][0-9]") %>%
                 unlist()
  
  ## Extracting Cope
  df$Minute <- str_extract_all(string = df$Cope,
                                 pattern = "cope-[0-9]|cope-[0-9][0-9]") %>%
                 unlist()

  ## Extracting ROI 
  df$ROI <- str_replace_all(string = df$Cope,
                            pattern = "^sub-[0-9][0-9][0-9][0-9]_run-[1-2]_roi-",
                            replacement = "") %>%
            str_replace_all(pattern = "_networks-[0-9][0-9]_parcels-[0-9][0-9][0-9]$",
                            replacement = "") 
  
  ## Removing the superfluous Cope column
  df <- df[,-which(names(df) == "Cope")]
}

# Exporting Our Data Frames
{ 
  write.csv(as.data.frame(df_empty), paste0("/data/Uncertainty/df_", PID,"_empty.csv"))
  write.csv(as.data.frame(df), paste0("/data/Uncertainty/df_", PID,".csv"))
}