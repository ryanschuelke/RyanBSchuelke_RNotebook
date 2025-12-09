###   Loads tidyverse package for data manipulation
```r
library(tidyverse)
```

### SIGN test

###   Reads 'DepressionScores.csv' into dataframe 'cbt'
```r
cbt <- read.csv("DepressionScores.csv")
```

###   Displays the dataframe
```r
cbt
```

### Calculate difference score

###   Creates new column 'Difference' by subtracting 'After' score from 'Before' score
```r
cbt$Difference=cbt$Before-cbt$After
```

###   Displays dataframe with the new difference column
```r
cbt
```

### How many <0?

###   Counts how many differences are negative (TRUE) vs positive (FALSE)
###   In Sign Test, this is the test statistic (number of "successes")
```r
table(cbt$Difference<0)
```

###   Checks if any differences are exactly 0 (ties)
```r
cbt$Difference==0
```

### Filter 0s

###   Removes rows where Difference is 0
###   The Sign Test requires dropping ties (observations with no change)
```r
cbt <- cbt %>% filter(Difference != 0)
```

###   Displays the filtered dataframe
```r
cbt
```

###   Checks the new sample size (n) after removing ties
```r
length(cbt$Difference)
```

### Binom test

###   Performs Exact Binomial Test
###   x=3 (number of "successes"), n=8 (total trials), p=0.5 (null hypothesis)
```r
binom.test(3,8)
```

### WILCOXON sign rank test

###   Opens help documentation for Wilcoxon tests
```r
?wilcox.test
```

###   Reads Sagebrush Crickets data from URL
```r
cricket <- read.csv(url("[https://whitlockschluter3e.zoology.ubc.ca/Data/chapter13/chap13e5SagebrushCrickets.csv](https://whitlockschluter3e.zoology.ubc.ca/Data/chapter13/chap13e5SagebrushCrickets.csv)"))
```

###   Opens data viewer
```r
view(cricket)
```

###   Performs Wilcoxon Rank Sum Test (Mann-Whitney U test)
###   Tests if 'timeToMating' differs between 'feedingStatus' groups
```r
wilcox.test(timeToMating~feedingStatus,data=cricket)
```

### Permutations test

###   Loads 'coin' package (Conditional Inference) for permutation tests
```r
library(coin)
```

###   Opens help for oneway_test
```r
?oneway_test
```

### Don't forget to specify factor

###   Performs permutation test for two independent samples
###   'feedingStatus' must be explicitly converted to a factor()
```r
oneway_test(timeToMating~factor(feedingStatus), data=cricket)
```

### Can specify # permutations

###   Performs permutation test using Monte Carlo approximation
###   nresample=100000 runs 100,000 random permutations to estimate P-value
```r
oneway_test(timeToMating~factor(feedingStatus),data=cricket,
            distribution=approximate(nresample=100000))
```
