import os
from minio import Minio
import pytesseract
from pdf2image import convert_from_path

# Configuration from .env (BP Section 6.2)
client = Minio(
    "localhost:9000",
    access_key="sgt_minio_admin",
    secret_key="sgt_minio_password",
    secure=False
)

def process_trade_document(bucket_name, object_name):
    # Download file from SGT MinIO
    local_path = f"/tmp/{object_name}"
    client.fget_object(bucket_name, object_name, local_path)
    
    # Convert PDF to Image for OCR
    images = convert_from_path(local_path)
    text = ""
    for img in images:
        text += pytesseract.image_to_string(img)
    
    # Extract "Total Amount" using basic NLP
    # Ref: Blueprint Section 15.4 (Heuristics)
    print(f"Extracted Text from {object_name}: {text[:100]}...")
    
    return {"status": "PROCESSED", "doc_type": "BILL_OF_LADING"}

if __name__ == "__main__":
    print("SGT Document Processor Standing By...")
