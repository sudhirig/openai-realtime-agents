#!/bin/bash

# Zerodha Voice Trading Agent - Replit Startup Script

echo "🚀 Starting Zerodha Voice Trading Agent on Replit..."

# Check if Node.js is available
if ! command -v node &> /dev/null; then
    echo "❌ Node.js not found. Please check Replit environment."
    exit 1
fi

# Check if npm is available
if ! command -v npm &> /dev/null; then
    echo "❌ npm not found. Please check Replit environment."
    exit 1
fi

echo "✅ Node.js $(node --version) detected"
echo "✅ npm $(npm --version) detected"

# Install dependencies if node_modules doesn't exist
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
    if [ $? -ne 0 ]; then
        echo "❌ Failed to install dependencies"
        exit 1
    fi
else
    echo "✅ Dependencies already installed"
fi

# Check for required environment variables
echo "🔍 Checking environment variables..."

required_vars=("OPENAI_API_KEY")
missing_vars=()

for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        missing_vars+=("$var")
    fi
done

if [ ${#missing_vars[@]} -ne 0 ]; then
    echo "❌ Missing required environment variables:"
    for var in "${missing_vars[@]}"; do
        echo "   - $var"
    done
    echo ""
    echo "Please set these in Replit Secrets:"
    echo "1. Go to Secrets tab in Replit"
    echo "2. Add each required variable"
    echo "3. Restart the application"
    exit 1
fi

echo "✅ All required environment variables found"

# Build the application
echo "🔨 Building application..."
npm run build
if [ $? -ne 0 ]; then
    echo "❌ Build failed"
    exit 1
fi

echo "✅ Build completed successfully"

# Start the application
echo "🎯 Starting Zerodha Voice Trading Agent..."
echo "🌐 Application will be available at your Replit URL"
echo "🎙️ Voice trading capabilities enabled"
echo "📱 Vernacular language support: Hindi, Tamil, Telugu, Bengali"
echo ""

# Start the Next.js application
npm run start
