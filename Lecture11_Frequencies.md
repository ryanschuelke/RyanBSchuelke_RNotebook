### Lecture 11. Frequencies

###   Loads tidyverse package for data manipulation and visualization
```r
library(tidyverse)
```

###   Loads gridExtra package for arranging multiple plots
```r
library(gridExtra)
```

###   Sets default theme for all plots to black-and-white with 15pt font
```r
theme_set(theme_bw(base_size=15))
```

### Multinomial

###   Opens help documentation for rmultinom() - random generation for multinomial distribution
```r
?rmultinom
```

### Chi squared

###   Opens help documentation for dchisq() - density function for Chi-squared distribution
```r
?dchisq
```

### P value

###   Calculates P-value for Chi-squared statistic of 15.05 with 6 degrees of freedom
###   1 - pchisq() calculates the area in the upper tail (probability of getting value > 15.05)
```r
1-pchisq(15.05,6)
```

### or

###   Equivalent calculation using lower.tail = FALSE
```r
pchisq(15.05,6,lower.tail = FALSE)
```

### Critical value

###   Calculates the critical Chi-squared value for alpha = 0.05 (95% confidence) with 6 df
###   Any Chi-squared statistic greater than 12.59 would be significant at p < 0.05
```r
qchisq(0.95,6)
```

### Using the chi-squared test.

###   Opens help documentation for chisq.test() function
```r
?chisq.test
```

###   Reads 'days.csv' file and calculates expected births
###   Fraction of year = Days in that week/365
###   Expected births = Fraction * Total Births (sum of Births column)
```r
days<-read_csv("days.csv") %>%
  mutate(fraction=Days/365,
         expected=fraction*sum(Births))
```

###   Displays the days dataframe with observed and expected counts
```r
days
```

### Days plot

###   Creates a grouped bar chart comparing Observed vs Expected births by Weekday
###   1. Converts Weekday to factor to preserve order
###   2. Renames 'Births' to 'observed'
###   3. Pivots longer to put observed/expected in one column for plotting
###   4. Plots bars side-by-side with custom colors
```r
days %>% mutate(Weekday=factor(Weekday,levels=days$Weekday)) %>%
  rename(observed=Births) %>%
  pivot_longer(c("observed","expected"), values_to="Births" , names_to="Type") %>%
  ggplot(aes(x=Weekday,y=Births,fill=Type))+geom_col(position=position_dodge())+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  scale_fill_manual(values=c("darkred","goldenrod"))
```

###   Manually calculates Chi-squared test statistic
###   Formula: sum of (Observed - Expected)^2 / Expected
```r
test.stat<-sum((days$Births-days$expected)^2/days$expected)
```

### With is an alternative to attach, or $. It says, look inside days for the variables

###   Calculates P-value using the manual test statistic and 6 degrees of freedom
```r
1-pchisq(test.stat,6)
```

### Or using the function

###   Performs Chi-squared Goodness of Fit test using built-in function
###   x = observed counts (Births), p = expected probabilities (fraction)
```r
chisq.test(x=days$Births,p=days$fraction)
```

### Contingency analysis for linkage in worm
### null hypothesis is 9:3:3:1 ratio

###   Creates vector of observed counts for worm phenotypes
```r
worm<-c(435,148,152,65)
```

###   Performs Chi-squared test against theoretical ratio 9:3:3:1
###   p=c(9,3,3,1)/16 normalizes the ratio into probabilities summing to 1
```r
chisq.test(worm,p=c(9,3,3,1)/16)
```

### Example, Hardy Weinberg
### Frequencies of MM, MN and NN genotypes in a sample

###   Creates vector of observed genotype counts
```r
genotype<-c(42,22,16)
```

### We need to calculate the allele frequencies to get the expected
### frequencies, so we lose 2 degrees of freedom (one for n, one for p)

###   Calculates total number of individuals (n)
```r
n<-sum(genotype)
```

###   Calculates frequency of M allele (p)
###   Each MM has 2 M alleles, each MN has 1 M allele; divide by 2n total alleles
```r
p<-(2*genotype[1]+genotype[2])/(2*n)
```

###   Calculates frequency of N allele (q = 1 - p)
```r
q<-1-p
```

###   Calculates expected probabilities under Hardy-Weinberg Equilibrium: p^2, 2pq, q^2
```r
expected.prob<-c(p^2, 2*p*q, q^2)
```

###   Performs Chi-squared test comparing observed counts to HWE probabilities
```r
chisq.test(genotype,p=expected.prob)
```

### Note the warning, it assumes df is n-1 = 2, but it should be n-1-1 = 1
### So the P value is wrong.

###   Manually recalculates correct P-value using 1 degree of freedom
###   chisq.test(...)$statistic extracts just the X-squared value from the result
```r
1-pchisq(chisq.test(genotype,p=expected.prob)$statistic,1)
```

### Binomial simulation of the probability of 0, 1, ... 18 right handed toads
### From Lecture 9

###   Simulates 100,000 binomial experiments (n=18, p=0.5) to generate null distribution
```r
right.handed<-rbinom(100000,18,0.5)
```

###   Creates frequency table of the simulation results
```r
frequencies<-table(right.handed)
```

###   Converts table to dataframe and renames columns
```r
df1<-as.data.frame(frequencies) %>% rename(Number=right.handed,Frequency=Freq)
```

###   Calculates expected probabilities for binomial distribution (0 to 18 successes)
```r
expected<-dbinom(0:18,18,0.5)
```

###   Performs Chi-squared test comparing simulated frequencies to theoretical probabilities
```r
chisq.test(df1$Frequency,p=expected)
```

### Warning because some expected values are small.
### We can fix this by doing a Monte Carlo simulation
### which simulates the null distribution of the X2 statistic

###   Performs Chi-squared test with Monte Carlo simulation for P-value (no small cell warning)
```r
chisq.test(df1$Frequency,p=expected,simulate.p.value = TRUE)
```

### Contingency table

###   Reads 'trematodes.csv' file
```r
trematodes<-read_csv("trematodes.csv")
```

###   Shows the raw data (one row per snail, indicating if eaten and if infected)
```r
trematodes
```

### To make the contingency table

###   Creates a contingency table (cross-tabulation) of Infection status vs Eaten status
```r
trematodes.table<-table(trematodes$InfectionStatus,trematodes$Eaten)
```

###   Displays the contingency table
```r
trematodes.table
```

### To do the mosaic plot

###   Plots a mosaic plot to visualize the contingency table
###   color=TRUE adds shading based on Pearson residuals (shows which cells deviate from expected)
```r
mosaicplot(trematodes.table,color=TRUE)
```

### Or with ggplot

###   Creates a 100% stacked bar chart (visual equivalent of mosaic plot proportions)
###   position="fill" stacks bars to 100% height to compare proportions
```r
ggplot(trematodes,aes(x=InfectionStatus,fill=Eaten))+geom_bar(position="fill")+
  ylab("Proportion")
```

### The analysis

###   Performs Chi-squared test of independence on the contingency table
###   correct=FALSE turns off continuity correction (standard for 2x2 tables in biology)
```r
chisq.test(trematodes.table,correct=FALSE)
```

### Fisher's exact test

###   Performs Fisher's Exact Test (better for small sample sizes) on the same table
```r
fisher.test(trematodes.table)
```

### Using Odds ratios to interpret the results

###   Calculates Odds Ratio (OR) manually
###   OR = (a/c) / (b/d) = (ad) / (bc)
###   Odds of being eaten if Infected / Odds of being eaten if Uninfected
```r
(trematodes.table[1,1]/trematodes.table[2,1])/(trematodes.table[1,2]/trematodes.table[2,2])
```

### Simulating a 2 x 2 table for power analysis
### Power of the trematode experiment to detect an effect of this magnitude

###   Extracts total sample size (sum of all cells in table)
```r
N<-sum(trematodes.table)
```

###   Extracts probability of being infected (marginal proportion)
```r
P_infected<-sum(trematodes.table[1,])/N
```

###   Extracts probability of being eaten (marginal proportion)
```r
P_eaten<-sum(trematodes.table[,1])/N
```

###   Extracts actual observed probabilities for each of the 4 cells
```r
Prob.cells<-trematodes.table/N
```

###   Converts the 2x2 probability table into a vector of 4 probabilities
```r
Prob.vector<-as.vector(Prob.cells)
```

###   Simulates ONE experiment of size N using the observed probabilities
###   rmultinom() generates counts for the 4 categories based on Prob.vector
```r
sim1<-rmultinom(1,N,Prob.vector)
```

###   Converts the simulated vector back into a 2x2 matrix
```r
matrix(sim1,nrow=2)
```

###   Performs Chi-squared test on the simulated matrix and extracts the P-value
```r
chisq.test(matrix(sim1,nrow=2),correct=FALSE)$p.value
```

### To do the power analysis, we need to repeat this many times

###   replicate() repeats the simulation and testing process 1000 times
###   Returns a vector of 1000 P-values
```r
P.values<-replicate(1000,
  chisq.test(matrix(rmultinom(1,N,Prob.vector),nrow=2),
             correct=FALSE)$p.value)
```

###   Calculates Power = proportion of simulations where P-value <= 0.05
###   mean(logical_vector) calculates the proportion of TRUEs
```r
mean(P.values<=0.05)
```

### Doing it with a loop (alternative to replicate)

###   Creates empty vector to store P-values
```r
P.values<-NA
```

###   For loop runs the simulation 1000 times
```r
for(i in 1:1000) {
  #   Simulates data
  sim1<-rmultinom(1,N,Prob.vector)
  #   Runs test and stores P-value in the i-th position of the vector
  P.values[i]<-chisq.test(matrix(sim1,nrow=2),correct=FALSE)$p.value
}
```

###   Calculates Power from the loop results
```r
mean(P.values<=0.05)
```

### What if the effect size was smaller?
### Say odds ratio of 5

###   Defines new theoretical probabilities for a smaller effect size (Odds Ratio ~ 5)
```r
Prob.small.effect<-c(0.35,0.05,0.1,0.5)
```

###   Runs power simulation with the small effect probabilities
```r
P.values<-replicate(1000,chisq.test(matrix(rmultinom(1,N,Prob.small.effect),nrow=2),correct=FALSE)$p.value)
```

###   Calculates Power for the smaller effect size
```r
mean(P.values<=0.05)
```

### Poisson distribution

###   Simulates 100 Poisson-distributed values with lambda (mean) = 1
```r
sim.poisson<-rpois(100,1)
```

###   Creates bar chart of the simulated Poisson data
```r
ggplot(tibble(sim.poisson),aes(x=sim.poisson))+geom_bar()
```

### Extinction example (Binomial)
### Note, this should be a poisson process, but for some reason 
### I analyzed it as a binomial process in the lecture 
### (number of AA extinctions out of 76)

###   Reads 'extinction.csv' file
```r
extinction<-read_csv("extinction.csv")
```

###   Shows first 6 rows of extinction data
```r
head(extinction)
```

###   Calculates mean number of extinctions
```r
mean.ext<-mean(extinction$N)
```

###   Calculates probability of extinction per time period (p = mean / n)
###   Assuming n=76 total possible extinctions
```r
p<-mean.ext/76
```

###   Creates dataframe of Observed frequencies
###   count() tabulates how many times each 'N' (number of extinctions) appears
```r
obs.freq<-extinction %>% count(N) 
```

###   Creates full sequence of possible extinctions (0 to 12) to ensure no gaps
```r
df1<-tibble(`Number AA`=0:12) %>%
  #   left_join() merges observed counts into the full sequence (fills missing with NA)
  left_join(obs.freq,by=c("Number AA"="N")) %>%
  #   Replaces NA values (counts of zero) with 0
  mutate(n=replace_na(n,0)) %>%
  #   Renames 'n' column to 'Number'
  rename(Number=n) %>%
  #   Calculates Expected probabilities using binomial distribution (size=76, p calculated above)
  mutate(Expected.p=dbinom(`Number AA`,76,p),
         #   Calculates Expected counts = Probability * Total number of time periods (76)
         Expected=Expected.p*76)
```

###   Plots Observed vs Expected counts side-by-side
###   pivot_longer puts Observed and Expected into one column ('Number') with label ('Frequency')
```r
df1 %>% pivot_longer(c("Number","Expected"),values_to="Number",names_to="Frequency") %>%
  ggplot(aes(x=`Number AA`,y=Number,fill=Frequency))+
  geom_col(position=position_dodge())+
  scale_fill_manual(values=c("goldenrod","darkred"))
```

### Extinction example Poisson

###   Opens help documentation for dpois() - Poisson density function
```r
?dpois
```

###   Reads Mass Extinctions data from URL
```r
extinction<-read.csv(url("[https://whitlockschluter3e.zoology.ubc.ca/Data/chapter08/chap08e4MassExtinctions.csv](https://whitlockschluter3e.zoology.ubc.ca/Data/chapter08/chap08e4MassExtinctions.csv)"))
```

###   Displays the dataframe
```r
extinction
```

###   Plots histogram of number of extinctions
```r
ggplot(extinction,aes(x=numberOfExtinctions))+
  geom_bar(fill="darkred")+
  xlab("Number of extinctions")+
  ylab("Frequency")
```

###   Calculates mean number of extinctions (lambda for Poisson)
```r
meanval<-with(extinction,mean(numberOfExtinctions))
```

###   Creates summary table with Observed and Expected counts (Poisson)
```r
extinctionSum<-extinction %>% 
  group_by(numberOfExtinctions) %>%
  summarize(Observed=n()) %>%
  #   Calculates expected probability using Poisson distribution with calculated mean
  mutate(Probability=dpois(numberOfExtinctions,meanval),
         #   Calculates expected counts
         Expected=Probability*sum(Observed))
```

###   Views the summary table
```r
view(extinctionSum)
```

###   Checks column sums (should match total sample size)
```r
colSums(extinctionSum)
```

### Need to combine some groups and add zero

###   Recalculates table grouping all values >= 8 into one category
###   This is often required for Chi-squared tests to avoid small expected counts
```r
extinctionSum<-extinction %>%
  #   if_else() caps number of extinctions at 8
  mutate(number=if_else(numberOfExtinctions>=8,8,numberOfExtinctions)) %>%
  group_by(number) %>%
  summarize(Observed=n()) %>%
  #   Calculates probabilities for the new groups
  #   ppois() calculates cumulative probability; 1-ppois(7) gives probability of >= 8
  mutate(Probability=case_when(number==1~ppois(1,meanval),
                               number==8~1-ppois(7,meanval),
                               TRUE~dpois(number,meanval)),
         Expected=Probability*sum(Observed))
```

###   Adds the missing '0' category manually since it wasn't in the original data
```r
extinctionSum<-rbind(c(0,0,dpois(0,meanval),dpois(0,meanval)*76),extinctionSum)
```

###   Displays final summary table
```r
extinctionSum
```

###   Performs Chi-squared test comparing Observed counts to Expected probabilities
```r
chisq.test(extinctionSum$Observed,p=extinctionSum$Probability)
```
