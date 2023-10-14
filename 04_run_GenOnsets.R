# Calling our custom functions
source("https://github.com/wj-mitchell/neuRotools/blob/main/GenOnsets.R?raw=TRUE")

# Calling the tidyverse package
library(tidyverse)

# Setting our working directory
setwd("/data/Uncertainty/scripts/")

# Noting our participant IDs
PIDs <- read.table("00_condA.txt")[,1] %>%
        sprintf("%04d",.)

# Generating Our Onset Files
GenOnsets(PIDs = PIDs,
          Tasks = "3_task-1",
          Method = "Inflections",
          Components = "Test",
          LowPass = T,
          Suffix = "LowPass")

GenOnsets(PIDs = PIDs,
          Tasks = "3_task-1",
          Method = "Inflections",
          Components = "Test",
          Override = 1,
          LowPass = T,
          Suffix = "LowPass")

# Setting our working directory
setwd("/data/Uncertainty/scripts/")

# Noting our participant IDs
PIDs <- read.table("00_condB.txt")[,1] %>%
  sprintf("%04d",.)

# Generating Our Onset Files
GenOnsets(PIDs = PIDs,
          Tasks = "5_task-2",
          Method = "Inflections",
          Components = "Test",
          LowPass = T,
          Suffix = "LowPass")

GenOnsets(PIDs = PIDs,
          Tasks = "5_task-2",
          Method = "Inflections",
          Components = "Test",
          Override = 1,
          LowPass = T,
          Suffix = "LowPass")
