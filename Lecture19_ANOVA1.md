### Lecture 19. ANOVA

###   Loads tidyverse package for data manipulation and visualization
```r
library(tidyverse)
```

###   Reads 'KneesWhoSayNight.csv' from URL
###   Data on circadian rhythm shifts (phase shift) in response to light on knees
```r
knee<-read.csv(url("[https://whitlockschluter3e.zoology.ubc.ca/Data/chapter15/chap15e1KneesWhoSayNight.csv](https://whitlockschluter3e.zoology.ubc.ca/Data/chapter15/chap15e1KneesWhoSayNight.csv)"))
```

###   Opens data viewer
```r
view(knee)
```

### Tell r treatment = factor

###   Explicitly converts 'treatment' column to a factor
###   This ensures R treats it as categorical for ANOVA
```r
knee$treatment<-factor(knee$treatment)
```

### Specify order= control, knee, eyes

###   Reorders factor levels to Control -> Knee -> Eyes
###   unique(knee$treatment) keeps the order they appear in the file (Control is usually first)
```r
knee$treatment<-factor(knee$treatment,levels=unique(knee$treatment))
```

### ANOVA functions 

###   Opens help for lm() (linear model) and aov() (analysis of variance)
```r
?lm
?aov
```

###   Fits a linear model: shift predicted by treatment
###   This creates the ANOVA model object
```r
kneelm<-lm(shift~treatment,data=knee)
```

###   Displays basic model coefficients
```r
kneelm
```

### Summary 

###   Displays detailed model summary (coefficients, R-squared, F-statistic)
```r
summary(kneelm) 
```

### Coefficients & means

###   Calculates mean 'shift' for each treatment group using tidyverse
```r
kneeSum<-knee %>% group_by(treatment) %>%
  summarise(mean=mean(shift))
```

###   Displays the group means
```r
kneeSum
```

### Check

###   Checks the difference between means (e.g., to verify coefficients)
```r
-1.55 - -0.309
```

### ANOVA table

###   Displays the standard ANOVA table (Df, Sum Sq, Mean Sq, F value, Pr(>F))
```r
anova(kneelm)
```

### Adding row for totals

###   Extracts ANOVA table to an object
```r
anovaTable<-anova(kneelm)
```

###   Manually adds a "Total" row to the bottom of the table
###   Sums the degrees of freedom and Sum of Squares columns
```r
anovaTable<-rbind(anovaTable,c(sum(anovaTable$Df),
                               sum(anovaTable$`Sum Sq`),
                               NA,NA,NA))
```

###   Renames the 3rd row to "Total"
```r
rownames(anovaTable)[3]<-"Total"
```

###   Displays the custom ANOVA table with totals
```r
anovaTable
```

### Assumptions
### Normally distributed residuals

###   Loads 'ggfortify' package for diagnostic plots
```r
library(ggfortify)
```

###   Creates diagnostic plots for the linear model (Residuals vs Fitted, Q-Q plot, etc.)
###   Checks assumptions of normality and homoscedasticity
```r
autoplot(kneelm)
```

### Test equality of variances

###   Opens help for Bartlett's test
```r
?bartlett.test
```

###   Performs Bartlett's test for homogeneity of variances
###   H0: Variances are equal across groups
```r
bartlett.test(shift~treatment,data=knee)
```

### Post-hoc = Tukey test

###   Opens help for TukeyHSD (Honestly Significant Difference)
```r
?TukeyHSD
```

### Details = runs on aov - won't work on lm

###   Performs Tukey's Post-hoc test
###   Note: TukeyHSD() requires an 'aov' object, so we wrap aov(kneelm)
###   This tests all pairwise comparisons between groups
```r
kneeTukey<-TukeyHSD(aov(kneelm))
```

###   Displays Tukey test results (diff, lower, upper, p adj)
```r
kneeTukey
```

###   Plots the Tukey intervals (if interval crosses 0, difference is not significant)
```r
plot(kneeTukey)
```
