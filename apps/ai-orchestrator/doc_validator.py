import os

class AI_DocValidator:
    def validate_proforma(self, rfq_data, proforma_data):
        """
        SGT Blueprint 10.2: AI-Driven Discrepancy Detection.
        Validates Exporter Proforma against Importer Request.
        """
        discrepancies = []
        
        # Check Quantity
        if rfq_data.get('quantity') != proforma_data.get('quantity'):
            discrepancies.append(f"Quantity Mismatch: Expected {rfq_data.get('quantity')}, got {proforma_data.get('quantity')}")
            
        # Check Budget Compliance
        if proforma_data.get('unit_price', 0) > rfq_data.get('max_budget', 0):
            discrepancies.append(f"Price Discrepancy: {proforma_data.get('unit_price')} exceeds budget of {rfq_data.get('max_budget')}")

        return {
            "is_valid": len(discrepancies) == 0,
            "discrepancies": discrepancies,
            "status": "APPROVED" if len(discrepancies) == 0 else "REJECTED"
        }

if __name__ == "__main__":
    validator = AI_DocValidator()
    # Test Case: Price violation
    res = validator.validate_proforma({'quantity': 500, 'max_budget': 10.0}, {'quantity': 500, 'unit_price': 12.5})
    print(f"AI Audit Result: {res}")
