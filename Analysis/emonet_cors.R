# Loading Packages
library(tidyverse)

# Loading Data
df_behav <- read.csv("S:/Helion_Group/studies/uncertainty/studies_neuro/analysis/df_behav_.csv",
                     row.names = 1)
df_qualtrics <- read.csv("S:/Helion_Group/studies/uncertainty/studies_neuro/analysis/df_qualtrics.csv", 
                         row.names = 1) %>%
                subset(select = c(PID, TheoryMid, TheoryEnd))

# Merging Data
df <- merge(df_behav,
            df_qualtrics,
            by = "PID")

# Cleaning Space
rm(df_behav, df_qualtrics)

# Subsetting By Condition
df_a_Jon <- subset(df, 
                   df$Condition == "A" & df$TheoryMid == "Jonathan Fraser", 
                   select = c("PID", "CertRate", "SecondEnd")) %>%
            pivot_wider(names_from = PID, values_from = CertRate)
             

df_a_NoJon <- subset(df, 
                     df$Condition == "A" & df$TheoryMid != "Jonathan Fraser", 
                     select = c("PID", "CertRate", "SecondEnd")) %>%
              pivot_wider(names_from = PID, values_from = CertRate)

df_b_Jon <- subset(df, 
                   df$Condition == "B" & df$TheoryMid == "Jonathan Fraser", 
                   select = c("PID", "CertRate", "SecondEnd")) %>%
             pivot_wider(names_from = PID, values_from = CertRate)

df_b_NoJon <- subset(df, 
                     df$Condition == "B" & df$TheoryMid != "Jonathan Fraser", 
                     select = c("PID", "CertRate", "SecondEnd")) %>%
              pivot_wider(names_from = PID, values_from = CertRate)

# Removing PIDs lacking useable data
{remove <- NULL
for (PID in 2:ncol(df_a_Jon)){
  if (sum(df_a_Jon[,PID]) == 0){
    remove <- c(remove, PID)
  }
}
if (!is.null(remove)){
  df_a_Jon <- df_a_Jon[,-remove]
}

remove <- NULL
for (PID in 2:ncol(df_a_NoJon)){
  if (sum(df_a_NoJon[,PID]) == 0){
    remove <- c(remove, PID)
  }
}
if (!is.null(remove)){
  df_a_NoJon <- df_a_NoJon[,-remove]
}

remove <- NULL
for (PID in 2:ncol(df_b_Jon)){
  if (sum(df_b_Jon[,PID]) == 0){
    remove <- c(remove, PID)
  }
}
if (!is.null(remove)){
  df_b_Jon <- df_b_Jon[,-remove]
}

remove <- NULL
for (PID in 2:ncol(df_b_NoJon)){
  if (sum(df_b_NoJon[,PID]) == 0){
    remove <- c(remove, PID)
  }
}
if (!is.null(remove)){
  df_b_NoJon <- df_b_NoJon[,-remove]
}
}

# Calculating the average at each timepoint
df_a_Jon$Average <- NA
df_a_NoJon$Average <- NA
df_b_Jon$Average <- NA
df_b_NoJon$Average <- NA
for (OBS in 1:nrow(df_a_Jon)){
  df_a_Jon$Average[OBS] <- mean(as.numeric(df_a_Jon[OBS,2:ncol(df_a_Jon)]), na.rm = T)
  df_a_NoJon$Average[OBS] <- mean(as.numeric(df_a_NoJon[OBS,2:ncol(df_a_NoJon)]), na.rm = T)
  df_b_Jon$Average[OBS] <- mean(as.numeric(df_b_Jon[OBS,2:ncol(df_b_Jon)]), na.rm = T)
  df_b_NoJon$Average[OBS] <- mean(as.numeric(df_b_NoJon[OBS,2:ncol(df_b_NoJon)]), na.rm = T)
}

# Concatenating to a New Dataframe
df_a <- as.data.frame(list(df_a_Jon$SecondEnd,
                         df_a_Jon$Average, 
                         df_a_NoJon$Average),
                    col.names = c("time", "a_Jon", "a_NoJon"))

df_b <- as.data.frame(list(df_b_Jon$SecondEnd,
                           df_b_Jon$Average, 
                           df_b_NoJon$Average),
                      col.names = c("time", "b_Jon", "b_NoJon"))

# Cleaning Space
rm(df, df_a_Jon, df_a_NoJon, df_b_Jon, df_b_NoJon, OBS, PID, remove)

# Loading EmoNet Data
df_EmoNet1 <- read.csv("S:/Helion_Group/studies/EmoNet_Projects/Uncertainty/Uncertainty-First-EmoNet-Scores.csv") %>%
              pivot_wider(names_from = EmotionCategory, values_from = Probability)
df_EmoNet2 <- read.csv("S:/Helion_Group/studies/EmoNet_Projects/Uncertainty/Uncertainty-Last-EmoNet-Scores.csv") %>%
              pivot_wider(names_from = EmotionCategory, values_from = Probability)

# Adding time
df_EmoNet1$time <- NA
for (OBS in 1:nrow(df_EmoNet1)){
  df_EmoNet1$time[OBS] <- ceiling((1337/nrow(df_EmoNet1)) * OBS)
}

df_EmoNet2$time <- NA
for (OBS in 1:nrow(df_EmoNet2)){
  df_EmoNet2$time[OBS] <- ceiling((1337/nrow(df_EmoNet2)) * OBS)
}

# Removing excluded observations
df_EmoNet1 <- subset(df_EmoNet1, df_EmoNet1$time > 17)
df_EmoNet2 <- subset(df_EmoNet2, df_EmoNet2$time > 17)

# Revising time to match TR granularity
for (TR in 0:(((1337 - 17)/2)-1)){
  df_EmoNet1$time[df_EmoNet1$time > (TR * 2) + 17 &
                  df_EmoNet1$time <= ((TR + 1) * 2) + 17] <- ((TR + 1) * 2) + 17
  df_EmoNet2$time[df_EmoNet2$time > (TR * 2) + 17 &
                  df_EmoNet2$time <= ((TR + 1) * 2) + 17] <- ((TR + 1) * 2) + 17
}

# Calculating Averages
df_EmoNet1 <- df_EmoNet1[,-1] %>%
              group_by(time) %>%
              mutate(Adoration = mean(Adoration),              
                     `Aesthetic Appreciation`= mean(`Aesthetic Appreciation`),
                     Amusement = mean(Amusement),              
                     Anxiety = mean(Anxiety),               
                     Awe = mean(Awe),                   
                     Boredom = mean(Boredom),                
                     Confusion = mean(Confusion),              
                     Craving = mean(Craving),               
                     Disgust = mean(Disgust),                
                     `Empathic Pain` = mean(`Empathic Pain`),          
                     Entrancement = mean(Entrancement),          
                     Excitement = mean(Excitement),             
                     Fear = mean(Fear),                   
                     Horror = mean(Horror),                
                     Interest = mean(Interest),               
                     Joy = mean(Joy),                   
                     Romance = mean(Romance),               
                     Sadness = mean(Sadness),                
                     `Sexual Desire` = mean(`Sexual Desire`),          
                     Surprise = mean(Surprise)) %>%
              distinct()

df_EmoNet2 <- df_EmoNet2[,-1] %>%
              group_by(time) %>%
              mutate(Adoration = mean(Adoration),              
                     `Aesthetic Appreciation`= mean(`Aesthetic Appreciation`),
                     Amusement = mean(Amusement),              
                     Anxiety = mean(Anxiety),               
                     Awe = mean(Awe),                   
                     Boredom = mean(Boredom),                
                     Confusion = mean(Confusion),              
                     Craving = mean(Craving),               
                     Disgust = mean(Disgust),                
                     `Empathic Pain` = mean(`Empathic Pain`),          
                     Entrancement = mean(Entrancement),          
                     Excitement = mean(Excitement),             
                     Fear = mean(Fear),                   
                     Horror = mean(Horror),                
                     Interest = mean(Interest),               
                     Joy = mean(Joy),                   
                     Romance = mean(Romance),               
                     Sadness = mean(Sadness),                
                     `Sexual Desire` = mean(`Sexual Desire`),          
                     Surprise = mean(Surprise)) %>%
              distinct()

# Merging Dataframes
df_a <- merge(df_a,
              df_EmoNet1,
              by = "time")

df_b <- merge(df_b,
              df_EmoNet2,
              by = "time")

# Cleaning Space
rm(df_EmoNet1, df_EmoNet2, TR)

emocols <- 4:ncol(df_a)
delay <- 0:23
corcols <- apply(expand.grid(list(c("a_", "b_"), c("Jon_", "NoJon_"), delay, "TR")), 
                 1, 
                 paste, 
                 collapse = "") %>%
           str_replace_all(pattern = " ", replacement = "")

df_Cor <- data.frame(matrix(data=NA, 
                            nrow = length(names(df_a[,emocols])), 
                            ncol = length(corcols),
                            dimnames = list(names(df_a[,emocols]),
                                            corcols)))

for (COND in c("a", "b")){
  for (THEORY in c("Jon", "NoJon")){
    for (DELAY in delay){
      for (EMOTION in 1:length(emocols)){
        if (COND == "a"){
          df_Cor[EMOTION,
                 str_detect(names(df_Cor),
                            pattern = paste0(COND,"_", THEORY, "_", DELAY,"TR"
                                             ))] <- cor(df_a[(1 + DELAY):nrow(df_a),str_detect(names(df_a),
                                                                         pattern = paste0(COND,"_", THEORY))],
                                                           df_a[1:(nrow(df_a) - DELAY),emocols[EMOTION]])
        }
        if (COND == "b"){
          df_Cor[EMOTION,
                 str_detect(names(df_Cor),
                            pattern = paste0(COND,"_", THEORY, "_", DELAY,"TR"
                            ))] <- cor(df_b[(1 + DELAY):nrow(df_b),str_detect(names(df_b),
                                                                              pattern = paste0(COND,"_", THEORY))],
                                       df_b[1:(nrow(df_b) - DELAY),emocols[EMOTION]])
        }
      }
    }
  }
}

delay_assess <- NULL
for (DELAY in delay){
  delay_assess[DELAY + 1] <- df_Cor[,str_detect(names(df_Cor),
                                                pattern = paste0(DELAY,"TR$"))] %>%
                                                abs() %>%
                                                as.matrix() %>%
                                                mean()
}

plot(x = 0:(length(delay_assess)-1), 
     y = delay_assess,
     xlab = "Lag in TRs",
     ylab = "Average R Value Across All Emotions")

print(paste0("The best performing lag over the 24TR-period assessed was :",
            (which(delay_assess == max(delay_assess)) - 1), " TRs (r =",
            max(delay_assess),")"))

df <- df_Cor[,str_detect(names(df_Cor),
                         pattern = paste0(14,"TR$"))]

df$a_Jon_14TR_abs <- abs(df$a_Jon_14TR)
df$a_NoJon_14TR_abs <- abs(df$a_NoJon_14TR)
df$b_Jon_14TR_abs <- abs(df$b_Jon_14TR)
df$b_NoJon_14TR_abs <- abs(df$b_NoJon_14TR)
df$Average <- NA
for (EMOTION in 1:nrow(df)){
  df$Average[EMOTION] <- df[EMOTION,5:8] %>%
                         as.matrix() %>%
                         mean()
}

write.csv(df, "S:/Helion_Group/studies/uncertainty/studies_neuro/analysis/emonet_behav_cor.csv")
