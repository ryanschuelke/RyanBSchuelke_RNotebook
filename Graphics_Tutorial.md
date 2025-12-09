### ANNOTATION: Title comment for this tutorial file
### Lecture 3-4. Graphics in ggplot

### ANNOTATION: Loads the ggplot2 package - the main graphics library for creating plots
```r
library(ggplot2)
```

### ANNOTATION: Loads the 'abd' package (Analysis of Biological Data) which contains example datasets
```r
library(abd)
```

### ggplot2 is the R library for high-quality graphics.
### See this tutorial for the basics
### http://r-statistics.co/ggplot2-Tutorial-With-R.html
### Google for examples of how to do specific kinds of graphs in ggplot.
### Also see cheat sheet in RStudio help

### ggplot uses grammar of graphics syntax. The idea is to put the data in a standard format, 
### so that graphics of all kinds can be done easily using a standard syntax.

### Basic plotting function is ggplot.

### ANNOTATION: Opens R's help documentation for the ggplot() function
```r
?ggplot
```

### Read in some data to plot

### ANNOTATION: Reads the CSV file "Ostrich.csv" and stores it as a dataframe named 'ostrich'
```r
ostrich<-read.csv("Ostrich.csv")
```

### ANNOTATION: Displays summary statistics (min, max, mean, median, quartiles) for all columns in ostrich
```r
summary(ostrich)
```

### Tell ggplot the dataframe to use, and the mapping to say which
### variables map to each aesthetic

### ANNOTATION: Creates empty plot canvas; data=ostrich specifies the dataset; aes() maps body.temp to x-axis and brain.temp to y-axis
### ANNOTATION: This creates the coordinate system but NO visible data points yet (just axes)
```r
ggplot(data=ostrich, mapping=aes(x=body.temp,y=brain.temp))
```

### Don't need the keywords, data and mapping 

### ANNOTATION: Same as above but using positional arguments instead of named arguments - shorter syntax
```r
ggplot(ostrich, aes(x=body.temp,y=brain.temp))
```

### Now add layers to the plot, using geometries. You can combine multiple layers
### This is a scatterplot of two numerical variables

### ANNOTATION: Creates scatterplot; geom_point() adds a layer of points to the plot - now we see data!
```r
ggplot(ostrich, aes(x=body.temp,y=brain.temp))+geom_point()
```

### ANNOTATION: Same scatterplot but color="red" makes points red, size=3 makes them larger (default is ~1.5)
```r
ggplot(ostrich, aes(x=body.temp,y=brain.temp))+geom_point(color="red",size=3)
```

### ANNOTATION: Combines two geometry layers: red points AND blue lines connecting them in order
```r
ggplot(ostrich, aes(x=body.temp,y=brain.temp))+
  geom_point(color="red",size=3)+
  geom_line(color="blue")
```

### You can change the theme, and add elements to personalize the plot
### It's useful to put each plot element on its own line, so it is organized

### ANNOTATION: ggplot() - sets up the data and axis mappings
```r
ggplot(ostrich, aes(x=body.temp,y=brain.temp))+
```

### ANNOTATION: geom_point() - adds red points of size 3
```r
  geom_point(color="red",size=3)+
```

### ANNOTATION: theme_light() - applies a light background theme; base_size=15 sets font size to 15pt
```r
  theme_light(base_size=15)+  
```

### ANNOTATION: xlab() - sets custom x-axis label text
```r
  xlab("Body temperature") + 
```

### ANNOTATION: ylab() - sets custom y-axis label text
```r
  ylab("Brain temperature") +
```

### ANNOTATION: geom_abline() - adds a diagonal reference line with slope=1 and intercept=0 (the y=x line)
```r
  geom_abline(slope=1,intercept=0)+
```

### ANNOTATION: xlim() and ylim() - set the range of x and y axes from 38 to 39.4
```r
  xlim(c(38,39.4)) +ylim(c(38,39.4))+
```

### ANNOTATION: ggtitle() - adds a title at the top of the plot
```r
  ggtitle("Ostrich temperature study")
```

### If you want the same theme for all your plots, you can just set it once at the beginning of the session.

### ANNOTATION: theme_set() - sets a default theme for ALL subsequent plots in this R session
### ANNOTATION: Now you don't need to add theme_light() to every plot - it's automatic
```r
theme_set(theme_light(base_size=10))
```

### Now all the plots will have the same theme.

### line graph based on Lynx from the abd library
### Number of lynx pelts traded per year 

### ANNOTATION: Displays summary statistics for the built-in Lynx dataset from abd package
```r
summary(Lynx)
```

### ANNOTATION: Creates a line graph with points; year on x-axis, pelts on y-axis
```r
ggplot(Lynx,aes(x=year,y=pelts)) +
```

### ANNOTATION: geom_line() - connects data points with lines (shows trend over time)
```r
  geom_line()+
```

### ANNOTATION: geom_point() - adds dots at each data point (shows actual observations)
```r
  geom_point()
```

### A frequency table from the abd library

### ANNOTATION: head() - shows first 6 rows of EndangeredSpecies dataset to preview its structure
```r
head(EndangeredSpecies)
```

### ANNOTATION: dim() - returns dimensions as (rows, columns) to see dataset size
```r
dim(EndangeredSpecies)
```

### ANNOTATION: Creates a bar chart; taxon (species type) on x-axis, num.species (count) on y-axis
```r
ggplot(EndangeredSpecies,aes(x=taxon,y=num.species)) + 
```

### ANNOTATION: geom_col() - creates bars where height = the y value (use when you already have counts)
```r
  geom_col() 
```

### Make it prettier by rotating the axis (google for instructions)

### ANNOTATION: Same bar chart with customizations
```r
ggplot(EndangeredSpecies,aes(x=taxon,y=num.species)) + 
```

### ANNOTATION: fill="darkgreen" - colors the inside of bars dark green
```r
  geom_col(fill="darkgreen") +
```

### ANNOTATION: theme() with element_text(angle=90) - rotates x-axis labels 90 degrees to prevent overlap
```r
  theme(axis.text.x = element_text(angle = 90))+
```

### ANNOTATION: ylab() - sets y-axis label
```r
  ylab("Number of species")+
```

### ANNOTATION: ggtitle() - adds plot title
```r
  ggtitle("ESA listed species")
```

### or flipping the axes

### ANNOTATION: Same bar chart but with horizontal bars instead of vertical
```r
ggplot(EndangeredSpecies,aes(x=taxon,y=num.species)) + 
  geom_col(fill="darkgreen") +
  ylab("Number of species")+
  ggtitle("ESA listed species")+
```

### ANNOTATION: coord_flip() - swaps x and y axes, making horizontal bar chart (easier to read long labels)
```r
  coord_flip()
```

### Relative frequency

### ANNOTATION: Creates new column 'Proportion' by dividing each species count by total count
### ANNOTATION: The $ operator accesses/creates columns; sum() adds all values in num.species
```r
EndangeredSpecies$Proportion<-EndangeredSpecies$num.species/sum(EndangeredSpecies$num.species)
```

### ANNOTATION: Bar chart showing proportions (0 to 1) instead of raw counts
```r
ggplot(EndangeredSpecies,aes(x=taxon,y=Proportion)) + 
  geom_col(fill="darkgreen") +
  theme(axis.text.x = element_text(angle = 90))+
  ylab("Proportion of species")+
  ggtitle("ESA listed species")
```

### Histograms for continuous data (Lynx)

### ANNOTATION: Creates a histogram; only x aesthetic needed - ggplot counts frequencies automatically
### ANNOTATION: geom_histogram() - bins continuous data and shows frequency of each bin
```r
ggplot(Lynx,aes(x=pelts))+geom_histogram()
```

### Histogram always says to pick a better binwidth, in this case the binwidth looks fine

### ANNOTATION: Same histogram but bins=10 forces exactly 10 bins (bars)
```r
ggplot(Lynx,aes(x=pelts))+
  geom_histogram(bins=10)  #10 bins
```

### ANNOTATION: Same histogram but binwidth=500 sets each bin to span 500 units on x-axis
```r
ggplot(Lynx,aes(x=pelts))+
  geom_histogram(binwidth=500)  #binwidth of 500 units
```

### Cumulative frequency histogram

### ANNOTATION: Creates cumulative distribution plot
```r
ggplot(Lynx,aes(x=pelts)) + 
```

### ANNOTATION: stat_ecdf() - empirical cumulative distribution function; shows what fraction of data falls below each x value
```r
  stat_ecdf()
```

### empirical cumulative density function

### With some formatting

### ANNOTATION: Same ECDF plot with styling
```r
ggplot(Lynx,aes(x=pelts)) + 
```

### ANNOTATION: linewidth=2 makes line thicker; color="darkred" colors the line
```r
  stat_ecdf(linewidth=2,color="darkred")+
  ylab("Fraction of years")+
  ggtitle("Lynx cumulative frequency")
```

### Comparing multiple histograms

### ANNOTATION: Reads daphnia.csv file into dataframe called 'daphnia'
```r
daphnia<-read.csv("daphnia.csv")
```

### ANNOTATION: Converts cyandensity column to a factor (categorical variable) with specific level order
### ANNOTATION: levels=c("low","med","high") ensures bars/legends appear in this logical order, not alphabetical
```r
daphnia$cyandensity<-factor(daphnia$cyandensity,levels=c("low","med","high"))
```

### Histogram of all the resistance data

### ANNOTATION: Basic histogram of resistance values; binwidth=0.05 sets bin width
```r
ggplot(daphnia,aes(x=resistance))+
  geom_histogram(binwidth=0.05)
```

### Using cyandensity for the fill aesthetic to fill with different colors

### ANNOTATION: fill=cyandensity inside aes() - colors bars differently based on cyandensity category
### ANNOTATION: When fill is inside aes(), it maps a variable to color (different colors per group)
```r
ggplot(daphnia,aes(x=resistance,fill=cyandensity))+
```

### ANNOTATION: color="black" adds black outline to each bar (color = outline, fill = inside)
```r
  geom_histogram(binwidth=0.05,color="black")
```

### Separate plots by cyandensity

### ANNOTATION: Same histogram but split into separate panels
```r
ggplot(daphnia,aes(x=resistance,fill=cyandensity))+
  geom_histogram(binwidth=0.05,color="black")+
```

### ANNOTATION: facet_wrap() - creates separate sub-plots for each level of cyandensity
### ANNOTATION: cyandensity~. means split by cyandensity; ncol=1 stacks panels vertically
```r
  facet_wrap(cyandensity~.,ncol=1)
```

### and cumulative frequencies, aesthetic is color (or colour or col, for points 
### and lines)

### ANNOTATION: Creates overlaid ECDF curves, one for each cyandensity level
### ANNOTATION: color=cyandensity inside aes() - different line colors for each group
```r
ggplot(daphnia,aes(x=resistance,color=cyandensity))+
```

### ANNOTATION: linewidth=2 makes all lines thicker for visibility
```r
  stat_ecdf(linewidth=2)
```

### Stripchart for anova data

### ANNOTATION: Creates a strip chart (1D scatterplot) - shows distribution of resistance for each category
```r
ggplot(daphnia,aes(x=cyandensity,y=resistance))+
```

### ANNOTATION: color="red" OUTSIDE aes() - applies same red color to ALL points
```r
  geom_point(color="red")
```

### Note, color here is not an aesthetic, it is the same for all points (i.e.
### not mapped to a variable)

### For larger datasets, spread out the points with jitter()

### ANNOTATION: Same strip chart but with jittered points to reduce overplotting
```r
ggplot(daphnia,aes(x=cyandensity,y=resistance))+
```

### ANNOTATION: position_jitter(width=0.05) - randomly spreads points horizontally within 0.05 units
### ANNOTATION: This reveals overlapping points that would otherwise hide each other
```r
  geom_point(color="red",position = position_jitter(width=0.05))
```

### Violin plots

### ANNOTATION: Creates violin plots showing distribution shape for each group
### ANNOTATION: fill=cyandensity - fills each violin with a different color based on category
```r
ggplot(daphnia,aes(x=cyandensity,y=resistance,fill=cyandensity)) +
```

### ANNOTATION: geom_violin() - shows distribution shape; width represents frequency/density
```r
  geom_violin()+
  xlab("Cyanobacteria density")+
  ylab("Daphnia resistance")
```

### What happens if you you make cyandensity the color rather than the fill?

### Grouped and stacked barplots 

### ANNOTATION: Reads bruv.csv (Baited Remote Underwater Video data) into dataframe
```r
bruv<-read.csv("bruv.csv")
```

### ANNOTATION: Shows first 6 rows to preview the data structure
```r
head(bruv)
```

### ANNOTATION: Converts Zone column to a factor (categorical variable)
```r
bruv$Zone<-factor(bruv$Zone)
```

### ANNOTATION: Converts Sharks column to a factor (categorical variable)
```r
bruv$Sharks<-factor(bruv$Sharks)
```

### ANNOTATION: Shows summary of all variables in the dataframe
```r
summary(bruv)
```

### ANNOTATION: Shows dimensions (number of rows and columns) of the dataframe
```r
dim(bruv)
```

### Data is long format, not aggregated, so use geom_bar rather than 
### geom_col

### ANNOTATION: Shows first 6 rows again
```r
head(bruv)
```

### Stacked is the default

### ANNOTATION: Creates stacked bar chart; geom_bar() COUNTS rows automatically (unlike geom_col)
### ANNOTATION: fill=Sharks - colors bar segments by whether sharks were present
```r
ggplot(bruv,aes(x=Zone,fill=Sharks))+geom_bar() 
```

### Side by side barplots

### ANNOTATION: Creates grouped (side-by-side) bar chart instead of stacked
```r
ggplot(bruv,aes(x=Zone,fill=Sharks))+
```

### ANNOTATION: position_dodge() - places bars side by side instead of stacked
```r
  geom_bar(position = position_dodge())  #For side by side
```

### Changing the color

### ANNOTATION: Same grouped bar chart with custom colors
```r
ggplot(bruv,aes(x=Zone,fill=Sharks))+
  geom_bar(position = position_dodge())  +
```

### ANNOTATION: scale_fill_manual() - manually set fill colors; values= specifies exact colors to use
```r
  scale_fill_manual(values=c("darkred","goldenrod"))
```

### Changing labels for each aesthetic

### ANNOTATION: Same plot with custom labels
```r
ggplot(bruv,aes(x=Zone,fill=Sharks))+
  geom_bar(position = position_dodge())  +
  scale_fill_manual(values=c("darkred","goldenrod"))+
```

### ANNOTATION: labs() - sets labels; x="" removes x-label; y= sets y-label; fill= sets legend title
### ANNOTATION: \n creates a line break in the legend title
```r
  labs(x="",y="Number of BRUVs",fill="Sharks\npresent")
```

### Changing position of the legend

### ANNOTATION: Same plot with legend moved to bottom
```r
ggplot(bruv,aes(x=Zone,fill=Sharks))+
  geom_bar(position = position_dodge())  +
  scale_fill_manual(values=c("darkred","goldenrod"))+
  labs(x="",y="Number of BRUVs",fill="Sharks present")+
```

### ANNOTATION: theme(legend.position="bottom") - moves legend from right side to bottom of plot
```r
  theme(legend.position = "bottom")
```

### geom_bar vs. geom_col

### geom_bar counts the frequencies for you
### geom_col expects the counts

### ANNOTATION: Loads tidyverse package which includes dplyr for data manipulation
```r
library(tidyverse)
```

### ANNOTATION: Uses dplyr pipe (%>%) to create a summary table
### ANNOTATION: group_by() - groups data by Zone and Sharks combinations
### ANNOTATION: summarize(count=n()) - counts number of rows in each group, stores as 'count'
```r
bruvGroup<-bruv %>% group_by(Zone,Sharks) %>%
  summarize(count=n())
```

### ANNOTATION: Displays the grouped/summarized data
```r
bruvGroup
```

### ANNOTATION: Creates bar chart from pre-aggregated data; y=count specifies the pre-computed counts
### ANNOTATION: geom_col() - uses the y values directly as bar heights (no counting)
```r
ggplot(bruvGroup,aes(x=Zone,y=count,fill=Sharks))+
  geom_col()
```
