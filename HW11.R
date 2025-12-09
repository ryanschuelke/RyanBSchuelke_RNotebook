library(tidyverse)
#Chocolate & Nobel Prizes Question
choc <- read.csv(url("https://whitlockschluter3e.zoology.ubc.ca/Data/chapter16/chap16q23ChocolateAndNobel.csv"))
view(choc)

#Shorten variable names
choc<-choc %>% rename(Consumption=chocolateConsumption)
choc<-choc %>% rename(Prizes=nobelPrizes.per.100.million.)
view(choc)

#A
ggplot(choc,aes(x=Consumption, y=Prizes))+geom_point()

#B
cor.test(choc$Prizes,choc$Consumption, method = "spearman")

#Normality
shapiro.test(choc$Consumption)
shapiro.test(choc$Prizes)
ggplot(choc,aes(x=Prizes))+geom_histogram()

#Transform
choc<- choc %>% 
  mutate(transPrizes=sqrt(Prizes))
view(choc)

shapiro.test(choc$transPrizes)

#CI
cor.test(choc$transPrizes,choc$Consumption, conf.level = 0.99)


#Eyelashes Question
eyelash <- read.csv(url("https://whitlockschluter3e.zoology.ubc.ca/Data/chapter16/chap16q25mammalEyelashDensity.csv"))
view(eyelash)

#A&B
cor.test(eyelash$eyeWidth, eyelash$eyelashDensity)

ggplot(eyelash,aes(x=eyeWidth, y=eyelashDensity))+geom_point()

#C
shapiro.test(eyelash$eyeWidth)
shapiro.test(eyelash$eyelashDensity)

#D
ggplot(eyelash,aes(x=eyeWidth))+geom_histogram()
ggplot(eyelash,aes(x=eyelashDensity))+geom_histogram()


#Nutrients Question
nutrients <- read.csv(url("https://whitlockschluter3e.zoology.ubc.ca/Data/chapter17/chap17q20GrasslandNutrientsPlantSpecies.csv"))
view(nutrients)

#A
ggplot(nutrients,aes(x=nutrients, y=species))+geom_point()

#B
nutrients.lm<-lm(species~nutrients,data=nutrients)
summary(nutrients.lm)

#C
ggplot(nutrients,aes(x=nutrients, y=species))+geom_point()+
  stat_smooth(method="lm")
