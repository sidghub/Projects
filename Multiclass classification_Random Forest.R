############################################################################################
############################ Make R Great Again ############################################
############################################################################################

# Importing  dataset

train <- read.csv("C:/Users/Danish/Downloads/MSBAPM/Fall 16/R/Project-2/train.csv/train.csv")
View(train)

dim(train)

# dropping id column, as it is not requitred for classification
train$id = NULL

View(train)


########## Random Forest ###########


# installing the package
install.packages("randomForest")

# Load library
library(randomForest)

class(train$target)

# Fitting the model
# A 100 tree model usually takes around 7 minutes to run
fit_rf = randomForest(formula = target~.,data = train, mtry = 9, ntree = 100, importance =T)

summary(fit_rf)

# Checking the OOB rate and confusion matrix
print(fit_rf)

# Plotting to check the optimal tree count
plot(fit_rf)

#### Tuning the model ####

# Removing the target column (94) from x and keeping the only target column (94) for y 

tune.rf <- tuneRF(x = train[,-94],y = train[,94], mytryStart = 2,  stepFactor=0.5, improve = 0.02)


# Re-running the model based on the optimal value of mtry

fit_rf = randomForest(formula = target~.,data = train, mtry = 18, ntree = 100, importance =T)

# Checking the OOB rate and confusion matrix
print(fit_rf)


###### Identifying the most important variables #######

# Variable Importance Plot
varImpPlot(fit_rf,
           sort = T,
           main="Variable Importance",
           n.var=20)


var_imp <- data.frame(importance(fit_rf,
                                 type=2))


# Creating a dataset of important variables and their mean decrease in GINI score

# make row names as columns
var_imp$Variables <- row.names(var_imp)
var_imp[order(var_imp$MeanDecreaseGini,decreasing = T),]


#*******************************************************


# Subsetting the top variables

train_new = train[,c('feat_34','feat_11','feat_60','feat_14','feat_40','feat_15','feat_26','feat_90','feat_42',
                     'feat_67','feat_25','feat_86','feat_62','feat_36','feat_69','feat_24','feat_48','feat_3',
                     'feat_75','target')]


View(train_new)


# Fitting model on the new dataset with imp. variables
fit_rf_1 = randomForest(formula = target~.,data = train_new, mtry = 18, ntree = 100, importance =T)

# Checking the error
print(fit_rf_1)

# error rate has increaed compared to previous model


# Predicting target variable using model with all variables
train$predict_rf <- predict(fit_rf,train)

summary(train$predict_rf)


# Loading caret package to get confusion matrix

library(caret)


# Creating Confusion Matrix to check the accuracy
confusionMatrix(data=train$predict_rf,
                reference=train$target,
                positive='yes')

# From the confusion matrix generated, we can observe the overall statistics at a Class level
# The accuracy and other statistics are good which explains further why random forest is widely popular

