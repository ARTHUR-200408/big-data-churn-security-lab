import csv
from pymongo import MongoClient

db = MongoClient(__import__("os").environ["MONGO_URI"])["telco"]
scores = {r["customerID"]: float(r["churn_risk"])
          for r in csv.DictReader(open("/home/kali/lab/data/scores.csv"))}
svc = ["PhoneService", "MultipleLines", "InternetService", "OnlineSecurity",
       "OnlineBackup", "DeviceProtection", "TechSupport", "StreamingTV", "StreamingMovies"]
docs = []
for r in csv.DictReader(open("/home/kali/lab/data/telco.csv")):
    tc = r["TotalCharges"].strip()
    docs.append({
        "_id": r["customerID"],
        "demographics": {"gender": r["gender"], "senior": r["SeniorCitizen"] == "1",
                         "partner": r["Partner"] == "Yes", "dependents": r["Dependents"] == "Yes"},
        "account": {"tenure": int(r["tenure"]), "contract": r["Contract"],
                    "paperless": r["PaperlessBilling"] == "Yes",
                    "payment_method": r["PaymentMethod"],
                    "monthly_charges": float(r["MonthlyCharges"]),
                    "total_charges": float(tc) if tc else 0.0},
        "services": {k: r[k] for k in svc},
        "churned": r["Churn"] == "Yes",
        "churn_risk": scores[r["customerID"]],
    })
db.customers.drop()
db.customers.insert_many(docs)
db.customers.create_index("churn_risk")
db.customers.aggregate([
    {"$group": {"_id": "$account.contract", "customers": {"$sum": 1},
                "churned": {"$sum": {"$cond": ["$churned", 1, 0]}}}},
    {"$project": {"customers": 1, "churned": 1,
                  "churn_pct": {"$round": [{"$multiply": [{"$divide": ["$churned", "$customers"]}, 100]}, 1]}}},
    {"$out": "churn_by_contract"}])
print("customers:", db.customers.count_documents({}))
for x in db.churn_by_contract.find():
    print(x)
