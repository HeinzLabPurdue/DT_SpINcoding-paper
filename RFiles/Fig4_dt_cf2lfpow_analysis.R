rm(list = ls())
cat("\014")  

restrict <- function(f,minVal,maxVal){  
  f <- f[f$CF_kHz >= minVal,]
  f <- f[f$CF_kHz <= maxVal,]
  return(f)
}


get_deq <- function(mdl){  
  var_out <- data.frame(d_eq_ttr=0, d_eq_q10=0, d_eq_thr=0)
  
  depVars <- rownames(mdl)
  ttr_ind <- match("TTR_dB", depVars)
  Q10_ind <- match("Q10local", depVars)
  thr_ind <- match("Threshold_dBSPL", depVars)
  
  pVal_ttr= mdl$`Pr(>F)`[ttr_ind];
  df_ttr= mdl$Df.res[ttr_ind];
  var_out$d_eq_ttr = 2*qt(1 - pVal_ttr, df_ttr) / sqrt(df_ttr)
  
  pVal_q10= mdl$`Pr(>F)`[Q10_ind];
  df_q10= mdl$Df.res[Q10_ind];
  var_out$d_eq_q10 = 2*qt(1 - pVal_q10, df_q10) / sqrt(df_q10)
  
  pVal_thr= mdl$`Pr(>F)`[thr_ind];
  df_thr= mdl$Df.res[thr_ind];
  var_out$d_eq_thr = 2*qt(1 - pVal_thr, df_thr) / sqrt(df_thr)
  
  return(var_out)
}

library(lme4)
library(car)

# Read data
data_all <- read.table("../tables_for_stats/Fig4_tbl_DT_CF2LF_withNan.txt", header = TRUE)
str(data_all)
data_all$ChinID <- as.factor(data_all$ChinID)
data_all$HearingStatus<- as.factor(data_all$HearingStatus)
data_all$SRgroup <- as.factor(data_all$SpontRate > 18)
data_all$CF_kHz_log <- log(data_all$CF_kHz)

data_lf <- restrict(data_all, 0, 3)
data_hf <- restrict(data_all, 3, 5.1)

## Driven rate 
m_DR <- lm(DrivenRate ~ HearingStatus*CF_kHz_log, data=data_all)
Anova(m_DR, test.statistic='F')

# m_DR <- lm(DrivenRate ~ HearingStatus*CF_kHz_log + SpontRate, data=data_all)
# Anova(m_DR, test.statistic='F')

# m_DR <- lmer(DrivenRate ~ HearingStatus*CF_kHz_log + SpontRate + (1|ChinID), data=data_all)
# Anova(m_DR, test.statistic='F')


## Spont rate 
m_SR <- lm(SpontRate ~ HearingStatus*CF_kHz_log, data=data_all)
Anova(m_SR, test.statistic='F')

# ## Spont rate 
# m_SR <- lmer(SpontRate ~ HearingStatus*CF_kHz_log + (1|ChinID), data=data_all)
# Anova(m_SR, test.statistic='F')

## near-CF pow 
m_CFpow <- lm(CFpow ~ HearingStatus*CF_kHz_log, data=data_all)
Anova(m_CFpow, test.statistic='F')

# ## near-CF pow 
# m_CFpow <- lmer(CFpow ~ HearingStatus*CF_kHz_log + (1|ChinID), data=data_all)
# Anova(m_CFpow, test.statistic='F')

# ## near-CF pow 
# m_CFpow_HF <- lmer(CFpow ~ HearingStatus*CF_kHz_log + (1|ChinID), data=data_hf)
# Anova(m_CFpow_HF, test.statistic='F')

## LF pow 
m_LFpow <- lm(LFpow ~ HearingStatus*CF_kHz_log, data=data_all)
Anova(m_LFpow, test.statistic='F')

# m_LFpow <- lmer(LFpow ~ HearingStatus*CF_kHz_log + (1|ChinID), data=data_all)
# Anova(m_LFpow, test.statistic='F')

## Model 1 
m_dt1 <- lm(CF2LFpow ~ HearingStatus*CF_kHz_log, data=data_all)
Anova(m_dt1, test.statistic='F')

# m_dt1 <- lmer(CF2LFpow ~ SRgroup + HearingStatus*CF_kHz_log + (1|ChinID), data=data_all)
# Anova(m_dt1, test.statistic='F')


m_dt1 <- lmer(CF2LFpow ~ HearingStatus + SRgroup + CF_kHz_log + (1|ChinID), data=data_lf)
Anova(m_dt1, test.statistic='F')

m_dt1 <- lmer(CF2LFpow ~ HearingStatus*CF_kHz_log + SpontRate + (1|ChinID), data=data_lf)
Anova(m_dt1, test.statistic='F')

m_dt2 <- lmer(CF2LFpow ~ HearingStatus + SRgroup + CF_kHz_log + (1|ChinID), data=data_hf)
Anova(m_dt2, test.statistic='F')

## Model 2 
m_dt2 <- lmer(CF2LFpow ~ CF_kHz_log * Threshold_dBSPL * TTR_dB * Q10local * SpontRate + (1|ChinID), data=data_all)
stat_m_dt2 <- Anova(m_dt2, test.statistic='F')
print(stat_m_dt2)

m_dt2 <- lmer(CF2LFpow ~ CF_kHz_log * Threshold_dBSPL * TTR_dB + Q10local + SpontRate + (1|ChinID), data=data_all)
stat_m_dt2 <- Anova(m_dt2, test.statistic='F')
print(stat_m_dt2)

m_dt2 <- lmer(CF2LFpow ~ CF_kHz_log * TTR_dB + Threshold_dBSPL + Q10local + SpontRate + (1|ChinID), data=data_all)
stat_m_dt2 <- Anova(m_dt2, test.statistic='F')
print(stat_m_dt2)

m_dt2 <- lmer(CF2LFpow ~ CF_kHz_log * TTR_dB + Threshold_dBSPL + Q10local + (1|ChinID), data=data_all)
stat_m_dt2 <- Anova(m_dt2, test.statistic='F')
print(stat_m_dt2)

m_dt2 <- lmer(CF2LFpow ~ CF_kHz_log + SpontRate + Threshold_dBSPL + Q10local + TTR_dB + (1|ChinID), data=data_all)
stat_m_dt2 <- Anova(m_dt2, test.statistic='F')
print(stat_m_dt2)
var_out <- get_deq(stat_m_dt2)
print(var_out)

m_dt2 <- lmer(CF2LFpow ~ CF_kHz_log + Threshold_dBSPL + Q10local + TTR_dB + (1|ChinID), data=data_all)
stat_m_dt2 <- Anova(m_dt2, test.statistic='F')
print(stat_m_dt2)
var_out <- get_deq(stat_m_dt2)
print(var_out)


# depVars <- rownames(stat_m_dt2)
# ttr_ind <- match("TTR_dB", depVars)
# Q10_ind <- match("Q10local", depVars)
# 
# pVal_ttr= stat_m_dt2$`Pr(>F)`[ttr_ind];
# df_ttr= stat_m_dt2$Df.res[ttr_ind];
# d_eq_ttr = 2*qt(1 - pVal_ttr, df_ttr) / sqrt(df_ttr)
# r_eq_ttr = sqrt(qt(1 - pVal_ttr, df_ttr)^2 / (qt(1 - pVal_ttr, df_ttr)^2 + df_ttr^2))
# 
# pVal_q10= stat_m_dt2$`Pr(>F)`[Q10_ind];
# df_q10= stat_m_dt2$Df.res[Q10_ind];
# d_eq_q10 = 2*qt(1 - pVal_q10, df_q10) / sqrt(df_q10)
# r_eq_q10 = sqrt(qt(1 - pVal_q10, df_q10)^2 / (qt(1 - pVal_q10, df_q10)^2 + df_q10^2))

# sprintf("Effect size for [TTR= %.2f] [Q10= %.2f]", d_eq_ttr, d_eq_q10) 

