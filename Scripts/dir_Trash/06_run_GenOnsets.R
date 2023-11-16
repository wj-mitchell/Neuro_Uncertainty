# Calling our custom functions
source("https://github.com/wj-mitchell/neuRotools/blob/main/GenOnsets.R?raw=TRUE")

# Calling the tidyverse package
library(tidyverse)

# Setting our working directory
setwd("/data/Uncertainty/scripts/")

# Noting our participant IDs
PIDs <- read.table("Participants.txt")[,1] %>%
        sprintf("%04d",.)

# Generating Our Onset Files
GenOnsets(PIDs = PIDs,
          Method = "Inflections",
          Suffix = "ParaMod-T_Method-Inflections_Buffer-10s_Smoothing-T_Threshold-2.5_Offset-0")