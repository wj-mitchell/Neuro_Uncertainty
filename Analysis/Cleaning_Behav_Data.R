## Libraries
pacman::p_load(here,
               tidyverse)

# Loading the custom cleaning function
source("https://raw.githubusercontent.com/wj-mitchell/neuRotools/main/rucleaner.R", local = T)

# Noting which directory the behavioral data is stored in
DataDir <- "S:/Helion_Group/studies/uncertainty/studies_neuro/data/task/"

# Noting the index number of all .csv files in the directory
filenums <- grep(pattern = "*\\.csv",
                 x = list.files(path = DataDir))

# Iterating through sequential integers up to the total number of .csvs
# Taking this approach rather than using the index numbers directly makes
# this code robust to any ordering changes that might occur in the files.
# (i.e., if the .csv files were listed after the .txts for some reason,
# the conditional statements binding the data together would get confused)
for (i in 1:length(filenums)) {
  # Running the cleaner function for an individual file within the noted directory
  df_temp <- rucleaner(
    file = list.files(path = DataDir)[filenums[i]],
    dir = DataDir,
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
  paste0(here(), "/Data/df_behav.csv")
)
write.csv(
  df_behav_FH,
  paste0(here(), "/Data/df_behav_FH.csv")
)
write.csv(
  df_behav_SH,
  paste0(here(), "/Data/df_behav_SH.csv")
)
write.csv(
  df_behav_CTRL,
  paste0(here(), "/Data/df_behav_CTRL.csv")
)
write.csv(
  df_behav_group,
  paste0(here(), "/Data/df_behav_group.csv")
)