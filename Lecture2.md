```r
## Lecture 2. Introduction to R

## Getting Started
# Start by making a new file, saving it your working directory, and setting the 
# working directory to the source file location (Session menu/Set working directory/to source file location). Remember to keep saving this file as you work, so you don't lose your work. 

## Basic Math Operations
# R does basic math
# Addition (+) means sum the numbers.
```r
2 + 2


# Exponentiation (^) raises left to the power of right (5^2 is 5 squared).

5^2


# sqrt(x) computes the square root of x.
sqrt(4)

# exp(x) computes e to the power of x.
exp(10)

## Variables and Assignment
# <- is the assignment operator; it stores the result in a variable.
# Data can be stored in vectors (=column of numbers). e.g.
x <- rnorm(10)  # produces  a vector called 'x' with length 10  

# which is now an R object
# See "Global Environment" in upper right for all the stored objects.
# Note:Can use either x<- or x= Both work
x

## Workspace Management
# From now on a variable called x is stored in the workspace (global environment). To see what is stored in the workspace, use the list function, or look in the Global environment in the upper right.
# ls() lists all objects in the workspace 
ls()  

# or look in the upper right.

# You can name an object with any letters, numbers and dot. e.g.
x.bar <- mean(x)
x.bar

# rm(x) removes objects from the workspace
rm(x)  # removes objects from the workspace
# rm(list = ls()) removes all objects from the workspace
rm(list = ls())  # removes all objects from the workspace

# Names are case sensitive. Don't use names that are already R functions (like c, t, F, T), 
# The c function can be used to make vectors.  e.g.

## Vectors and Arithmetic
# c(...) combines things to make a vector.
x <- c(1, 2, 3, 4)
y <- c(5, 6, 7, 8)

# The arithmetic operations are applied to every member of the vector. This only works if the vectors are the same length, or one is multiple of the other. For example
z <- y - x
z
z <- y * 2 + x

## Vector Functions
# Functions that apply to vectors
# sum(x) computes the sum of all x values.
sum(x)
# length(x) returns the number of elements in x.
length(x)
# mean(x) returns the average of x values.
mean(x)
# sum(x*y) computes the sum of y times x for all elements.
sum(x*y)

## Getting Help
# Getting help.  Type ? followed by the function you need help with.
# ?function opens help for that function.
?mean
# Or search in the lower right hand panel, or use Google. 

## Data Types
# Types of data objects
# Data can  Numeric, character, logical and factor

# Character
# Character vectors store text, e.g. x <- c("red", "white", "blue")
x<-c("red","white","blue")

# x is a character vector
x <- c("red", "white", "blue")           # create character vector
x                                         # print character vector
summary(x)                                # summary of character vector

# Convert x to a factor
x <- factor(x)                            # convert character vector to factor
summary(x)                                # shows counts of each factor level

# Change the order of factor levels
x <- factor(x, levels = c("red", "white", "blue"))  # specify order of levels
summary(x)                                # check levels and counts

## Sequences and Matrices
x <- c(1, 2, 3, 4)              # c(): combine values into a vector
y <- c(5, 6, 7, 8)              # c(): combine values into a vector

z <- y - x                      # -: element-wise subtraction between vectors
z                               # prints the result

z <- y * 2 + x                  # *: scalar multiplication; +: element-wise addition
sum(x)                          # sum(): sum of elements in vector x
length(x)                       # length(): count of elements in x
mean(x)                         # mean(): average value of x
sum(x*y)                        # sum(): sum; *: element-wise multiplication

?mean                           # ?: help/documentation for mean()

# Character vectors store text, e.g. x <- c("red", "white", "blue")
x<-c("red","white","blue")      # c(): combine character values into a vector

x <- c("red", "white", "blue")           # c(): create character vector
x                                         # print character vector
summary(x)                                # summary(): summary information (length, class, etc.)

x <- factor(x)                            # factor(): convert to factor (categorical variable)
summary(x)                                # summary(): show count in each factor level

x <- factor(x, levels = c("red", "white", "blue"))  # factor(..., levels=): set order of levels
summary(x)                                          # summary(): show count in each factor level

z<-c(x, y, 0,0,0)                         # c(): combine factors/variables into a vector

seq(4,9)                                  # seq(): generate a sequence from 4 to 9
4:19                                      # : (colon): generate integer sequence from 4 to 19
seq(4,19,2)                               # seq(): sequence from 4 to 19 in steps of 2

matrix(1:12,3,4)                          # matrix(): create 3x4 matrix from data 1:12
matrix(1:12,3,4,byrow=TRUE)               # matrix(..., byrow=TRUE): fill matrix by rows
x<-matrix(1:12,3,4,dimnames=list(c("A","B","C"),c("a","b","c","d")))  # matrix(..., dimnames=): name rows and columns
x                                         # print matrix

## Lists and Data Frames
mylist<-list(x=c(1,2,3,4),y=c(5,6,7,8))   # list(): create list from vectors

mylist$x                                  # $: select element x from list mylist
mylist                                    # print list

mydata<-data.frame(x=c(1,2,3,4),y=c(5,6,7,8))      # data.frame(): create data frame
mydata                                    # print data frame
mydata$x                                  # $: select column x from data frame

mydata$z<-rep(1,4)                        # rep(): repeat value 1 four times; $: assign to new column
mydata                                    # print updated data frame

## Indexing and Subsetting
x<-seq(100,500,100)                       # seq(): generate sequence from 100 to 500 by 100

y <- x^2                       # Square each element in x and assign result to y
x                              # Print the values of x
x[1]                           # Access the first element of x
x[c(4,2,1)]                    # Access the 4th, 2nd, and 1st elements of x, in that order
a <- c(4,2,1)                  # Create a vector a containing 4, 2, and 1
x[a]                           # Use vector a as an index to access elements 4, 2, and 1 from x
x[1:3]                         # Access elements 1 through 3 of x
x[x > 200]                     # Access elements of x that are greater than 200
y[x > 200]                     # Access corresponding elements of y where x is greater than 200

# Anything that returns TRUE or FALSE values can be used to subset vectors

y[x == 200]                    # Get values of y where x equals 200, note the use of '==' for equality check
x[x != 300]                    # Get elements of x where x is NOT equal to 300; '!=' means 'not equal'
x[x >= 300]                    # Access elements of x that are greater than or equal to 300
x[x > 200 & x < 400]           # Find elements of x greater than 200 AND less than 400; '&' means 'and'
x[x < 200 | x > 400]           # Get elements where x is less than 200 OR greater than 400; '|' means 'or'
x[!(x < 200 | x > 400)]        # Get elements of x NOT less than 200 OR greater than 400; '!' negates the condition

# For matrices and data frames, use a comma to separate rows and columns

mydata                         # Print the data frame called mydata
mydata[1:2, 2]                 # Access rows 1 and 2, column 2 of mydata
mydata[2, ]                    # Access all columns of row 2 in mydata
mydata[, 2]                    # Access all rows of column 2 in mydata
mydata[mydata$x > 2, ]         # Access all rows where x > 2, for all columns in mydata

## Reading in data. 
# Set working directory to source file location and check that you have the right directory

# setwd("path/to/directory")
getwd()                          # Print the current working directory
daphnia <- read.csv("daphnia.csv") # Read CSV file 'daphnia.csv' into a data frame called daphnia

## Functions to summarize data frames. 
dim(daphnia)                     # Get the dimensions (number of rows and columns) of daphnia
head(daphnia)                    # Print the first 6 rows of daphnia
summary(daphnia)                 # Get summary statistics for each column in daphnia
table(daphnia$cyandensity)       # Get counts of unique values in the cyandensity column of daphnia

## Plotting data
# We will do ggplot next week, but for now here is one simple graph

library(ggplot2)                             # Load the ggplot2 package for plotting
ggplot(daphnia, aes(x = cyandensity, y = resistance)) + stat_summary()  # Plot resistance vs cyandensity using summary statistics

# To copy and paste the plot, select Export>Copy plot to clipboard>Copy Plot, and then paste it into a Word document.
# You will need to do this for your homework.

## How to export data. 
write.csv(daphnia, file = "newDaphnia.csv")  # Save the daphnia data frame to a new CSV file called 'newDaphnia.csv'

# Use session/save workspace as and
# Session/load workspace

# ?save.image                   # Get help on saving the R workspace

# When you are done, be sure to save your R code.
# For simple analyses with small data sets
