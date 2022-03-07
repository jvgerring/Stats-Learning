

# fit a single lasso
hotel_lasso = gamlr(hotel_dev_x, hotel_dev_y, family="binomial")

# compare the out-of-sample performance of 1, 2, and lasso (best)
hotel_cvl = cv.gamlr(hotel_dev_x, hotel_dev_y, nfold=10, family="binomial", verb=TRUE)

# optimal lambda
hotels_lasso$lambda[which.min(AICc(hotels_lasso))]
log(hotels_lasso$lambda[which.min(AICc(hotels_lasso))])
sum(scbeta!=0) # chooses 30 (+intercept) @ log(lambda) = -4.5


# build the best model 

# combine the dev and val data sets 
hotel_combined = rbind(hotels_dev, hotels_val)

#create our own numeric feature matrix using the combined data set
combined_x = model.matrix(children ~. -1, data = hotel_combined)
combined_y= hotel_combined$children

# seperate them into the ones from dev and the ones from val

dev_x = combined_x[1:45000,]
dev_y = combined_y[1:45000]
val_x = combined_x[45001:49999,]
val_y = combined_y[45001:49999]