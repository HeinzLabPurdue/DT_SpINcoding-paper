rm(list = ls())
cat("\014")  

restrict <- function(f,minVal,maxVal){  
  f <- f[f$CF_kHz >= minVal,]
  f <- f[f$CF_kHz <= maxVal,]
  return(f)
}


library(lme4)
library(car)


# Read FFR data
print("--------------------- Working on FFR")
data_ffr <- read.table("../tables_for_stats/Fig6_FFR_s_all.txt", header = TRUE)
data_ffr$HearingStatus <- as.factor(data_ffr$HearingStatus)
data_ffr$ChinID <- as.factor(data_ffr$ChinID)
str(data_ffr)

m_FFR <- lmer(OnRate ~ HearingStatus + (1|ChinID), data=data_ffr)
Anova(m_FFR, test.statistic='F')
print("--------------------- Done with FFR")

# Read data
data_an <- read.table("../tables_for_stats/Fig6_AN_s_all.txt", header = TRUE)
str(data_an)
data_an$ChinID <- as.factor(data_an$ChinID)
data_an$HearingStatus<- as.factor(data_an$HearingStatus)
data_an$CF_kHz_log <- log(data_an$CF_kHz)

print("--------------------- Working on AN data")
print("Start: ------------- The effect of hearing loss") 

data_an_LF <- restrict(data_an, 0, 2.5)
data_an_HF <- restrict(data_an, 2.5, 8)

## Onset rate 
m_OR <- lm(OnRate ~ HearingStatus*CF_kHz_log, data=data_an)
Anova(m_OR, test.statistic='F')

# m_OR <- lmer(OnRate ~ HearingStatus*CF_kHz_log + (1|ChinID), data=data_an)
# Anova(m_OR, test.statistic='F')


## Driven rate 
m_DR <- lm(SusRate ~ HearingStatus*CF_kHz_log + SpontRate, data=data_an)
Anova(m_DR, test.statistic='F')

# m_DR <- lmer(SusRate ~ HearingStatus*CF_kHz_log + SpontRate + (1|ChinID), data=data_an)
# Anova(m_DR, test.statistic='F')

m_DR_LF <- lmer(SusRate ~ HearingStatus*CF_kHz_log + SpontRate + (1|ChinID), data=data_an_LF)

m_DR_HF <- lm(SusRate ~ HearingStatus*CF_kHz_log, data=data_an_HF)
Anova(m_DR_HF, test.statistic='F')

# m_DR_HF <- lmer(SusRate ~ HearingStatus*CF_kHz_log + (1|ChinID), data=data_an_HF)
# Anova(m_DR_HF, test.statistic='F')

m_OR_HF <- lmer(OnRate ~ HearingStatus*CF_kHz_log + (1|ChinID), data=data_an_HF)
Anova(m_OR_HF, test.statistic='F')

## Onset rate 
m_OR <- lm(OnRate_rel ~ HearingStatus*CF_kHz_log, data=data_an_HF)
Anova(m_OR, test.statistic='F')

# m_OR <- lmer(OnRate_rel ~ HearingStatus*CF_kHz_log + (1|ChinID), data=data_an_HF)
# Anova(m_OR, test.statistic='F')

## Driven rate 
m_DR <- lm(SusRate_rel ~ HearingStatus*CF_kHz_log, data=data_an_HF)
Anova(m_DR, test.statistic='F')

# m_DR <- lmer(SusRate_rel ~ HearingStatus*CF_kHz_log + (1|ChinID), data=data_an_HF)
# Anova(m_DR, test.statistic='F')
print("End: ------------- The effect of hearing loss") 

# print("Start : ------------- Factors contributing to coding deficit") 
# m_DR <- lmer(SusRate ~ thresh_dB*SpontRate + CF_kHz_log*SpontRate+ (1|ChinID), data=data_an)
# Anova(m_DR, test.statistic='F')