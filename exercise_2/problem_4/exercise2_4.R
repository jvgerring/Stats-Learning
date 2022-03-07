library(tidyverse)
library(ggplot2)
library(caret)
library(modelr)
library(rsample)
library(gamlr)
library(glmnet)
library(foreach)
library(ROCR)
library(pROC)

hotels_dev<- read.csv("~/Documents/GitHub/ECO395M/data/hotels_dev.csv")
hotels_val<- read.csv("~/Documents/GitHub/ECO395M/data/hotels_val.csv")

## split the "dev" data
hotel_dev_split = initial_split(hotels_dev, prop = 0.8)
hotel_dev_train = training(hotel_dev_split)
hotel_dev_test = testing(hotel_dev_split)

# Model Building 
## baseline 1
hotel_baseline1 = glm(children ~ market_segment + adults + customer_type + is_repeated_guest, data = hotel_dev_train, family = binomial)

## baseline 2
hotel_baseline2 = glm(children ~ .-arrival_date , data = hotel_dev_train, family = binomial)

# build the best model 
# # getting the p-value of each coefficients, to create the best model 
# summary(hotel_try)$coefficients[,4]%>%round(3)
hotel_best = glm(children ~ . - arrival_date + stays_in_weekend_nights:distribution_channel + is_repeated_guest:distribution_channel + adults:is_repeated_guest +  adults:stays_in_weekend_nights + stays_in_weekend_nights:customer_type + customer_type:adults, data = hotel_dev_train, family = binomial)


# the out of sample performance for model 1 and 2: setting the t as 0.15
#for model 1
phat_baseline1 = predict(hotel_baseline1, hotel_dev_test, type = "response")
yhat_baseline1 = ifelse(phat_baseline1>0.3, 1, 0)
confusion_baseline1 = table(y = hotel_dev_test$children, yhat = yhat_baseline1)

#for model 2
phat_baseline2 = predict(hotel_baseline2, hotel_dev_test, type = "response")
yhat_baseline2 = ifelse(phat_baseline2>0.3, 1, 0)
confusion_baseline2 = table(y = hotel_dev_test$children, yhat = yhat_baseline2)

#for the best model
phat_best = predict(hotel_best, hotel_dev_test, type = "response")
yhat_best = ifelse(phat_best>0.3, 1, 0)
confusion_best = table(y = hotel_dev_test$children, yhat = yhat_best)

# output: out of sample performance
round(sum(diag(confusion_baseline1))/sum(confusion_baseline1) * 100, 2)
round(sum(diag(confusion_baseline2))/sum(confusion_baseline2) * 100, 2)
round(sum(diag(confusion_best))/sum(confusion_best) * 100, 2)



# Model Validation: Step 1
# validate our best model using the fresh val data
phat_best_val = predict(hotel_best, hotel_val_test, type = "response")

# plot the roc curve
t = rep(1:90)/100

roc_plot = foreach(t = t, .combine='rbind')%do%{
  yhat_best_val = ifelse(phat_best_val >= t, 1, 0)
  confusion_best_val = table(y=hotels_val$children, yhat=yhat_best_val)
  TPR = confusion_best_val[2,2]/(confusion_best_val[2,2]+confusion_best_val[2,1])
  FPR = confusion_best_val[1,2]/(confusion_best_val[1,1]+confusion_best_val[1,2]) 
  c(t=t, TPR = TPR, FPR = FPR)
} %>% as.data.frame()

ggplot(roc_plot) +
  geom_line(aes(x=FPR, y=TPR)) +
  labs(y="True Positive Rate", x = "False Positive Rate", title = "ROC Curve for the Best Model")+
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))


# Model Validation: Step 2
hotel_cv = hotels_val %>%
  mutate(fold = rep(1:20, length=nrow(hotels_val))%>%sample())

hotel_cv = foreach(i = 1:20, .combine='rbind')  %do% {
  hotel_cv_test = filter(hotel_cv, fold == i)
  hotel_cv_train = filter (hotel_cv, fold != i)
  hotel_cv_model = glm(children ~ .+ stays_in_weekend_nights:distribution_channel + is_repeated_guest:distribution_channel + adults:is_repeated_guest +  adults:stays_in_weekend_nights + stays_in_weekend_nights:customer_type + customer_type:adults, data = hotel_cv_train[,!colnames(hotel_cv_train)%in% c("arrival_date")], family = binomial)
  hotel_cv_phat = predict(hotel_cv_model, hotel_cv_test, type = "response")
  c(y=sum(hotel_cv_test$children), y_hat=sum(hotel_cv_phat), fold =i)
} %>% as.data.frame()

ggplot(data = hotel_cv) +
  geom_line(aes(x=fold, y=y, color = "Actual"),  size=1) +
  geom_line(aes(x=fold, y=y_hat, color = "Expected"), size=1) +
  labs(y="Numbers of Bookings", x = "Fold", title = "Actual vs. Expected number of bookings With Children")+
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

