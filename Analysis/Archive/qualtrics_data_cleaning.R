library(tidyverse)

# Loading data ----
df <- read.csv(file = "S:/Helion_Group/studies/uncertainty/studies_neuro/data/qualtrics/qualtrics.csv",
               header = T,
               na.strings = c("","NA","na"))

df_retro <- read.csv(file = "S:/Helion_Group/studies/uncertainty/studies_neuro/data/qualtrics/qualtrics_retroactive.csv",
               header = T,
               na.strings = c("","NA","na")) 

# Cleaning Retro Data ----
df_retro$PID <- as.numeric(df_retro$PID)
df_retro <- df_retro %>%
            subset(!is.na(.$SCCS_Q01) & 
                   !is.na(.$PID) &   
                   .$PID != "9999")

# Converting PIDs ----

# An array of the original IDs
PID_Original <- c("SR-0035", "SR-6021", "SR-4590", "SR-6943", "SR-6977",
                  "SR-5006", "SR-8746", "SR-6799", "SR-0757", "SR-3046",
                  "SR-9827", "SR-3011", "SR-2758", "SR-6971", "SR-7492",
                  "SR-6773", "SR-9907", "SR-6269", "SR-3801", "SR-7255",
                  "SR-8607", "SR-4781", "SR-2610", "SR-3951", "SR-1371",
                  "SR-3274", "SR-8929")

# An array of the recontact IDs
PID_Recontact <- c(2129, 5304, 1617, 2447, 4712,
                   3831, 8140, 2838, 4285, 5259,
                   3725, 7252, 2798, 1279, 9680,
                   8264, 7930, 8600, 4185, 9371,
                   6543, 4108, 6965, 2588, 3240,
                   1630, 2056)

# Iterating through each row of the recontact dataframe
for (ROW in 1:length(PID_Original)){
  
  # and overwriting the recontact PID with its corresponding original PID
  df_retro$PID[df_retro$PID == PID_Recontact[ROW]] <- PID_Original[ROW] 
}

# Removing bloat rows ----
df <- df[-c(1,2),]

# Removing bloat columns ----
df <- subset(df, select = -c(EndDate, Status, IPAddress, Finished,
                             RecordedDate, ResponseId, RecipientLastName,
                             RecipientFirstName, RecipientEmail, ExternalReference,
                             LocationLatitude, LocationLongitude, DistributionChannel,
                             UserLanguage))

# Correcting column name ----
colnames(df)[which(colnames(df) == "Duration..in.seconds.")] <- "Dur_secs"

# Merging Retro Data with Standard Data ----
for (PID in unique(df_retro$PID)){
  df[df$PID == PID, grep("SCC.*|OCI.*", names(df))] <- df_retro[df_retro$PID == PID, grep("SCC.*|OCI.*", names(df_retro))]
}

rm(df_retro)

## SCORING BDI ----
# I know I've found more eloquent ways to assign numeric values to categorical variables in the past, but this'll have to do the trick now.
# Assigning Numeric Values to BDI Responses ----
df$BDI_01[df$BDI_01 == "I do not feel sad."] <- 0
df$BDI_01[df$BDI_01 == "I feel sad."] <- 1
df$BDI_01[df$BDI_01 == "I am sad all the time and I can't snap out of it."] <- 2
df$BDI_01[df$BDI_01 == "I am so sad and unhappy that I can't stand it."] <- 3
df$BDI_02[df$BDI_02 == "I am not particularly discouraged about the future."] <- 0
df$BDI_02[df$BDI_02 == "I feel discouraged about the future."]  <- 1
df$BDI_02[df$BDI_02 == "I feel I have nothing to look forward to."]  <- 2
df$BDI_02[df$BDI_02 == "I feel the future is hopeless and that things cannot improve."]  <- 3
df$BDI_03[df$BDI_03 == "I do not feel like a failure."] <- 0
df$BDI_03[df$BDI_03 == "I feel I have failed more than the average person."]  <- 1
df$BDI_03[df$BDI_03 == "As I look back on my life, all I can see is a lot of failures."]  <- 2
df$BDI_03[df$BDI_03 == "I feel I am a complete failure as a person."] <- 3
df$BDI_04[df$BDI_04 == "I am not particularly dissatisfied."] <- 0
df$BDI_04[df$BDI_04 == "I don't enjoy things the way I used to."] <- 1
df$BDI_04[df$BDI_04 == "I don't get satisfaction out of anything anymore."] <- 2
df$BDI_04[df$BDI_04 == "I am dissatisfied with everything."] <- 3
df$BDI_05[df$BDI_05 == "I don't feel particularly guilty."] <- 0
df$BDI_05[df$BDI_05 == "I feel guilty a good part of the time."] <- 1
df$BDI_05[df$BDI_05 == "I feel quite guilty most of the time."] <- 2
df$BDI_05[df$BDI_05 == "I feel guilty all of the time."] <- 3
df$BDI_06[df$BDI_06 == "I don't feel disappointed in myself."] <- 0
df$BDI_06[df$BDI_06 == "I am disappointed in myself."] <- 1
df$BDI_06[df$BDI_06 == "I am disgusted with myself."] <- 2
df$BDI_06[df$BDI_06 == "I hate myself."] <- 3
df$BDI_07[df$BDI_07 == "I have not lost interest in other people."] <- 0
df$BDI_07[df$BDI_07 == "I am less interested in other people than I used to be."] <- 1
df$BDI_07[df$BDI_07 == "I have lost most of my interest in other people."] <- 2
df$BDI_07[df$BDI_07 == "I have lost all of my interest in other people."] <- 3
df$BDI_08[df$BDI_08 == "I make decisions about as well as I ever could."] <- 0
df$BDI_08[df$BDI_08 == "I put off making decisions more than I used to."] <- 1
df$BDI_08[df$BDI_08 == "I have greater difficulty in making decisions more than I used to."] <- 2
df$BDI_08[df$BDI_08 == "I can't make any decisions at all anymore."] <- 3
df$BDI_09[df$BDI_09 == "I don't feel that I look any worse than I used to."] <- 0
df$BDI_09[df$BDI_09 == "I am worried that I am looking old or unattractive."] <- 1
df$BDI_09[df$BDI_09 == "I feel that there are permanent changes in my appearance and they make me look unattractive."] <- 2
df$BDI_09[df$BDI_09 == "I believe that I look ugly."] <- 3
df$BDI_10[df$BDI_10 == "I can work about as well as before."] <- 0
df$BDI_10[df$BDI_10 == "It takes extra effort to get started at doing something."] <- 1
df$BDI_10[df$BDI_10 == "I have to push myself very hard to do anything."] <- 2
df$BDI_10[df$BDI_10 == "I can't do any work at all."] <- 3
df$BDI_11[df$BDI_11 == "I don't get more tired than usual."] <- 0
df$BDI_11[df$BDI_11 == "I get tired more easily than I used to."] <- 1
df$BDI_11[df$BDI_11 == "I get tired from doing almost anything."] <- 2
df$BDI_11[df$BDI_11 == "I get too tired to do anything."] <- 3
df$BDI_12[df$BDI_12 == "My appetite is no worse than usual."] <- 0
df$BDI_12[df$BDI_12 == "My appetite is not as good as it used to be."] <- 1
df$BDI_12[df$BDI_12 == "My appetite is much worse now."] <- 2
df$BDI_12[df$BDI_12 == "I have no appetite at all anymore."] <- 3

# Restructuring BDI Variables as Numeric ----
BDI_Cols <- grep("BDI", colnames(df))
for (i in BDI_Cols){
  df[,i] <- as.numeric(df[,i])
}

# Calculating BDI ----
for (i in 1:length(rownames(df))){
  df$BDI_Total[i] <- sum(df[i,BDI_Cols])
}

# Removing BDI We No Longer Need ----
df <- df[,-BDI_Cols]
rm(BDI_Cols, i)

## SCORING IUS ----
# Assigning Numeric Values to IUS Responses ----
IUS_Cols <- grep("IUS", colnames(df))
for (i in IUS_Cols){
  for (j in 1:length(rownames(df))){
    if (df[j,i] == "Not at all characteristic of me" & !is.na(df[j,i]))
      df[j,i] <- 1
    if (df[j,i] == "A little characteristic of me" & !is.na(df[j,i]))
      df[j,i] <- 2
    if (df[j,i] == "Somewhat characteristic of me" & !is.na(df[j,i]))
      df[j,i] <- 3
    if (df[j,i] == "Very characteristic of me" & !is.na(df[j,i]))
      df[j,i] <- 4
    if (df[j,i] == "Entirely characteristic of me" & !is.na(df[j,i]))
      df[j,i] <- 5
  }
}

# Restructuring IUS Variables as Numeric ----
for (i in IUS_Cols){
  df[,i] <- as.numeric(df[,i])
}

# Calculating IUS ----
for (i in 1:length(rownames(df))){
  df$IUS_Total[i] <- sum(df[i,IUS_Cols])
  df$IUS_F1[i] <- sum(df[i,IUS_Cols[-c(4, 5, 6, 7, 8, 10, 11, 18, 19, 21, 26, 27)]])
  df$IUS_F2[i] <- sum(df[i,IUS_Cols[c(4, 5, 6, 7, 8, 10, 11, 18, 19, 21, 26, 27)]])
}

# Removing IUS We No Longer Need ----
df <- df[,-IUS_Cols]
rm(IUS_Cols, i, j)

## SCORING STAI ----
# Assigning Numeric Values to STAI Responses ----
STAI_Cols <- grep("STAI", colnames(df))
for (i in STAI_Cols){
  for (j in 1:length(rownames(df))){
    if (df[j,i] == "Not at all" & !is.na(df[j,i]))
      df[j,i] <- 1
    if (df[j,i] == "Somewhat" & !is.na(df[j,i]))
      df[j,i] <- 2
    if (df[j,i] == "Moderately so" & !is.na(df[j,i]))
      df[j,i] <- 3
    if (df[j,i] == "Very much so" & !is.na(df[j,i]))
      df[j,i] <- 4
  }
}

# Restructuring STAI Variables as Numeric ----
for (i in STAI_Cols){
  df[,i] <- as.numeric(df[,i])
}

# Reverse Scoring STAI ----
STAI_Cols.r <- STAI_Cols[c(1,2,5,8,10,11,15,16,19,20,21,26,27,30,31,35,36,39)]
for (i in STAI_Cols.r){
  df[,i] <- 5 - df[,i]
}

# Calculating STAI ----
for (i in 1:length(rownames(df))){
  df$STAI_State[i] <- sum(df[i, STAI_Cols[-c(1:20)]])
  df$STAI_Trait[i] <- sum(df[i, STAI_Cols[c(1:20)]])
}

# Removing STAI We No Longer Need ----
df <- df[,-STAI_Cols]
rm(STAI_Cols, STAI_Cols.r, i, j)

## SCORING PNS ----
# Assigning Numeric Values to PNS Responses ----
PNS_Cols <- grep("PNS", colnames(df))
for (i in PNS_Cols){
  for (j in 1:length(rownames(df))){
    if (df[j,i] == "Strongly disagree" & !is.na(df[j,i]))
      df[j,i] <- 1
    if (df[j,i] == "Moderately disagree" & !is.na(df[j,i]))
      df[j,i] <- 2
    if (df[j,i] == "Slightly disagree" & !is.na(df[j,i]))
      df[j,i] <- 3
    if (df[j,i] == "Slightly agree" & !is.na(df[j,i]))
      df[j,i] <- 4
    if (df[j,i] == "Moderately agree" & !is.na(df[j,i]))
      df[j,i] <- 5
    if (df[j,i] == "Strongly agree" & !is.na(df[j,i]))
      df[j,i] <- 6    
  }
}

# Restructuring PNS Variables as Numeric ----
for (i in PNS_Cols){
  df[,i] <- as.numeric(df[,i])
}

# Reverse Scoring PNS ----
PNS_Cols.r <- PNS_Cols[c(2,5,11)]
for (i in PNS_Cols.r){
  df[,i] <- 7 - df[,i]
}

# Calculating PNS ----
for (i in 1:length(rownames(df))){
  df$PNS_Total[i] <- sum(df[i,PNS_Cols])
}

# Removing PNS We No Longer Need ----
df <- df[,-PNS_Cols]
rm(PNS_Cols, PNS_Cols.r, i, j)

## SCORING NFCS ----
# Assigning Numeric Values to NFCS Responses ----
NFCS_Cols <- grep("NFCS", colnames(df))
for (i in NFCS_Cols){
  for (j in 1:length(rownames(df))){
    if (df[j,i] == "Strongly disagree" & !is.na(df[j,i]))
      df[j,i] <- 1
    if (df[j,i] == "Moderately disagree" & !is.na(df[j,i]))
      df[j,i] <- 2
    if (df[j,i] == "Slightly disagree" & !is.na(df[j,i]))
      df[j,i] <- 3
    if (df[j,i] == "Slightly agree" & !is.na(df[j,i]))
      df[j,i] <- 4
    if (df[j,i] == "Moderately agree" & !is.na(df[j,i]))
      df[j,i] <- 5
    if (df[j,i] == "Strongly agree" & !is.na(df[j,i]))
      df[j,i] <- 6    
  }
}

# Restructuring NFCS Variables as Numeric ----
for (i in NFCS_Cols){
  df[,i] <- as.numeric(df[,i])
}

# Calculating NFCS ----
for (i in 1:length(rownames(df))){
  df$NFCS_Total[i] <- sum(df[i,NFCS_Cols])
}

# Removing NFCS We No Longer Need ----
df <- df[,-NFCS_Cols]
rm(NFCS_Cols, i, j)

## SCORING SCCS ----
# Assigning Numeric Values to SCCS Responses ----
SCC_Cols <- grep("SCC", colnames(df))
for (i in SCC_Cols){
  for (j in 1:length(rownames(df))){
    if (df[j,i] == "Strongly disagree" & !is.na(df[j,i]))
      df[j,i] <- 1
    if (df[j,i] == "Somewhat disagree" & !is.na(df[j,i]))
      df[j,i] <- 2
    if (df[j,i] == "Neither agree nor disagree" & !is.na(df[j,i]))
      df[j,i] <- 3
    if (df[j,i] == "Somewhat agree" & !is.na(df[j,i]))
      df[j,i] <- 4
    if (df[j,i] == "Strongly agree" & !is.na(df[j,i]))
      df[j,i] <- 5  
  }
}

# Restructuring SCCS Variables as Numeric ----
for (i in SCC_Cols){
  df[,i] <- as.numeric(df[,i])
}

# Reverse Scoring PNS ----
SCC_Cols.r <- SCC_Cols[c(1,2,3,4,5,7,8,9,10,12)]
for (i in SCC_Cols.r){
  df[,i] <- 6 - df[,i]
}

# Calculating SCCS ----
for (i in 1:length(rownames(df))){
  df$SCC_Total[i] <- sum(df[i,SCC_Cols])
}

# Removing SCCS We No Longer Need ----
df <- df[,-SCC_Cols]
rm(SCC_Cols, i, j)

## SCORING OCI ----
# Assigning Numeric Values to OCI Responses ----
OCI_Cols <- grep("OCI", colnames(df))
for (i in OCI_Cols){
  for (j in 1:length(rownames(df))){
    if (df[j,i] == "Not at all" & !is.na(df[j,i]))
      df[j,i] <- 0
    if (df[j,i] == "A little" & !is.na(df[j,i]))
      df[j,i] <- 1
    if (df[j,i] == "Moderately" & !is.na(df[j,i]))
      df[j,i] <- 2
    if (df[j,i] == "A lot" & !is.na(df[j,i]))
      df[j,i] <- 3
    if (df[j,i] == "Extremely" & !is.na(df[j,i]))
      df[j,i] <- 4   
  }
}

# Restructuring OCI Variables as Numeric ----
for (i in OCI_Cols){
  df[,i] <- as.numeric(df[,i])
}

# Calculating OCI ----
for (i in 1:nrow(df)){
  df$OCI_Total[i] <- sum(df[i,OCI_Cols])
  df$OCI_OCD[i] <- sum(df[i,OCI_Cols[c(2,3,4,5,6,8,9,10,11,12,14,15,16,17,18)]])
  df$OCI_Hoarding[i] <- sum(df[i,OCI_Cols[c(1,7,13)]])
  df$OCI_Washing[i] <- sum(df[i,OCI_Cols[c(5,11,17)]])
  df$OCI_Obsessing[i] <- sum(df[i,OCI_Cols[c(6,12,18)]])
  df$OCI_Ordering[i] <- sum(df[i,OCI_Cols[c(3,9,15)]])
  df$OCI_Checking[i] <- sum(df[i,OCI_Cols[c(2,8,14)]])
  df$OCI_Neutralizing[i] <- sum(df[i,OCI_Cols[c(4,10,16)]])
}

# Removing OCI We No Longer Need ----
df <- df[,-OCI_Cols]
rm(OCI_Cols, i, j)

## CORRECTING ASSESSMENT NAMES ----
Assess_Cols <- grep("ChrAssess", colnames(df))
names <- NULL
for (CHARACTER in c("Grace", "Jonathan", "Franklin", "Fernando")){
  for (METRIC in c("Attractive", "Agency", "Agreeable", "Competence", "Conscientious", "Dominating", 
                   "Experienced", "Extraverted", "Intelligent", "Neurotic", "Open", "Trustworthy", "Warm")){
    names <- c(names, 
               paste("ChrAssess", CHARACTER, METRIC, sep = "_"))
  }
}

names(df)[Assess_Cols] <- names

write.csv(df, "S:/Helion_Group/studies/uncertainty/studies_neuro/analysis/df_qualtrics_.csv")
