### Lecture 9 hypothesis testing

###   Loads tidyverse package for data manipulation and visualization
```r
library(tidyverse)
```

###   Sets default theme for all plots to black-and-white with 15pt font
```r
theme_set(theme_bw(base_size=15))
```

### Empirical null distribution for toads

###   Opens help documentation for sample() function
```r
?sample
```

###   Simulates ONE experiment: randomly assigns 18 toads to "left" or "right"
###   size=18 is sample size; p=c(0.5,0.5) means equal probability for each
###   replace=TRUE allows same outcome to be drawn multiple times
```r
toads<-sample(c("left","right"), size=18,p=c(0.5,0.5),replace=TRUE)
```

###   table() counts how many toads chose each direction in this one simulation
```r
table(toads)
```

###   rbinom() simulates 100,000 experiments from a binomial distribution
###   Each experiment: count of "right-handed" toads out of 18, with p=0.5
###   This creates an empirical null distribution (what we'd expect by chance)
```r
right.handed<-rbinom(100000,18,0.5)
```

###   Plots the simulated null distribution as a bar chart
###   tibble() creates a one-column dataframe for ggplot
```r
ggplot(tibble(right.handed=right.handed),aes(x=right.handed))+geom_bar()
```

### Probabilities for binomial distribution

###   dbinom() calculates probability mass function (PMF) for binomial distribution
###   Calculates P(X = x) for x=0 through 18, given n=18 and p=0.5
```r
dbinom(0:18,18,0.5)
```

###   round(x, 2) rounds probabilities to 2 decimal places for easier reading
```r
round(dbinom(0:18,18,0.5),2)
```

###   Creates a tibble of theoretical probabilities for plotting
```r
toadNull<-tibble(
  #   Sequence of possible outcomes: 0 to 18 right-handed toads
  `Number right handed`=0:18,
  #   Probability of each outcome under H0 (p=0.5)
  Probability=dbinom(0:18,18,0.5))
```

###   Plots the theoretical null distribution (probability mass function)
###   fill="grey" makes bars grey; geom_col() plots pre-calculated probabilities
```r
ggplot(toadNull,aes(x=`Number right handed`,y=Probability))+
  geom_col(fill="grey")
```

### One sided P value for observing 14 right handed toads

###   Creates logical vector identifying outcomes >= 14 (one-sided test criteria)
```r
toadNull$`Number right handed`>=14
```

###   Subsets the probabilities for outcomes >= 14
```r
toadNull$Probability[toadNull$`Number right handed`>=14]
```

###   Sums these probabilities to get the one-sided P-value
###   P(X >= 14) given H0 is true
```r
sum(toadNull$Probability[toadNull$`Number right handed`>=14])
```

### Two sided P value

###   For symmetric distribution, two-sided P-value = 2 * one-sided P-value
###   Accounts for extreme outcomes in BOTH directions (>=14 OR <=4)
```r
2*sum(toadNull$Probability[toadNull$`Number right handed`>=14])
```

### Shade the one-sided P value region

###   mutate() adds a column indicating if outcome is >= 14 ("yes" or "no")
```r
toadNull <- toadNull %>% mutate(`As extreme as observed`=if_else(`Number right handed`>=14,"yes","no"))
```

###   Plots null distribution again, but colors bars red if they fall in the >=14 region
```r
ggplot(toadNull,aes(x=`Number right handed`,y=Probability,fill=`As extreme as observed`))+
  geom_col()+
  #   Manually sets colors: "grey" for 'no', "red" for 'yes'
  scale_fill_manual(values=c("grey","red"))
```

### Null distribution for Test statistic

###   Converts binomial counts (0-18) into proportions (0.0 to 1.0)
```r
toadNull <- toadNull %>% mutate(Proportion=`Number right handed`/18)
```

###   Plots distribution of PROPORTIONS instead of counts
```r
ggplot(toadNull,aes(x=Proportion,y=Probability))+
  geom_col()
```

### Power analysis (Power = 1 - Beta)

###   Loads gridExtra package to combine multiple plots
```r
library(gridExtra)
```

###   Sets parameters for power analysis
###   n=18 (sample size), p=0.7 (alternative hypothesis H1: true proportion is 0.7)
```r
n<-18
p<-0.7
```

###   Defines function to calculate two-sided P-value for binomial test
###   Note: This simplified function assumes p=0.5 for H0 and symmetric distribution
```r
P.value.func<-function(observed,n) {
  #   Calculates P(X >= observed)
  one.sided<-sum(dbinom(observed:n,n,0.5))
  #   Returns 2 * one-sided P-value
  2*one.sided
}
```

###   Calculates actual P-value for observed data (14 right-handed out of 18)
```r
P.value<-P.value.func(14,n)
```

###   Creates null distribution dataframe (H0: p=0.5)
```r
toadNull<-tibble(`Number right handed`=0:n,
                 #   Probabilities under null hypothesis
                 Probability=dbinom(0:n,n,0.5),
                 #   Calculates P-value for each possible outcome
                 `P value if drawn`= P.value.func(`Number right handed`,n=n)) %>%
  #   Marks which outcomes would be significant (P <= 0.05)
  mutate(`Significant if drawn`=if_else( `P value if drawn`<=0.05,"yes","no"))
```

###   Creates plot of null distribution with significant regions (rejection regions) highlighted red
```r
g1<-ggplot(toadNull,aes(x=`Number right handed`,y=Probability,fill=`Significant if drawn`))+
  geom_col()+
  scale_fill_manual(values=c("grey","red"))+
  ggtitle(paste("P value = ",format(P.value,digits=2)))
```

###   Displays the null distribution plot
```r
g1
```

###   Creates alternative distribution (H1: p=0.7) for power analysis
```r
toadAlt<-tibble(`Number right handed`=0:n,
                  #   Probabilities under alternative hypothesis
                  Probability=dbinom(0:n,n,0.7),
                  #   Calculates P-value for each possible outcome
                  `P value if drawn`= P.value.func(`Number right handed`,n=n)) %>%
  #   Marks which outcomes would be significant (P <= 0.05)
  mutate(`Significant if drawn`=if_else( `P value if drawn`<=0.05,"yes","no"))
```

###   Calculates POWER = sum of probabilities for significant outcomes under H1
```r
power<-sum(toadAlt$Probability[toadAlt$`Significant if drawn`=="yes"])
```

###   Creates plot of alternative distribution with power region highlighted
```r
g2<-ggplot(toadAlt,aes(x=`Number right handed`,y=Probability,fill=`Significant if drawn`))+
  geom_col()+
  xlab("Number right handed")+
  scale_fill_manual(values=c("grey","red"))+
  ggtitle(paste("Power = ",format(power,digits=2)))
```

###   Displays the alternative distribution plot
```r
g2
```

###   grid.arrange() from gridExtra package places both plots side-by-side
###   ncol=1 stacks them vertically; shows H0 (top) vs H1 (bottom) distributions
```r
grid.arrange(g1,g2,ncol=1)
```
