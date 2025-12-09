###   Loads required packages for analysis and visualization
###   Includes tidyverse (data manip), gridExtra (plot arrangement), multcompView (post-hoc letters), lme4 (mixed models), coin/lmPerm (permutation tests), ggfortify (diagnostics)
```r
library(tidyverse)
library(gridExtra)
library(multcompView)
library(lme4)   #For mixed models
library(coin)
library(lmPerm)  # For more permutation tests
library(ggfortify)
theme_set(theme_bw())
```

### Make figures

###   Reads 'HoneybeeCaffeine.csv' from URL
###   Converts 'ppmCaffeine' to a factor with levels in original order
###   Fits linear model (lm) and runs ANOVA
###   Runs Tukey's HSD post-hoc test
###   Generates significance letters (multcompLetters) based on P-values
###   Summarizes means and adds significance letters
###   Plots means with error bars (pointrange) and adds letters indicating significance groups
```r
caffeine<-read.csv(url("[https://whitlockschluter3e.zoology.ubc.ca/Data/chapter15/chap15q01HoneybeeCaffeine.csv](https://whitlockschluter3e.zoology.ubc.ca/Data/chapter15/chap15q01HoneybeeCaffeine.csv)"))
caffeine<-mutate(caffeine, ppmCaffeine=factor(ppmCaffeine,levels=unique(ppmCaffeine)))
lmCaffeine <- lm(consumptionDifferenceFromControl~ppmCaffeine,data=caffeine)
anova(lmCaffeine)
caffeineTukey<-TukeyHSD(aov(lmCaffeine))

multcompLetters(caffeineTukey$ppmCaffeine[,4])
labels<-multcompLetters(caffeineTukey$ppmCaffeine[,4])$Letters
labels<-labels[c(4,1,2,3)]

caffeineSum<-caffeine %>% 
  group_by(ppmCaffeine) %>%
  summarize(mean=mean(consumptionDifferenceFromControl)) %>%
  mutate(letters=labels)

ggplot(caffeine, aes(x=ppmCaffeine, y=consumptionDifferenceFromControl))+
  stat_summary(fun.data = mean_se, geom = "pointrange") +
  geom_text(data=caffeineSum,aes(x=ppmCaffeine,y=mean,label=letters),hjust=-1)
```

### Planned comparisons

###   Defines custom contrasts for planned comparisons
###   First contrast: compares first group (-3) vs average of others (1,1,1)
###   Second contrast: compares groups 2 vs 3 (first is 0)
###   Third contrast: compares groups 3 vs 4
###   Assigns these contrasts to the 'ppmCaffeine' factor
###   summary.aov(..., split=...) partitions the Sum of Squares based on these contrasts
```r
contrasts(caffeine$ppmCaffeine)<-cbind(c(-3,1,1,1),c(0,-1,1,0),c(0,0,-1,1))
summary.aov(lmCaffeine, split=list(ppmCaffeine=list("0 vs rest"=1, "50 vs 100" = 2, "100 vs 200" = 3))) 
```

### Violating assumptions

###   Re-reads 'KneesWhoSayNight.csv' data
###   Converts treatment to factor
###   Fits linear model for shift ~ treatment
```r
knee<-read.csv(url("[https://whitlockschluter3e.zoology.ubc.ca/Data/chapter15/chap15e1KneesWhoSayNight.csv](https://whitlockschluter3e.zoology.ubc.ca/Data/chapter15/chap15e1KneesWhoSayNight.csv)"))
knee$treatment<-factor(knee$treatment)
knee$treatment<-factor(knee$treatment,levels=unique(knee$treatment))
kneelm<-lm(shift~treatment,data=knee)
```

### Welch's ANOVA

###   Performs Welch's ANOVA (does not assume equal variances) using oneway.test()
###   Compares standard ANOVA results
###   Also runs Welch's ANOVA on caffeine data
```r
oneway.test(shift~treatment,data=knee,var.equal=TRUE)
anova(kneelm)
oneway.test(shift~treatment,data=knee)
oneway.test(consumptionDifferenceFromControl~ppmCaffeine,data=caffeine)
```

### Kruskal-Wallis non-parametric equivalent of ANOVA

###   Performs Kruskal-Wallis rank sum test (non-parametric alternative to one-way ANOVA)
###   Tests if median 'shift' differs between groups
###   Also shows 'coin' package version (kruskal_test)
```r
kruskal.test(shift~treatment,data=knee)
kruskal.test(consumptionDifferenceFromControl~ppmCaffeine,data=caffeine)

# or in coin
kruskal_test(shift~factor(treatment),data=knee)
```

### Permuation test

###   Performs permutation-based ANOVA using 'lmPerm' package (aovp function)
###   Calculates P-values by shuffling data labels instead of theoretical F-distribution
```r
library(lmPerm)

summary(aovp(shift~treatment,data=knee))
summary(aovp(consumptionDifferenceFromControl~ppmCaffeine,data=caffeine))
```

### Random effects

###   Reads 'WalkingStickFemurs.csv' data
###   Converts 'specimen' to a factor (random effect grouping variable)
###   Plots femurLength by specimen to visualize variation within vs between specimens
```r
femur<-read.csv(url("[https://whitlockschluter3e.zoology.ubc.ca/Data/chapter15/chap15e6WalkingStickFemurs.csv](https://whitlockschluter3e.zoology.ubc.ca/Data/chapter15/chap15e6WalkingStickFemurs.csv)"))
summary(femur)
#Must make specimen a factor
femur <- femur %>%
  mutate(specimen=factor(specimen)) 
ggplot(femur,aes(x=specimen,y=femurLength))+geom_point()
```

### lmer

###   Fits a Linear Mixed-Effects Model (lmer)
###   (1 | specimen) specifies 'specimen' as a random intercept (random effect)
###   summary() shows variance components (Variance due to specimen vs Residual variance)
###   Calculates Repeatability (ICC): Var_specimen / (Var_specimen + Var_residual)
```r
lmerFemur<-lmer(femurLength~1+(1|specimen),data=femur)
summary(lmerFemur)
#Repeatability
0.0348/(0.0348+0.0152)
```

### Calculate variance components manually

###   Calculates variance components manually using standard ANOVA
###   MS_groups (Mean Sq for specimen) and MS_error (Mean Sq Residuals)
###   Formula: Var_A = (MS_groups - MS_error) / n (where n=2 measurements per specimen)
###   Repeatability matches the lmer result
```r
femurLm<-lm(femurLength~specimen,data=femur)
anova(femurLm)
varA<-(0.0848-0.0152)/2
varA
varA/(varA+0.0152)
```
