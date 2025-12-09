### Lecture 26. GLMM and Likelihood

### ANNOTATION: Loads required packages for analysis
### ANNOTATION: Includes lme4 (mixed models), MuMIn (model selection), mgcv (GAMs), ggfortify (diagnostics)
```r
library(lme4)
library(MuMIn)
library(tidyverse)
library(mgcv)
library(ggfortify)
theme_set(theme_bw(base_size=12))
```

### Random effects in linear models (GLMM)

### ANNOTATION: Random effects on intercepts and slopes. Sleep study example
### ANNOTATION: Visualizes Reaction time vs Days for each Subject (color=Subject)
### ANNOTATION: Adds linear regression lines for each subject (stat_smooth)
```r
library(lme4)
#?sleepstudy

ggplot(sleepstudy,aes(x=Days,y=Reaction,color=Subject))+
  geom_point()+
  stat_smooth(method=lm,se=FALSE)
```

### ANNOTATION: Fits standard linear model (Fixed effects only, ignores Subject grouping)
```r
sleeplm<-lm(Reaction~Days,data=sleepstudy)  
```

### ANNOTATION: Fits Random Intercept model
### ANNOTATION: (1 | Subject) allows each subject to have their own starting reaction time (intercept)
```r
sleeplmIntercept<-lmer(Reaction~Days+(1|Subject),data=sleepstudy)
```

### ANNOTATION: Fits Random Slope and Intercept model
### ANNOTATION: (Days | Subject) allows each subject to have their own intercept AND their own slope (reaction to sleep deprivation)
```r
sleeplmBoth<-lmer(Reaction~Days+(Days|Subject),data=sleepstudy)
```

### ANNOTATION: Fits Random Slope model (Fixed intercept)
### ANNOTATION: (0 + Days | Subject) forces fixed intercept but random slopes
```r
sleeplmSlope<-lmer(Reaction~Days+(0+Days|Subject),data=sleepstudy)
```

### ANNOTATION: Compares all models using AIC
```r
aicTab<-AIC(sleeplm,sleeplmIntercept,sleeplmSlope,sleeplmBoth)
aicTab
```

### ANNOTATION: Calculates delta AIC (difference from best model)
```r
aicTab$AIC-min(aicTab$AIC)
```

### ANNOTATION: Extracts coefficients from the best model (Random Slope + Intercept)
### ANNOTATION: Shows individual intercept and slope for each Subject
```r
coef(sleeplmBoth)
```

### ANNOTATION: Summary of the best model (Variance components, Fixed effects)
```r
summary(sleeplmBoth)
```

### Generalized Linear Mixed Models (GLMM)

### ANNOTATION: Uses glmer() for non-normal data with random effects
### ANNOTATION: Fits Logistic Mixed Model (family=binomial)
### ANNOTATION: Successes/Failures ~ Treatment + (1 | Unit)
```r
tsetse<-read.csv(url("[https://whitlockschluter3e.zoology.ubc.ca/Data/chapter13/chap13q16TsetseLearning.csv](https://whitlockschluter3e.zoology.ubc.ca/Data/chapter13/chap13q16TsetseLearning.csv)"))
tsetse$unit<-1:nrow(tsetse)  # Observation level random effect for overdispersion

tsetse.glmer<-glmer(cbind(proportionSurvived,1-proportionSurvived)~treatment+(1|unit),
                family="binomial",
                data=tsetse)
summary(tsetse.glmer)
```

### Likelihood

### ANNOTATION: Binomial likelihood calculation
### ANNOTATION: Calculates Likelihood of p=0.72 given 23 successes in 32 trials
### ANNOTATION: dbinom gives the probability mass (Likelihood) for discrete data
```r
dbinom(23,32,0.72)
```

### ANNOTATION: Calculates Likelihood of p=0.5 (Null hypothesis) given 23 successes
```r
dbinom(23,32,0.5)
```

### ANNOTATION: Calculates Likelihood Ratio: L(p=0.72) / L(p=0.5)
```r
dbinom(23,32,0.72)/dbinom(23,32,0.5)
```

### ANNOTATION: Calculates Log-Likelihood Ratio
### ANNOTATION: log(L1) - log(L2) is equivalent to log(L1/L2)
```r
log(dbinom(23,32,0.72))-log(dbinom(23,32,0.5))
```

### ANNOTATION: Calculates G-statistic (Deviance)
### ANNOTATION: G = 2 * (LogLikelihood_Alternative - LogLikelihood_Null)
### ANNOTATION: Under H0, G follows Chi-squared distribution
```r
G<-2*(log(dbinom(23,32,0.72))-log(dbinom(23,32,0.5)))  
```

### ANNOTATION: Calculates P-value for the G-statistic (df=1)
```r
1-pchisq(G,1)
```

### Likelihood ratio test for models

### ANNOTATION: Fits two nested models (Intercept vs Slope+Intercept random effects)
```r
library(lme4)
sleeplmIntercept<-lmer(Reaction~Days+(1|Subject),data=sleepstudy)
sleeplmBoth<-lmer(Reaction~Days+(Days|Subject),data=sleepstudy)
```

### ANNOTATION: Performs Likelihood Ratio Test (LRT) comparing the two models
### ANNOTATION: anova() on two model objects automatically performs LRT
```r
anova(sleeplmIntercept,sleeplmBoth)
```

### Multiple variables in regression and ANOVA

### Cystic fibrosis example

### ANNOTATION: Loads ISwR package and summarizes cystic fibrosis data
```r
library(ISwR)
summary(cystfibr)
plot(cystfibr)
```

### ANNOTATION: Fits Full Model with all variables
```r
cf1<-lm(pemax~age+sex+height+weight+bmp+fev1+rv+frc+tlc,data=cystfibr)
anova(cf1)
summary(cf1)
```

### With all variables, the model explains 64% of the variance, but many variables aren't significant.
### Can a model with fewer variables explains nearly as much of the variance? First, with step

### ANNOTATION: Performs stepwise model selection
```r
cf2<-step(cf1)
anova(cf2)
summary(cf2)
```

### Do we need any square terms or interactions?

### MuMin library for cystic fibrosis

### ANNOTATION: Fits global model with na.fail (required for dredge)
```r
cfGlobal<-lm(pemax~weight+bmp+fev1+rv,data=cystfibr,na.action="na.fail")
```

### ANNOTATION: Dredge performs all subsets selection on the global model
```r
cfDredge<-dredge(cfGlobal)
```

### ANNOTATION: Displays the dredge table (models ranked by AICc)
```r
cfDredge
```

### ANNOTATION: Calculates Model Averaged coefficients from the dredge results
```r
model.avg(cfDredge)
```

### ANNOTATION: Calculates variable importance (sum of Akaike weights for models containing each variable)
```r
importance(cfDredge)
```
