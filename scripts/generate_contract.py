import datetime
import os

def generate_spa(trade_id, buyer, seller, commodity, qty, price):
    contract_text = f"""
    =========================================
    SALE AND PURCHASE AGREEMENT (SPA)
    =========================================
    Date: {datetime.date.today()}
    Ref: {trade_id}
    
    1. THE PARTIES
       BUYER: {buyer}
       SELLER: {seller}
    
    2. PRODUCT SPECIFICATIONS
       COMMODITY: {commodity}
       QUANTITY: {qty} Metric Tons
       UNIT PRICE: ${price}
    
    3. TOTAL CONTRACT VALUE
       TOTAL: ${qty * price:,.2f}
       COMMISSION LOCK (7%): ${(qty * price) * 0.07:,.2f}
    
    4. TERMS
       Subject to QC Inspection and AI Document Validation.
    =========================================
    """
    return contract_text

if __name__ == "__main__":
    spa = generate_spa("T-DEC-2025-001", "Importer_Main", "Exporter_Alpha", "Yellow Corn Grade 2", 5000, 245.0)
    print(spa)
    with open("/Users/tonsy/Documents/sgt-seek/docs/SPA_T_DEC_2025_001.txt", "w") as f:
        f.write(spa)
