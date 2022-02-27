# Welcome to Jayme Gerring's Exercise 1 !

#Import libraries
library(tidyverse)
library(markdown)

#QUESTION 1

#Reading in the data 
ABIA = read.csv('/Users/jaymegerring/Downloads/GitHub/Stats-Learning/exercises-1/ABIA.csv')

Time_of_Day_adjusted <- ABIA[,c("CRSDepTime","UniqueCarrier","ArrDelay")]

#Created new variable that organizes time as different periods of the day
Time_of_Day_adjusted <- Time_of_Day_adjusted %>%
  mutate(TimeofDay =  ifelse( between(CRSDepTime, 0, 659), yes = "Early Morning",
                              no = ifelse(between(CRSDepTime, 700, 1159), yes = "Morning",
                                          no = ifelse(between(CRSDepTime, 1200, 1759), yes = "Afternoon",
                                                      no =  "Evening" ))))
# Filtering Out by Top Ten Airlines
TopTen <- ABIA %>%
  count(UniqueCarrier, sort = TRUE)

TopTen

TopTen %>%
  filter(n > 2134)

Time_of_Day_adjusted <- Time_of_Day_adjusted %>%
  filter(UniqueCarrier == "WN" | UniqueCarrier == "AA" 
         | UniqueCarrier == "CO" | UniqueCarrier == "YV" 
         | UniqueCarrier == "B6" | UniqueCarrier == "XE" 
         | UniqueCarrier == "OO" | UniqueCarrier == "OH" 
         | UniqueCarrier == "MQ" | UniqueCarrier == "9E")

#WN = Southwest
#AA= American
#CO = Continental 
#YV = Mesa Airlines (Code Shares with American and United)
#B6 = Jet Blue
#XE = Express Jet (Code Shared as American, United, and Delta) (Now Aha! Air)
#OO = Skywest (Code shares as Alaska Airlines, American Airlines, Delta Air Lines, and United Airlines)
#OH = Jetstream Intl. (Charters)
#MQ = Envoy Air (Owned by American Airlines)
#9E = Pinnacle Airlines (Code Shared Delta) (Now Endeavor Air)

#Add Carrier names based off of Unique Carrier Code
Time_of_Day_adjusted <- Time_of_Day_adjusted %>% 
  mutate(Carrier = ifelse(UniqueCarrier == "WN", 
                          yes = "Southwest", no = ifelse(UniqueCarrier == "AA", 
                                                         yes = "American Airlines", no = ifelse(UniqueCarrier == "CO",
                                                                                                yes = "Continental", no = ifelse(UniqueCarrier == "YV",
                                                                                                                                 yes= "Mesa Airlines", no = ifelse(UniqueCarrier == "B6",
                                                                                                                                                                   yes= "Jet Blue", no = ifelse(UniqueCarrier == "XE",
                                                                                                                                                                                                yes = "Express Jet", no = ifelse(UniqueCarrier=="OO",
                                                                                                                                                                                                                                 yes = "Skywest", no = ifelse(UniqueCarrier=="OH",
                                                                                                                                                                                                                                                              yes = "Jetstream Intl.", no = ifelse(UniqueCarrier=="MQ",
                                                                                                                                                                                                                                                                                                   yes = "Envoy Air", no = "Pinnacle Air"))))))))))


#replace N/A values with zeros 
Time_of_Day_adjusted[is.na(Time_of_Day_adjusted)] = 0


#Find Average Arrival Delay, Grouped by Carrier and Departure time and create new data frame
group_cols <- c("TimeofDay", "Carrier")
Time_of_Day_adjusted_avgs<- Time_of_Day_adjusted %>% 
  group_by(across(all_of(group_cols))) %>% 
  summarize(mean_delay = mean(ArrDelay))

#round the average delays to discrete values
Time_of_Day_adjusted_avgs$Rounded_Delay <- round(Time_of_Day_adjusted_avgs$mean_delay)

#plotting the data!!!!!
  ggplot(Time_of_Day_adjusted_avgs, aes(TimeofDay, Rounded_Delay)) + 
    geom_bar(aes(fill = Carrier), stat = "identity", position = "dodge") + 
    ggtitle("Best Time to Fly for On-Time Arrival") + 
    labs(y = "Average Arrival Delay (min)", x = "Time of Day")
  
#######QUESTION 2########

#clear environment 
rm(list=ls())

#read in data
billboard <- read.csv('/Users/jaymegerring/Downloads/GitHub/Stats-Learning/exercises-1/billboard.csv')

#getting the appropriate data
billboard_topTen <- billboard %>%
  arrange(desc(weeks_on_chart)) %>%
  distinct(song_id, .keep_all= TRUE)%>%
  slice(1:10) 

#filtering out specified columns
filtered_billboardTen <- billboard_topTen[,c("performer", "song", "weeks_on_chart")]

#final data frame with correct column names 
filtered_billboardTen <- filtered_billboardTen %>%
  rename(Performer = performer,
         Song = song,
         Count = weeks_on_chart)

#FIGURE OUT HOW TO GET THE TABLE TO APPEAR IN R MARKDOWN

#2B
Filtered_billboard_unique <- filter(billboard, year != 1958 | year != 2021) %>%
  group_by(year)%>%
  summarize(yearly_songs = length(unique(song)))

  






  
                                                                                                                                                                
                                                                                                 
                                                                                                     
  
  
  

