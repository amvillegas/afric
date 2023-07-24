#--------------------------------------------------------------
# GLM
#--------------------------------------------------------------

#Simple glm using only few variables

glmSimple <- glm(fatal_cnt ~ SEX +  AGE_GROUP + HELMET_BELT_WORN + 
                   Weekday + hour_fac, family = binomial(),
                 data = vicDataTrain)

summary(glmSimple)

#plot coef by hour

coef_glm <- glmSimple$coefficients 

hour_coef <- c(0, coef_glm[grep("^hour_fac", names(coef_glm))])

plot(x = 0:23, y = hour_coef, type = "l", xlab = "hour", 
     ylab = "coefficient", main = "Hour coefficients from GLM") 

#Predicted probabilities in train and test for glm
predTest <- data.frame(glm = predict(glmSimple, newdata = vicDataTest, 
                                     type = "response"))
predTrain <- data.frame(glm = fitted(glmSimple, type = "response"))

#--------------------------------------------------------------
# Regularised GLM (Lasso) 
#--------------------------------------------------------------

library(glmnet)
#Get design Matrix
X <- model.matrix(fatal_cnt ~ ., data = vicDataTrain)[,-1] 
Y <- vicDataTrain$fatal_cnt
lasso <- glmnet(x = X, y = Y, alpha = 1, family = "binomial")

#Plot regularisation path
plot(lasso, xvar = "lambda")  

#Cross-validation to select lambda
set.seed(2)
cv.lasso <- cv.glmnet(x = X, y = Y, family = "binomial",
                      alpha = 1, nfolds = 10, type.measure = "auc")

#Find index of lambda with the best CV error
index_cv_lamblda <- which(lasso$lambda==cv.lasso$lambda.1se)

abline(v = log(lasso$lambda[index_cv_lamblda])) 

#Predicted probabilities in train and test for lasso at best lambda
newX <- model.matrix(fatal_cnt ~ ., data = vicDataTest)[,-1]
predTest$lasso <- predict(lasso, newx =  newX, type = "response")[, index_cv_lamblda]
predTrain$lasso <- predict(lasso, newx =  X, type = "response")[, index_cv_lamblda]



#Optional - Do nice plot of solution path and cross-validation solution

#Function to get data frame with solution path
getSolutionPath <- function(regSol){
  extractSol <- function(regSol, i) tibble(variable = names(regSol$beta[,i]), 
                                           beta = regSol$beta[,i], 
                                           alpha = regSol$lambda[i])
  
  map_df(seq(1,length(regSol$lambda)), function(i) extractSol(regSol, i))
}

lassoDF <- getSolutionPath(lasso)


var_in_cv <- lassoDF %>% filter(alpha == cv.lasso$lambda.1se, beta != 0) %>% 
  select(variable)
var_in_cv <- var_in_cv$variable

lassoPlot1 <- ggplot(lassoDF, aes(x = log(alpha), y = beta, group = variable)) + 
  labs(x = "log(lambda)", y = "Coefficients", title = "Lasso") +
  geom_line() +
  geom_text(data = filter(lassoDF, alpha == last(lassoDF$alpha), 
                          variable %in% var_in_cv),
            aes(x = log(alpha), y = beta, label = variable), hjust = 1) +
  xlim(-18, -4) +
  theme_bw() +
  theme(legend.position = "none") +
  theme(plot.title = element_text(hjust = 0.5)) + 
  scale_colour_manual(values = c("gray50", "black"))
NULL  

lassoPlotCV <- lassoPlot1  + geom_vline(xintercept = log(cv.lasso$lambda.1se), linetype = "dashed") +
  annotate(x = log(cv.lasso$lambda.1se), y = max(lassoDF$beta)*0.98, geom = "label", 
           label = "Cross-Validation Solution", hjust = 0)


print(lassoPlotCV)
