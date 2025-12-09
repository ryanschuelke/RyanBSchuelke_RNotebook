###   Loads tidyverse package for data manipulation and visualization
```r
library(tidyverse)
```

### 22 Linear regression
### Lion example

###   Reads 'LionNoses.csv' from URL
###   Data on lion age vs proportion of black pigmentation on nose
```r
lion<-read.csv(url("[https://whitlockschluter3e.zoology.ubc.ca/Data/chapter17/chap17e1LionNoses.csv](https://whitlockschluter3e.zoology.ubc.ca/Data/chapter17/chap17e1LionNoses.csv)"))
```

###   Opens data viewer
```r
view(lion)
```

###   Creates scatterplot of Age vs Proportion Black
```r
ggplot(lion,aes(x=proportionBlack,y=ageInYears))+
  geom_point()+theme_classic(base_size=10)
```

###   Fits a linear regression model (lm)
###   ageInYears (Y) predicted by proportionBlack (X)
```r
lion.lm<-lm(ageInYears~proportionBlack,data=lion)
```

###   Displays model coefficients (Intercept and Slope)
```r
lion.lm
```

###   Displays detailed model summary (residuals, coefficients, R-squared, P-values)
```r
summary(lion.lm)
```

### ANOVA summary table from regression output

###   Generates ANOVA table for the regression model
###   Tests if the model explains significant variation (F-test)
```r
anova(lion.lm)
```

### Fitting line to data

###   Plot with regression line added
###   stat_smooth(method="lm") adds the linear regression line
###   se=FALSE removes the shaded confidence interval region
```r
ggplot(lion,aes(x=proportionBlack,y=ageInYears))+
  geom_point()+
  stat_smooth(method="lm", se=FALSE)
```

###   Same plot with custom labels and theme
```r
ggplot(lion,aes(x=proportionBlack,y=ageInYears))+
  geom_point()+
  stat_smooth(method="lm",se=FALSE)+
  xlab("Proportion black")+
  ylab("Age")+
  theme_classic(base_size=10)
```

### Testing Hypothesis ≠0
### test.stat<-(slopeval-slopeNull)/slopeSE

###   Manually calculates t-statistic for the slope
###   H0: Slope = 0 (no relationship)
###   Values (10.6471, 1.5095) come from summary(lion.lm) output
```r
slopeNull<-0
test.stat<-(10.6471-slopeNull)/1.5095
```

### Since test.stat is positive, take the negative to get to the left of the bell
### curve and multiply by 2 for a 2-sided test

###   Calculates P-value from the t-statistic
###   pt() gives cumulative probability from t-distribution with n-2 degrees of freedom
```r
PValue<-2*pt(-test.stat,df=nrow(lion)-2)  
PValue
```

### Confidence Intervals
### ggplot

###   Opens help for stat_smooth
```r
?stat_smooth
```

### Same code as above without SE=FALSE

###   Plot with regression line AND Confidence Interval (shaded region)
###   Default is se=TRUE (95% CI)
```r
ggplot(lion,aes(x=proportionBlack,y=ageInYears))+
  geom_point()+
  stat_smooth(method="lm")
```

### Confidence Bands

###   Calculates Confidence Intervals for the model coefficients (Slope and Intercept)
```r
confint(lion.lm, level=0.95)
```

### Prediction intervals

###   Predicts Age for a new lion with 0.5 proportion black
###   interval="confidence" gives CI for the MEAN age at X=0.5
```r
predict(lion.lm,data.frame(proportionBlack=0.5),interval="confidence")
```

###   Predicts Age for a new lion with 0.5 proportion black
###   interval="prediction" gives PI for an INDIVIDUAL lion at X=0.5 (wider range)
```r
predict(lion.lm,data.frame(proportionBlack=0.5),interval="prediction")
```

### Assumptions

###   Creates diagnostic plots for the regression model
###   Checks linearity, normality of residuals, homoscedasticity, etc.
```r
library(ggfortify)
autoplot(lion.lm)
```
