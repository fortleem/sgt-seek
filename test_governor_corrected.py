#!/usr/bin/env python3
"""
Corrected Governor Service integration test
Based on actual API requirements
"""
import asyncio
import httpx
import json
import sys

async def test_governor_corrected():
    """Test with correct API format"""
    print("Testing Governor Service with corrected format...")
    
    # Test 1: Health endpoint (should still work)
    try:
        async with httpx.AsyncClient(timeout=10.0) as client:
            response = await client.get("http://localhost:8081/health")
            if response.status_code == 200 and "Governor OK" in response.text:
                print("✅ Health check passed")
            else:
                print(f"❌ Health check failed: {response.status_code} - {response.text}")
                return False
    except Exception as e:
        print(f"❌ Health check error: {e}")
        return False
    
    # Test 2: Try different request formats based on common patterns
    test_formats = [
        # Format 1: Based on error message (decision_type)
        {
            "decision_type": "SETTLEMENT_ELIGIBILITY",
            "context": {
                "ustn": "TEST-001",
                "risk_score": 0.1
            }
        },
        # Format 2: Based on Python client (gate_type)
        {
            "gate_type": "SHIPMENT_MILESTONE", 
            "context": {
                "ustn": "TEST-001",
                "milestone": "TEST_MILESTONE",
                "risk_score": 0.1,
                "commission_lock": False
            }
        },
        # Format 3: Minimal test
        {
            "decision_type": "TEST",
            "context": {}
        }
    ]
    
    for i, test_data in enumerate(test_formats, 1):
        print(f"\nTrying format {i}: {json.dumps(test_data, indent=2)}")
        try:
            async with httpx.AsyncClient(timeout=10.0) as client:
                response = await client.post(
                    "http://localhost:8081/v1/decide",
                    json=test_data,
                    timeout=10.0
                )
                
                print(f"  Status: {response.status_code}")
                if response.status_code == 200:
                    result = response.json()
                    print(f"  ✅ Success! Response:")
                    print(f"     Decision ID: {result.get('decision_id', 'N/A')}")
                    print(f"     Result: {result.get('result', 'N/A')}")
                    print(f"     Reason: {result.get('reason', 'N/A')}")
                    return True
                else:
                    print(f"  ❌ Failed: {response.text}")
        except Exception as e:
            print(f"  ❌ Error: {e}")
    
    # If none worked, check the check_gates endpoint
    print("\nTrying check_gates endpoint...")
    try:
        async with httpx.AsyncClient(timeout=10.0) as client:
            test_data = {
                "gate_type": "SHIPMENT_MILESTONE",
                "context": {
                    "ustn": "TEST-001",
                    "milestone": "TEST_MILESTONE"
                }
            }
            response = await client.post(
                "http://localhost:8081/v1/gates/check",
                json=test_data,
                timeout=10.0
            )
            
            print(f"  Status: {response.status_code}")
            if response.status_code == 200:
                result = response.json()
                print(f"  ✅ check_gates endpoint worked!")
                print(f"     Response: {json.dumps(result, indent=2)}")
                return True
            else:
                print(f"  ❌ check_gates failed: {response.text}")
    except Exception as e:
        print(f"  ❌ check_gates error: {e}")
    
    return False

if __name__ == "__main__":
    # Check if governor service is running
    import socket
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(2)
        result = sock.connect_ex(('localhost', 8081))
        sock.close()
        
        if result == 0:
            print("✅ Governor Service is reachable on port 8081")
            success = asyncio.run(test_governor_corrected())
            if success:
                print("\n✅ Python integration test PASSED")
                sys.exit(0)
            else:
                print("\n❌ Python integration test FAILED - API format mismatch")
                print("\nRecommendations:")
                print("1. Check Rust API implementation in services/governor/sgt-governor/src/api/v1.rs")
                print("2. Update Python client in apps/backend/governor_client.py")
                print("3. Check blueprint pages 80-84 for correct API specification")
                sys.exit(1)
        else:
            print("❌ Governor Service not reachable on port 8081")
            sys.exit(1)
    except Exception as e:
        print(f"❌ Connection test error: {e}")
        sys.exit(1)
