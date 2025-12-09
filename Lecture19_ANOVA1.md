### Lecture 19. ANOVA

### ANNOTATION: Loads tidyverse package for data manipulation and visualization
```r
library(tidyverse)
```

### ANNOTATION: Reads 'KneesWhoSayNight.csv' from URL
### ANNOTATION: Data on circadian rhythm shifts (phase shift) in response to light on knees
```r
knee<-read.csv(url("[https://whitlockschluter3e.zoology.ubc.ca/Data/chapter15/chap15e1KneesWhoSayNight.csv](https://whitlockschluter3e.zoology.ubc.ca/Data/chapter15/chap15e1KneesWhoSayNight.csv)"))
```

### ANNOTATION: Opens data viewer
```r
view(knee)
```

### Tell r treatment = factor

### ANNOTATION: Explicitly converts 'treatment' column to a factor
### ANNOTATION: This ensures R treats it as categorical for ANOVA
```r
knee$treatment<-factor(knee$treatment)
```

### Specify order= control, knee, eyes

### ANNOTATION: Reorders factor levels to Control -> Knee -> Eyes
### ANNOTATION: unique(knee$treatment) keeps the order they appear in the file (Control is usually first)
```r
knee$treatment<-factor(knee$treatment,levels=unique(knee$treatment))
```

### ANOVA functions 

### ANNOTATION: Opens help for lm() (linear model) and aov() (analysis of variance)
```r
?lm
?aov
```

### ANNOTATION: Fits a linear model: shift predicted by treatment
### ANNOTATION: This creates the ANOVA model object
```r
kneelm<-lm(shift~treatment,data=knee)
```

### ANNOTATION: Displays basic model coefficients
```r
kneelm
```

### Summary 

### ANNOTATION: Displays detailed model summary (coefficients, R-squared, F-statistic)
```r
summary(kneelm) 
```

### Coefficients & means

### ANNOTATION: Calculates mean 'shift' for each treatment group using tidyverse
```r
kneeSum<-knee %>% group_by(treatment) %>%
  summarise(mean=mean(shift))
```

### ANNOTATION: Displays the group means
```r
kneeSum
```

### Check

### ANNOTATION: Checks the difference between means (e.g., to verify coefficients)
```r
-1.55 - -0.309
```

### ANOVA table

### ANNOTATION: Displays the standard ANOVA table (Df, Sum Sq, Mean Sq, F value, Pr(>F))
```r
anova(kneelm)
```

### Adding row for totals

### ANNOTATION: Extracts ANOVA table to an object
```r
anovaTable<-anova(kneelm)
```

### ANNOTATION: Manually adds a "Total" row to the bottom of the table
### ANNOTATION: Sums the degrees of freedom and Sum of Squares columns
```r
anovaTable<-rbind(anovaTable,c(sum(anovaTable$Df),
                               sum(anovaTable$`Sum Sq`),
                               NA,NA,NA))
```

### ANNOTATION: Renames the 3rd row to "Total"
```r
rownames(anovaTable)[3]<-"Total"
```

### ANNOTATION: Displays the custom ANOVA table with totals
```r
anovaTable
```

### Assumptions
### Normally distributed residuals

### ANNOTATION: Loads 'ggfortify' package for diagnostic plots
```r
library(ggfortify)
```

### ANNOTATION: Creates diagnostic plots for the linear model (Residuals vs Fitted, Q-Q plot, etc.)
### ANNOTATION: Checks assumptions of normality and homoscedasticity
```r
autoplot(kneelm)
```

### Test equality of variances

### ANNOTATION: Opens help for Bartlett's test
```r
?bartlett.test
```

### ANNOTATION: Performs Bartlett's test for homogeneity of variances
### ANNOTATION: H0: Variances are equal across groups
```r
bartlett.test(shift~treatment,data=knee)
```

### Post-hoc = Tukey test

### ANNOTATION: Opens help for TukeyHSD (Honestly Significant Difference)
```r
?TukeyHSD
```

### Details = runs on aov - won't work on lm

### ANNOTATION: Performs Tukey's Post-hoc test
### ANNOTATION: Note: TukeyHSD() requires an 'aov' object, so we wrap aov(kneelm)
### ANNOTATION: This tests all pairwise comparisons between groups
```r
kneeTukey<-TukeyHSD(aov(kneelm))
```

### ANNOTATION: Displays Tukey test results (diff, lower, upper, p adj)
```r
kneeTukey
```

### ANNOTATION: Plots the Tukey intervals (if interval crosses 0, difference is not significant)
```r
plot(kneeTukey)
```
