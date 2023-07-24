#------------------------------------------------
# Tree
#------------------------------------------------

library(rpart)
library(rpart.plot)

#set control
control <- rpart.control(minsplit = 10, #Minimum number of splits
                         maxdepth = 3,  #Maximum depth of the tree
                         minbucket = 100, #Minimum number of obs in each leaf   
                         cp = -1)         #Force every split

#fit the tree
rpartModel <- rpart(fatal_cnt ~ SEX +  AGE + HELMET_BELT_WORN + 
                      Weekday + hour, data = vicDataTrain, method = "class", 
                    control = control) 

#plot the tree
rpart.plot(rpartModel, type = 2, digits = 3)


#Predicted probabilities in train and test for tree
predTest$tree <- predict(rpartModel, newdata = vicDataTest, type = "prob")[,2]
predTrain$tree <- predict(rpartModel, type = "prob")[,2]


#--------------------------------------------
# Random Forest
#--------------------------------------------

library(randomForest)
set.seed(10)
RFModel <- randomForest(factor(fatal_cnt) ~ .,
                        data=vicDataTrain %>% 
                          select(-AGE_GROUP,  #Remove factor version of some variables
                                 -hour_fac,
                                 -month_fac,
                                 -year_fac), 
                        importance=TRUE, 
                        ntree=50,
                        xtest = vicDataTest %>% 
                          select(-AGE_GROUP,  #Remove factor version of some variables
                                 -hour_fac,
                                 -month_fac,
                                 -year_fac,
                                 -fatal_cnt), 
                        ytest = factor(vicDataTest$fatal_cnt))

#Plot out of bag error rate
plot(RFModel$err.rate[,1], xlab = "Trees", ylab = "OOB error rate")

# Plot the importantce of the variables
importanceRF <- importance(RFModel)

importanceRF <- as.data.frame(importanceRF) %>% 
  mutate(Variable = row.names(importanceRF), VI = MeanDecreaseGini/max(MeanDecreaseGini)*100)


impPlotRF <- ggplot(importanceRF, aes(x = reorder(Variable, VI), y = VI)) +
  geom_bar(stat = "identity") +
  coord_flip() + theme_bw() + theme(plot.title = element_text(hjust = 0.5)) +
  labs(x = NULL, y = "Variable Importance", title = "Random Forest")

print(impPlotRF)


#Predicted probabilities in train and test for RF
predTest$RF <- RFModel$test$votes[, 2]
predTrain$RF <- RFModel$votes[, 2]


#--------------------------------------------
# Boosting
#--------------------------------------------
library(gbm)
set.seed(10)
boostModel <- gbm(fatal_cnt ~ ., data=vicDataTrain %>% 
                    select(-AGE_GROUP,  #Remove factor version of some variables
                           -hour_fac,
                           -month_fac,
                           -year_fac),
                  n.trees = 1000 , interaction.depth = 1, shrinkage = 0.02)


#Plot add of the bag error. And get the best number of trees
bestIter <- gbm.perf(boostModel, method = "OOB")

#Variable importance plot
varImpBoost <- summary(boostModel)

importanceGBM <- data.frame(Variable = varImpBoost$var,
                            VI = varImpBoost$rel.inf/varImpBoost$rel.inf[1]*100)

impPlotGBM <- ggplot(importanceGBM, aes(x = reorder(Variable, VI), y = VI)) +
  geom_bar(stat = "identity") +
  coord_flip() + theme_bw() + theme(plot.title = element_text(hjust = 0.5)) +
  labs(x = NULL, y = "Variable Importance", title = "Boosting")

print(impPlotGBM)

#Predicted probabilities in train and test for GBM

predTest$Boost <- predict(boostModel, newdata = vicDataTest, n.trees = bestIter, 
                          type = "response")
predTrain$Boost <- predict(boostModel, newdata = vicDataTrain, n.trees = bestIter, 
                           type = "response")


