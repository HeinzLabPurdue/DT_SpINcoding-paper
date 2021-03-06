rm(list = ls())
cat("\014")  

library(lme4)
library(car)

# Read data
VPdat <- read.table("../tables_for_stats/Fig2_VPprecision_Table.txt", header = TRUE)
VPdat$UnitID <- as.factor(VPdat$UnitID)
VPdat$HearingStatus <- as.factor(VPdat$HearingStatus)
#VPdat$WindowDur_ms <- as.factor(VPdat$WindowDur_ms)
VPdat$VPcost <- as.factor(VPdat$VPcost)
str(VPdat)

## Model 1 
m_vp <- lmer(VPdistance  ~ CF_Hz_log*HearingStatus + SRps + Rate + VPcost*HearingStatus + (1|UnitID), data=VPdat)
Anova(m_vp, test.statistic='F')
# summary(m_vp)
# anova(m_vp)