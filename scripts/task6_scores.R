d <- read.csv("~/lab/data/telco.csv", stringsAsFactors = FALSE)
ids <- d$customerID
d$TotalCharges <- suppressWarnings(as.numeric(d$TotalCharges))
d$TotalCharges[is.na(d$TotalCharges)] <- 0
d$customerID <- NULL
d$SeniorCitizen <- as.character(d$SeniorCitizen)
chars <- sapply(d, is.character)
d[chars] <- lapply(d[chars], factor)
d$Churn <- factor(d$Churn, levels = c("No", "Yes"))
library(randomForest)
set.seed(42)
rf <- randomForest(Churn ~ ., data = d, ntree = 200)
out <- data.frame(customerID = ids, churn_risk = round(rf$votes[, "Yes"], 3))
write.csv(out, "~/lab/data/scores.csv", row.names = FALSE)
cat("Wrote", nrow(out), "scores\n")
