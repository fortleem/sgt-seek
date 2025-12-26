# SGT Blueprint Section 3.5.1: USTN Management
import uuid

def generate_ustn(country_code: str):
    """SGT-{CountryCode}-{Timestamp}-{Sequence}"""
    return f"SGT-{country_code.upper()}-{uuid.uuid4().hex[:8].upper()}"

def verify_qc_milestone(inspection_data: dict):
    # Rule: If inspection fails, block further execution legs
    if inspection_data.get("score") < 0.7:
        return {"status": "BLOCKED", "reason": "QC_FAILED"}
    return {"status": "PASSED"}
