# problem 3

german_credit <- read.csv("~/Documents/GitHub/ECO395M/data/german_credit.csv")

library(tidyverse)
library(ggplot2)
library(caret)
library(modelr)
library(rsample)

# 1. Make a bar plot of default probability by credit history, 
# 2. and build a logistic regression model for predicting default probability

# compute the average default rate in every group
default_prob = german_credit %>% 
  group_by(history) %>%
  summarize(avg_default_prob = mean(Default))

# making the plot"default probability by history"
ggplot(default_prob, aes(history, avg_default_prob)) + geom_bar(stat = "identity") + 
  labs(y = "Default Probability", x = "Class of Credit History", title = "Default Probability by Credit History") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# split the train/test data
credit_split =  initial_split(german_credit, prop=0.8)
credit_train = training(credit_split)
credit_test  = testing(credit_split)

# building the model 
logit_default = glm(Default~duration + amount + installment + age + history + purpose + foreign, data = credit_train, family = binomial)

coef(logit_default) %>% round(2)

# check the confusion matrix, using the threshold of 0.5
phat_test_default = predict(logit_default, credit_test, type = "response")
yhat_test_default = ifelse(phat_test_default>0.5, 1, 0)
confusion_default = table(y = credit_test$Default, yhat = yhat_test_default)

confusion_default

# Question: how does the history variables perform?
 # It is actually weird here bc the history has a counter intuitive results. see graphs and coefficients

