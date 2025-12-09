### Lecture 16. Data transformations

###   Loads tidyverse package for data manipulation and visualization
```r
library(tidyverse)
```

### qq normal

###   Reads 'marineReserve.csv' from a URL
```r
marineReserve<-read.csv(url("[https://whitlockschluter3e.zoology.ubc.ca/Data/chapter13/chap13e1marineReserve.csv](https://whitlockschluter3e.zoology.ubc.ca/Data/chapter13/chap13e1marineReserve.csv)"))
```

###   Opens the data viewer to inspect the dataframe
```r
view(marineReserve)
```

### Plot data

###   Creates a histogram to visualize the distribution of 'biomassRatio'
###   This helps check for normality (is it bell-shaped?)
```r
ggplot(marineReserve,aes(x=biomassRatio))+geom_histogram()
```

###   Plots the empirical cumulative density function (ECDF)
###   Shows the proportion of data points less than or equal to x
```r
ggplot(marineReserve,aes(x=biomassRatio))+
  stat_ecdf()
```

### Notice 'sample'

###   Creates a Normal Q-Q plot (Quantile-Quantile plot)
###   aes(sample=...) maps the data to sample quantiles
###   If data is normal, points should fall roughly on a straight diagonal line
```r
ggplot(marineReserve,aes(sample=biomassRatio))+geom_qq()
```

### Add line

###   Adds a reference line (geom_qq_line) to the Q-Q plot
###   Helps visually judge if points deviate from normality (the straight line)
```r
ggplot(marineReserve,aes(sample=biomassRatio))+
  geom_qq()+
  geom_qq_line()
```

### Need to add axis titles

###   Adds custom x and y axis labels to the Q-Q plot
```r
ggplot(marineReserve,aes(sample=biomassRatio))+
  geom_qq()+
  geom_qq_line()+
  xlab("theoretical quantiles")+
  ylab("empirical quantiles")
```

### Shapiro wilks test

###   Performs Shapiro-Wilk test for normality
###   H0: Data is normally distributed. P < 0.05 indicates deviation from normality.
```r
shapiro.test(marineReserve$biomassRatio)
```

### t test log transformed

###   Performs a one-sample t-test on the LOG-transformed data
###   Log transformation is often used to normalize right-skewed data
```r
t.test(log(marineReserve$biomassRatio))
```

### OR create new column

###   Creates a new column 'logdata' containing the log-transformed values
```r
marineReserve$logdata = log(marineReserve$biomassRatio)
```

###   Views the dataframe with the new column
```r
view(marineReserve)
```

###   Runs the t-test on the new 'logdata' column (same result as above)
```r
t.test(marineReserve$logdata)
```

### Calculating CIs

###   Stores the t-test result object
```r
marResTtest <- t.test(marineReserve$logdata)
```

###   Back-transforms the Confidence Interval from log scale to original scale
###   exp() is the inverse of log()
```r
CI <- exp(marResTtest$conf.int)
```

###   Rounds the back-transformed CI to 2 decimal places
```r
round(CI,2)
```

### Data transformations

###   Reads 'proportions.csv' file (assumes it is in working directory)
```r
proportions<-read.csv("proportions.csv")
```

###   Views the proportions dataframe
```r
view(proportions)
```

###   Plots histogram of variable 'p' (proportions)
```r
ggplot(proportions,aes(x=p)) +geom_histogram()
```

###   Creates Q-Q plot for variable 'p'
```r
ggplot(proportions,aes(sample=p)) +
  geom_qq()+
  geom_qq_line()
```

###   Runs Shapiro-Wilk test on 'p'
```r
shapiro.test(proportions$p)
```

### arcsine sqrt

###   Creates new column 'asinsqrt' using Arcsine Square Root transformation
###   Formula: asin(sqrt(p)). Used to be standard for proportion data (0 to 1 range).
```r
proportions<- proportions %>% 
  mutate(asinsqrt=asin(sqrt(p)))
```

###   Views dataframe with transformed column
```r
view(proportions)
```

###   Runs Shapiro-Wilk test on the transformed data
```r
shapiro.test(proportions$asinsqrt)
```

###   Plots histogram of the transformed data
```r
ggplot(proportions,aes(x=asinsqrt)) +geom_histogram()
```

###   Creates Q-Q plot of the transformed data
```r
ggplot(proportions,aes(sample=asinsqrt)) +
  geom_qq()+
  geom_qq_line()
```

### CI with asin sqrt

###   Runs t-test on arcsine-sqrt transformed data
```r
asinsqrt.t<-t.test(proportions$asinsqrt)
```

###   Extracts the confidence interval from the t-test object
```r
asinsqrt.t$conf.int
```

### Must transform back

###   Back-transforms CI to original proportion scale
###   Reverse of asin(sqrt(p)) is sin(x)^2
```r
CI<-sin(asinsqrt.t$conf.int)^2
```

###   Rounds back-transformed CI to 2 decimal places
```r
round(CI,2)
```

### logit

###   Defines custom function for Logit transformation
###   Formula: log(x / (1 - x))
```r
logit<-function(x) log(x/(1-x))
```
