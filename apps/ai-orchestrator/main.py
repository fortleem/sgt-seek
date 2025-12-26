import os
from dotenv import load_dotenv

load_dotenv()

# SGT Blueprint Section 10: Hybrid AI Intelligence Layer
# SECURED: Token is now loaded from environment variables
HF_TOKEN = os.getenv("HF_TOKEN")

def run_ai_matching():
    if not HF_TOKEN:
        print("Error: HF_TOKEN not found in environment.")
        return
    print("AI Orchestrator Active: Matching Exporters to Trade Requests...")

if __name__ == "__main__":
    run_ai_matching()
