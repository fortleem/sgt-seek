import os
import time
import subprocess
import json

def run_step(name, command):
    print(f"--- Executing: {name} ---")
    result = subprocess.run(command, shell=True, capture_output=True, text=True)
    return result.stdout.strip()

def orchestrate():
    while True:
        # 1. AI Audit Step
        audit_res = run_step("AI Proforma Audit", f"python3 {ROOT}/apps/ai-orchestrator/doc_validator.py")
        
        # 2. Contract Generation
        contract_res = run_step("SPA Generation", f"python3 {ROOT}/scripts/generate_contract.py")
        
        # 3. Notification Step
        notify_cmd = f"python3 {ROOT}/scripts/notify_parties.py"
        run_step("Broadcast Notification", notify_cmd)
        
        print("✅ Cycle Complete. Sleeping for 300 seconds...")
        time.sleep(300)

if __name__ == "__main__":
    orchestrate()
