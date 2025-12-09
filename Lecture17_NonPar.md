### ANNOTATION: Loads tidyverse package for data manipulation
```r
library(tidyverse)
```

### SIGN test

### ANNOTATION: Reads 'DepressionScores.csv' into dataframe 'cbt'
```r
cbt <- read.csv("DepressionScores.csv")
```

### ANNOTATION: Displays the dataframe
```r
cbt
```

### Calculate difference score

### ANNOTATION: Creates new column 'Difference' by subtracting 'After' score from 'Before' score
```r
cbt$Difference=cbt$Before-cbt$After
```

### ANNOTATION: Displays dataframe with the new difference column
```r
cbt
```

### How many <0?

### ANNOTATION: Counts how many differences are negative (TRUE) vs positive (FALSE)
### ANNOTATION: In Sign Test, this is the test statistic (number of "successes")
```r
table(cbt$Difference<0)
```

### ANNOTATION: Checks if any differences are exactly 0 (ties)
```r
cbt$Difference==0
```

### Filter 0s

### ANNOTATION: Removes rows where Difference is 0
### ANNOTATION: The Sign Test requires dropping ties (observations with no change)
```r
cbt <- cbt %>% filter(Difference != 0)
```

### ANNOTATION: Displays the filtered dataframe
```r
cbt
```

### ANNOTATION: Checks the new sample size (n) after removing ties
```r
length(cbt$Difference)
```

### Binom test

### ANNOTATION: Performs Exact Binomial Test
### ANNOTATION: x=3 (number of "successes"), n=8 (total trials), p=0.5 (null hypothesis)
```r
binom.test(3,8)
```

### WILCOXON sign rank test

### ANNOTATION: Opens help documentation for Wilcoxon tests
```r
?wilcox.test
```

### ANNOTATION: Reads Sagebrush Crickets data from URL
```r
cricket <- read.csv(url("[https://whitlockschluter3e.zoology.ubc.ca/Data/chapter13/chap13e5SagebrushCrickets.csv](https://whitlockschluter3e.zoology.ubc.ca/Data/chapter13/chap13e5SagebrushCrickets.csv)"))
```

### ANNOTATION: Opens data viewer
```r
view(cricket)
```

### ANNOTATION: Performs Wilcoxon Rank Sum Test (Mann-Whitney U test)
### ANNOTATION: Tests if 'timeToMating' differs between 'feedingStatus' groups
```r
wilcox.test(timeToMating~feedingStatus,data=cricket)
```

### Permutations test

### ANNOTATION: Loads 'coin' package (Conditional Inference) for permutation tests
```r
library(coin)
```

### ANNOTATION: Opens help for oneway_test
```r
?oneway_test
```

### Don't forget to specify factor

### ANNOTATION: Performs permutation test for two independent samples
### ANNOTATION: 'feedingStatus' must be explicitly converted to a factor()
```r
oneway_test(timeToMating~factor(feedingStatus), data=cricket)
```

### Can specify # permutations

### ANNOTATION: Performs permutation test using Monte Carlo approximation
### ANNOTATION: nresample=100000 runs 100,000 random permutations to estimate P-value
```r
oneway_test(timeToMating~factor(feedingStatus),data=cricket,
            distribution=approximate(nresample=100000))
```
