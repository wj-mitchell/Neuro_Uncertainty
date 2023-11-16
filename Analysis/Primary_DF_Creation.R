## Loading packages
pacman::p_load(here, lme4, lmerTest, tidyverse)

## Adding custom function
source("https://raw.githubusercontent.com/wj-mitchell/neuRotools/main/cormat_long.R", local= T)
source("https://raw.githubusercontent.com/wj-mitchell/Neuro_Uncertainty/main/Scripts/Sliding_Window_Cor.R?token=GHSAT0AAAAAACJC62QPRN5K3APIPOMFHWJIZKWTFHA", local= T)

## Establishing working directory
here()

## Has the dataframe been created already?
df_created = TRUE

## Create the original correlation dataframe
if (df_created == FALSE){
 
  
  ## Creating an array of the files to be loaded
  files <- list.files("data/AvgROI/", 
                      full.names = TRUE)
  
  ## Creating a null array to house PIDs
  PIDs <- NULL
  
  ## Iterating through each of these files
  for (FILE in 1:length(files)){
    
    ## Reading in the data for this iteration
    df_ <- read.csv(files[FILE])
    
    ## Identifying the Participant ID for this file 
    PID <- sub(".*/sub-(\\d+)_.*", "\\1", files[FILE])
    
    ## If the PID isn't present in the PIDs array
    if (all(PIDs != PID)){
      
      ## add the PID to the array
      PIDs <- c(PIDs, PID)
    }
    
    ## Identifying the Run for this participant
    Run <- sub(".*/sub-\\d+_(run-\\d+)_.*", "\\1", files[FILE])
    
    ## Renaming the column headers
    names(df_) <- paste0("sub-", PID, "_", Run, "_ROI-",1:ncol(df_))
    
    # If the participant's file has 759 datapoints 
    if (nrow(df_) == 759){
      
      # Create an onset sequence that removes the first 90 and last 90 seconds, plus the 17 second buffer
      df_ <- df_[(1 + 45 + 9):(nrow(df_) - 45),]
    }
    
    # If the participant's file has 729 datapoints
    if (nrow(df_) == 729){
      
      # Create an onset sequence that removes the first 60 and last 60 seconds, plus the 17 second buffer
      df_ <- df_[(1 + 30 + 9):(nrow(df_) - 30),]
    }
    
    ## If this is the first file
    if (FILE == 1){
      
      ## Make it the standard
      df <- df_
    }
    
    ## If it's a later file
    if (FILE > 1){
      
      ## Bind the columns together
      df <- cbind(df, df_)
    }
  }
  
  ## Cleaning the space
  rm(Run, PID, files, FILE, df_)
  
  ## Iterating through each run
  for (RUN in 1:2) {
    
    ## and iterating through each of the ROIs
    for (ROI in 1:400){
      
      ## Generating correlations for each run and ROI
      df_cor_ <- grep(pattern = paste0("run-", RUN, "_ROI-", ROI, "$"),
                      x = names(df), 
                      value = TRUE) %>%
        df[,.] %>%
        cormat_long()
      
      ## If this is the first iteration
      if (RUN == 1 & ROI == 1){
        
        ## Make the generated dataframe the standard
        df_cor <- df_cor_
      }
      
      ## If this is a later iteration
      if (RUN != 1 | ROI != 1){
        
        ## Bind the rows together
        df_cor <- rbind(df_cor,
                        df_cor_)
      }
    }
  }
  
  ## Cleaning Our Space
  rm(df_cor_, ROI, RUN)
  
  ## Separating the columns 
  df_cor <- df_cor %>%
    separate(var1, into = c("PID1", "run", "ROI"), sep = "_") %>%
    separate(var2, into = c("PID2", "run", "ROI"), sep = "_")
  
  ## Saving my progress
  write.csv(df_cor, "/Helion_Group/studies/uncertainty/studies_neuro/data/df_cor_AvgROI.csv") 
}

## Reading in neural correaltion data
df_cor <- read.csv(paste0(here(), "/Github/Neuro_Uncertainty/Analysis/data/df_cor_AvgROI.csv"),
                          row.names = 1, 
                          stringsAsFactors = T)

## Reading in other data
df_cor_SH <- read.csv("S:/Helion_Group/studies/uncertainty/studies_neuro/analysis/corabs_behav_SH.csv",row.names = 1, stringsAsFactors = T)
df_cor_FH <- read.csv("S:/Helion_Group/studies/uncertainty/studies_neuro/analysis/corabs_behav_FH.csv",row.names = 1, stringsAsFactors = T)

## Replacing SR with sub for consistency
df_cor_FH$var1 <-str_replace_all(string = df_cor_FH$var1,
                                 pattern = "^SR",
                                 replacement = "sub")
df_cor_FH$var2 <-str_replace_all(string = df_cor_FH$var2,
                                 pattern = "^SR",
                                 replacement = "sub")
df_cor_SH$var1 <-str_replace_all(string = df_cor_SH$var1,
                                 pattern = "^SR",
                                 replacement = "sub")
df_cor_SH$var2 <-str_replace_all(string = df_cor_SH$var2,
                                 pattern = "^SR",
                                 replacement = "sub")

## Creating an Empty Array of Behavioral Correlations
df_cor$cor_behav <- NA

## Iterating through every combination of PIDs in condition A
for (ROW in 1:nrow(df_cor_FH)){
  
  ## Noting the First and Second IDs
  PID1 <- df_cor_FH$var1[ROW]
  PID2 <- df_cor_FH$var2[ROW]
  
  ## Identifying which columns in the df_cor have values from these participants
  df_cor$cor_behav[((df_cor$PID1 == PID1 & df_cor$PID2 == PID2) | 
                     (df_cor$PID1 == PID2 & df_cor$PID2 == PID1)) & df_cor$run == "run-1"] <- df_cor_FH$value[ROW]
}

## Iterating through every combination of PIDs in condition B
for (ROW in 1:nrow(df_cor_SH)){
  
  ## Noting the First and Second IDs
  PID1 <- df_cor_SH$var1[ROW]
  PID2 <- df_cor_SH$var2[ROW]
  
  ## Identifying which columns in the df_cor have values from these participants
  df_cor$cor_behav[((df_cor$PID1 == PID1 & df_cor$PID2 == PID2) | 
                      (df_cor$PID1 == PID2 & df_cor$PID2 == PID1)) & df_cor$run == "run-2"] <- df_cor_SH$value[ROW]
}

## Omitting datapoints without behavioral correlations
df_cor <- df_cor[!is.na(df_cor$cor_behav),]

## Cleaning our space
rm(df_cor_SH, df_cor_FH, ROW, PID1, PID2)

## Checking ICC
performance::icc(lmer(cor_behav ~ (1|PID1), 
                      data = df_cor))

performance::icc(lmer(cor_behav ~ (ROI|PID1), 
                      data = df_cor))

performance::icc(lmer(cor_behav ~ (1|PID1) + (1|PID2), 
                      data = df_cor))

performance::icc(lmer(cor_behav ~ (ROI|PID1) + (ROI|PID2), 
                      data = df_cor))

## Running an analysis
m1 <- lmer(cor_behav ~ value * ROI + (1|PID1) + (1|PID2), 
           data = df_cor)
summary(m1)


df_temp<- df_cor[df_cor$ROI == unique(df_cor$ROI)[200],]
