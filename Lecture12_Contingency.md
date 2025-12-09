### Lecture 12. Contingency analysis

###   Loads tidyverse for data manipulation and visualization
```r
library(tidyverse)
```

###   Loads epitools package, which provides tools for epidemiology and contingency tables (e.g., odds ratios, risk ratios)
```r
library(epitools)
```

### Birds and worms example

###   Reads CSV data from a URL into a tibble
###   Data is in "long" format (one row per bird)
```r
birdsLong<-read_csv(url("[https://whitlockschluter3e.zoology.ubc.ca/Data/chapter09/chap09e4WormGetsBird.csv](https://whitlockschluter3e.zoology.ubc.ca/Data/chapter09/chap09e4WormGetsBird.csv)"))
```

###   Shows the first 6 rows of the dataset
```r
head(birdsLong)
```

### The chi-squared contingency table test can take a contingency table as input

###   table() creates a contingency table (cross-tabulation) of all columns in birdsLong
###   This counts combinations of 'fate' and 'infection'
```r
birdTable<-table(birdsLong)
```

###   Displays the contingency table
```r
birdTable
```

###   Performs Chi-squared test of independence on the table
###   correct=FALSE turns off Yates' continuity correction
```r
bird.chi<-chisq.test(birdTable,correct=FALSE)
```

###   Displays the results of the Chi-squared test
```r
bird.chi
```

### Checking assumptions

###   Extracts expected frequencies from the test object
###   Assumption check: All expected frequencies should be > 1, and no more than 20% should be < 5
```r
bird.chi$expected   # check that all expected frequencies are greater than 1
```

###   Extracts Pearson residuals: (Observed - Expected) / sqrt(Expected)
```r
bird.chi$residuals  # Residuals are (observed-expected)/sqrt(expected)
```

###   Squares the residuals - each cell's contribution to the Chi-squared statistic
```r
bird.chi$residuals^2
```

###   Sum of squared residuals equals the Chi-squared statistic
```r
sum(bird.chi$residuals^2)
```

### chisq.test also works with unagreggated data, but must be entered as separate columns.

###   Alternative syntax: enter the two raw columns directly into chisq.test()
```r
chisq.test(birdsLong$fate,birdsLong$infection) 
```

### or

###   Alternative syntax using with() to avoid typing 'birdsLong$' repeatedly
```r
with(birdsLong,chisq.test(fate,infection) )
```

### sharks

###   Reads 'bruv.csv' file
```r
bruv<-read.csv("bruv.csv")
```

###   Shows first 6 rows
```r
head(bruv)
```

###   Performs Chi-squared test on Sharks vs Zone columns
###   correct=FALSE (no correction)
```r
shark.chi<-chisq.test(bruv$Sharks,bruv$Zone,correct=FALSE)
```

### with Yates correction

###   Performs Chi-squared test with Yates' continuity correction (correct=TRUE)
###   This is the default in R for 2x2 tables; makes p-value slightly larger (more conservative)
```r
shark.chi2<-chisq.test(bruv$Zone,bruv$Sharks,correct=TRUE)
```

### Fisher.test

###   Opens help documentation for fisher.test()
```r
?fisher.test
```

###   Performs Fisher's Exact Test on raw columns
###   Recommended for small sample sizes where Chi-square assumptions fail
```r
shark.fisher<-fisher.test(bruv$Sharks,bruv$Zone)
```

###   Displays Fisher test results
```r
shark.fisher
```

### or wide format

###   Creates contingency table first
```r
sharkTable<-table(bruv$Zone,bruv$Sharks)
```

###   Runs Fisher test on the table object
```r
shark.fisher<-fisher.test(sharkTable)
```

### To use functions in epitools, must organize the data with treatments
### in rows, and response in columns, with the reference level in the 
### first row, and the outcome being risked in the last column. 

###   Creates table again to check structure
###   Rows=Zone, Columns=Sharks
```r
sharkTable<-table(bruv$Zone,bruv$Sharks)
```

###   Displays table
```r
sharkTable
```

###   Calculates Risk Ratio (Relative Risk) using epitools
###   Compares risk of outcome between groups
```r
riskratio(sharkTable)
```

### Odds ratio

###   Calculates Odds Ratio using epitools
###   method="wald" uses the normal approximation for confidence intervals
```r
oddsratio(sharkTable,method="wald")
```

### Regular normal method is "wald" for both RR and OR

### Below are calculations "by hand" for RR and OR

### Relative risk calculations

###   Calculates probability of sharks in Unfished zone (10 sharks / 30 drops)
```r
prob.shark.unfished<-10/30
```

###   Calculates probability of sharks in Fished zone (3 sharks / 30 drops)
```r
prob.shark.fished<-3/30
```

###   Calculates Relative Risk (Risk Ratio)
###   Risk in Fished / Risk in Unfished
```r
RR<-prob.shark.fished/prob.shark.unfished
```

### If you put larger "risk" on top, the number is > 1

###   Alternative RR calculation: Risk in Unfished / Risk in Fished
```r
RR2<-prob.shark.unfished/prob.shark.fished
```

### Odds ratio calculations

###   Calculates Odds of sharks in Unfished zone
###   Odds = Probability / (1 - Probability) OR Successes / Failures (10/20)
```r
odds.shark.unfished<-10/20
```

###   Calculates Odds of sharks in Fished zone (3/27)
```r
odds.shark.fished<-3/27
```

###   Calculates Odds Ratio (OR)
###   Odds in Fished / Odds in Unfished
```r
OR<-odds.shark.fished/odds.shark.unfished
```

### Or

###   Alternative OR calculation: Odds in Unfished / Odds in Fished
```r
OR2<-odds.shark.unfished/odds.shark.fished
```
