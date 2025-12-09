### Lecture 15. Two-sample t-test

### ANNOTATION: Loads tidyverse for data manipulation and visualization
```r
library(tidyverse)
```

### ANNOTATION: Reads 'HornedLizards.csv' file
### ANNOTATION: Note: This assumes the file is in your working directory
```r
lizard <- read.csv("HornedLizards.csv")
```

### ANNOTATION: Alternative: Reads the same data directly from a URL
```r
#OR
lizard<-read.csv(url("[https://whitlockschluter3e.zoology.ubc.ca/Data/chapter12/chap12e3HornedLizards.csv](https://whitlockschluter3e.zoology.ubc.ca/Data/chapter12/chap12e3HornedLizards.csv)"))
```

### ANNOTATION: Opens data viewer
```r
view(lizard)
```

### ANNOTATION: Shows summary statistics for the dataset
```r
summary(lizard)
```

### ANNOTATION: Shortens variable name 'squamosalHornLength' to 'Length' for easier typing
```r
lizard<-lizard %>% rename(Length=squamosalHornLength) 
```

### ANNOTATION: Opens viewer again to check rename
```r
view(lizard)
```

### ANNOTATION: Removes rows with NA (missing values) in the Length column using filter()
### ANNOTATION: !is.na(Length) keeps rows where Length is NOT NA
```r
lizard <- filter(.data=lizard,!is.na(Length))
```

### ANNOTATION: Checks summary again to verify NAs are gone
```r
summary(lizard)
```

### ANNOTATION: Equivalent tidyverse pipe doing rename AND filter in one step
```r
lizard<-lizard %>% rename(Length=squamosalHornLength) %>%
  filter(!is.na(Length))
```

### Plots from slide

### ANNOTATION: Creates histograms of Length, faceted by Survival status
### ANNOTATION: scales="free" allows y-axes to vary independently between panels
```r
ggplot(lizard,aes(x=Length))+
  geom_histogram(fill="darkred",color="black")+
  facet_wrap(Survival~., ncol=1,scales="free")
```

### Test Equal Variances = F test - will come back to

### ANNOTATION: Performs F-test to check if variances of Length are equal between Survival groups
### ANNOTATION: This checks the assumption for the standard two-sample t-test
```r
var.test(Length~Survival,data = lizard)
```

### t test using ~

### ANNOTATION: Performs Two-Sample t-test assuming equal variances (Student's t-test)
### ANNOTATION: Formula syntax: numeric_variable ~ grouping_variable
```r
t.test(Length~Survival,data = lizard,var.equal=TRUE)
```

### ANNOTATION: Same test using $ notation instead of data= argument
```r
#same as:
t.test(lizard$Length~lizard$Survival, var.equal=TRUE)
```

### Plot means & SE (default = one SE)

### ANNOTATION: Plots point ranges (Mean +/- SE) for each group
```r
ggplot(lizard, aes(x=Survival, y=Length))+
  stat_summary()
```

### Unequal variances

### ANNOTATION: Performs Welch's Two-Sample t-test (var.equal=FALSE is default in R)
### ANNOTATION: This does NOT assume equal variances
```r
t.test(Length~Survival,data = lizard)
```

### Trout Example (data also on BB)

### ANNOTATION: Reads 'ChinookWithBrookTrout.csv' from URL
```r
trout<-read.csv(url("[https://whitlockschluter3e.zoology.ubc.ca/Data/chapter12/chap12e4ChinookWithBrookTrout.csv](https://whitlockschluter3e.zoology.ubc.ca/Data/chapter12/chap12e4ChinookWithBrookTrout.csv)"))
```

### ANNOTATION: Views and summarizes trout data
```r
view(trout)
summary(trout)
```

### Renaming columns so they're easier to type

### ANNOTATION: Renames 'troutTreatment' to 'Treat' and 'proportionSurvived' to 'Prop'
```r
trout <- trout %>% rename(Treat=troutTreatment) %>% 
  rename(Prop=proportionSurvived)
```

### ANNOTATION: Views data
```r
view(trout)
```

### variance F test - would test this now

### ANNOTATION: Tests for equal variances between Treatment groups
```r
var.test(Prop~Treat, data= trout)
```

### Welch's test (default in r)

### ANNOTATION: Performs Welch's t-test (assumes unequal variances)
```r
t.test(Prop~Treat,data=trout)
```

### Summary from slide

### ANNOTATION: Creates summary table with n, mean, and sd for each Treatment group
```r
troutSum<-trout %>% group_by(Treat) %>%
  summarize(n=n(),
            mean=mean(Prop),
            sd=sd(Prop))
```

### ANNOTATION: Displays summary table
```r
troutSum
```

### Testing for Equal variances

### ANNOTATION: Opens help for var.test
```r
?var.test
```

### ANNOTATION: Runs F-test for equal variances again
```r
var.test(Prop~Treat, data= trout)
```

### Levene's test is better (more robust)

### ANNOTATION: Loads 'car' package (Companion to Applied Regression)
```r
library(car)
```

### ANNOTATION: Performs Levene's Test for homogeneity of variance
### ANNOTATION: This is more robust to non-normality than the F-test
```r
leveneTest(Prop~Treat, data=trout)
```
