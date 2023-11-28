#### R tool to generate EA and IA lookup tables for NW model
#################################################################################
############# the goal of this script is to produce a lookup table of predicted values for the possible range of RdNBR values
############# The NW model is used to generate one set of lookup tables
############# The NW model with RdNBR / 1.144 is used to generate the second set of lookup tables
############# miller and Quayle 2015 divded RdNBR within the national RAVG models (Miller 2009) to convert EA equations to IA
############## code modified by Ali Reiner from code by S.J. Saberi
######################################################################################################################
## first install and load relevant packages ---------------------

#install.packages('gamlss')
#install.packages('openxlsx')

library(gamlss)
library(openxlsx)
#library(ggplot2)

#######################################################################################################################
########################## Fit the NW model using the original NW model dataset ###################
#######################################################################################################################

# Read in Saba's data for model fitting
respdata = read.csv("C:/ali_working/!GTAC/RAVG/NW_IA/RdNBR_to_field_SJS_copy/SJS_data/RSnew_20191124.csv") 

# Convert CBI to a proportion so you can run models 
respdata$propCBI = respdata$TotalPlotCBI_mean/3 

# Fit the models with original data

NW.CBI.EA <-gamlss(propCBI ~ RDNBR, nu.formula=~ RDNBR, tau.formula=~RDNBR, data=respdata, family=BEINF);
NW.BAloss<-gamlss(prop_killedBA ~ RDNBR, nu.formula=~ RDNBR, tau.formula=~RDNBR, data=respdata, family=BEINF);  
NW.CCloss.EA<-gamlss(delt.livecc ~ RDNBR, nu.formula=~ RDNBR, tau.formula=~RDNBR, data=respdata, family=BEINF);

#######################################################################################################################
########################## Generate NW model Lookup tables across range of values for EA models cross check  ###################
#######################################################################################################################

df.RDNBR<-data.frame(RDNBR=seq(from= -609, to = 3000, by = 1))

########################## recreate CBI EA lookup table to cross check we are re-generating exactly the same model ####

# extract predictions 
NW.CBI.EA.predAll <- predictAll(NW.CBI.EA, newdata=df.RDNBR, type="response") 
mu.CBI.EA <- NW.CBI.EA.predAll$mu
nu.CBI.EA <- NW.CBI.EA.predAll$nu
tau.CBI.EA <- NW.CBI.EA.predAll$tau
p0.CBI.EA <- nu.CBI.EA / (1+nu.CBI.EA+tau.CBI.EA) # probability of zeros
p1.CBI.EA <- tau.CBI.EA / (1+nu.CBI.EA+tau.CBI.EA) # probability of ones

# calculate expected value for new predictions
yest.CBI.EA <- (1-p0.CBI.EA)*(p1.CBI.EA+(1-p1.CBI.EA)*mu.CBI.EA)

#Need to multiply by 100, then round off decimals for easy comparison of previously (by Saberi) created NW EA lookup table
yest.CBI100.EA<-round(yest.CBI.EA*100)
yest.CBI.EA<-yest.CBI100.EA/33.3  #to convert back to 0-3 scale

Lookup.NW.CBI.EA<-cbind(df.RDNBR, yest.CBI100.EA, yest.CBI.EA)


#AR note 11/6/2023: this lookup table is similar, but not exactly the same as those developed originally with the NW model



########################## recreate BA EA lookup table to cross check we are re-generating exactly the same model ####

#in progress

########################## recreate CC EA lookup table to cross check we are re-generating exactly the same model ####


#in progress



#######################################################################################################################
########################## Generate RdNBR/1.144 for prediction using NW model for IA   ###################
#######################################################################################################################

#Note: the national RAVG model (Miller 2009) is modified to obtain IA predictions according to Miller and Quayle 2015.  
#this method employed the use of the same EA national models, with an adjustment to RdNBR of 1.144 for the IA time frame predictions
#at this point since there is no IA NW model, we are beta-testing applying this 1.144 adjustment to the NW model to generate IA predictions

#For V2 I corrected the code to be RDBNR * 1.144 (not divide)

respdata$RDNBR_IA<-respdata$RDNBR*1.144

#fit models with modified RDNBR for IA predictions
NW.CBI.IA <-gamlss(propCBI ~ RDNBR_IA, nu.formula=~ RDNBR_IA, tau.formula=~RDNBR_IA, data=respdata, family=BEINF)


########################## generate predictions and lookup table for NW IA CBI   #######################

#Need to generate a RDNBR lookup dataframe with variable named as in model: 'RDNBR_IA'
#Note: the RDBNR_IA in this dataframe IS NOT DIVIDED BY 1.144!!!!
df.RDNBR_forIA<-data.frame(RDNBR_IA=seq(from= -609, to = 3000, by = 1))

# extract predictions 
NW.CBI.IA.predAll <- predictAll(NW.CBI.IA, newdata=df.RDNBR_forIA, type="response") 
mu.CBI.IA <- NW.CBI.IA.predAll$mu
nu.CBI.IA <- NW.CBI.IA.predAll$nu
tau.CBI.IA <- NW.CBI.IA.predAll$tau
p0.CBI.IA <- nu.CBI.IA / (1+nu.CBI.IA+tau.CBI.IA) # probability of zeros
p1.CBI.IA <- tau.CBI.IA / (1+nu.CBI.IA+tau.CBI.IA) # probability of ones


# calculate expected value for new predictions
yest.CBI.IA <- (1-p0.CBI.IA)*(p1.CBI.IA+(1-p1.CBI.IA)*mu.CBI.IA)

#Need to multiply by 100, then round off decimals for easy comparison of previously (by Saberi) created NW EA lookup table
yest.CBI100.IA<-round(yest.CBI.IA*100)
yest.CBI.IA<-yest.CBI100.IA/33.3  #to convert back to 0-3 scale

Lookup.NW.CBI.IA<-cbind(df.RDNBR_forIA, yest.CBI100.IA, yest.CBI.IA)





########################## generate predictions and lookup table for NW IA BA   #######################

#in progress




########################## generate predictions and lookup table for NW IA CC   #######################

#in progress




#######################################################################################################################
########################## Generate National Model (Miller 2009) EA and IA lookup tables   ###################
#######################################################################################################################

#Generate national model (CBI '0')

NatEA.CBI<- ifelse(df.RDNBR$RDNBR < 53, 0, 
                   ifelse (df.RDNBR$RDNBR > 986, 3, ((1/0.389)*log((df.RDNBR$RDNBR + 369.0)/421.7))))
NatLookup<-cbind(df.RDNBR, NatEA.CBI)

NatIA.CBI<- ifelse(df.RDNBR$RDNBR < 60, 0, 
                   ifelse (df.RDNBR$RDNBR > 1127, 3, ((1/0.389)*log(((df.RDNBR$RDNBR/1.1444) + 369.0)/421.7))))

NatLookup<-cbind(NatLookup, NatIA.CBI)





#######################################################################################################################
########################## combine lookup tables and graph          ###################
#######################################################################################################################

CBI_CombLookup<-cbind(NatLookup, Lookup.NW.CBI.EA$yest.CBI.EA, Lookup.NW.CBI.IA$yest.CBI.IA)


write.xlsx(CBI_CombLookup, "C:/ali_working/!GTAC/RAVG/NW_IA/output/Lookup.CBIcombinedV2.xlsx")
