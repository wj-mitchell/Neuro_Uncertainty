# Loading the custom cleaning function
source("/data/Uncertainty/scripts/08_script_BehavCleaner.R")

# Noting which directory the behavioral data is stored in
dir <- "/data/Uncertainty/data/behav/"

# Noting the index number of all .csv files in the directory
filenums <- grep(pattern = "*\\.csv", 
                 x = list.files(path = dir))

# Iterating through sequential integers up to the total number of .csvs
# Taking this approach rather than using the index numbers directly makes
# this code robust to any ordering changes that might occur in the files.
# (i.e., if the .csv files were listed after the .txts for some reason,
# the conditional statements binding the data together would get confused)
for (i in 1:length(filenums)){
  
  # Running the cleaner function for an individual file within the noted directory
   df_temp <- BehavCleaner(file = list.files(path = dir)[filenums[i]],
                        dir = dir,
                        unit_secs = 60,
                        shave_secs = 17)

  # 
  EV_File <- subset(df_temp)   
}
