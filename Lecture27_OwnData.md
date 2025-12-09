# Lecture 27. R with your own data

###   Loads required packages
###   Includes tidyverse (data manipulation), ISwR (datasets), readxl (reading Excel files)
```r
library(tidyverse)
library(ISwR)
library(readxl)
```

### Getting citations

###   citation() gives the citation info for R or specific packages
```r
citation() # for R itself
citation("ggplot2")
```

### Read in from a well formatted Excel file

### First, see what happens from badly formatted data

###   Reads 'FISH DATA Bad.xlsx' (an example of messy data) using read_xlsx
```r
badExcel<-read_xlsx("FISH DATA Bad.xlsx")
#view(badExcel)
```

### Now, read in the data from each tab, well formatted

###   Reads specific sheets ("Data" and "Species List") from a clean Excel file
###   summary() and head() inspect the loaded data
```r
fishData<-read_xlsx("FISH DATA Good.xlsx",sheet="Data")
speciesList<-read_xlsx("FISH DATA Good.xlsx",sheet="Species List")
summary(fishData)
head(speciesList)
```

### Use left_join to look up the names of the species in speciesList

###   left_join() merges the species names into the fish data using the common column "SP"
```r
fishData<-left_join(fishData,speciesList,by="SP")
#view(fishData)
```

## Read in data and look for obvious mistakes

### See if there are any unexpected NA values. 

###   Reads 'FISH DATA with errors.csv'
###   summary() helps identify columns with NAs
###   filter(!is.na(YR)) removes rows where Year is missing
```r
fish<-read.csv("FISH DATA with errors.csv")
summary(fish) 
fish<-fish %>% filter(!is.na(YR))
#view(fish)
```

### Check for mistakes in categorical variables

###   table() lists unique values in 'SP' column - good for spotting typos (e.g., "Gerrid " vs "GERRID")
###   trimws() removes extra spaces; toupper() converts to uppercase to standardize
###   Alternatively, ifelse() can manually correct specific typos
```r
table(fish$SP)  # Look for names spelled wrong, like extra spaces
fish<-fish %>% mutate(SP=trimws(SP), #trims whitespaces
  SP=toupper(SP))  #All to upper case
#or
fish<-fish %>% mutate(SP=ifelse(SP %in% c("GERRID ","Gerrid"),"GERRID",SP))
table(fish$SP)
```

### Make plots to see if there are any typos in numbers.

###   Plots Longitude vs Latitude to check for geographic outliers
###   Replaces positive Longitude values (likely errors if Western hemisphere) with NA
###   Re-plots to verify the fix
```r
ggplot(fish,aes(x=LON,y=LAT))+
  geom_point()
#view(fish)
fish<-fish %>% mutate(LON=ifelse(LON>0,NA,LON)) #Take out bad value
ggplot(fish,aes(x=LON,y=LAT,color=STR))+
  geom_point()
```

### Importing dates into R

### From a csv file. 

###   Reads good CSV data
###   Checks the format of DATE column (often read as character/factor initially)
```r
fish<-read.csv("FISH DATA Good.csv")
#fish<-read_csv("FISH DATA Good.csv")
summary(fish$DATE)

fish$DATE[1]
as.Date(fish$DATE[1],format="%m/%d/%Y")
fish$DATE<-as.Date(fish$DATE,format="%m/%d/%Y")
summary(fish$DATE)
```

### Date variables plot correctly as numeric, and you can do arithmetic

###   Plots Date vs Temp
###   Calculates difference between two dates
```r
ggplot(fish,aes(x=DATE,y=TEMP))+geom_point()
fish$DATE[40]-fish$DATE[1]
```

### Some useful functions from the lubridate library

###   Extracts Year, Month, Day from date objects
###   make_date() constructs a date object from separate YR, MO, DY columns
```r
year(fish$DATE)  #Get year from date
month(fish$DATE) # get month
day(fish$DATE)  #get day
fish<-fish %>% mutate(newdate=make_date(YR,MO,DY)) #make a date from year, month,day
summary(fish$newdate)
```

### Reading dates from from excel 

###   Reads Excel file again
###   Excel dates often include time; format() removes it
```r
fish2<-read_xlsx("FISH DATA Good.xlsx",sheet=1)
summary(fish2$DATE)
#To eliminate the time
fish2$DATE<-as.Date(format(fish2$DATE,format="%Y-%m-%d"))
summary(fish2$DATE)
```
