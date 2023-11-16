# Calling our custom functions
source("https://github.com/wj-mitchell/neuRotools/blob/main/GenOnsets.R?raw=TRUE")

# Calling the tidyverse package
library(tidyverse)

# Setting our working directory
setwd("/data/Uncertainty/scripts/")

# Noting our participant IDs
PIDs <- read.table("Participants.txt")[,1] %>%
        sprintf("%04d",.)

# # Create an onset file for the shaved period we won't be modeling 
# for (PID in PIDs){
#         write.table(data.frame(x=60, 
#                                y=17,
#                                z=1),
#                         paste0("/data/Uncertainty/data/deriv/pipeline_1/fmriprep/sub-", PID, "/onset/sub-", PID, "_task-uncertainty_Shaved_timing.txt"),
#                         sep = "\t",
#                         row.names = FALSE,
#                         col.names = FALSE)
# }

# Iterating through the different possible times at which we could specify trial length
for (TIME in c(20, 30, 40, 60)){

# # Generating onset files for those participants

#         # Using Parametric Modulation and Z-scored Ratings
#         GenOnsets(PIDs = PIDs,
#                   Trials = 1320 / TIME,
#                   Trial_Length = TIME,
#                   ParaMod = T,
#                   ParaMod_Diff = F,
#                   Shaved = F,                  
#                   Suffix = paste0("_ParaMod-T_ParaModDiff-F_TrialLength-",TIME))
        
#         # Sorting the Parametrically Modulated Results in Condition Onsets W/O Parametric Modulation
#         ConditionSorter(PIDs = PIDs,
#                         Suffix = paste0("_ParaMod-T_ParaModDiff-F_TrialLength-",TIME))

        # Using Parametric Modulation and Change in Rating
        GenOnsets(PIDs = PIDs,
                  Trials = 1320 / TIME,
                  Trial_Length = TIME,
                  ParaMod = T,
                  ParaMod_Diff = T,
                  Shaved = F,                  
                  Suffix = paste0("_ParaMod-T_ParaModDiff-T_TrialLength-",TIME))

#         # Using No Parametric Modulation
#         GenOnsets(PIDs = PIDs,
#                   Trials = 1320 / TIME,
#                   Trial_Length = TIME,
#                   ParaMod = F,
#                   ParaMod_Diff = F,
#                   Shaved = F,    
#                   Suffix = paste0("_ParaMod-F_ParaModDiff-F_TrialLength-",TIME))
}

# Using Parametric Modulation and Change in Rating
GenOnsets(PIDs = PIDs,
                Trials = 1320 / 20,
                Trial_Length = 20,
                ParaMod = T,
                ParaMod_Scale = F,
                ParaMod_Diff = T,
                ParaMod_Offset = T,
                ParaMod_OffsetLength = 1,
                Shaved = F,                  
                Suffix = paste0("_ParaMod-T_ParaModDiff-T_ParaModScale-F_ParaModOffset-1_TrialLength-",20))