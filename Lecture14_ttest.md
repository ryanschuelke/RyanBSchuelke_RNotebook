### Lecture 14. One-sample and Paired t-tests

###   Loads tidyverse for data manipulation
```r
library(tidyverse)
```

###   Reads 'Stalkies.csv' file from URL (flies eye span data)
```r
flies<-read.csv(url("[https://whitlockschluter3e.zoology.ubc.ca/Data/chapter11/chap11e2Stalkies.csv](https://whitlockschluter3e.zoology.ubc.ca/Data/chapter11/chap11e2Stalkies.csv)"))
```

###   Displays the dataframe
###   Datafile 'EyeStalks' is also on Blackboard
```r
flies
```

### Confidence Intervals

###   Opens help documentation for t.test()
```r
?t.test
```

###   Calculates one-sample t-test (default mu=0)
###   Main purpose here is to get the 95% Confidence Interval for the mean
```r
t.test(flies$eyespan)
```

###   Calculates 99% Confidence Interval (conf.level = 0.99)
```r
t.test(flies$eyespan, conf.level = 0.99)
```

### Testing Hypotheses!

###   Opens help again
```r
?t.test
```

###   Reads 'Temperature.csv' data from URL (human body temperature data)
###   Datafile also on Blackboard
```r
temp<-read.csv(url("[https://whitlockschluter3e.zoology.ubc.ca/Data/chapter11/chap11e3Temperature.csv](https://whitlockschluter3e.zoology.ubc.ca/Data/chapter11/chap11e3Temperature.csv)"))
```

###   Opens data viewer
```r
view(temp)
```

###   Performs one-sample t-test testing H0: mu = 98.6
###   Tests if sample mean differs significantly from 98.6
```r
temp.ttest<-t.test(temp$temperature,mu=98.6)
```

###   Displays t-test results
```r
temp.ttest
```

###   Rounds confidence interval to 2 decimal places
```r
round(temp.ttest$conf.int,2)
```

### Confidence intervals for Variance and Standard Deviation

###   Commented out install command (run once if package not installed)
```r
## install.packages("misty")
```

###   Loads 'misty' package for variance confidence intervals
```r
library(misty)
```

###   Opens help for ci.var function
```r
?ci.var
```

###   Calculates Confidence Interval for the VARIANCE
###   method="chisq" uses Chi-squared distribution (standard for normal data)
```r
tempCI <- ci.var(temp$temperature,method = "chisq")
```

###   Displays the result (variance estimate and CI)
```r
tempCI$result$var
```

###   Calculates Standard Deviation CI by taking square root of Variance CI bounds
###   Lower bound
```r
sqrt(tempCI$result$low)
```

###   Upper bound
```r
sqrt(tempCI$result$upp)
```

###   Alternatively, calculate SD CI directly using ci.sd()
```r
ci.sd(temp$temperature,method = "chisq")
```

### Blackbird paired t-test

###   Loads 'abd' package containing Blackbirds dataset
```r
library(abd)
```

###   Shows first 6 rows of Blackbirds data
```r
head(Blackbirds)
```

###   Creates scatterplot of After vs Before antibody levels (log transformed)
###   Adds 1:1 line (slope=1, intercept=0) to visualize changes
###   Points above line = increased; Points below line = decreased
```r
ggplot(Blackbirds,aes(x=log.before,y=log.after))+
  geom_point()+
  geom_abline(slope=1,intercept=0)
```

###   Performs PAIRED t-test
###   Tests if the mean difference between log.after and log.before is 0
###   paired=TRUE is crucial here
```r
blackbird.test<-t.test(Blackbirds$log.after,Blackbirds$log.before,paired=TRUE)
```

###   Displays paired t-test results
```r
blackbird.test
```
