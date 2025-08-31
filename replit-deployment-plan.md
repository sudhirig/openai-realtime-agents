# Zerodha Voice Trading Agent - Replit Deployment Plan

## 🎯 Objective
Deploy the Zerodha voice trading agent on Replit for scalable, cloud-based access with real-time trading capabilities using direct Kite Connect API integration.

## 🏗️ Replit Architecture

### **Deployment Configuration**
- **Platform**: Replit Autoscale Deployment
- **Runtime**: Node.js 18+ with Next.js 15
- **Resources**: 1vCPU, 2 GiB RAM (scalable to 3 machines)
- **WebSocket Support**: Native Replit WebSocket handling
- **API Integration**: Direct Kite Connect API + external financial APIs

### **Project Structure**
```
zerodha-trading-agent/
├── .replit                 # Replit configuration
├── replit.nix             # Nix environment setup
├── package.json           # Dependencies
├── next.config.js         # Next.js config with WebSocket
├── src/
│   ├── app/
│   │   ├── api/
│   │   │   ├── session/           # OpenAI Realtime sessions
│   │   │   ├── kite/              # Zerodha Kite Connect APIs
│   │   │   ├── trading/           # Trading operations
│   │   │   ├── portfolio/         # Portfolio management
│   │   │   ├── market-data/       # Market data APIs
│   │   │   └── websocket/         # WebSocket handlers
│   │   ├── components/
│   │   │   ├── TradingAgent.tsx   # Main voice interface
│   │   │   ├── Portfolio.tsx     # Portfolio display
│   │   │   └── OrderForm.tsx     # Order confirmation
│   │   └── hooks/
│   │       ├── useRealtimeSession.ts
│   │       ├── useKiteConnect.ts
│   │       └── useTradingAPI.ts
└── lib/
    ├── kite-client.js     # Kite Connect client
    ├── risk-manager.js    # Risk management logic
    └── market-data.js     # Market data handlers
```

## 🔧 Technical Implementation

### **1. Replit Configuration Files**

#### `.replit`
```toml
run = "npm run dev"
entrypoint = "src/app/page.tsx"

[deployment]
run = ["npm", "run", "start"]
build = ["npm", "run", "build"]

[env]
NODE_ENV = "production"

[nix]
channel = "stable-22_11"

[languages.typescript]
pattern = "**/{*.ts,*.js,*.tsx,*.jsx}"

[languages.typescript.languageServer]
start = "typescript-language-server --stdio"
```

#### `replit.nix`
```nix
{ pkgs }: {
  deps = [
    pkgs.nodejs-18_x
    pkgs.nodePackages.npm
    pkgs.nodePackages.typescript
  ];
}
```

### **2. Environment Variables (Replit Secrets)**
```
# OpenAI Configuration
OPENAI_API_KEY=sk-...

# Zerodha Kite Connect
KITE_API_KEY=your_kite_api_key
KITE_API_SECRET=your_kite_api_secret
KITE_REDIRECT_URL=https://your-repl-name.replit.app/api/kite/callback

# External APIs (Optional)
ALPHA_VANTAGE_KEY=your_alpha_vantage_key
FINANCIAL_DATASETS_KEY=your_financial_datasets_key

# Security
JWT_SECRET=your_jwt_secret
ENCRYPTION_KEY=your_encryption_key

# Database (if needed)
DATABASE_URL=your_database_url
```

### **3. Next.js Configuration for Replit**
```javascript
// next.config.js
/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
    serverComponentsExternalPackages: ['kiteconnect']
  },
  env: {
    CUSTOM_KEY: process.env.CUSTOM_KEY,
  },
  // Enable WebSocket support
  async rewrites() {
    return [
      {
        source: '/api/ws/:path*',
        destination: '/api/websocket/:path*',
      },
    ]
  },
  // Replit-specific optimizations
  output: 'standalone',
  compress: true,
  poweredByHeader: false,
}

module.exports = nextConfig
```

### **4. Kite Connect API Integration**

#### Direct API Client Setup
```javascript
// lib/kite-client.js
import { KiteConnect } from 'kiteconnect';

class KiteClient {
  constructor() {
    this.kc = new KiteConnect({
      api_key: process.env.KITE_API_KEY,
      debug: false
    });
  }

  async authenticate(requestToken) {
    try {
      const data = await this.kc.generateSession(
        requestToken,
        process.env.KITE_API_SECRET
      );
      this.kc.setAccessToken(data.access_token);
      return data;
    } catch (error) {
      throw new Error(`Authentication failed: ${error.message}`);
    }
  }

  async getPortfolio() {
    try {
      const holdings = await this.kc.getHoldings();
      const positions = await this.kc.getPositions();
      return { holdings, positions };
    } catch (error) {
      throw new Error(`Portfolio fetch failed: ${error.message}`);
    }
  }

  async placeOrder(orderParams) {
    try {
      // Risk checks before placing order
      await this.performRiskChecks(orderParams);
      
      const order = await this.kc.placeOrder(
        orderParams.variety || 'regular',
        {
          tradingsymbol: orderParams.symbol,
          quantity: orderParams.quantity,
          order_type: orderParams.order_type,
          transaction_type: orderParams.transaction_type,
          price: orderParams.price,
          exchange: orderParams.exchange || 'NSE'
        }
      );
      return order;
    } catch (error) {
      throw new Error(`Order placement failed: ${error.message}`);
    }
  }

  async getMarketData(symbols) {
    try {
      const quotes = await this.kc.getQuote(symbols);
      return quotes;
    } catch (error) {
      throw new Error(`Market data fetch failed: ${error.message}`);
    }
  }

  async performRiskChecks(orderParams) {
    // Implement risk management logic
    const margins = await this.kc.getMargins();
    // Add position size checks, margin checks, etc.
    return true;
  }
}

export default KiteClient;
```

### **5. Voice Agent Configuration for Replit**
```javascript
// src/app/api/session/route.ts
export async function POST() {
  try {
    const response = await fetch(
      "https://api.openai.com/v1/realtime/sessions",
      {
        method: "POST",
        headers: {
          Authorization: `Bearer ${process.env.OPENAI_API_KEY}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          model: "gpt-realtime",
          instructions: `You are a professional trading assistant for Indian stock markets deployed on Replit. 
          You can help with portfolio analysis, market research, and trading operations through Zerodha Kite Connect API.
          Always confirm high-risk actions before execution. Support Hindi, Tamil, Telugu, and Bengali languages.
          You have access to real-time market data, portfolio information, and trading capabilities through function calls.`,
          voice: "alloy",
          temperature: 0.3,
          max_response_output_tokens: 4096,
          turn_detection: {
            type: "server_vad",
            threshold: 0.6,
            prefix_padding_ms: 300,
            silence_duration_ms: 500
          },
          input_audio_transcription: {
            model: "whisper-1"
          },
          tools: [
            {
              type: "function",
              function: {
                name: "get_portfolio",
                description: "Get user's portfolio holdings and P&L from Zerodha",
                parameters: {
                  type: "object",
                  properties: {},
                  required: []
                }
              }
            },
            {
              type: "function",
              function: {
                name: "place_order",
                description: "Place buy/sell order with risk checks",
                parameters: {
                  type: "object",
                  properties: {
                    symbol: { type: "string", description: "Trading symbol" },
                    quantity: { type: "number", description: "Order quantity" },
                    order_type: { type: "string", enum: ["MARKET", "LIMIT"] },
                    transaction_type: { type: "string", enum: ["BUY", "SELL"] },
                    price: { type: "number", description: "Price for limit orders" }
                  },
                  required: ["symbol", "quantity", "order_type", "transaction_type"]
                }
              }
            },
            {
              type: "function",
              function: {
                name: "get_market_data",
                description: "Get real-time market data for stocks",
                parameters: {
                  type: "object",
                  properties: {
                    symbols: {
                      type: "array",
                      items: { type: "string" },
                      description: "Array of stock symbols"
                    }
                  },
                  required: ["symbols"]
                }
              }
            },
            {
              type: "function",
              function: {
                name: "get_margins",
                description: "Get account margins and available funds",
                parameters: {
                  type: "object",
                  properties: {},
                  required: []
                }
              }
            }
          ]
        }),
      }
    );
    const data = await response.json();
    return NextResponse.json(data);
  } catch (error) {
    console.error("Error in /session:", error);
    return NextResponse.json(
      { error: "Internal Server Error" },
      { status: 500 }
    );
  }
}
```

## 🚀 Deployment Process

### **Phase 1: Setup & Configuration**
1. **Fork Next.js template** on Replit
2. **Configure secrets** in Replit Secrets Manager
3. **Set up Kite Connect** developer account
4. **Install dependencies** and configure MCP servers

### **Phase 2: API Integration**
1. **Set up Kite Connect client** with authentication
2. **Create API routes** for trading operations
3. **Implement function calling** for voice agent
4. **Configure risk management** logic

### **Phase 3: Voice Agent Deployment**
1. **Configure Realtime API** with function calling
2. **Test voice recognition** in vernacular languages
3. **Deploy to Replit Autoscale** with WebSocket support
4. **Set up custom domain** (optional)

### **Phase 4: Production Optimization**
1. **Enable autoscaling** for high traffic
2. **Configure monitoring** and logging
3. **Set up backup systems** and failover
4. **Implement compliance** features

## 🛡️ Security & Compliance

### **Replit Security Features**
- **Secrets Management** - Encrypted environment variables
- **HTTPS by default** - All traffic encrypted
- **Isolated environments** - Secure container deployment
- **Access controls** - Team collaboration with permissions

### **Trading Security**
- **OAuth 2.0** for Kite Connect authentication
- **JWT tokens** for session management
- **Risk management** via dedicated MCP server
- **Audit logging** for all trading operations
- **Rate limiting** to prevent abuse

## 📊 Monitoring & Analytics

### **Replit Built-in Monitoring**
- **Resource usage** tracking
- **Performance metrics** dashboard
- **Error logging** and alerts
- **Uptime monitoring**

### **Custom Analytics**
- **Trading activity** logs
- **Voice command** success rates
- **MCP server** performance metrics
- **User engagement** analytics

## 🔄 Scaling & Performance

### **Autoscale Configuration**
```javascript
// Replit Deployment Settings
{
  "machine": "1vCPU, 2 GiB RAM",
  "maxMachines": 5,
  "minMachines": 1,
  "buildCommand": "npm run build",
  "runCommand": "npm run start",
  "environment": "production"
}
```

### **Performance Optimizations**
- **WebSocket connection pooling**
- **MCP server caching**
- **Database connection optimization**
- **CDN for static assets**

## 💰 Cost Estimation

### **Replit Costs**
- **Autoscale Deployment**: $20/month per machine
- **Custom Domain**: $5/month (optional)
- **Additional storage**: $1/GB/month

### **External Services**
- **OpenAI Realtime API**: Usage-based pricing
- **Zerodha Kite Connect**: ₹2000/month
- **Alpha Vantage API**: $49.99/month (optional)

**Total Estimated Cost**: $70-120/month for production deployment

## 🎯 Success Metrics

- **Deployment uptime**: >99.9%
- **Voice recognition accuracy**: >95%
- **Trading order execution**: <2 seconds
- **MCP server response time**: <500ms
- **Concurrent users**: 100+ supported
- **Language support**: 4+ Indian languages

## 🔧 Maintenance & Updates

### **Automated Updates**
- **Dependency updates** via Replit
- **MCP server updates** through CI/CD
- **Security patches** automatic deployment
- **Performance monitoring** alerts

### **Manual Maintenance**
- **Trading strategy** updates
- **Risk parameter** adjustments
- **New language** additions
- **Feature enhancements**

This comprehensive plan enables full deployment of the Zerodha voice trading agent on Replit with MCP integration, providing scalable, secure, and feature-rich trading capabilities accessible from anywhere.
