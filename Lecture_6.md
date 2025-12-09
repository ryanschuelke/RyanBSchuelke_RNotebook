###   Loads the tidyverse package - a collection of packages for data manipulation and visualization
###   Includes: dplyr (data manipulation), ggplot2 (graphics), tidyr (reshaping), readr (reading data), etc.
```r
library(tidyverse)
```

###   Loads ISwR package (Introductory Statistics with R) which contains example datasets
```r
library(ISwR)  #Library from the book Introductory Statistics with R (Dalgaard),
#to load in some data to play with
```

## Lecture 6.  Tidyverse

### Using tibbles rather than data frames
### https://jtr13.github.io/cc21fall1/tibble-vs.-dataframe.html

### read_csv reads data into a tibble

###   Opens help documentation for read_csv() - the tidyverse version of read.csv()
```r
?read_csv
```

### Read in a tibble

###   read_csv() reads CSV file into a tibble (enhanced dataframe from tidyverse)
###   Tibbles have nicer printing, preserve column names with spaces, and don't convert strings to factors
```r
ostrich<-read_csv("ostrich.csv")
```

###   Printing a tibble shows only first 10 rows plus column types - much cleaner than dataframe printing
```r
ostrich
```

### Instead of printing the whole dataset, it just prints the top,
### with information about data types.

### read_csv retains column name with spaces or special characters, use
### the backward single quote (under the tilde) to refer to the colum
### You must continue to use the backtick  signs in all contexts

###   When column names have spaces, wrap them in backticks ` ` (not regular quotes)
###   `body temp` and `brain temp` refer to columns with spaces in their names
```r
ggplot(ostrich,aes(x=`body temp`,y=`brain temp`))+
  geom_point()
```

### Can also make any dataframe a tibble with as_tibble
### Try the total lung capacity data from ISwR

###   head() shows first 6 rows of the tlc (total lung capacity) dataset from ISwR package
```r
head(tlc)
```

###   as_tibble() converts a regular dataframe to a tibble
```r
tlc2<-as_tibble(tlc)
```

###   Displays the tibble - shows column types and cleaner formatting
```r
tlc2
```

### The tidyverse pipe %>%

###   The pipe %>% takes the output from the left side and passes it as the FIRST argument to the right side
###   Read as "take tlc, THEN apply summary()"
```r
tlc %>% summary()
```

### passed the data from tlc to the summary function. This is the same as

###   Traditional R syntax - function wraps around the data
```r
summary(tlc)
```

### similarly, we can pipe a dataframe or tibble to ggplot

###   Pipes data to ggplot - equivalent to ggplot(tlc, aes(...))
###   Useful for chaining data manipulation before plotting
```r
tlc %>% ggplot(aes(x=age,y=tlc))+geom_point()
```

### The advantage of the pipe is that it lets us build up sequential operations
### and manipulating data. E.g.

###   Chains multiple operations: take tlc, THEN filter to sex==1, THEN summarize
###   filter() keeps only rows where condition is TRUE (here, sex equals 1)
```r
tlc %>% filter(sex==1) %>%
  summary()
```

### same as

###   Same result using nested functions - harder to read with more operations
```r
summary(filter(tlc,sex==1))
```

### same as

###   Same result using base R bracket notation - tlc[rows, columns]
###   tlc$sex==1 creates a logical vector; keeping only TRUE rows
```r
summary(tlc[tlc$sex==1,])
```

### Some tidyverse data manipulations include:
### Filter  for subsetting rows
### Select  for subsetting columns
### Input can be either a dataframe or a tibble.

###   filter() subsets ROWS based on condition; select() subsets COLUMNS by name
###   This keeps only sex==1 rows, then keeps only the age, sex, and height columns
```r
tlc %>% filter(sex==1) %>%
  select(age,sex,height)
```

### mutate is for making new columns, that can be functions of other columns

###   mutate() creates new column 'tlc.height' = tlc divided by height
###   The new column is added to the existing dataframe
```r
tlc %>% mutate(tlc.height=tlc/height)
```

### Can make a new object with the outcome of a tidyverse pipe

###   Saves the result of the pipe to a new object 'tlc2'
###   Without assignment (<-), the result just prints but isn't saved
```r
tlc2<-tlc %>% mutate(tlc.height=tlc/height)
```

### Note that we made a new object called tlc2 in our environment

### Can do multiple operations and save as new object

###   Chains multiple operations: filter rows → create new column → select specific columns → save result
```r
tlc2<-tlc %>% 
  #   filter() keeps only rows where sex equals 1
  filter(sex==1) %>%
  #   mutate() creates new column tlc.height
  mutate(tlc.height=tlc/height) %>%
  #   select() keeps only age and tlc.height columns (drops all others)
  select(age,tlc.height)
```

###   Displays the resulting tibble
```r
tlc2
```

### Always add elements to pipes one at a time, to debug.

### group_by followed by summarize is a good way to summarize by levels of a
### categorical variable.
### can do mean, sd, quantiles, n for count, etc.

###   group_by() groups data by unique values of 'sex'; summarize() calculates statistics for each group
```r
tlcSummary<-tlc %>%
  #   group_by(sex) splits data into groups based on sex values
  group_by(sex) %>%
  #   summarize() collapses each group to one row; meanAge = mean of age for each group
  summarize(meanAge=mean(age))
```

###   Displays summary - one row per sex value with the mean age
```r
tlcSummary
```

### Can do multiple summaries at the same time.

###   Multiple summary statistics calculated at once for each group
```r
tlcSummary<-tlc %>%
  group_by(sex) %>%
  summarize(
    #   mean() calculates average age per group
    meanAge=mean(age),
    #   n() counts the number of observations in each group
    count=n(),
    #   sd() calculates standard deviation of age per group
    sdAge=sd(age))
```

###   Displays the summary table with all three statistics
```r
tlcSummary
```

## Converting between wide and long

###   Reads bruv.csv into a tibble
```r
bruv<-read_csv("bruv.csv")
```

###   Shows first 6 rows - this is "long format" with one observation per row, not aggregated
```r
head(bruv)  #Long format, not aggregated
```

### Aggregate into long format with counts

###   Groups by Location AND Sharks, then counts rows in each combination
###   n() returns the count of rows in each group
```r
bruvLong<-bruv %>% group_by(Location,Sharks) %>%
  summarize(Count=n())
```

###   Displays aggregated data - now shows counts instead of individual observations
```r
bruvLong
```

### Both long formats work in ggplot

###   geom_bar() counts rows automatically - use with non-aggregated data
```r
ggplot(bruv,aes(x=Location,fill=Sharks))+
  geom_bar()  #geom_bar to count 
```

### For aggregated, use geom_col

###   geom_col() uses pre-computed y values - use when counts are already calculated
###   Must specify y=Count since values are already aggregated
```r
ggplot(bruvLong,aes(x=Location,y=Count,fill=Sharks))+
  geom_col()  #geom_col if counts are already in a column 
```

### Wide format would look like this

###   select() keeps only Location and Sharks columns; table() creates a cross-tabulation
###   This shows wide format: rows=Location, columns=Sharks values, cells=counts
```r
bruv %>% select(Location,Sharks) %>%
  table()
```

### This wide format doesn't work for ggplot, but looks good as a table

### Two switch between long and wide use
### pivot_longer and pivot_wider

###   pivot_wider() converts from long to wide format
###   names_from=Sharks: creates new columns from unique Sharks values (Yes, No)
###   values_from=Count: fills new columns with Count values
```r
bruvWide<-pivot_wider(bruvLong,names_from=Sharks,values_from=Count)
```

###   Displays wide format - each Location is one row, with separate columns for Yes/No shark counts
```r
bruvWide
```

###   pivot_longer() converts from wide to long format
###   No:Yes specifies which columns to pivot (the No and Yes columns)
###   names_to="Sharks": the column names (No, Yes) become values in new "Sharks" column
###   values_to="Count": the cell values go into new "Count" column
```r
bruvLong2<-pivot_longer(bruvWide,No:Yes,names_to="Sharks",values_to="Count")
```

###   Displays long format - back to one row per Location-Sharks combination
```r
bruvLong2
```

### Note you need quotes on the column names in pivot_longer (because we are naming
### a new column) but on pivot_wider (because we are referring to an existing column)

### Another useful function, uncount to disaggregate

###   Shows the aggregated data (counts per group)
```r
bruvLong
```

###   uncount() expands aggregated data back to individual rows
###   Each row is duplicated 'Count' times - opposite of group_by + summarize(n())
```r
bruv2<-uncount(bruvLong,Count)
```

###   Shows first 6 rows of expanded data
```r
head(bruv2)
```

###   dim() shows dimensions - original bruv data
```r
dim(bruv)
```

###   dim() shows dimensions - should match original since we uncounted back to individual rows
```r
dim(bruv2)
```

### We are now back to the original data format (one row per sample unit)

### Pivoting the ostrich data

###   read.csv() (base R) reads data as regular dataframe (not tibble)
```r
ostrich<-read.csv("ostrich.csv")
```

###   Displays the dataframe
```r
ostrich
```

### Wide format is good for a scatterplot

###   Wide format works for scatterplots - each variable (body.temp, brain.temp) is its own column
```r
ggplot(ostrich,aes(x=body.temp,y=brain.temp))+geom_point()
```

### But if we want two boxplosts or violin plots we need long format

###   pivot_longer() converts wide to long format for side-by-side comparisons
###   body.temp:brain.temp selects those columns to pivot
###   names_to="Location": column names become values in new "Location" column
###   values_to="Temperature": the temperature values go into new "Temperature" column
```r
ostrichLong<-pivot_longer(ostrich,body.temp:brain.temp,
  names_to="Location",values_to = "Temperature")
```

###   Shows first 6 rows of long format - now one row per measurement, with Location indicating which temp
```r
head(ostrichLong)
```

###   Long format allows comparing distributions with boxplots - one box per Location (body vs brain)
```r
ggplot(ostrichLong,aes(x=Location,y=Temperature))+geom_boxplot(fill="grey")
```

### More tidyverse functions:
### arrange to sort by levels of a variable
### rename to change name of a column

###   arrange() sorts rows by the specified column (ascending by default)
###   Use arrange(desc(sex)) for descending order
```r
tlcSummary %>% arrange(sex)
```

###   rename() changes column name: new_name = old_name
###   Changes 'sex' to 'Sex' (capitalized)
```r
tlcSummary %>% rename(Sex=sex)
```

### Useful functions for making new columns:
### ifelse to mutate a variable based on a true/false question
### cut to break up a numerical value into bins
### trunc to truncate, etc.
### Can do multiple operations in one mutate, separated by commas

###   Multiple new columns created in one mutate() call, separated by commas
```r
tlc2<-tlc %>% mutate(
  #   Creates ratio of tlc to height
  tlc.height=tlc/height,
  #   ifelse(condition, value_if_true, value_if_false) - converts 1/2 to "F"/"M"
  Sex=ifelse(sex==1,"F","M"),
  #   cut() bins continuous height into categories; breaks=seq(135,190,10) creates bins: 135-145, 145-155, etc.
  heightClass=cut(height,breaks=seq(135,190,10)),
  #   ifelse() creates logical TRUE/FALSE column based on whether tlc > 6
  highTLC=ifelse(tlc>6,TRUE,FALSE),
  #   trunc() truncates to integer (removes decimal part, doesn't round)
  truncateTLC=trunc(tlc)) 
```

###   Displays the dataframe with all new columns added
```r
tlc2
```
