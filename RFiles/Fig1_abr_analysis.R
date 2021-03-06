rm(list = ls())
cat("\014")  

library(lme4)
library(car)

# Read data
ABRdata <- read.table("../tables_for_stats/Fig1_abr_data_all.txt", header = TRUE)

ABRdata$chinID <- as.factor(ABRdata$chinID)
ABRdata$hearing <- as.factor(ABRdata$hearing)
ABRdata$freq_kHz <- as.factor(ABRdata$freq_kHz)
str(ABRdata)

## Model 1 
m_abr <- lmer(abr_thresh  ~ freq_kHz * hearing + (1|chinID), data=ABRdata)
Anova(m_abr, test.statistic='F')
# summary(m_abr)
# anova(m_abr)