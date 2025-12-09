### Lecture 14. One-sample and Paired t-tests

### ANNOTATION: Loads tidyverse for data manipulation
```r
library(tidyverse)
```

### ANNOTATION: Reads 'Stalkies.csv' file from URL (flies eye span data)
```r
flies<-read.csv(url("[https://whitlockschluter3e.zoology.ubc.ca/Data/chapter11/chap11e2Stalkies.csv](https://whitlockschluter3e.zoology.ubc.ca/Data/chapter11/chap11e2Stalkies.csv)"))
```

### ANNOTATION: Displays the dataframe
### ANNOTATION: Datafile 'EyeStalks' is also on Blackboard
```r
flies
```

### Confidence Intervals

### ANNOTATION: Opens help documentation for t.test()
```r
?t.test
```

### ANNOTATION: Calculates one-sample t-test (default mu=0)
### ANNOTATION: Main purpose here is to get the 95% Confidence Interval for the mean
```r
t.test(flies$eyespan)
```

### ANNOTATION: Calculates 99% Confidence Interval (conf.level = 0.99)
```r
t.test(flies$eyespan, conf.level = 0.99)
```

### Testing Hypotheses!

### ANNOTATION: Opens help again
```r
?t.test
```

### ANNOTATION: Reads 'Temperature.csv' data from URL (human body temperature data)
### ANNOTATION: Datafile also on Blackboard
```r
temp<-read.csv(url("[https://whitlockschluter3e.zoology.ubc.ca/Data/chapter11/chap11e3Temperature.csv](https://whitlockschluter3e.zoology.ubc.ca/Data/chapter11/chap11e3Temperature.csv)"))
```

### ANNOTATION: Opens data viewer
```r
view(temp)
```

### ANNOTATION: Performs one-sample t-test testing H0: mu = 98.6
### ANNOTATION: Tests if sample mean differs significantly from 98.6
```r
temp.ttest<-t.test(temp$temperature,mu=98.6)
```

### ANNOTATION: Displays t-test results
```r
temp.ttest
```

### ANNOTATION: Rounds confidence interval to 2 decimal places
```r
round(temp.ttest$conf.int,2)
```

### Confidence intervals for Variance and Standard Deviation

### ANNOTATION: Commented out install command (run once if package not installed)
```r
## install.packages("misty")
```

### ANNOTATION: Loads 'misty' package for variance confidence intervals
```r
library(misty)
```

### ANNOTATION: Opens help for ci.var function
```r
?ci.var
```

### ANNOTATION: Calculates Confidence Interval for the VARIANCE
### ANNOTATION: method="chisq" uses Chi-squared distribution (standard for normal data)
```r
tempCI <- ci.var(temp$temperature,method = "chisq")
```

### ANNOTATION: Displays the result (variance estimate and CI)
```r
tempCI$result$var
```

### ANNOTATION: Calculates Standard Deviation CI by taking square root of Variance CI bounds
### ANNOTATION: Lower bound
```r
sqrt(tempCI$result$low)
```

### ANNOTATION: Upper bound
```r
sqrt(tempCI$result$upp)
```

### ANNOTATION: Alternatively, calculate SD CI directly using ci.sd()
```r
ci.sd(temp$temperature,method = "chisq")
```

### Blackbird paired t-test

### ANNOTATION: Loads 'abd' package containing Blackbirds dataset
```r
library(abd)
```

### ANNOTATION: Shows first 6 rows of Blackbirds data
```r
head(Blackbirds)
```

### ANNOTATION: Creates scatterplot of After vs Before antibody levels (log transformed)
### ANNOTATION: Adds 1:1 line (slope=1, intercept=0) to visualize changes
### ANNOTATION: Points above line = increased; Points below line = decreased
```r
ggplot(Blackbirds,aes(x=log.before,y=log.after))+
  geom_point()+
  geom_abline(slope=1,intercept=0)
```

### ANNOTATION: Performs PAIRED t-test
### ANNOTATION: Tests if the mean difference between log.after and log.before is 0
### ANNOTATION: paired=TRUE is crucial here
```r
blackbird.test<-t.test(Blackbirds$log.after,Blackbirds$log.before,paired=TRUE)
```

### ANNOTATION: Displays paired t-test results
```r
blackbird.test
```
