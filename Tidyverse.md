### Loads tidyverse package - a collection of packages for data manipulation (includes dplyr, tidyr, etc.)
```r
library(tidyverse)
```

### Loads ggplot2 package for creating visualizations (also included in tidyverse, but loaded explicitly here)
```r
library(ggplot2)
```

### Reads the CSV file "hogfish.csv" into a dataframe called 'hogfish'
```r
hogfish <- read.csv("hogfish.csv")
```

### Creates a histogram of the 'L' column (likely Length); geom_histogram() bins continuous data and shows frequency
```r
ggplot(hogfish,aes(L))+geom_histogram()
```

### Preset options helpful for avoiding typos & checking data has loaded correctly:

### head() shows the first 6 values of the 'L' column - useful to verify data loaded correctly
```r
head(hogfish$L)
```

### Opens help documentation for geom_boxplot() function
```r
?geom_boxplot
```

### Attempts to create a boxplot with L on x-axis - this creates a horizontal boxplot
```r
ggplot(hogfish,aes(L))+geom_boxplot()
```

### Creates a vertical boxplot with L on y-axis - the standard orientation for boxplots
### Boxplots show: median (center line), IQR (box), whiskers (1.5×IQR), and outliers (points)
```r
ggplot(hogfish,aes(y=L))+geom_boxplot()
```

### Calculating mean, median and quantiles

### median() calculates the middle value when data is sorted (50th percentile)
```r
median(hogfish$L)
```

### Opens help documentation for quantile() function
```r
?quantile
```

### quantile() returns the 0%, 25%, 50%, 75%, and 100% percentiles (min, Q1, median, Q3, max)
```r
quantile(hogfish$L)
```

### Returns the 97th percentile - the value below which 97% of data falls
```r
quantile(hogfish$L,c(0.97))
```

### Returns the 10th percentile - the value below which 10% of data falls
```r
quantile(hogfish$L,c(0.1))
```

### Interquartile Range

### Opens help documentation for IQR() function
```r
?IQR
```

### IQR() calculates Interquartile Range = Q3 - Q1 (the spread of the middle 50% of data)
### IQR is a robust measure of spread, not affected by outliers
```r
IQR(hogfish$L)
```

### summary() shows min, Q1, median, mean, Q3, max for numeric columns in the dataframe
```r
summary(hogfish)
```

### mean() calculates the arithmetic average of all values in hogfish$L
```r
mean(hogfish$L)
```

### round() rounds to the nearest whole number (0 decimal places by default)
```r
round(mean(hogfish$L))
```

### round(x, 1) rounds to 1 decimal place
```r
round(mean(hogfish$L),1)
```

### var() calculates the sample variance - measures how spread out the data is (in squared units)
### Formula: sum of squared deviations from mean, divided by (n-1)
```r
var(hogfish$L)
```

### sd() calculates the sample standard deviation - square root of variance (in original units)
```r
sd(hogfish$L)
```

### sqrt(var()) manually calculates standard deviation by taking square root of variance
### This proves that sd() = sqrt(var())
```r
sqrt(var(hogfish$L))
```

### Opens help documentation for sd() function
```r
?sd
```

### CV

### Calculates Coefficient of Variation (CV) = standard deviation / mean
### CV is a unitless measure of relative variability - useful for comparing spread across different scales
```r
sd(hogfish$L)/mean(hogfish$L)
```

###  Same CV calculation, rounded to 2 decimal places
```r
round(sd(hogfish$L)/mean(hogfish$L),2)
```

### Calculating means and variances from frequency tables

###  Creates a dataframe manually with two columns: Value (0 to 5) and Frequency (how many times each value occurs)
###  data.frame() creates a table; 0:5 generates sequence 0,1,2,3,4,5; c() creates a vector of frequencies
```r
df1<-data.frame(Value=0:5,Frequency=c(5,2,3,4,1,2))
```

###  Displays the dataframe to see its contents
```r
df1
```

###  sum() adds up all frequencies - this gives the total number of observations (n)
```r
sum(df1$Frequency)
```

### Calculate mean

###  Calculates weighted mean from frequency table:
###  Numerator: sum of (each value × its frequency) = total sum of all values
###  Denominator: sum of frequencies = total count (n)
###  Formula: Σ(x × f) / Σf
```r
sum(df1$Value*df1$Frequency)/sum(df1$Frequency)
```

### Make object so can be used

###  Stores the calculated mean in a variable 'meanval' for use in later calculations
```r
meanval<-sum(df1$Value*df1$Frequency)/sum(df1$Frequency)
```

### Calculate variance

###  Calculates sample variance from frequency table:
###  (df1$Value - meanval) = deviation of each value from the mean
###  **2 = squares the deviations (same as ^2)
###  *df1$Frequency = multiplies by frequency (weights each squared deviation)
###  sum() = adds up all weighted squared deviations
###  /(sum(df1$Frequency)-1) = divides by (n-1) for sample variance (Bessel's correction)
###  Formula: Σ[(x - mean)² × f] / (n-1)
```r
sum((df1$Value-meanval)**2*df1$Frequency)/(sum(df1$Frequency)-1)
```

### Calculate median

###  Creates a new column 'Cumulative.Freq' using cumsum() which calculates running total of frequencies
###  cumsum() returns cumulative sum: each element is sum of all previous elements plus itself
###  Useful for finding median: the value where cumulative frequency reaches or exceeds n/2
```r
df1$Cumulative.Freq<-cumsum(df1$Frequency)
```

###  Displays the dataframe now with the new Cumulative.Freq column added
```r
df1
```
