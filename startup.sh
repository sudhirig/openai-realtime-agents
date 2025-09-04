#!/bin/bash

# OpenAI Realtime Agents - Enhanced Replit Startup Script

set -e

echo "🚀 Starting OpenAI Realtime Agents..."

# Environment Check
echo "📋 System Check..."
node --version
npm --version

# Critical Environment Variable Check
echo "🔐 Environment Variables..."
if [ -z "$OPENAI_API_KEY" ]; then
  echo "❌ CRITICAL: OPENAI_API_KEY not set!"
  echo "   🔧 Add to Replit Secrets: OPENAI_API_KEY"
  echo "   🚫 Cannot start without API key"
  exit 1
else
  echo "✅ OPENAI_API_KEY configured"
fi

# Handle fresh installation
if [ "$1" = "--fresh" ]; then
  echo "🧹 Fresh installation..."
  rm -rf .next node_modules package-lock.json
fi

# Install dependencies
if [ ! -d "node_modules" ] || [ "$1" = "--fresh" ]; then
  echo "📦 Installing dependencies..."
  npm install --prefer-offline --no-audit
else
  echo "✅ Dependencies ready"
fi

# Build application
echo "🔨 Building..."
if ! npm run build; then
  echo "❌ Build failed, trying fresh install..."
  npm run fresh-install
  npm run build
fi

# Health check function
health_check() {
  echo "🏥 Health check..."
  sleep 2
  if curl -s http://localhost:3000/api/health > /dev/null 2>&1; then
    echo "✅ Health check passed"
    return 0
  else
    echo "❌ Health check failed"
    return 1
  fi
}

# Start server
echo "🎯 Starting server..."
npm run start &
SERVER_PID=$!

# Verify startup
if health_check; then
  echo "🎉 SUCCESS!"
  echo "🌐 App URL: https://$REPL_SLUG.$REPL_OWNER.repl.co"
  echo "🎤 Voice AI ready!"
  wait $SERVER_PID
else
  echo "🚨 Startup failed"
  kill $SERVER_PID 2>/dev/null || true
  exit 1
fi
