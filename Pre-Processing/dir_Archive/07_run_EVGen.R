# Loading the custom cleaning function
source("https://github.com/Wjpmitchell3/neuRotools/blob/main/EVGen.R?raw=TRUE")

# Calling the tidyverse package
library(tidyverse)

# Setting our working directory
setwd("/data/Uncertainty/scripts/")

# Noting our participant IDs
PIDs <- read.table("Participants.txt")[,1] %>%
        sprintf("%04d",.)

# Running the cleaner function for an individual file within the noted directory
df_temp <- EVGen(PIDs = PIDs)
