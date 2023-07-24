#--------------------------------------------
# Model evaluation
#--------------------------------------------
library(pROC)


ROC_test_glm <- roc(vicDataTest$fatal_cnt, predTest$glm)
ROC_test_lasso <- roc(vicDataTest$fatal_cnt, predTest$lasso)
ROC_test_tree <- roc(vicDataTest$fatal_cnt, predTest$tree)
ROC_test_RF <- roc(vicDataTest$fatal_cnt, predTest$RF)
ROC_test_Boost <- roc(vicDataTest$fatal_cnt, predTest$Boost)

ROC_train_glm <- roc(vicDataTrain$fatal_cnt, predTrain$glm)
ROC_train_lasso <- roc(vicDataTrain$fatal_cnt, predTrain$lasso)
ROC_train_tree <- roc(vicDataTrain$fatal_cnt, predTrain$tree)
ROC_train_RF <- roc(vicDataTrain$fatal_cnt, predTrain$RF)
ROC_Train_Boost <- roc(vicDataTrain$fatal_cnt, predTrain$Boost)


#ROC Curve on testing
get_TP_FP <- function(ROC, method) {
  tibble(TP = ROC[["sensitivities"]], 
         FP = 1.0- ROC[["specificities"]],
         method = method) %>% arrange(FP, TP)
}


ROCdata <- bind_rows(get_TP_FP(ROC_test_glm, "glm"),
                     get_TP_FP(ROC_test_lasso, "lasso"),
                     get_TP_FP(ROC_test_tree, "tree"),
                     get_TP_FP(ROC_test_RF, "RF"),
                     get_TP_FP(ROC_test_Boost, "Boosting"))



ROCplotAll <- ggplot(ROCdata) + geom_line(aes(x = FP, y = TP, 
                                              group = method, colour = method),
                                          linewidth = 1.0) +
  geom_abline(slope = 1, intercept = 0, linetype = "dotted") +
  theme_bw()  + 
  theme(legend.key.size = unit(1, "cm")) +
  labs(x = "False postive rate", y = "True positive rate", title = "ROC Curve")

print(ROCplotAll)

#Get AUC table
get_AUC <- function(ROC_train, ROC_test, method) {
  tibble(method = method, 
         train_AUC = as.numeric(ROC_train$auc),
         test_AUC = as.numeric(ROC_test$auc))
}

AUC_Table <- bind_rows(get_AUC(ROC_train_glm, ROC_test_glm, "glm"),
                       get_AUC(ROC_train_lasso, ROC_test_lasso, "lasso"),
                       get_AUC(ROC_train_tree, ROC_test_tree, "tree"),
                       get_AUC(ROC_train_RF, ROC_test_RF, "RF"),
                       get_AUC(ROC_Train_Boost, ROC_test_Boost, "Boosting"))

AUC_Table
