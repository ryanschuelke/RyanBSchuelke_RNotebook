### Lecture 15. Two-sample t-test

###   Loads tidyverse for data manipulation and visualization
```r
library(tidyverse)
```

###   Reads 'HornedLizards.csv' file
###   Note: This assumes the file is in your working directory
```r
lizard <- read.csv("HornedLizards.csv")
```

###   Alternative: Reads the same data directly from a URL
```r
#OR
lizard<-read.csv(url("[https://whitlockschluter3e.zoology.ubc.ca/Data/chapter12/chap12e3HornedLizards.csv](https://whitlockschluter3e.zoology.ubc.ca/Data/chapter12/chap12e3HornedLizards.csv)"))
```

###   Opens data viewer
```r
view(lizard)
```

###   Shows summary statistics for the dataset
```r
summary(lizard)
```

###   Shortens variable name 'squamosalHornLength' to 'Length' for easier typing
```r
lizard<-lizard %>% rename(Length=squamosalHornLength) 
```

###   Opens viewer again to check rename
```r
view(lizard)
```

###   Removes rows with NA (missing values) in the Length column using filter()
###   !is.na(Length) keeps rows where Length is NOT NA
```r
lizard <- filter(.data=lizard,!is.na(Length))
```

###   Checks summary again to verify NAs are gone
```r
summary(lizard)
```

###   Equivalent tidyverse pipe doing rename AND filter in one step
```r
lizard<-lizard %>% rename(Length=squamosalHornLength) %>%
  filter(!is.na(Length))
```

### Plots from slide

###   Creates histograms of Length, faceted by Survival status
###   scales="free" allows y-axes to vary independently between panels
```r
ggplot(lizard,aes(x=Length))+
  geom_histogram(fill="darkred",color="black")+
  facet_wrap(Survival~., ncol=1,scales="free")
```

### Test Equal Variances = F test - will come back to

###   Performs F-test to check if variances of Length are equal between Survival groups
###   This checks the assumption for the standard two-sample t-test
```r
var.test(Length~Survival,data = lizard)
```

### t test using ~

###   Performs Two-Sample t-test assuming equal variances (Student's t-test)
###   Formula syntax: numeric_variable ~ grouping_variable
```r
t.test(Length~Survival,data = lizard,var.equal=TRUE)
```

###   Same test using $ notation instead of data= argument
```r
#same as:
t.test(lizard$Length~lizard$Survival, var.equal=TRUE)
```

### Plot means & SE (default = one SE)

###   Plots point ranges (Mean +/- SE) for each group
```r
ggplot(lizard, aes(x=Survival, y=Length))+
  stat_summary()
```

### Unequal variances

###   Performs Welch's Two-Sample t-test (var.equal=FALSE is default in R)
###   This does NOT assume equal variances
```r
t.test(Length~Survival,data = lizard)
```

### Trout Example (data also on BB)

###   Reads 'ChinookWithBrookTrout.csv' from URL
```r
trout<-read.csv(url("[https://whitlockschluter3e.zoology.ubc.ca/Data/chapter12/chap12e4ChinookWithBrookTrout.csv](https://whitlockschluter3e.zoology.ubc.ca/Data/chapter12/chap12e4ChinookWithBrookTrout.csv)"))
```

###   Views and summarizes trout data
```r
view(trout)
summary(trout)
```

### Renaming columns so they're easier to type

###   Renames 'troutTreatment' to 'Treat' and 'proportionSurvived' to 'Prop'
```r
trout <- trout %>% rename(Treat=troutTreatment) %>% 
  rename(Prop=proportionSurvived)
```

###   Views data
```r
view(trout)
```

### variance F test - would test this now

###   Tests for equal variances between Treatment groups
```r
var.test(Prop~Treat, data= trout)
```

### Welch's test (default in r)

###   Performs Welch's t-test (assumes unequal variances)
```r
t.test(Prop~Treat,data=trout)
```

### Summary from slide

###   Creates summary table with n, mean, and sd for each Treatment group
```r
troutSum<-trout %>% group_by(Treat) %>%
  summarize(n=n(),
            mean=mean(Prop),
            sd=sd(Prop))
```

###   Displays summary table
```r
troutSum
```

### Testing for Equal variances

###   Opens help for var.test
```r
?var.test
```

###   Runs F-test for equal variances again
```r
var.test(Prop~Treat, data= trout)
```

### Levene's test is better (more robust)

###   Loads 'car' package (Companion to Applied Regression)
```r
library(car)
```

###   Performs Levene's Test for homogeneity of variance
###   This is more robust to non-normality than the F-test
```r
leveneTest(Prop~Treat, data=trout)
```
