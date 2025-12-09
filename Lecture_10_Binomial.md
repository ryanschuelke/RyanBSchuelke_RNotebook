### Lecture 10. Binomial distribution in R

###   Loads tidyverse package for data manipulation and visualization
```r
library(tidyverse)
```

###   Sets default theme for all plots to black-and-white with 15pt font
```r
theme_set(theme_bw(base_size=15))
```

### R has random number generation functions. 

###   Opens help documentation for sample() function
```r
?sample
```

###   Creates a vector with two possible outcomes for coin toss
```r
coinToss<-c("heads","tails")
```

###   Randomly samples 10 coin tosses with replacement
###   size=10 draws 10 samples; replace=TRUE allows repeated outcomes; prob=c(0.5,0.5) gives equal probability
```r
sample(coinToss,size=10,replace=TRUE,prob=rep(0.5,2))
```

###   Randomly shuffles numbers 1-10 without replacement (each number appears once)
###   replace=FALSE means no repeats - useful for randomizing order
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

###   dbinom() calculates EXACT probability P(X = x) for binomial distribution
###   x=15 successes, size=20 trials, prob=0.75 success probability per trial
```r
dbinom(x=15,size=20,prob=0.75)
```

### Probability of at least 15 survivors

###   Sums probabilities for outcomes 15, 16, 17, 18, 19, 20
###   This calculates P(X >= 15)
```r
sum(dbinom(15:20,20,0.75))
```

###   Same calculation using pbinom()
###   pbinom(14, 20, 0.75) gives cumulative probability P(X <= 14)
###   1 - P(X <= 14) gives P(X >= 15)
```r
1-pbinom(14,20,0.75)
```

### Randomly generate data 
### Number of survivors in 1000 experiments of 20 individuals

###   rbinom() simulates random binomial experiments
###   n=1000 simulations, size=20 trials per simulation, prob=0.75
```r
outcomes<-rbinom(n=1000,size=20,prob=0.75)
```

###   Plots histogram of simulated outcomes
```r
ggplot(tibble(outcomes),aes(x=outcomes))+geom_histogram(binwidth=1,color="black")
```

### Sampling distribution of a proportion
### Example, survivorship = 0.72, n=25
### We will look at the entire distribution of outcomes

###   Loads gridExtra package for arranging multiple plots
```r
library(gridExtra)
```

###   Creates dataframe of ALL possible outcomes (0 to 25 survivors)
```r
df1<-data.frame(Survivors=0:25,Probability=dbinom(0:25,25,0.72)) %>%
  #   Adds column for estimated proportion (P-hat = Survivors / n)
  mutate(P.hat=round(Survivors/25,2) )
```

###   Plot 1: Distribution of NUMBER of survivors
```r
g1<-ggplot(df1,aes(x=Survivors,y=Probability))+
  geom_col(fill="darkblue")+
  xlab("Survivors")+
  ggtitle("Expected distribution of number of survivors (n=25)")
```

###   Plot 2: SAMPLING DISTRIBUTION of the proportion estimate
###   Same shape, but x-axis is now proportion (0-1) instead of count (0-25)
```r
g2<-ggplot(df1,aes(x=P.hat,y=Probability))+
  geom_col(fill="darkblue")+
  xlab("Estimated P = x/n")+
  ggtitle("Sampling disribution of P(survive) for n=25")
```

###   Arranges both plots together for comparison
```r
grid.arrange(g1,g2)
```

###   Same analysis but with larger sample size (n=100)
```r
df2<-data.frame(Survivors=0:100,Probability=dbinom(0:100,100,0.72)) %>%
  mutate(P.hat=round(Survivors/100,2) )
```

###   Plot 3: Distribution of survivors for n=100
```r
g3<-ggplot(df2,aes(x=Survivors,y=Probability))+
  geom_col(fill="darkblue")+
  xlab("Survivors")+
  ggtitle("Expected distribution of number of survivors (n=100)")
```

###   Plot
