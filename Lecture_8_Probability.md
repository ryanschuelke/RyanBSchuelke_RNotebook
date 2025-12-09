### Lecture 8 Probability

###   Loads the tidyverse package for data manipulation and piping
```r
library(tidyverse)
```

### Create dataframe:

###   Creates a dataframe with 4 rows representing all combinations of Parasitized (yes/no) and Sex (M/F)
###   This models a probability problem about wasps parasitizing caterpillar eggs
```r
wasps<-data.frame(
  #   rep(c("yes","no"), each=2) repeats each value 2 times: "yes","yes","no","no"
  Parasitized=rep(c("yes","no"),each=2),
  #   Probability of being parasitized: P(parasitized)=0.2, P(not parasitized)=0.8
  Prob.parasitized=rep(c(0.2,0.8),each=2),
  #   rep(c("M","F"), 2) repeats the sequence twice: "M","F","M","F"
  Sex=rep(c("M","F"),2),
  #   Conditional probabilities P(Sex | Parasitized status)
  #   If parasitized: P(M)=0.9, P(F)=0.1 (wasps prefer to lay male eggs in parasitized hosts)
  #   If NOT parasitized: P(M)=0.05, P(F)=0.95 (unparasitized hosts mostly produce females)
  Prob.sex=c(0.9,0.1,0.05,0.95))
```

###   Creates new column 'Total.Prob' using the multiplication rule for joint probability
###   P(A and B) = P(A) × P(B|A) - joint probability of both events occurring
###   Total.Prob = P(Parasitized status) × P(Sex | Parasitized status)
```r
wasps$Total.Prob=wasps$Prob.parasitized*wasps$Prob.sex
```

###   Displays the complete probability table
```r
wasps
```

### Prob. male:

###   Calculates P(Male) using the Law of Total Probability
###   P(M) = P(M and parasitized) + P(M and not parasitized)
###   wasps$Sex=="M" creates logical vector to subset only male rows
###   sum() adds up the joint probabilities for all ways to get a male
```r
sum(wasps$Total.Prob[wasps$Sex=="M"])
```

### Or the tidyverse way:

###   Same calculation using tidyverse pipe syntax
###   filter(Sex=="M") keeps only male rows; summarise() calculates the sum
```r
wasps %>% filter(Sex== "M") %>% summarise (total=sum(Total.Prob))
```

### Prob that host was parasitized | male egg (Bayes rule)

###   Calculates P(Parasitized | Male) using Bayes' Theorem
###   Bayes' Rule: P(A|B) = P(A and B) / P(B)
###   Numerator: P(Parasitized AND Male) - the joint probability
###   wasps$Parasitized=="yes" & wasps$Sex=="M" selects the row where both conditions are true
```r
wasps$Total.Prob[wasps$Parasitized=="yes" & wasps$Sex=="M"]/
  #   Denominator: P(Male) - the total probability of male (calculated above)
  sum(wasps$Total.Prob[wasps$Sex=="M"])
```

### Wasp plots:

###   Creates a grouped bar chart showing CONDITIONAL probabilities P(Sex | Parasitized)
```r
ggplot(wasps,aes(x=Parasitized,y=Prob.sex,fill=Sex))+
  #   geom_col() makes bars; position_dodge() places bars side-by-side
  geom_col(position=position_dodge())+
  #   ylab() sets y-axis label
  ylab("P(outcome)")+
  #   ggtitle() adds title explaining what the plot shows
  ggtitle("Conditional probability of male | parasitised")
```

###   Creates a grouped bar chart showing JOINT probabilities P(Sex AND Parasitized)
```r
ggplot(wasps,aes(x=Parasitized,y=Total.Prob,fill=Sex))+
  geom_col(position=position_dodge())+
  ylab("P(outcome)")+
  #   \n creates a line break in the title
  #   This plot shows joint probabilities, which account for how common each parasitized category is
  ggtitle("Total probability, acounting for fraction in each parasitised \ncategory")
```
