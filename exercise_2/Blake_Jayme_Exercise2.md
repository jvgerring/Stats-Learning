## Problem 1: Data visualization: Capital Metro

###Part A:

![](Blake_Jayme_Ex2_files/figure-markdown_strict/1A-1.png)

Average bus boardings per hour during the months of September through
November, organized by weekday. During the workday, Mon-Fri, boardings
seem to peak consistently between the hours of 3-5PM. During the
weekends, average boardings appear relatively flat with not one hour
appearing more popular than the other. The lower average boardings on
Mondays in September could be due to a number of reasons. The closing of
the university on the first Monday in September due to Labor Day could
be artificially bringing down the average for the month, because it’s
fathomable that there are close to 0 boardings on that day. Similarly,
the averages for Wednesdays-Fridays in November seem to be affected by
the Thanksgiving holiday, which typically begins on a Wednesday and
lasts until the following Monday. The near zero boardings one could
expect on these days could be affecting the mean for Wed-Fri in
November.

###Part B

![](Blake_Jayme_Ex2_files/figure-markdown_strict/1B-1.png)

The figure shows a “heat-map” of average boardings during each hour of
the day depending on temperature and sorted by weekday or weekend. Based
on the figures above, there doesn’t appear to be any evidence that
suggests that UT students ride the bus more or less because of
temperature, but the time of day does seem to have an impact with the
mid-day being the most frequented time.

## Problem 2: Saratoga House Prices

The linear model which outperformed the medium linear model is: price =
lotSize + age + landValue + livingArea + bedrooms + bathrooms + rooms +
heating + waterfront + newConstruction + centralAir which was found
using Stepwise regression.

Using a cross validated RMSE, we found that the linear medium model had
an RMSE of 69966 and our chosen linear model had an RMSE of 63280. The
KNN model had a RMSE of 69919 which was selected using repeated cross
validation and then refit to the testing set. This means our chosen
linear model was the best at predicting market values for properties in
Saratoga. For a taxing authority it’s clear that there are important
factors in determining property value compared to the medium model: Land
Value, Waterfront Property, and finally whether or not a house was a new
construction.

## Question 3

![](Blake_Jayme_Ex2_files/figure-markdown_strict/Q3-1.png)

    ##         (Intercept)            duration              amount         installment 
    ##               -0.42                0.02                0.00                0.25 
    ##                 age         historypoor     historyterrible          purposeedu 
    ##               -0.03               -1.02               -1.72                0.52 
    ## purposegoods/repair       purposenewcar      purposeusedcar       foreigngerman 
    ##               -0.01                0.58               -1.02               -1.06

The coefficients of poor and terrible history are the opposite of what
people would expect, this negative number means people with worse credit
history are less likely to default.

The bar plot seems to suggest that these results are coming directly
from the data set.

It seems that by choosing to only have a sample of loans that defaulted,
the bank isn’t able to accurately predict who will default. Since the
sample is full of defaulted loans, it’s hard to draw conclusions on what
makes a successful borrower and vise versa. It would make more sense for
the bank to have a random sample of loans that both defaulted and didn’t
default to better predict defaults.

## Question 4

### Model Building

First, we will train/split the data, then build the baseline models 1
and 2. We attempted to get the best model by looking at the p-value of
each coefficients, and by exploring the interaction terms.


After fitting the best model, we create the confusion matrix to compare
the out of sample performance of the models.

Below are the accuracy of the models, baseline1, baseline2, best model
respectively: note that our “best model” is still performing slightly
worse than the baseline2 model, I might want to try something more
efficient than handpicking variables.

    ## [1] 92.19

    ## [1] 93.28

    ## [1] 93.28

### Model Validation: Step 1

Validate our best model by testing on the `hotels_dev` data, and
generate the ROC curve of this prediction using threshold of 0.01 to 0.9

![](Blake_Jayme_Ex2_files/figure-markdown_strict/Model%20Validation:%20Step%201-1.png)

From the plot we can see that the optimal threshold to choose might be
around 0.1 ~ 0.2.

### Model Validation: Step 2

Do 20 folds cross validation using the `hotels_dev` data, and I used
sample to create random fold number 1 to 20 onto each data entry.

For each fold, I stored the sum of predicted bookings and Actual
bookings to see how well is this model performing.

![](Blake_Jayme_Ex2_files/figure-markdown_strict/Model%20Validation:%20Step%202-1.png)

We can see the expected numbers of bookings is only loosely following
the actual numbers.
