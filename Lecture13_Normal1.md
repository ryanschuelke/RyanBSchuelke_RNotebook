### Normal functions
### Default is standard normal (mean=0, sd=1)

### ANNOTATION: Opens help documentation for dnorm function
```r
?dnorm
```

### dnorm is the probability density for making plots

### ANNOTATION: dnorm(0) gives the height of the density curve at z=0 (peak of standard normal)
### ANNOTATION: pnorm(0) gives the cumulative probability area to the left of z=0 (should be 0.5)
### ANNOTATION: qnorm(0.025) gives the z-score that has 0.025 area to the left (approx -1.96)
```r
dnorm(0)
pnorm(0)
qnorm(0.025) 
```

### Spies

### ANNOTATION: Calculates probability of height < 180.3 given mean=177 and sd=7.1
```r
pnorm(180.3,mean=177,sd=7.1) 
```

### ANNOTATION: Calculates probability of height > 180.3 (1 minus the lower tail)
### ANNOTATION: This gives > which is what the question is asking
```r
1-pnorm(180.3,mean=177,sd=7.1) #This gives > which is what the question is asking
```

### Birth Weight in class activity
### A

### ANNOTATION: Calculates probability of weight > 5
```r
1-pnorm(5,mean=3.339, sd=0.573)
```

### B

### ANNOTATION: Calculates probability of weight between 3 and 4
### ANNOTATION: P(X < 4) - P(X < 3)
```r
pnorm(4,mean=3.339, sd=0.573) - (pnorm(3,mean=3.339, sd=0.573))
```

### C There are several ways to answer this. You could also have used the standard normal

### ANNOTATION: Calculates 1.5 standard deviations
```r
calc <- 0.573*1.5
```

### ANNOTATION: Finds the Upper and Lower boundaries (Mean +/- 1.5 SDs)
```r
UpperVal <- 3.339+calc
LowerVal <- 3.339-calc
```

### ANNOTATION: Calculates probability OUTSIDE the interval (Area > Upper + Area < Lower)
```r
1-pnorm(UpperVal,mean=3.339, sd=0.573)+ pnorm(LowerVal,mean=3.339, sd=0.573)
```
