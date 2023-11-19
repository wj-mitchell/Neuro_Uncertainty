## Libraries
pacman::p_load(tidyverse)

# Loading the custom cleaning function
source("S:/Helion_Group/studies/uncertainty/studies_neuro/analysis/rucleaner.R")
source("https://raw.githubusercontent.com/wj-mitchell/neuRotools/main/cormat_long.R", local= T)

# Noting which directory the behavioral data is stored in
dir <-
  "S:/Helion_Group/studies/uncertainty/studies_neuro/data/task/"

## Has the dataframe been created already?
df_created = TRUE

## Has the vanilla correlation dataframe been created already?
dfcor_created = TRUE

## Has the absolute correlation dataframe been created already?
dfcorabs_created = FALSE

## Has the inflection correlation dataframe been created already?
dfcorinfl_created = FALSE

## Create the original dataframe
if (df_created == FALSE){
  
  # Noting the index number of all .csv files in the directory
  filenums <- grep(pattern = "*\\.csv",
                   x = list.files(path = dir))
  
  # Iterating through sequential integers up to the total number of .csvs
  # Taking this approach rather than using the index numbers directly makes
  # this code robust to any ordering changes that might occur in the files.
  # (i.e., if the .csv files were listed after the .txts for some reason,
  # the conditional statements binding the data together would get confused)
  for (i in 1:length(filenums)) {
    # Running the cleaner function for an individual file within the noted directory
    df_temp <- rucleaner(
      file = list.files(path = dir)[filenums[i]],
      dir = dir,
      unit_secs = 2,
      shave_secs = 17
    )
    
    # if this is the first file we're cleaning . . .
    if (i == 1) {
      # Make it the master dataframe
      df <- df_temp
      
      # Remove the temporary dataframe
      rm(df_temp)
    }
    
    # If this is not the first file we're cleaning . . .
    if (i != 1) {
      # Append it to the end of the master dataframe
      df <- rbind(df, df_temp)
      
      # Remove the temporary dataframe
      rm(df_temp)
      
    }
    
  }
  
  ## Creating a dataframe of only non-control raters 
  df_behav <- subset(
    df,
    df$Video != "StimVidControl.mp4" &
      df$Video != "StimVidControl_Undoing.mp4",
    select = c(PID, Condition, CertRate, CertRateVar, Video, SecondEnd)
  )
  
  ## Creating a dataframe of only first half raters 
  df_behav_FH <- subset(
    df,
    df$Video != "StimVidControl.mp4" &
      df$Video != "StimVidControl_Undoing.mp4" &
      df$Condition == "A",
    select = c(PID, Condition, CertRate, CertRateVar, Video, SecondEnd)
  )
  
  ## Creating a dataframe of only second half raters 
  df_behav_SH <- subset(
    df,
    df$Video != "StimVidControl.mp4" &
      df$Video != "StimVidControl_Undoing.mp4" &
      df$Condition == "B",
    select = c(PID, Condition, CertRate, CertRateVar, Video, SecondEnd)
  )
  
  ## Creating a dataframe of only control raters 
  df_behav_CTRL <- subset(
    df,
    df$Video == "StimVidControl.mp4" |
      df$Video == "StimVidControl_Undoing.mp4",
    select = c(PID, Condition, CertRate, CertRateVar, Video, SecondEnd)
  )
  
  ## Creating a group-level dataframe
  df_behav_group <- df_behav %>%
                    group_by(PID) %>%
                    mutate(cert_mean = mean(abs(CertRate)),
                           certvar_sum = sum(CertRateVar)) %>%
                    .[, -c(3:4,6)] %>%
                    distinct()
  
  df_behav_group$cert_end <-  abs(df_behav$CertRate[df_behav$SecondEnd == 1337]) 
  
  ## Exporting these dataframes
  write.csv(
    df_behav_FH,
    "S:/Helion_Group/studies/uncertainty/studies_neuro/analysis/df_behav_FH.csv"
  )
  write.csv(
    df_behav_SH,
    "S:/Helion_Group/studies/uncertainty/studies_neuro/analysis/df_behav_SH.csv"
  )
  write.csv(
    df_behav_CTRL,
    "S:/Helion_Group/studies/uncertainty/studies_neuro/analysis/df_behav_CTRL.csv"
  )
  write.csv(
    df_behav_group,
    "S:/Helion_Group/studies/uncertainty/studies_neuro/analysis/df_behav_group.csv"
  )
}

## Read in the dataframe
if (df_created == TRUE){
  
  ## Reading in data
  df_behav_CTRL <- read.csv("S:/Helion_Group/studies/uncertainty/studies_neuro/analysis/df_behav_CTRL.csv", row.names = 1)
  df_behav_FH <- read.csv("S:/Helion_Group/studies/uncertainty/studies_neuro/analysis/df_behav_FH.csv", row.names = 1)
  df_behav_SH <- read.csv("S:/Helion_Group/studies/uncertainty/studies_neuro/analysis/df_behav_SH.csv", row.names = 1)
  
}

## Create the vanilla correlation dataframe
if (dfcor_created == FALSE){

  ## Pivoting our control dataframes
  cor_behav_CTRL <- df_behav_CTRL %>%
                    subset(select = c("PID", "CertRate", "SecondEnd")) %>%
                    pivot_wider(names_from = PID,
                                values_from = CertRate) %>%
                    na.omit %>%
                    .[,-1] %>%
                    cormat_long()
  
  ## Pivoting our first half dataframes
  cor_behav_FH <- df_behav_FH %>%
                    subset(select = c("PID", "CertRate", "SecondEnd")) %>%
                    pivot_wider(names_from = PID,
                                values_from = CertRate) %>%
                    na.omit %>%
                    .[,-1] %>%
                    cormat_long()
  
  ## Pivoting our second half dataframes
  cor_behav_SH <- df_behav_SH %>%
                  subset(select = c("PID", "CertRate", "SecondEnd")) %>%
                  pivot_wider(names_from = PID,
                              values_from = CertRate) %>%
                  na.omit %>%
                  .[,-1] %>%
                  cormat_long()
  
  ## Exporting these dataframes
  write.csv(
    cor_behav_FH,
    "S:/Helion_Group/studies/uncertainty/studies_neuro/analysis/cor_behav_FH.csv"
  )
  write.csv(
    cor_behav_SH,
    "S:/Helion_Group/studies/uncertainty/studies_neuro/analysis/cor_behav_SH.csv"
  )
  write.csv(
    cor_behav_CTRL,
    "S:/Helion_Group/studies/uncertainty/studies_neuro/analysis/cor_behav_CTRL.csv"
  )
}

## Create the vanilla correlation dataframe
if (dfcorabs_created == FALSE){
  
  ## Pivoting our control dataframes
  corabs_behav_CTRL <- df_behav_CTRL %>%
    subset(select = c("PID", "CertRate", "SecondEnd")) %>%
    mutate(CertRate = abs(CertRate)) %>%
    pivot_wider(names_from = PID,
                values_from = CertRate) %>%
    na.omit %>%
    .[,-1] %>%
    cormat_long()
  
  ## Pivoting our first half dataframes
  corabs_behav_FH <- df_behav_FH %>%
    subset(select = c("PID", "CertRate", "SecondEnd")) %>%
    mutate(CertRate = abs(CertRate)) %>%
    pivot_wider(names_from = PID,
                values_from = CertRate) %>%
    na.omit %>%
    .[,-1] %>%
    cormat_long()
  
  ## Pivoting our second half dataframes
  corabs_behav_SH <- df_behav_SH %>%
    subset(select = c("PID", "CertRate", "SecondEnd")) %>%
    mutate(CertRate = abs(CertRate)) %>%
    pivot_wider(names_from = PID,
                values_from = CertRate) %>%
    na.omit %>%
    .[,-1] %>%
    cormat_long()
  
  ## Exporting these dataframes
  write.csv(
    corabs_behav_FH,
    "S:/Helion_Group/studies/uncertainty/studies_neuro/analysis/corabs_behav_FH.csv"
  )
  write.csv(
    corabs_behav_SH,
    "S:/Helion_Group/studies/uncertainty/studies_neuro/analysis/corabs_behav_SH.csv"
  )
  write.csv(
    corabs_behav_CTRL,
    "S:/Helion_Group/studies/uncertainty/studies_neuro/analysis/corabs_behav_CTRL.csv"
  )
}
