# Lecture 27. R with your own data

### ANNOTATION: Loads required packages
### ANNOTATION: Includes tidyverse (data manipulation), ISwR (datasets), readxl (reading Excel files)
```r
library(tidyverse)
library(ISwR)
library(readxl)
```

### Getting citations

### ANNOTATION: citation() gives the citation info for R or specific packages
```r
citation() # for R itself
citation("ggplot2")
```

### Read in from a well formatted Excel file

### First, see what happens from badly formatted data

### ANNOTATION: Reads 'FISH DATA Bad.xlsx' (an example of messy data) using read_xlsx
```r
badExcel<-read_xlsx("FISH DATA Bad.xlsx")
#view(badExcel)
```

### Now, read in the data from each tab, well formatted

### ANNOTATION: Reads specific sheets ("Data" and "Species List") from a clean Excel file
### ANNOTATION: summary() and head() inspect the loaded data
```r
fishData<-read_xlsx("FISH DATA Good.xlsx",sheet="Data")
speciesList<-read_xlsx("FISH DATA Good.xlsx",sheet="Species List")
summary(fishData)
head(speciesList)
```

### Use left_join to look up the names of the species in speciesList

### ANNOTATION: left_join() merges the species names into the fish data using the common column "SP"
```r
fishData<-left_join(fishData,speciesList,by="SP")
#view(fishData)
```

## Read in data and look for obvious mistakes

### See if there are any unexpected NA values. 

### ANNOTATION: Reads 'FISH DATA with errors.csv'
### ANNOTATION: summary() helps identify columns with NAs
### ANNOTATION: filter(!is.na(YR)) removes rows where Year is missing
```r
fish<-read.csv("FISH DATA with errors.csv")
summary(fish) 
fish<-fish %>% filter(!is.na(YR))
#view(fish)
```

### Check for mistakes in categorical variables

### ANNOTATION: table() lists unique values in 'SP' column - good for spotting typos (e.g., "Gerrid " vs "GERRID")
### ANNOTATION: trimws() removes extra spaces; toupper() converts to uppercase to standardize
### ANNOTATION: Alternatively, ifelse() can manually correct specific typos
```r
table(fish$SP)  # Look for names spelled wrong, like extra spaces
fish<-fish %>% mutate(SP=trimws(SP), #trims whitespaces
  SP=toupper(SP))  #All to upper case
#or
fish<-fish %>% mutate(SP=ifelse(SP %in% c("GERRID ","Gerrid"),"GERRID",SP))
table(fish$SP)
```

### Make plots to see if there are any typos in numbers.

### ANNOTATION: Plots Longitude vs Latitude to check for geographic outliers
### ANNOTATION: Replaces positive Longitude values (likely errors if Western hemisphere) with NA
### ANNOTATION: Re-plots to verify the fix
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

### ANNOTATION: Reads good CSV data
### ANNOTATION: Checks the format of DATE column (often read as character/factor initially)
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

### ANNOTATION: Plots Date vs Temp
### ANNOTATION: Calculates difference between two dates
```r
ggplot(fish,aes(x=DATE,y=TEMP))+geom_point()
fish$DATE[40]-fish$DATE[1]
```

### Some useful functions from the lubridate library

### ANNOTATION: Extracts Year, Month, Day from date objects
### ANNOTATION: make_date() constructs a date object from separate YR, MO, DY columns
```r
year(fish$DATE)  #Get year from date
month(fish$DATE) # get month
day(fish$DATE)  #get day
fish<-fish %>% mutate(newdate=make_date(YR,MO,DY)) #make a date from year, month,day
summary(fish$newdate)
```

### Reading dates from from excel 

### ANNOTATION: Reads Excel file again
### ANNOTATION: Excel dates often include time; format() removes it
```r
fish2<-read_xlsx("FISH DATA Good.xlsx",sheet=1)
summary(fish2$DATE)
#To eliminate the time
fish2$DATE<-as.Date(format(fish2$DATE,format="%Y-%m-%d"))
summary(fish2$DATE)
```
