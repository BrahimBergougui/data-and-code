
*** Initial Data Preparation  

// Load the dataset 
clear 
import excel "data.xls", sheet("Sheet2") firstrow 

// Define the panel structure  
xtset id year, yearly  

// Generate natural log transformations for variables  
gen LPRO = ln(pro)  
gen LPRO2 = (ln(pro))^2  
gen LTEE = ln(tee)  
gen LSEE = ln(see)  
gen LTRA = ln(tra)  
gen LRD = ln(rd)  
gen LETG = ln(etg)  
gen LEUM = ln(eum)  
gen LTRD = ln(trd)  
gen LDI = ln(di)  

// Create an interaction term and its log  
gen mod = etg * eum  
gen LMod = ln(mod)  

// Create first differences of the variables  
gen DPRO = d.LPRO  
gen DPRO2 = d.LPRO2  
gen DTEE = d.LTEE  
gen DSEE = d.LSEE  
gen DTRA = d.LTRA  
gen DRD = d.LRD  
gen DETG = d.LETG  
gen DEUM = d.LEUM  
gen DTRD = d.LTRD  
gen DDI = d.LDI  
gen DMod = d.LMod  

*** Descriptive Statistics (Table 2)  

// Summary statistics by panel ID  
tabstat tee pro tra etg rd eum trd di see, statistics(mean sd max min skewness kurtosis) by(id)  


*** Overall Descriptive Statistics and Correlations (Table 3)  

// Overall summary statistics  
tabstat tee pro tra etg rd eum trd di see, statistics(mean sd max min skewness kurtosis)  

// Pairwise correlations with significance  
pwcorr tee pro tra etg rd eum trd di see, sig  


*** Slope heterogeneity and cross-sectional dependence - outcomes (Table 4)  

// Fixed-effects regressions  
qui xtreg LTEE LPRO LPRO2 LTRA LETG LRD LEUM LTRD, fe  
xtcsd, pesaran  

qui xtreg LSEE LPRO LPRO2 LTRA LETG LRD LEUM LTRD, fe  
xtcsd, pesaran  

// Additional models  
qui xtreg LTEE LPRO LPRO2 LTRA LETG LRD LEUM LDI, fe  
xtcsd, pesaran  

qui xtreg LSEE LPRO LPRO2 LTRA LETG LRD LEUM LDI, fe  
xtcsd, pesaran  

// Cross-section heterogeneity tests  
xthst LTEE LPRO LPRO2 LTRA LETG LRD LEUM LTRD  
xthst LSEE LPRO LPRO2 LTRA LETG LRD LEUM LTRD  
xthst LTEE LPRO LPRO2 LTRA LETG LRD LEUM LDI  
xthst LSEE LPRO LPRO2 LTRA LETG LRD LEUM LDI  


*** Panel Unit Root Tests (Table 5)  

// Apply the cross-sectional Im-Pesaran-Shin unit root test  
xtcips LPRO, maxlags(1) bglags(1) t  
xtcips DPRO, maxlags(1) bglags(1) t  
xtcips LPRO2, maxlags(1) bglags(1) t  
xtcips DPRO2, maxlags(1) bglags(1) t  
xtcips LTRA, maxlags(1) bglags(1) t  
xtcips DTRA, maxlags(1) bglags(1) t  
xtcips LETG, maxlags(1) bglags(1) t  
xtcips DETG, maxlags(1) bglags(1) t  
xtcips LRD, maxlags(1) bglags(1) t  
xtcips DRD, maxlags(1) bglags(1) t  
xtcips LEUM, maxlags(1) bglags(1) t  
xtcips DEUM, maxlags(1) bglags(1) t  
xtcips LTRD, maxlags(1) bglags(1) t  
xtcips DTRD, maxlags(1) bglags(1) t  
xtcips LDI, maxlags(1) bglags(1) t  
xtcips DDI, maxlags(1) bglags(1) t  
xtcips LTEE, maxlags(1) bglags(1) t  
xtcips DTEE, maxlags(1) bglags(1) t  
xtcips LSEE, maxlags(1) bglags(1) t  
xtcips DSEE, maxlags(1) bglags(1) t  
xtcips LMod, maxlags(1) bglags(1) t  


*** Cointegration Tests (Table 6)  

// Apply Westerlund panel cointegration tests  
xtcointtest westerlund DTEE DPRO DPRO2 DTRA DETG DRD DEUM DTRD, demean  
xtcointtest westerlund DSEE DPRO DPRO2 DTRA DETG DRD DEUM DTRD, demean  
xtcointtest westerlund DTEE DPRO DPRO2 DTRA DETG DRD DEUM DDI, demean  
xtcointtest westerlund DSEE DPRO DPRO2 DTRA DETG DRD DEUM DDI, demean  


*** Tables 7 and Figures 2 
 
// QUANTILE 

xtqreg LTEE LPRO LPRO2 LTRA LETG LRD LEUM LTRD , i(id) quantile(.1(0.1)0.9)
qregplot, title ("Model (01)")
xtqreg LSEE LPRO LPRO2 LTRA LETG LRD LEUM LTRD , i(id) quantile(.1(0.1)0.9)
qregplot, title ("Model (02)")
xtqreg LTEE LPRO LPRO2 LTRA LMod LRD LEUM LTRD , i(id) quantile(.1(0.1)0.9)
qregplot, title ("Model (03)")
xtqreg LSEE LPRO LPRO2 LTRA LMod LRD LEUM LTRD , i(id) quantile(.1(0.1)0.9)
qregplot, title ("Model (04)")

// ESDK

xtscc LTEE LPRO LPRO2 LTRA LETG LRD LEUM LTRD, fe lag(0)  
xtscc LSEE LPRO LPRO2 LTRA LETG LRD LEUM LTRD, fe lag(0)  
xtscc LTEE LPRO LPRO2 LTRA LMod LRD LEUM LTRD, fe lag(0)  
xtscc LSEE LPRO LPRO2 LTRA LMod LRD LEUM LTRD, fe lag(0)  

*** Table A1 and Figure A1
// QUANTILE 

xtqreg LTEE LPRO LPRO2 LTRA LETG LRD LEUM LDI , i(id) quantile(.1(0.1)0.9)
qregplot, title ("Model (05)")
xtqreg LSEE LPRO LPRO2 LTRA LETG LRD LEUM LDI , i(id) quantile(.1(0.1)0.9)
qregplot, title ("Model (06)")
xtqreg LTEE LPRO LPRO2 LTRA LMod LRD LEUM LDI , i(id) quantile(.1(0.1)0.9)
qregplot, title ("Model (07)")
xtqreg LSEE LPRO LPRO2 LTRA LMod LRD LEUM LDI , i(id) quantile(.1(0.1)0.9)
qregplot, title ("Model (08)")

// ESDK

xtscc  LTEE LPRO LPRO2 LTRA LETG LRD LEUM LDI  , fe lag(0)
xtscc  LSEE LPRO LPRO2 LTRA LETG LRD LEUM LDI  , fe lag(0)
xtscc  LTEE LPRO LPRO2 LTRA LMod LRD LEUM LDI  , fe lag(0)
xtscc  LSEE LPRO LPRO2 LTRA LMod LRD LEUM LDI  , fe lag(0)
