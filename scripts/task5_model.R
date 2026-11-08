d <- read.csv("~/lab/data/telco.csv", stringsAsFactors = FALSE)
cat("Rows:", nrow(d), " Columns:", ncol(d), "\n")

# Data preparation
d$TotalCharges <- suppressWarnings(as.numeric(d$TotalCharges))
cat("Blank TotalCharges set to 0:", sum(is.na(d$TotalCharges)), "\n")
d$TotalCharges[is.na(d$TotalCharges)] <- 0
d$customerID <- NULL
d$SeniorCitizen <- as.character(d$SeniorCitizen)
chars <- sapply(d, is.character)
d[chars] <- lapply(d[chars], factor)
d$Churn <- factor(d$Churn, levels = c("No", "Yes"))

# 80/20 train-test split
set.seed(42)
idx <- sample(nrow(d), 0.8 * nrow(d))
train <- d[idx, ]
test <- d[-idx, ]
cat("Train:", nrow(train), " Test:", nrow(test), "\n")

# Model
library(randomForest)
rf <- randomForest(Churn ~ ., data = train, ntree = 200)
pred <- predict(rf, test)

# Evaluation
cm <- table(Actual = test$Churn, Predicted = pred)
print(cm)
acc <- sum(diag(cm)) / sum(cm)
prec <- cm["Yes", "Yes"] / sum(cm[, "Yes"])
rec <- cm["Yes", "Yes"] / sum(cm["Yes", ])
f1 <- 2 * prec * rec / (prec + rec)
cat(sprintf("Accuracy: %.3f\nPrecision: %.3f\nRecall: %.3f\nF1: %.3f\n", acc, prec, rec, f1))

saveRDS(list(test = test, pred = pred, imp = importance(rf)), "~/lab/model_results.rds")
cat("Saved ~/lab/model_results.rds\n")
