df <- read.csv("S:/Helion_Group/studies/uncertainty/studies_neuro/analysis/df_behav_.csv")


df <- subset(df, df$Video != "StimVidControl.mp4" & 
                 df$Video != "StimVidControl_Undoing.mp4") 

plot <- ggplot(data = df, aes(x = SecondEnd, 
                      y = CertRate, 
                      color = PID)) +
       geom_line(size = 1.5) +
       coord_cartesian(y = c(-100, 100)) +
       scale_color_discrete()+
       labs(title = "The Development of Certainty Over Time",
            subtitle = "Each line represents a different participant's certainty ratings over time",
            x = "Time in Seconds", 
            y ="Certainty of Target's Guilt / Innocence (Percentage)") +   
       theme_classic() +
       theme(legend.position = "none") +
       theme(plot.title = element_text(face = "bold", size = 8, hjust = 0.5)) +
       theme(plot.subtitle = element_text(size = 8, hjust = 0.5, face = "italic")) +
       theme(plot.caption = element_text(size = 4, hjust = 0.00, face = "italic")) +
       theme(axis.title = element_text(size = 10)) +
       theme(axis.text.x = element_text(size = 10, color = "Black")) +
       theme(axis.text.y = element_text(size = 10, color = "Black"))
plot

pdf("C:/Users/tui81100/Desktop/Visualization.pdf",
    width = 4*1.5, 
    height = 3*1.5)
plot
dev.off()

time <- sort(unique(df$SecondEnd))
var <- 1:660
for (SEC in time){
  var[(SEC-17) / 2] <- var(df$CertRate[df$SecondEnd == SEC])
}

plot <- ggplot(data = lol,
               aes(x = time, 
                   y = var)) +
  geom_line(size = 1.5) +
  # coord_cartesian(y = c(-100, 100)) +
  scale_color_discrete()+
  labs(title = "The Variance of Certainty Over Time",
       subtitle = "",
       x = "Time in Seconds", 
       y ="Variance in Certainty Ratings") +   
  theme_classic() +
  theme(legend.position = "none") +
  theme(plot.title = element_text(face = "bold", size = 8, hjust = 0.5)) +
  theme(plot.subtitle = element_text(size = 8, hjust = 0.5, face = "italic")) +
  theme(plot.caption = element_text(size = 4, hjust = 0.00, face = "italic")) +
  theme(axis.title = element_text(size = 10)) +
  theme(axis.text.x = element_text(size = 10, color = "Black")) +
  theme(axis.text.y = element_text(size = 10, color = "Black"))
plot

pdf("C:/Users/tui81100/Desktop/Visualization_variance.pdf",
    width = 4*1.5, 
    height = 3*1.5)
plot
dev.off()