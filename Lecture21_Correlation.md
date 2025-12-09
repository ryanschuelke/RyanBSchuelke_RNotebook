### Lecture 21. Correlation

### ANNOTATION: Loads tidyverse for data manipulation
```r
library(tidyverse)
```

### ANNOTATION: Reads 'FlippingBird.csv' file (assumes file is in working directory)
### ANNOTATION: Note: File name suggests bird behavior data (perhaps flipping/visiting)
```r
birds <- read.csv("FlippingBird.csv")
```

### ANNOTATION: Opens data viewer to inspect the dataframe
```r
view(birds)
```

### Shorten variable names

### ANNOTATION: Renames 'nVisitsNestling' column to 'Visits' for easier typing
```r
birds<-birds %>% rename(Visits=nVisitsNestling)
```

### ANNOTATION: Renames 'futureBehavior' column to 'Behaviour'
```r
birds<-birds %>% rename(Behaviour=futureBehavior)
```

### ANNOTATION: Views dataframe with new column names
```r
view(birds)
```

### Covariance

### ANNOTATION: Calculates the covariance matrix for all numeric columns in 'birds'
### ANNOTATION: Covariance measures how two variables vary together (positive = move together, negative = opposite)
```r
cov(birds)
```

### ANNOTATION: Calculates covariance specifically between 'Visits' and 'Behaviour' columns
```r
cov(birds$Visits, birds$Behaviour)
```

### Correlation

### ANNOTATION: Calculates the correlation matrix (Pearson's r) for all numeric columns
### ANNOTATION: Correlation is standardized covariance (range -1 to +1)
```r
cor(birds)
```

### ANNOTATION: Calculates Pearson correlation between 'Visits' and 'Behaviour'
```r
cor(birds$Visits, birds$Behaviour)
```

### CI & hyp test

### ANNOTATION: Opens help documentation for cor.test()
```r
?cor.test
```

### ANNOTATION: Performs Pearson's product-moment correlation test
### ANNOTATION: Tests H0: true correlation is equal to 0
### ANNOTATION: Returns t-statistic, df, p-value, and 95% confidence interval for r
```r
cor.test(birds$Visits,birds$Behaviour)
```

### Spearman

### ANNOTATION: Performs Spearman's rank correlation test (method="spearman")
### ANNOTATION: Non-parametric alternative (uses ranks instead of raw values)
### ANNOTATION: Use this if data is non-normal or relationship is monotonic but not linear
```r
cor.test(birds$Visits,birds$Behaviour, method = "spearman")
```
