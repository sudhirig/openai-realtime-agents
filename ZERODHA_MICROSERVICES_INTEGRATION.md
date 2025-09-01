# 🚀 Zerodha Voice Trading Agent - Direct Integration

**Complete integration guide for deploying OpenAI Realtime voice agent directly into Zerodha trading platform via GitHub clone on Replit**

## Architecture Overview

**Direct Integration Approach**
- Single Repository: Complete voice trading agent
- Replit Deployment: One-click GitHub clone
- Zerodha Integration: Direct component import or API calls

```
┌─────────────────────────────────────────────────────────────┐
│                 ZERODHA VOICE AGENT                         │
│            (voice-agent.replit.app)                        │
│  ✅ Complete Voice Trading ✅ OpenAI Realtime ✅ Ready      │
│                                                             │
│  Integration Options:                                       │
│  ├── Direct Component Import                               │
│  ├── API Endpoint Calls                                    │
│  ├── Embedded iframe                                       │
│  └── WebSocket Connection                                   │
└─────────────────────────────────────────────────────────────┘
```

## 🔧 Implementation

### Step 1: Add API Endpoint to Each Microservice

**In each of your 5 Replit apps, add this API route:**

```javascript
// src/app/api/process/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { validateToken } from '@/lib/auth';

export async function POST(request: NextRequest) {
  try {
    const { message, userId, context, token, action } = await request.json();
    
    // Validate authentication token
    const user = await validateToken(token);
    if (!user || user.id !== userId) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }
    
    // Process request based on service type
    let result;
    switch (action) {
      case 'voice_chat':
        result = await processVoiceMessage(message, context);
        break;
      case 'get_analytics':
        result = await getAnalyticsData(userId, context);
        break;
      case 'get_signals':
        result = await getTradingSignals(userId, context);
        break;
      case 'get_portfolio':
        result = await getPortfolioInsights(userId, context);
        break;
      case 'assess_risk':
        result = await assessRisk(userId, context);
        break;
      default:
        result = await processGenericRequest(message, context);
    }
    
    return NextResponse.json({
      success: true,
      response: result.response,
      actions: result.actions || [],
      data: result.data || {},
      timestamp: new Date().toISOString()
    });
    
  } catch (error) {
    console.error('API Error:', error);
    return NextResponse.json(
      { error: 'Internal server error' }, 
      { status: 500 }
    );
  }
}

// Example implementation for voice chat service
async function processVoiceMessage(message: string, context: any) {
  // OpenAI integration
  const completion = await openai.chat.completions.create({
    model: "gpt-4",
    messages: [
      {
        role: "system",
        content: `You are ARIA, a professional trading assistant for Indian markets. 
        User's portfolio: ${JSON.stringify(context.portfolio)}
        Current positions: ${JSON.stringify(context.positions)}
        Respond in Hindi/English mix as appropriate.`
      },
      { role: "user", content: message }
    ],
    tools: [
      {
        type: "function",
        function: {
          name: "place_order",
          description: "Place a trading order",
          parameters: {
            type: "object",
            properties: {
              symbol: { type: "string" },
              quantity: { type: "number" },
              action: { type: "string", enum: ["BUY", "SELL"] }
            }
          }
        }
      }
    ]
  });
  
  return {
    response: completion.choices[0].message.content,
    actions: completion.choices[0].message.tool_calls || []
  };
}

// Token validation utility
async function validateToken(token: string) {
  try {
    // Validate JWT token with your existing auth system
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    return decoded;
  } catch (error) {
    return null;
  }
}
```

### Step 2: Add Service Client to Main Zerodha App

```javascript
// utils/microserviceClient.ts
interface ServiceResponse {
  success: boolean;
  response: string;
  actions: any[];
  data: any;
  timestamp: string;
}

interface ServiceRequest {
  message?: string;
  userId: string;
  context: {
    portfolio: any;
    positions: any;
    watchlist: any;
  };
  action: string;
  token: string;
}

class MicroserviceClient {
  private services = {
    voice: 'https://voice-chat.replit.app/api/process',
    analytics: 'https://analytics.replit.app/api/process',
    signals: 'https://signals.replit.app/api/process',
    portfolio: 'https://portfolio.replit.app/api/process',
    risk: 'https://risk.replit.app/api/process'
  };
  
  async callService(
    serviceName: keyof typeof this.services, 
    request: ServiceRequest
  ): Promise<ServiceResponse> {
    try {
      const response = await fetch(this.services[serviceName], {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'Zerodha-Main-App/1.0'
        },
        body: JSON.stringify(request)
      });
      
      if (!response.ok) {
        throw new Error(`Service ${serviceName} returned ${response.status}`);
      }
      
      return await response.json();
    } catch (error) {
      console.error(`Error calling ${serviceName} service:`, error);
      return {
        success: false,
        response: `Sorry, ${serviceName} service is temporarily unavailable.`,
        actions: [],
        data: {},
        timestamp: new Date().toISOString()
      };
    }
  }
  
  // Convenience methods for each service
  async voiceChat(message: string, userId: string, context: any, token: string) {
    return this.callService('voice', {
      message,
      userId,
      context,
      action: 'voice_chat',
      token
    });
  }
  
  async getAnalytics(userId: string, context: any, token: string) {
    return this.callService('analytics', {
      userId,
      context,
      action: 'get_analytics',
      token
    });
  }
  
  async getTradingSignals(userId: string, context: any, token: string) {
    return this.callService('signals', {
      userId,
      context,
      action: 'get_signals',
      token
    });
  }
}

export const microserviceClient = new MicroserviceClient();
```

### Step 3: Update ARIA Chat Component

```javascript
// components/ARIAChat.tsx
import React, { useState, useEffect } from 'react';
import { microserviceClient } from '@/utils/microserviceClient';
import { useAuth } from '@/hooks/useAuth';
import { usePortfolio } from '@/hooks/usePortfolio';

interface Message {
  id: string;
  role: 'user' | 'assistant';
  content: string;
  timestamp: Date;
  actions?: any[];
}

export const ARIAChat: React.FC = () => {
  const [messages, setMessages] = useState<Message[]>([]);
  const [inputMessage, setInputMessage] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [isListening, setIsListening] = useState(false);
  
  const { user, token } = useAuth();
  const { portfolioData, positionsData, watchlistData } = usePortfolio();
  
  const addMessage = (message: Omit<Message, 'id'>) => {
    setMessages(prev => [...prev, {
      ...message,
      id: Date.now().toString()
    }]);
  };
  
  const handleSendMessage = async (message: string) => {
    if (!message.trim() || !user || !token) return;
    
    // Add user message
    addMessage({
      role: 'user',
      content: message,
      timestamp: new Date()
    });
    
    setIsLoading(true);
    
    try {
      // Call voice service
      const response = await microserviceClient.voiceChat(
        message,
        user.id,
        {
          portfolio: portfolioData,
          positions: positionsData,
          watchlist: watchlistData
        },
        token
      );
      
      // Add AI response
      addMessage({
        role: 'assistant',
        content: response.response,
        timestamp: new Date(),
        actions: response.actions
      });
      
      // Execute any trading actions
      if (response.actions && response.actions.length > 0) {
        await executeTradingActions(response.actions);
      }
      
    } catch (error) {
      addMessage({
        role: 'assistant',
        content: 'Sorry, I encountered an error. Please try again.',
        timestamp: new Date()
      });
    } finally {
      setIsLoading(false);
      setInputMessage('');
    }
  };
  
  const executeTradingActions = async (actions: any[]) => {
    for (const action of actions) {
      if (action.function?.name === 'place_order') {
        const params = JSON.parse(action.function.arguments);
        // Show confirmation dialog
        const confirmed = await showOrderConfirmation(params);
        if (confirmed) {
          await placeOrder(params);
        }
      }
    }
  };
  
  const startVoiceRecording = async () => {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
      setIsListening(true);
      
      // Implement voice recording logic
      // This would integrate with the OpenAI Realtime API
      
    } catch (error) {
      console.error('Voice recording error:', error);
    }
  };
  
  return (
    <div className="aria-chat-container">
      <div className="chat-header">
        <h3>🎙️ ARIA - Your Trading Assistant</h3>
        <div className="language-selector">
          <button>🇮🇳 हिंदी</button>
          <button>🇬🇧 English</button>
        </div>
      </div>
      
      <div className="messages-container">
        {messages.map((message) => (
          <div key={message.id} className={`message ${message.role}`}>
            <div className="message-content">{message.content}</div>
            <div className="message-time">
              {message.timestamp.toLocaleTimeString()}
            </div>
            {message.actions && message.actions.length > 0 && (
              <div className="message-actions">
                <small>🔄 {message.actions.length} action(s) suggested</small>
              </div>
            )}
          </div>
        ))}
        {isLoading && (
          <div className="message assistant loading">
            <div className="typing-indicator">ARIA is thinking...</div>
          </div>
        )}
      </div>
      
      <div className="chat-input">
        <div className="input-group">
          <input
            type="text"
            value={inputMessage}
            onChange={(e) => setInputMessage(e.target.value)}
            onKeyPress={(e) => e.key === 'Enter' && handleSendMessage(inputMessage)}
            placeholder="Ask ARIA about your portfolio, place orders, or get market insights..."
            disabled={isLoading}
          />
          <button
            onClick={() => handleSendMessage(inputMessage)}
            disabled={isLoading || !inputMessage.trim()}
            className="send-button"
          >
            Send
          </button>
          <button
            onClick={startVoiceRecording}
            className={`voice-button ${isListening ? 'listening' : ''}`}
            disabled={isLoading}
          >
            🎙️
          </button>
        </div>
        
        <div className="quick-actions">
          <button onClick={() => handleSendMessage("मेरा पोर्टफोलियो दिखाओ")}>
            📊 Portfolio
          </button>
          <button onClick={() => handleSendMessage("आज के signals क्या हैं?")}>
            📈 Signals
          </button>
          <button onClick={() => handleSendMessage("Risk analysis करो")}>
            ⚠️ Risk Check
          </button>
        </div>
      </div>
    </div>
  );
};
```

### Step 4: Environment Configuration

```bash
# .env (in each microservice)
OPENAI_API_KEY=sk-your-openai-key
JWT_SECRET=your-jwt-secret-key
SERVICE_NAME=voice-chat # or analytics, signals, etc.
MAIN_APP_URL=https://zerodha-main.replit.app
CORS_ORIGINS=https://zerodha-main.replit.app

# .env (in main Zerodha app)
VOICE_SERVICE_URL=https://voice-chat.replit.app
ANALYTICS_SERVICE_URL=https://analytics.replit.app
SIGNALS_SERVICE_URL=https://signals.replit.app
PORTFOLIO_SERVICE_URL=https://portfolio.replit.app
RISK_SERVICE_URL=https://risk.replit.app
```

### Step 5: Security Enhancements

```javascript
// middleware/apiSecurity.ts
import rateLimit from 'express-rate-limit';
import helmet from 'helmet';

// Rate limiting
export const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per windowMs
  message: 'Too many requests from this IP'
});

// CORS configuration
export const corsOptions = {
  origin: process.env.CORS_ORIGINS?.split(',') || ['http://localhost:3000'],
  credentials: true,
  optionsSuccessStatus: 200
};

// Request validation
export const validateRequest = (req: any, res: any, next: any) => {
  const { userId, token } = req.body;
  
  if (!userId || !token) {
    return res.status(400).json({ error: 'Missing required fields' });
  }
  
  next();
};
```

## 🚀 Deployment Instructions

### For Each Microservice (5 Replit Apps)

1. **Update .replit configuration:**
```toml
run = "npm run dev"
entrypoint = "src/app/api/process/route.ts"

[deployment]
run = ["npm", "run", "start"]
build = ["npm", "run", "build"]

[env]
NODE_ENV = "production"
```

2. **Add to package.json:**
```json
{
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "replit:setup": "npm install && npm run build"
  },
  "dependencies": {
    "@openai/agents": "^0.0.5",
    "jsonwebtoken": "^9.0.2",
    "next": "^15.3.1",
    "openai": "^4.77.3"
  }
}
```

3. **Deploy each service:**
   - Click Deploy in Replit
   - Choose Autoscale Deployment
   - Set environment variables in Secrets

### For Main Zerodha App

1. **Install microservice client:**
```bash
npm install axios jsonwebtoken
```

2. **Import ARIA component:**
```javascript
// In your main dashboard
import { ARIAChat } from '@/components/ARIAChat';

// Add to your dashboard
<div className="aria-section">
  <ARIAChat />
</div>
```

## 🔍 Testing

```javascript
// Test API endpoints
const testVoiceService = async () => {
  const response = await fetch('https://voice-chat.replit.app/api/process', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      message: "मेरा पोर्टफोलियो दिखाओ",
      userId: "test-user",
      context: { portfolio: { value: 100000 } },
      action: "voice_chat",
      token: "test-token"
    })
  });
  
  console.log(await response.json());
};
```

## 📊 Monitoring & Maintenance

```javascript
// Add to each microservice
const logRequest = (req: any) => {
  console.log({
    timestamp: new Date().toISOString(),
    service: process.env.SERVICE_NAME,
    userId: req.body.userId,
    action: req.body.action,
    responseTime: Date.now() - req.startTime
  });
};
```

## 🖥️ Frontend Inheritance Options

### Option 1: Hybrid API + Frontend Calls

```javascript
// In main Zerodha app - Enhanced microservice client
class HybridMicroserviceClient {
  async callServiceWithUI(serviceName: string, request: any, showUI: boolean = false) {
    if (showUI) {
      // Load frontend component from microservice
      return this.loadFrontendComponent(serviceName, request);
    } else {
      // Standard API call
      return this.callService(serviceName, request);
    }
  }
  
  async loadFrontendComponent(serviceName: string, context: any) {
    const serviceUrls = {
      voice: 'https://voice-chat.replit.app',
      analytics: 'https://analytics.replit.app/dashboard',
      signals: 'https://signals.replit.app/widget',
      portfolio: 'https://portfolio.replit.app/insights'
    };
    
    // Return iframe URL with context
    return {
      type: 'frontend',
      url: `${serviceUrls[serviceName]}?${new URLSearchParams({
        userId: context.userId,
        token: context.token,
        theme: 'zerodha-dark',
        embedded: 'true'
      })}`
    };
  }
}
```

### Option 2: Dynamic Component Loading

```javascript
// Smart component that decides API vs Frontend
const SmartARIAComponent = () => {
  const [displayMode, setDisplayMode] = useState<'chat' | 'dashboard' | 'widget'>('chat');
  
  const handleRequest = async (message: string, requestType: string) => {
    switch (requestType) {
      case 'simple_query':
        // Use API for simple responses
        const apiResponse = await microserviceClient.voiceChat(message, user.id, context, token);
        setMessages(prev => [...prev, { role: 'assistant', content: apiResponse.response }]);
        break;
        
      case 'show_analytics':
        // Load frontend component for complex UI
        setDisplayMode('dashboard');
        break;
        
      case 'show_signals_widget':
        // Load widget view
        setDisplayMode('widget');
        break;
    }
  };
  
  return (
    <div className="smart-aria-container">
      {displayMode === 'chat' && (
        <ARIAChatInterface onRequest={handleRequest} />
      )}
      
      {displayMode === 'dashboard' && (
        <iframe 
          src={`https://analytics.replit.app/dashboard?userId=${user.id}&token=${token}`}
          width="100%" 
          height="600px"
          style={{ border: 'none', borderRadius: '8px' }}
        />
      )}
      
      {displayMode === 'widget' && (
        <iframe 
          src={`https://signals.replit.app/widget?userId=${user.id}&token=${token}`}
          width="100%" 
          height="400px"
        />
      )}
      
      <div className="mode-switcher">
        <button onClick={() => setDisplayMode('chat')}>💬 Chat</button>
        <button onClick={() => setDisplayMode('dashboard')}>📊 Dashboard</button>
        <button onClick={() => setDisplayMode('widget')}>📈 Signals</button>
      </div>
    </div>
  );
};
```

### Option 3: Conditional Frontend Inheritance

```javascript
// Enhanced ARIA that can switch between API and Frontend modes
const EnhancedARIAChat = () => {
  const [viewMode, setViewMode] = useState<'api' | 'frontend'>('api');
  const [activeService, setActiveService] = useState<string>('voice');
  
  const intelligentResponse = async (userMessage: string) => {
    // Analyze message to determine if frontend is needed
    const needsFrontend = analyzeMessageComplexity(userMessage);
    
    if (needsFrontend.requiresUI) {
      // Switch to frontend mode for complex interactions
      setViewMode('frontend');
      setActiveService(needsFrontend.service);
      
      return {
        response: `Opening ${needsFrontend.service} interface for better visualization...`,
        showFrontend: true,
        service: needsFrontend.service
      };
    } else {
      // Use API for simple responses
      return await microserviceClient.voiceChat(userMessage, user.id, context, token);
    }
  };
  
  const analyzeMessageComplexity = (message: string) => {
    const patterns = {
      'analytics': /show.*chart|dashboard|detailed.*analysis|visual/i,
      'signals': /signals.*chart|trading.*view|technical.*analysis/i,
      'portfolio': /portfolio.*breakdown|detailed.*holdings|allocation.*chart/i
    };
    
    for (const [service, pattern] of Object.entries(patterns)) {
      if (pattern.test(message)) {
        return { requiresUI: true, service };
      }
    }
    
    return { requiresUI: false, service: 'voice' };
  };
  
  return (
    <div className="enhanced-aria">
      {viewMode === 'api' ? (
        <StandardChatInterface onMessage={intelligentResponse} />
      ) : (
        <div className="frontend-view">
          <div className="frontend-header">
            <button onClick={() => setViewMode('api')}>← Back to Chat</button>
            <h3>📊 {activeService.toUpperCase()} Interface</h3>
          </div>
          
          <iframe 
            src={getFrontendUrl(activeService)}
            width="100%" 
            height="500px"
            allow="microphone; camera"
          />
        </div>
      )}
    </div>
  );
};

const getFrontendUrl = (service: string) => {
  const urls = {
    analytics: `https://analytics.replit.app?userId=${user.id}&token=${token}&mode=embedded`,
    signals: `https://signals.replit.app?userId=${user.id}&token=${token}&mode=widget`,
    portfolio: `https://portfolio.replit.app?userId=${user.id}&token=${token}&mode=dashboard`
  };
  return urls[service];
};
```

### Option 4: Micro-Frontend Architecture

```javascript
// Load frontend components dynamically based on need
const MicroFrontendLoader = () => {
  const [loadedComponents, setLoadedComponents] = useState<Map<string, any>>(new Map());
  
  const loadMicroFrontend = async (serviceName: string, mountPoint: string) => {
    if (loadedComponents.has(serviceName)) {
      return loadedComponents.get(serviceName);
    }
    
    // Dynamically load frontend component from microservice
    const componentUrl = `https://${serviceName}.replit.app/component.js`;
    
    try {
      // Load the component script
      const script = document.createElement('script');
      script.src = componentUrl;
      script.onload = () => {
        // Mount the component
        window[`${serviceName}Component`].mount(mountPoint, {
          userId: user.id,
          token: token,
          theme: 'zerodha-dark'
        });
      };
      document.head.appendChild(script);
      
      setLoadedComponents(prev => new Map(prev.set(serviceName, true)));
    } catch (error) {
      console.error(`Failed to load ${serviceName} frontend:`, error);
      // Fallback to API mode
      return false;
    }
  };
  
  return { loadMicroFrontend };
};
```

## 🔄 Updated Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                 ZERODHA MAIN APP                            │
│                                                             │
│  ┌─────────────────┐    ┌─────────────────┐               │
│  │   Smart ARIA    │    │  Micro-Frontend │               │
│  │   Component     │    │  Loader         │               │
│  │                 │    │                 │               │
│  │  API Mode ←→    │    │  Frontend Mode  │               │
│  │  Frontend Mode  │    │  (iframes/      │               │
│  │                 │    │   components)   │               │
│  └─────────────────┘    └─────────────────┘               │
└─────────────────────────────────────────────────────────────┘
            │                           │
            ▼                           ▼
┌─────────────────┐              ┌─────────────────┐
│  API Endpoints  │              │  Frontend UIs   │
│  (Backend only) │              │  (Full UI)      │
└─────────────────┘              └─────────────────┘
```

## 🎯 Benefits

✅ **Team Independence** - Each developer works on their own Replit app  
✅ **Scalability** - Services scale independently  
✅ **Maintainability** - Easy to update individual services  
✅ **User Experience** - Single beautiful interface  
✅ **Security** - Centralized authentication  
✅ **Performance** - Optimized API calls  
✅ **Flexibility** - Can use API or Frontend based on need  
✅ **Rich UI** - Complex visualizations when needed  
✅ **Seamless UX** - Intelligent switching between modes  

This architecture provides a production-ready foundation that can evolve with your needs while keeping development simple and team-friendly.
