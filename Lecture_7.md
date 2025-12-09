### LECTURE 7

### SHORTCUTS
### Command – shift – M = pipe %>% 
### Command – enter = run
### (option – dash = arrow <- )


### ANNOTATION: c() combines values into a vector; creates a sample of 10 measurements stored in variable Y
```r
Y <- c(16.54, 23.13, 20.15, 16.43, 25.22, 23.87, 25.42, 21.89, 22.96, 10.51)
```

### ANNOTATION: mean() calculates the arithmetic average (sample mean, ȳ) of all values in Y
```r
mean(Y)
```

### ANNOTATION: sd() calculates the sample standard deviation - measures spread of data around the mean
```r
sd(Y)
```

### ANNOTATION: length() returns the number of elements in Y (the sample size, n)
```r
length(Y)
```

### ANNOTATION: Calculates Standard Error (SE) of the mean and stores it in variable 'SE'
### ANNOTATION: Formula: SE = s / √n where s = standard deviation and n = sample size
### ANNOTATION: sqrt() calculates square root; SE measures how precisely the sample mean estimates the population mean
```r
SE <- sd(Y)/sqrt(length(Y))
```

### ANNOTATION: Same calculation as above, just prints the result without storing it
```r
sd(Y)/sqrt(length(Y))
```

### For ease of calculation, we can make our own standard error function

### ANNOTATION: function(x) creates a custom function that takes input 'x'
### ANNOTATION: The code inside { } defines what the function does
### ANNOTATION: This creates a reusable 'standard.error' function you can apply to any vector
```r
standard.error<-function(x) {
  # ANNOTATION: Calculates SE = standard deviation / square root of sample size
  sd(x)/sqrt(length(x))
}
```

### CV

### ANNOTATION: Calculates Coefficient of Variation of the SE relative to the mean
### ANNOTATION: This shows the SE as a proportion of the mean (measures relative precision)
```r
SE/mean(Y)
```

### CI

### ANNOTATION: Calculates UPPER bound of 95% Confidence Interval
### ANNOTATION: Formula: mean + (z * SE) where z = 1.96 for 95% CI (from standard normal distribution)
### ANNOTATION: 20.6 is approximately the mean of Y; this gives the upper limit of the CI
```r
20.6+(1.96*SE)
```

### ANNOTATION: Calculates LOWER bound of 95% Confidence Interval
### ANNOTATION: Formula: mean - (z * SE)
### ANNOTATION: The 95% CI means: we are 95% confident the true population mean falls within this interval
```r
20.6-(1.96*SE)
```
