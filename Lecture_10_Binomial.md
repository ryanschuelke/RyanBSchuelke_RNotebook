### Lecture 10. Binomial distribution in R

### ANNOTATION: Loads tidyverse package for data manipulation and visualization
```r
library(tidyverse)
```

### ANNOTATION: Sets default theme for all plots to black-and-white with 15pt font
```r
theme_set(theme_bw(base_size=15))
```

### R has random number generation functions. 

### ANNOTATION: Opens help documentation for sample() function
```r
?sample
```

### ANNOTATION: Creates a vector with two possible outcomes for coin toss
```r
coinToss<-c("heads","tails")
```

### ANNOTATION: Randomly samples 10 coin tosses with replacement
### ANNOTATION: size=10 draws 10 samples; replace=TRUE allows repeated outcomes; prob=c(0.5,0.5) gives equal probability
```r
sample(coinToss,size=10,replace=TRUE,prob=rep(0.5,2))
```

### ANNOTATION: Randomly shuffles numbers 1-10 without replacement (each number appears once)
### ANNOTATION: replace=FALSE means no repeats - useful for randomizing order
```r
sample(1:10,replace=FALSE)
```

### The binomial functions calculate the probabilities, etc

### dbinom is the binomial probability 
### pbinom is cumulative probability
### qbinom is quantiles
### rbinom is a random number generator

### Examples
### Probability of x=15 survivors out of n=20, with p=0.75

### ANNOTATION: dbinom() calculates EXACT probability P(X = x) for binomial distribution
### ANNOTATION: x=15 successes, size=20 trials, prob=0.75 success probability per trial
```r
dbinom(x=15,size=20,prob=0.75)
```

### Probability of at least 15 survivors

### ANNOTATION: Sums probabilities for outcomes 15, 16, 17, 18, 19, 20
### ANNOTATION: This calculates P(X >= 15)
```r
sum(dbinom(15:20,20,0.75))
```

### ANNOTATION: Same calculation using pbinom()
### ANNOTATION: pbinom(14, 20, 0.75) gives cumulative probability P(X <= 14)
### ANNOTATION: 1 - P(X <= 14) gives P(X >= 15)
```r
1-pbinom(14,20,0.75)
```

### Randomly generate data 
### Number of survivors in 1000 experiments of 20 individuals

### ANNOTATION: rbinom() simulates random binomial experiments
### ANNOTATION: n=1000 simulations, size=20 trials per simulation, prob=0.75
```r
outcomes<-rbinom(n=1000,size=20,prob=0.75)
```

### ANNOTATION: Plots histogram of simulated outcomes
```r
ggplot(tibble(outcomes),aes(x=outcomes))+geom_histogram(binwidth=1,color="black")
```

### Sampling distribution of a proportion
### Example, survivorship = 0.72, n=25
### We will look at the entire distribution of outcomes

### ANNOTATION: Loads gridExtra package for arranging multiple plots
```r
library(gridExtra)
```

### ANNOTATION: Creates dataframe of ALL possible outcomes (0 to 25 survivors)
```r
df1<-data.frame(Survivors=0:25,Probability=dbinom(0:25,25,0.72)) %>%
  # ANNOTATION: Adds column for estimated proportion (P-hat = Survivors / n)
  mutate(P.hat=round(Survivors/25,2) )
```

### ANNOTATION: Plot 1: Distribution of NUMBER of survivors
```r
g1<-ggplot(df1,aes(x=Survivors,y=Probability))+
  geom_col(fill="darkblue")+
  xlab("Survivors")+
  ggtitle("Expected distribution of number of survivors (n=25)")
```

### ANNOTATION: Plot 2: SAMPLING DISTRIBUTION of the proportion estimate
### ANNOTATION: Same shape, but x-axis is now proportion (0-1) instead of count (0-25)
```r
g2<-ggplot(df1,aes(x=P.hat,y=Probability))+
  geom_col(fill="darkblue")+
  xlab("Estimated P = x/n")+
  ggtitle("Sampling disribution of P(survive) for n=25")
```

### ANNOTATION: Arranges both plots together for comparison
```r
grid.arrange(g1,g2)
```

### ANNOTATION: Same analysis but with larger sample size (n=100)
```r
df2<-data.frame(Survivors=0:100,Probability=dbinom(0:100,100,0.72)) %>%
  mutate(P.hat=round(Survivors/100,2) )
```

### ANNOTATION: Plot 3: Distribution of survivors for n=100
```r
g3<-ggplot(df2,aes(x=Survivors,y=Probability))+
  geom_col(fill="darkblue")+
  xlab("Survivors")+
  ggtitle("Expected distribution of number of survivors (n=100)")
```

### ANNOTATION: Plot
