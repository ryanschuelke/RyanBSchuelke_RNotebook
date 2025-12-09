### Lecture 8 Probability

### ANNOTATION: Loads the tidyverse package for data manipulation and piping
```r
library(tidyverse)
```

### Create dataframe:

### ANNOTATION: Creates a dataframe with 4 rows representing all combinations of Parasitized (yes/no) and Sex (M/F)
### ANNOTATION: This models a probability problem about wasps parasitizing caterpillar eggs
```r
wasps<-data.frame(
  # ANNOTATION: rep(c("yes","no"), each=2) repeats each value 2 times: "yes","yes","no","no"
  Parasitized=rep(c("yes","no"),each=2),
  # ANNOTATION: Probability of being parasitized: P(parasitized)=0.2, P(not parasitized)=0.8
  Prob.parasitized=rep(c(0.2,0.8),each=2),
  # ANNOTATION: rep(c("M","F"), 2) repeats the sequence twice: "M","F","M","F"
  Sex=rep(c("M","F"),2),
  # ANNOTATION: Conditional probabilities P(Sex | Parasitized status)
  # ANNOTATION: If parasitized: P(M)=0.9, P(F)=0.1 (wasps prefer to lay male eggs in parasitized hosts)
  # ANNOTATION: If NOT parasitized: P(M)=0.05, P(F)=0.95 (unparasitized hosts mostly produce females)
  Prob.sex=c(0.9,0.1,0.05,0.95))
```

### ANNOTATION: Creates new column 'Total.Prob' using the multiplication rule for joint probability
### ANNOTATION: P(A and B) = P(A) × P(B|A) - joint probability of both events occurring
### ANNOTATION: Total.Prob = P(Parasitized status) × P(Sex | Parasitized status)
```r
wasps$Total.Prob=wasps$Prob.parasitized*wasps$Prob.sex
```

### ANNOTATION: Displays the complete probability table
```r
wasps
```

### Prob. male:

### ANNOTATION: Calculates P(Male) using the Law of Total Probability
### ANNOTATION: P(M) = P(M and parasitized) + P(M and not parasitized)
### ANNOTATION: wasps$Sex=="M" creates logical vector to subset only male rows
### ANNOTATION: sum() adds up the joint probabilities for all ways to get a male
```r
sum(wasps$Total.Prob[wasps$Sex=="M"])
```

### Or the tidyverse way:

### ANNOTATION: Same calculation using tidyverse pipe syntax
### ANNOTATION: filter(Sex=="M") keeps only male rows; summarise() calculates the sum
```r
wasps %>% filter(Sex== "M") %>% summarise (total=sum(Total.Prob))
```

### Prob that host was parasitized | male egg (Bayes rule)

### ANNOTATION: Calculates P(Parasitized | Male) using Bayes' Theorem
### ANNOTATION: Bayes' Rule: P(A|B) = P(A and B) / P(B)
### ANNOTATION: Numerator: P(Parasitized AND Male) - the joint probability
### ANNOTATION: wasps$Parasitized=="yes" & wasps$Sex=="M" selects the row where both conditions are true
```r
wasps$Total.Prob[wasps$Parasitized=="yes" & wasps$Sex=="M"]/
  # ANNOTATION: Denominator: P(Male) - the total probability of male (calculated above)
  sum(wasps$Total.Prob[wasps$Sex=="M"])
```

### Wasp plots:

### ANNOTATION: Creates a grouped bar chart showing CONDITIONAL probabilities P(Sex | Parasitized)
```r
ggplot(wasps,aes(x=Parasitized,y=Prob.sex,fill=Sex))+
  # ANNOTATION: geom_col() makes bars; position_dodge() places bars side-by-side
  geom_col(position=position_dodge())+
  # ANNOTATION: ylab() sets y-axis label
  ylab("P(outcome)")+
  # ANNOTATION: ggtitle() adds title explaining what the plot shows
  ggtitle("Conditional probability of male | parasitised")
```

### ANNOTATION: Creates a grouped bar chart showing JOINT probabilities P(Sex AND Parasitized)
```r
ggplot(wasps,aes(x=Parasitized,y=Total.Prob,fill=Sex))+
  geom_col(position=position_dodge())+
  ylab("P(outcome)")+
  # ANNOTATION: \n creates a line break in the title
  # ANNOTATION: This plot shows joint probabilities, which account for how common each parasitized category is
  ggtitle("Total probability, acounting for fraction in each parasitised \ncategory")
```
