### Lecture 18. Power analysis

### ANNOTATION: Loads tidyverse package for data manipulation and visualization
```r
library(tidyverse)
```

### ANNOTATION: Opens help documentation for power.t.test() function
```r
?power.t.test
```

### Can be used for power or n calculations

### To calculate power

### ANNOTATION: Calculates Power for a one-sample t-test
### ANNOTATION: n=25 sample size, delta=-0.076 true difference from null, sd=0.678
### ANNOTATION: sig.level=0.05 (alpha), power=NULL (this is what we are solving for)
```r
power.t.test(n=25, delta=-0.076, sd=0.678, sig.level = 0.05, power = NULL, type = "one.sample")
```

### ANNOTATION: Shortened version (sig.level defaults to 0.05)
```r
power.t.test(n=25, delta=-0.076, sd=0.678, type = "one.sample")
```

### What n is needed for power = 0.8

### ANNOTATION: Calculates required Sample Size (n) to achieve 80% power (power=0.8)
### ANNOTATION: n=NULL (this is what we are solving for), other parameters stay the same
```r
power.t.test(n = NULL, delta = -0.076, sd = 0.678, power = 0.8, type = "one.sample")
```
