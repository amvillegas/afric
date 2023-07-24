#--------------------------------------------------------------
# Read and prepare the data
#--------------------------------------------------------------
library(tidyverse)

vicData <- read_csv(file = "VicRoadFatalData.csv")

str(vicData) # check the data

#Remove variables 
vicDataPre <-  vicData %>% 
  select(-DRIVER_ID,   
         -VEHICLE_ID,     
         -OWNER_POSTCODE, #It has too many levels
         -ACCIDENT_NO, 
         - DAY_OF_WEEK,
         -fatal, 
         -accident_cnt)


#Create new variables based on data and time

vicDataPre <- vicDataPre %>% 
  mutate(hour = (hour(ACCIDENTTIME)), 
         ACCIDENTDATE = as.Date(ACCIDENTDATE, format = "%d/%m/%Y"),
         month = (month(ACCIDENTDATE)),
         year = (year(ACCIDENTDATE)),
         hour_fac = factor(hour),       #Use factors for glm but continuous for 
         month_fac = factor(month),     #for tree-based methods
         year_fac = factor(year)) %>% 
  rename(AGE_GROUP = `Age Group`) %>%   #Rename variable to remove space which cause problems for some methods 
  select(-ACCIDENTTIME, -ACCIDENTDATE)

#Convert character variables to factor (necessary for some methods)
vicDataPre[] <- lapply(vicDataPre, function(x) if(is.character(x)) as.factor(x) else x)


#--------------------------------------------------------------
# Split the data into training and testing
#--------------------------------------------------------------

n <- nrow(vicDataPre)
set.seed(123)

indexTrain <- sample(1:n, round(n*0.8)) #Do 80/20 split

vicDataTrain <- vicDataPre[indexTrain, ] 
vicDataTest <- vicDataPre[-indexTrain, ] 

#--------------------------------------------------------------
# Exploratory plots
#--------------------------------------------------------------

#Plot by hour 
fat_hour <- vicDataPre %>% 
  group_by(hour_fac, SEX) %>% 
  summarise(rate = mean(fatal_cnt))

fat_hour_plot <- ggplot(fat_hour %>% filter(SEX != "U")) + 
  geom_line(aes(x = hour_fac, y = rate, group = SEX, colour = SEX)) +
  labs(title = "Fatality rate by hour", x = "hour")

print(fat_hour_plot)
