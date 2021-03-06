rm(list = ls())
cat("\014")  

restrict_cf <- function(f,minVal,maxVal){  
  f <- f[f$CF_kHz >= minVal,]
  f <- f[f$CF_kHz <= maxVal,]
  return(f)
}

get_deq <- function(mdl){  
  var_out <- data.frame(d_eq_ttr=0, d_eq_q10=0, d_eq_thr=0)
    
  depVars <- rownames(mdl)
  ttr_ind <- match("TTR_dB", depVars)
  Q10_ind <- match("Q10local", depVars)
  thr_ind <- match("thresh_dB", depVars)
  
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
dat_all <- read.table('../tables_for_stats/Fig5_Fpow_table.txt', header=TRUE)

dat_all$ChinID <- as.factor(dat_all$ChinID) # Value doesn't matter 
dat_all$UnitID <- as.factor(dat_all$UnitID) # Value doesn't matter 
dat_all$SNR <- as.ordered(dat_all$SNR)
dat_all$HearingStatus<- as.factor(dat_all$HearingStatus)
dat_all$SRgroup <- as.factor(dat_all$SpontRate > 18)
dat_all$CF_kHz_log <- log(dat_all$CF_kHz)
str(dat_all)

dat_hf <- restrict_cf(dat_all, .5, 5)
m_f1_hf <- lm(F1pow  ~ CF_kHz_log * HearingStatus + SNR * HearingStatus, data=dat_hf)
Anova(m_f1_hf, test.statistic='F')

m_f1_hf <- lmer(F1pow  ~ CF_kHz_log * HearingStatus + SNR * HearingStatus + (1|ChinID), data=dat_hf)
Anova(m_f1_hf, test.statistic='F')

m_f1_hf <- lmer(F1pow  ~ CF_kHz_log + SNR + TTR_dB + Q10local + thresh_dB + (1|ChinID), data=dat_hf)
anOut_f1_hf <- Anova(m_f1_hf, test.statistic='F')

print(anOut_f1_hf)
var_out <- get_deq(anOut_f1_hf)
print(var_out)

## 
dat_f2_cf <- restrict_cf(dat_all, 1, 2.5) 
m_f2_cf <- lm(F2pow  ~ CF_kHz_log * SNR * HearingStatus, data=dat_f2_cf)
Anova(m_f2_cf, test.statistic='F')

# dat_f2_cf <- restrict_cf(dat_all, 1, 2.5) 
# m_f2_cf <- lmer(F2pow  ~ CF_kHz_log * SNR * HearingStatus + (1|ChinID), data=dat_f2_cf)
# Anova(m_f2_cf, test.statistic='F')

m_f2_cf <- lmer(F2pow  ~ CF_kHz_log + SNR + TTR_dB + Q10local + thresh_dB + (1|ChinID), data=dat_f2_cf)
anOut_f2_cf <- Anova(m_f2_cf, test.statistic='F')
print(anOut_f2_cf)
var_out_f2_cf <- get_deq(anOut_f2_cf)
print(var_out_f2_cf)


## 
dat_f3_cf <- restrict_cf(dat_all, 2, 3) 
m_f3_cf <- lm(F3pow  ~ CF_kHz_log * SNR * HearingStatus, data=dat_f3_cf)
Anova(m_f3_cf, test.statistic='F')

# dat_f3_cf <- restrict_cf(dat_all, 2, 3) 
# m_f3_cf <- lmer(F3pow  ~ CF_kHz_log * SNR * HearingStatus + (1|ChinID), data=dat_f3_cf)
# Anova(m_f3_cf, test.statistic='F')

m_f3_cf <- lmer(F3pow  ~ CF_kHz_log + SNR + TTR_dB + Q10local + thresh_dB + (1|ChinID), data=dat_f3_cf)
anOut_f3_cf <- Anova(m_f3_cf, test.statistic='F')
print(anOut_f3_cf)
var_out_f3_cf <- get_deq(anOut_f3_cf)
print(var_out_f3_cf)

dat_f3_cf_snr_q0 <- dat_f3_cf[dat_f3_cf$SNR != -5,]
m_f3_cf <- lmer(F3pow  ~ CF_kHz_log * SNR * HearingStatus + (1|ChinID), data=dat_f3_cf_snr_q0)
Anova(m_f3_cf, test.statistic='F')

m_f3_cf <- lmer(F3pow  ~ CF_kHz_log + SNR + TTR_dB + Q10local + thresh_dB + (1|ChinID), data=dat_f3_cf_snr_q0)
anOut_f3_cf <- Anova(m_f3_cf, test.statistic='F')
print(anOut_f3_cf)
var_out_f3_cf <- get_deq(anOut_f3_cf)
print(var_out_f3_cf)
