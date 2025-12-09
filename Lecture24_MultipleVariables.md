### Lecture 24. Linear models with multiple variables

###   Loads required packages for analysis and plotting
###   Includes tidyverse, gridExtra (layout), ggfortify (diagnostics), jtools (regression summaries), interactions (interaction plots)
```r
library(tidyverse)
library(gridExtra)
library(ggfortify)
library(jtools)
library(interactions)
theme_set(theme_classic(base_size=12))
```

### Calcium example

###   Reads 'calcium.csv' file (assumes it is in working directory)
###   Summarizes the dataset
###   Creates an Interaction Plot using ggplot
###   stat_summary() plots means +/- standard errors for Calcium by Treatment, colored by Sex
```r
calcium<-read.csv("calcium.csv")
summary(calcium)
ggplot(calcium,aes(x=Treatment,y=Calcium,color=Sex))+
  stat_summary(fun.data=mean_se,size=1,position=position_dodge(width=0.1))+
  ggtitle("Interaction plot")
```

###   Fits a Two-Way ANOVA model with Interaction
###   Calcium ~ Sex * Treatment is equivalent to Sex + Treatment + Sex:Treatment
###   Tests for main effects of Sex, Treatment, and their Interaction
```r
calcium.aov<-lm(Calcium~Sex*Treatment,data=calcium) #or
calcium.aov<-lm(Calcium~Sex+Treatment+Sex:Treatment,data=calcium)
anova(calcium.aov)
```

###   Fits a Reduced Model (Additive Model) WITHOUT interaction
###   Calcium ~ Sex + Treatment
```r
calcium.aov2<-lm(Calcium~Sex+Treatment,data=calcium)
anova(calcium.aov2)
```

### Make plots with ggplot

###   Adds fitted (predicted) values from both models to the dataframe
###   fitFull = predicted values from model with interaction
###   fitReduced = predicted values from model without interaction
```r
calcium$fitFull<-predict(calcium.aov)
calcium$fitReduced<-predict(calcium.aov2)
```

###   Plots actual data vs Predicted values from the Full Model (Interaction)
###   Note that lines for Sex are NOT parallel (allowing for interaction)
```r
#Interaction
g1<-ggplot(calcium,aes(x=Treatment,y=fitFull,color=Sex,group=Sex))+
  geom_point(aes(y=Calcium),position=position_dodge(width=0.1))+
  geom_line(position=position_dodge(width=0.1))+
  ggtitle("Interaction model")
```

###   Plots actual data vs Predicted values from the Reduced Model (Additive)
###   Note that lines for Sex ARE parallel (forcing no interaction)
```r
#Additive
g2<-ggplot(calcium,aes(x=Treatment,y=fitReduced,color=Sex,group=Sex))+
  geom_point(aes(y=Calcium),position=position_dodge(width=0.1))+
  geom_line(position=position_dodge(width=0.1))+
  ggtitle("Additive model")
```

###   Arranges both plots side-by-side for comparison
```r
grid.arrange(g1,g2,ncol=2)
```

###   cat_plot (from interactions package) creates a cleaner interaction plot
```r
cat_plot(calcium.aov, pred = Treatment, modx = Sex, plot.points = TRUE,
         interval = TRUE)
```

###   interaction.plot (base R function) creates a simple interaction plot
```r
interaction.plot(calcium$Treatment,calcium$Sex,calcium$Calcium)
```

### ANCOVA

###   Reads 'NeanderthalBrainSize.csv' from URL
###   Converts species to a factor
###   Summarizes the dataset
```r
neander<-read.csv(url("[https://whitlockschluter3e.zoology.ubc.ca/Data/chapter18/chap18e4NeanderthalBrainSize.csv](https://whitlockschluter3e.zoology.ubc.ca/Data/chapter18/chap18e4NeanderthalBrainSize.csv)"))
neander$species<-factor(neander$species)
summary(neander)
```

###   Fits Full Model (Interaction Model) for ANCOVA
###   lnBrain ~ species * lnMass (tests if slopes differ between species)
```r
neander.lm<-lm(lnBrain~species*lnMass,data=neander)
anova(neander.lm)
summary(neander.lm)
```

###   Fits Reduced Model (Additive Model) for ANCOVA
###   lnBrain ~ species + lnMass (assumes parallel slopes)
###   This tests if intercepts (brain size adjusted for mass) differ between species
```r
neander.lm2<-lm(lnBrain~species+lnMass,data=neander)
anova(neander.lm2)
summary(neander.lm2)
```

###   Creates scatterplot with regression lines
###   geom_smooth(method="lm") fits separate lines for each species (visualizing the interaction)
```r
ggplot(neander,aes(x=lnMass,y=lnBrain,color=species))+
  geom_point()+
  geom_smooth(method="lm")
```

### General Linear Models

### Null model: y ~ 1

###   Reads 'LionNoses.csv' from URL
###   Fits Null Model (Intercept only): ageInYears ~ 1
###   Fits Linear Regression Model: ageInYears ~ proportionBlack
```r
lion<-read.csv(url("[https://whitlockschluter3e.zoology.ubc.ca/Data/chapter17/chap17e1LionNoses.csv](https://whitlockschluter3e.zoology.ubc.ca/Data/chapter17/chap17e1LionNoses.csv)"))
lionnull<-lm(ageInYears~1,data=lion)
lionlm<-lm(ageInYears~proportionBlack,data=lion)
```

###   Compares the two models using ANOVA
###   Tests if adding 'proportionBlack' significantly improves fit over the null model
```r
anova(lionnull,lionlm)
```

###   Plots the two models
###   lion1: Linear regression (y ~ x) - sloped line
###   lion2: Null model (y ~ 1) - flat horizontal line at the mean
```r
lion1<-ggplot(lion,aes(x=proportionBlack,y=ageInYears))+geom_point()+
  geom_smooth(method="lm",formula=y~x)+
  ggtitle("Linear regression y~x")
lion2<-ggplot(lion,aes(x=proportionBlack,y=ageInYears))+geom_point()+
  geom_smooth(method="lm",formula=y~1)+
  ggtitle("Null model y~1")
grid.arrange(lion2,lion1,ncol=2)
```

### ANOVA as lm

###   Reads 'KneesWhoSayNight.csv' data
###   Converts treatment to factor and orders levels
###   Fits ANOVA model (as linear model): shift ~ treatment
###   Fits Null model: shift ~ 1
```r
knee<-read.csv(url("[https://whitlockschluter3e.zoology.ubc.ca/Data/chapter15/chap15e1KneesWhoSayNight.csv](https://whitlockschluter3e.zoology.ubc.ca/Data/chapter15/chap15e1KneesWhoSayNight.csv)"))
summary(knee)
knee$treatment<-factor(knee$treatment,levels=unique(knee$treatment))
kneelm<-lm(shift~treatment,data=knee)
kneenull<-lm(shift~1,data=knee)
```

###   Calculates group means and SEs for plotting
```r
kneeSum <- knee %>% group_by(treatment) %>%
  summarize(mean=mean(shift),
            se=sd(shift)/sqrt(n()))
```

###   Calculates overall grand mean and SE
```r
kneeAll <- knee %>%
  summarize(mean=mean(shift),
            se=sd(shift)/sqrt(n()))
```

###   Duplicates the grand mean row 3 times to match the structure for plotting
```r
kneeAll<-rbind(kneeAll,kneeAll,kneeAll) %>%
  mutate(treatment=kneeSum$treatment)
kneeAll
```

###   Plots the two models
###   knee1: ANOVA model (means vary by group)
###   knee2: Null model (grand mean for everyone)
```r
knee1<-ggplot(knee,aes(x=treatment,y=shift))+
  geom_point(col="darkred",position=position_jitter(width=0.1))+
  geom_errorbar(data=kneeSum,
                aes(x=treatment,y=mean,ymin=mean-se,ymax=mean+se),width=0.2)+
  ggtitle("ANOVA y~x")

knee2<-ggplot(knee,aes(x=treatment,y=shift))+
  geom_point(col="darkred",position=position_jitter(width=0.1))+
  geom_errorbar(data=kneeAll,
                aes(x=treatment,y=mean,ymin=mean-se,ymax=mean+se),width=0.2)+
  ggtitle("Null y~1")
grid.arrange(knee2,knee1,ncol=2)
```

###   Compares the Null model vs ANOVA model
###   This is mathematically identical to the standard one-way ANOVA F-test
```r
anova(kneenull,kneelm)
```
