library(tidyverse)
library(arules) 
library(arulesViz)
library(igraph)

#import data, tab delimited text file
raw_groceries <- read.table("/Users/jaymegerring/Downloads/GitHub/Stats-Learning/exercise_4/groceries.txt", 
                            sep = '\t', header = F)

#add a numbered variable to keep track of baskets
raw_groceries <- raw_groceries %>%
 add_column(Basket_Number= NA) 
raw_groceries$Basket_Number <- 1:nrow(raw_groceries) 

#rename first variable
raw_groceries <- rename(raw_groceries, Customer = V1)

raw_groceries$Basket_Number = factor(raw_groceries$Basket_Number)

#commas into individual items
groceries = strsplit(raw_groceries$Customer, ",")

groceries$Customer = factor(groceries$Customer)


# Remove duplicates ("de-dupe")
# lapply says "apply a function to every element in a list"
# unique says "extract the unique elements" (i.e. remove duplicates)
groceries = lapply(groceries, unique)

grocerytrans = as(groceries, "transactions")
summary(grocerytrans)

groceryrules = apriori(grocerytrans, 
                     parameter=list(support=.001, confidence=.8, maxlen=10))

grocrules_df <- arules::DATAFRAME(groceryrules)

inspect(groceryrules)

inspect(subset(groceryrules, lift > 2))
inspect(subset(groceryrules, confidence > 0.8))
inspect(subset(groceryrules, lift > 10 & confidence > 0.05))

plot(groceryrules)

sub1 = subset(groceryrules, subset=confidence > 0.01 & support > 0.005)
summary(sub1)
plot(sub1, method='graph')
