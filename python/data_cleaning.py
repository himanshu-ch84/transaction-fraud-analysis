import pandas as pd


cards = pd.read_csv('Data/cards_data.csv')
customers = pd.read_csv('Data/customer_data.csv')
merchants = pd.read_csv('Data/merchant_table.csv')
transactions = pd.read_csv('Data/transaction_data_250k.csv')

cards.info()
print(cards.isnull().sum())

customers.info()
print(customers.isnull().sum())

merchants.info()
print(merchants.isnull().sum())




transactions["Fraud_Reason"] = transactions["Fraud_Reason"].fillna("No Fraud")
print(transactions.isnull().sum())
transactions.info()
print(transactions["Transaction_ID"].duplicated().sum())
print(cards.duplicated().sum())
print(customers.duplicated().sum())
print(merchants.duplicated().sum())
for col in customers.select_dtypes(include="object").columns:
    customers[col] = customers[col].str.lower().str.strip()
for col in cards.select_dtypes(include="object").columns:
    cards[col] = cards[col].str.lower().str.strip()
for col in merchants.select_dtypes(include="object").columns:
    merchants[col] = merchants[col].str.lower().str.strip()
for col in transactions.select_dtypes(include="object").columns:
    transactions[col] = transactions[col].str.lower().str.strip()

transactions.columns = transactions.columns.str.lower()
cards.columns = cards.columns.str.lower()
merchants.columns = merchants.columns.str.lower()
customers.columns = customers.columns.str.lower()

# Check summary statistics
print(transactions.describe())
# Check for duplicate primary keys
print(customers["customer_id"].duplicated().sum())
print(cards["card_id"].duplicated().sum())
print(merchants["merchant_id"].duplicated().sum())
print(transactions["transaction_id"].duplicated().sum())

# Check data types
print(transactions.dtypes)

customers.to_csv("customers_clean.csv", index=False)
cards.to_csv("cards_clean.csv", index=False)
merchants.to_csv("merchants_clean.csv", index=False)
transactions.to_csv("transactions_clean.csv", index=False)