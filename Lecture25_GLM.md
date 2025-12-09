###   Loads required packages for analysis
###   Includes MuMIn (model selection), mgcv (GAMs), DHARMa (GLM diagnostics)
```r
library(tidyverse)
library(MuMIn)  #new
library(ggfortify)
library(jtools)
library(mgcv)  #new
library(DHARMa)  #new
theme_set(theme_bw())
options(scipen = 1, digits = 2)
```

### Calcium model selection

###   Reads 'calcium.csv'
###   Fits full model with interaction (Sex * Treatment)
###   step() performs stepwise model selection (backward by default) using AIC
```r
calcium<-read.csv("calcium.csv")
calcium.aov1<-lm(Calcium~Sex*Treatment,data=calcium) 
calcium.aov2<-step(calcium.aov1)
calcium.aov2
```

### Using MuMIN, start with a linear model object, and use the dredge function. Re-run the lm model with na.fail=TRUE because MuMun needs that.

###   dredge() tests all possible subsets of the full model
###   na.action="na.fail" is required for dredge to work
###   rank="AIC" ranks models by Akaike Information Criterion (lower is better)
```r
calcium<-read.csv("calcium.csv")
calcium.aov1<-lm(Calcium~Sex*Treatment,
                 data=calcium,
                 na.action="na.fail") 
calcium.dredge<-dredge(calcium.aov1,
                       rank="AIC")
calcium.dredge
```

###   Extracts the best model (top row of dredge table)
```r
calciumBest<-get.models(calcium.dredge,subset=1)[[1]]
summary(calciumBest)
```

###   Calculates Model Averaged coefficients (averages across all models, weighted by AICc weight)
```r
model.avg(calcium.dredge)
```

### Bird abundance

###   Reads 'bird.abundance.csv'
###   Fits full model: abundance predicted by mass, time, and their interaction
```r
bird<-read.csv("bird.abundance.csv")
bird.lm<-lm(abundance~mass*time,data=bird,na.action="na.fail")
```

###   Performs stepwise selection on bird model
```r
step(bird.lm)
```

###   Performs dredge (all subsets selection) on bird model
```r
bird.dredge<-dredge(bird.lm)
bird.dredge
```

###   Extracts best model (subset=1)
```r
get.models(bird.dredge,subset=1)[[1]]
```

###   Extracts all models with delta AIC < 2 (models practically equivalent to the best)
```r
get.models(bird.dredge,subset=delta<2)
```

###   Calculates model averaged coefficients
```r
model.avg(bird.dredge)
```

###   Calculates importance weights for each variable (sum of weights of models containing that variable)
```r
importance(bird.dredge)
```

### GLM

###   Reads 'soaySheepFitness.csv' from URL
###   Plots fitness vs body mass
###   smooth.method="lm" adds linear fit; method="gam" adds smoothed curve (General Additive Model)
```r
soay<-read.csv(url("[https://whitlockschluter3e.zoology.ubc.ca/Data/chapter17/chap17e5SoaySheepFitness.csv](https://whitlockschluter3e.zoology.ubc.ca/Data/chapter17/chap17e5SoaySheepFitness.csv)"))
ggplot(soay,aes(x=bodyMass,y=fitness))+
  geom_point()+
  geom_smooth(method="lm",se=FALSE)+
  geom_smooth(method="gam",se=FALSE,color="red")+
  ggtitle("Sheep fitness linear vs GAM")
```

###   Fits Generalized Additive Model (GAM) with smoothing spline 's(bodyMass)'
###   Checks if the non-linear smooth term is significant
```r
soay.gam<-gam(fitness~s(bodyMass),data=soay)
summary(soay.gam)
```

###   Plots the GAM smooth curve
```r
plot(soay.gam)
```

### Logistic regression

###   Reads 'GuppyColdDeath.csv' from URL
###   Plots Mortality (0 or 1) vs Exposure Duration with jitter to see overlapping points
```r
guppy<-read.csv(url("[https://whitlockschluter3e.zoology.ubc.ca/Data/chapter17/chap17f9_1GuppyColdDeath.csv](https://whitlockschluter3e.zoology.ubc.ca/Data/chapter17/chap17f9_1GuppyColdDeath.csv)"))
summary(guppy)
head(guppy)
ggplot(guppy,aes(x=exposureDurationMin,y=mortality))+
   geom_point(position=position_jitter(width=0.2,height=0.02),alpha=0.5)+
   labs(y="Mortality", x="Exposure duration (min)")
```

###   Fits Logistic Regression Model using glm()
###   family="binomial" specifies logistic link function (for binary 0/1 data)
```r
glm.guppy<-glm(mortality~exposureDurationMin,
               family="binomial",
               data=guppy)   
#Must specify binomial for logit link. Must use glm not lm for non-normal data
```

###   Analysis of Deviance table (like ANOVA for GLM)
###   test="Chi" performs Chi-squared test on deviance (required for binomial GLM)
```r
anova(glm.guppy,test="Chi")					   
#  Must specify "Chi" for analysis of deviance table for binomial data.	
# For normal models, specify "F" for test
summary(glm.guppy)
```

###   Adds predicted values to dataframe
###   predict() gives log-odds (logit scale)
###   predict(..., type="response") gives predicted PROBABILITIES (0 to 1 scale)
```r
view(guppy)
guppy$predict<-predict(glm.guppy)
guppy$predictProb<-predict(glm.guppy,type="response")
?predict.glm
```

### Logistic regression usually has ugly residuals because the data are not normal
### Use DHARMa library instead, to get "scaled residuals" based on
### comparing residuals to simulated data. 

###   Plots standard GLM diagnostics (often hard to interpret for binary data)
```r
autoplot(glm.guppy) 								
```

###   Simulates residuals using DHARMa package (better for GLM diagnostics)
###   plot(dharmaResid) creates QQ plot and residual vs predicted plot for scaled residuals
```r
dharmaResid<-simulateResiduals(glm.guppy)
plot(dharmaResid)
```

###   Plots data with predicted probability curve (Logistic curve)
```r
ggplot(guppy,aes(x=exposureDurationMin,y=mortality))+
  geom_point(position=position_jitter(width=0.2,height=0.02),alpha=0.5)+
  labs(y="Mortality", x="Exposure duration (min)")+
  geom_line(aes(y=predictProb),color="blue",size=2)
```

### Poisson regression (GLM)

###   Reads 'MassExtinctions.csv' from URL
###   Fits GLM with family="poisson" (for count data)
```r
extinction<-read.csv(url("[https://whitlockschluter3e.zoology.ubc.ca/Data/chapter08/chap08e4MassExtinctions.csv](https://whitlockschluter3e.zoology.ubc.ca/Data/chapter08/chap08e4MassExtinctions.csv)"))
extinction.glm<-glm(numberOfExtinctions~1,family="poisson",data=extinction)
summary(extinction.glm)
```

###   Back-transforms the intercept to get the mean count (lambda)
###   exp() is inverse of the log link used in Poisson regression
```r
exp(coef(extinction.glm))
```

###   Checks the actual mean of the raw data (should match)
```r
mean(extinction$numberOfExtinctions)
```

###   DHARMa diagnostics for Poisson model
```r
dharmaResid<-simulateResiduals(extinction.glm)
plot(dharmaResid)
```

###   Reads 'TsetseLearning.csv' from URL
```r
tsetse<-read.csv(url("[https://whitlockschluter3e.zoology.ubc.ca/Data/chapter13/chap13q16TsetseLearning.csv](https://whitlockschluter3e.zoology.ubc.ca/Data/chapter13/chap13q16TsetseLearning.csv)"))
```

###   Fits GLM for proportion data
###   Response is a matrix: cbind(Successes, Failures)
###   family="binomial" used for proportions
```r
tsetse.glm<-glm(cbind(proportionSurvived,1-proportionSurvived)~treatment,
                family="binomial",
                data=tsetse)
summary(tsetse.glm)
anova(tsetse.glm,test="Chi")
```
