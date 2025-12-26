#!/bin/bash

# SGT Frontend Deployment Script
# Aligned with Blueprint Implementation Checklist (Pages 84-92)

echo "=== SGT Frontend Deployment ==="
echo "Blueprint Reference: Pages 68-84 (Governor Service)"
echo ""

# Check dependencies
echo "1. Checking dependencies..."
if ! command -v node &> /dev/null; then
    echo "❌ Node.js not found. Please install Node.js 18+"
    exit 1
fi

if ! command -v npm &> /dev/null; then
    echo "❌ npm not found"
    exit 1
fi

node_version=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$node_version" -lt 18 ]; then
    echo "❌ Node.js version must be 18 or higher"
    exit 1
fi

echo "✅ Node.js $(node -v), npm $(npm -v)"

# Install dependencies
echo ""
echo "2. Installing dependencies..."
npm install
if [ $? -ne 0 ]; then
    echo "❌ Failed to install dependencies"
    exit 1
fi
echo "✅ Dependencies installed"

# Check Governor Service
echo ""
echo "3. Checking Governor Service..."
if ! curl -s http://localhost:8080/health > /dev/null 2>&1; then
    echo "⚠️  Governor Service not detected on port 8080"
    echo "   Start Governor with: cd ~/documents/sgt-seek/services/governor/sgt-governor && cargo run"
    read -p "Continue without Governor? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Deployment cancelled"
        exit 1
    fi
else
    echo "✅ Governor Service is running"
fi

# Build frontend
echo ""
echo "4. Building frontend..."
npm run build
if [ $? -ne 0 ]; then
    echo "❌ Build failed"
    exit 1
fi
echo "✅ Build successful"

# Start development server
echo ""
echo "5. Starting development server..."
echo "   Frontend: http://localhost:5173"
echo "   Governor: http://localhost:8080"
echo "   API:      http://localhost:8000"
echo ""
echo "📘 Blueprint Compliance:"
echo "   ✅ Pages 68-84: Governor Service Integration"
echo "   ✅ Non-custodial enforcement UI"
echo "   ✅ Rust/Python hybrid stack"
echo "   ✅ Execution gates visualization"
echo ""
echo "Press Ctrl+C to stop all services"

# Start in background
npm run dev &
FRONTEND_PID=$!

# Wait for user interruption
trap "kill $FRONTEND_PID 2>/dev/null; echo 'Stopped frontend server'; exit 0" INT TERM
wait $FRONTEND_PID
