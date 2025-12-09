### Lecture 16. Data transformations

### ANNOTATION: Loads tidyverse package for data manipulation and visualization
```r
library(tidyverse)
```

### qq normal

### ANNOTATION: Reads 'marineReserve.csv' from a URL
```r
marineReserve<-read.csv(url("[https://whitlockschluter3e.zoology.ubc.ca/Data/chapter13/chap13e1marineReserve.csv](https://whitlockschluter3e.zoology.ubc.ca/Data/chapter13/chap13e1marineReserve.csv)"))
```

### ANNOTATION: Opens the data viewer to inspect the dataframe
```r
view(marineReserve)
```

### Plot data

### ANNOTATION: Creates a histogram to visualize the distribution of 'biomassRatio'
### ANNOTATION: This helps check for normality (is it bell-shaped?)
```r
ggplot(marineReserve,aes(x=biomassRatio))+geom_histogram()
```

### ANNOTATION: Plots the empirical cumulative density function (ECDF)
### ANNOTATION: Shows the proportion of data points less than or equal to x
```r
ggplot(marineReserve,aes(x=biomassRatio))+
  stat_ecdf()
```

### Notice 'sample'

### ANNOTATION: Creates a Normal Q-Q plot (Quantile-Quantile plot)
### ANNOTATION: aes(sample=...) maps the data to sample quantiles
### ANNOTATION: If data is normal, points should fall roughly on a straight diagonal line
```r
ggplot(marineReserve,aes(sample=biomassRatio))+geom_qq()
```

### Add line

### ANNOTATION: Adds a reference line (geom_qq_line) to the Q-Q plot
### ANNOTATION: Helps visually judge if points deviate from normality (the straight line)
```r
ggplot(marineReserve,aes(sample=biomassRatio))+
  geom_qq()+
  geom_qq_line()
```

### Need to add axis titles

### ANNOTATION: Adds custom x and y axis labels to the Q-Q plot
```r
ggplot(marineReserve,aes(sample=biomassRatio))+
  geom_qq()+
  geom_qq_line()+
  xlab("theoretical quantiles")+
  ylab("empirical quantiles")
```

### Shapiro wilks test

### ANNOTATION: Performs Shapiro-Wilk test for normality
### ANNOTATION: H0: Data is normally distributed. P < 0.05 indicates deviation from normality.
```r
shapiro.test(marineReserve$biomassRatio)
```

### t test log transformed

### ANNOTATION: Performs a one-sample t-test on the LOG-transformed data
### ANNOTATION: Log transformation is often used to normalize right-skewed data
```r
t.test(log(marineReserve$biomassRatio))
```

### OR create new column

### ANNOTATION: Creates a new column 'logdata' containing the log-transformed values
```r
marineReserve$logdata = log(marineReserve$biomassRatio)
```

### ANNOTATION: Views the dataframe with the new column
```r
view(marineReserve)
```

### ANNOTATION: Runs the t-test on the new 'logdata' column (same result as above)
```r
t.test(marineReserve$logdata)
```

### Calculating CIs

### ANNOTATION: Stores the t-test result object
```r
marResTtest <- t.test(marineReserve$logdata)
```

### ANNOTATION: Back-transforms the Confidence Interval from log scale to original scale
### ANNOTATION: exp() is the inverse of log()
```r
CI <- exp(marResTtest$conf.int)
```

### ANNOTATION: Rounds the back-transformed CI to 2 decimal places
```r
round(CI,2)
```

### Data transformations

### ANNOTATION: Reads 'proportions.csv' file (assumes it is in working directory)
```r
proportions<-read.csv("proportions.csv")
```

### ANNOTATION: Views the proportions dataframe
```r
view(proportions)
```

### ANNOTATION: Plots histogram of variable 'p' (proportions)
```r
ggplot(proportions,aes(x=p)) +geom_histogram()
```

### ANNOTATION: Creates Q-Q plot for variable 'p'
```r
ggplot(proportions,aes(sample=p)) +
  geom_qq()+
  geom_qq_line()
```

### ANNOTATION: Runs Shapiro-Wilk test on 'p'
```r
shapiro.test(proportions$p)
```

### arcsine sqrt

### ANNOTATION: Creates new column 'asinsqrt' using Arcsine Square Root transformation
### ANNOTATION: Formula: asin(sqrt(p)). Used to be standard for proportion data (0 to 1 range).
```r
proportions<- proportions %>% 
  mutate(asinsqrt=asin(sqrt(p)))
```

### ANNOTATION: Views dataframe with transformed column
```r
view(proportions)
```

### ANNOTATION: Runs Shapiro-Wilk test on the transformed data
```r
shapiro.test(proportions$asinsqrt)
```

### ANNOTATION: Plots histogram of the transformed data
```r
ggplot(proportions,aes(x=asinsqrt)) +geom_histogram()
```

### ANNOTATION: Creates Q-Q plot of the transformed data
```r
ggplot(proportions,aes(sample=asinsqrt)) +
  geom_qq()+
  geom_qq_line()
```

### CI with asin sqrt

### ANNOTATION: Runs t-test on arcsine-sqrt transformed data
```r
asinsqrt.t<-t.test(proportions$asinsqrt)
```

### ANNOTATION: Extracts the confidence interval from the t-test object
```r
asinsqrt.t$conf.int
```

### Must transform back

### ANNOTATION: Back-transforms CI to original proportion scale
### ANNOTATION: Reverse of asin(sqrt(p)) is sin(x)^2
```r
CI<-sin(asinsqrt.t$conf.int)^2
```

### ANNOTATION: Rounds back-transformed CI to 2 decimal places
```r
round(CI,2)
```

### logit

### ANNOTATION: Defines custom function for Logit transformation
### ANNOTATION: Formula: log(x / (1 - x))
```r
logit<-function(x) log(x/(1-x))
```
