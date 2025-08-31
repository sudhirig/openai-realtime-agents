# 🚀 Replit Deployment Instructions

## Quick Setup for Zerodha Voice Trading Agent

### 1. Fork to Replit
1. Go to [Replit](https://replit.com)
2. Create new Repl → Import from GitHub
3. Use this repository URL
4. Select "Node.js" as template

### 2. Configure Secrets
Go to **Secrets** tab in Replit and add:

```
OPENAI_API_KEY=sk-your-openai-key
```

**Note**: This project currently uses the existing OpenAI Realtime Agents demo. To add Zerodha trading functionality, you'll need to:
1. Add Kite Connect API credentials
2. Create trading API routes in `src/app/api/`
3. Implement Kite Connect integration

### 3. Run Setup
In Replit Shell, run:
```bash
./startup.sh
```

### 4. Deploy
1. Click **Deploy** button
2. Choose **Autoscale Deployment**
3. Configure:
   - Build: `npm run build`
   - Run: `npm run start`
   - Machine: 1vCPU, 2GB RAM

## 🎯 Current Features

- ✅ **OpenAI Realtime Voice Agent** - Working voice interaction
- ✅ **Multiple Agent Scenarios** - Simple handoff, customer service, chat supervisor, custom realtime
- ✅ **WebRTC Audio** - Real-time voice communication
- ✅ **Agent Handoffs** - Seamless transitions between agents
- ✅ **Guardrails** - Content moderation

## 🚧 Planned Features (Not Yet Implemented)

- 🔄 **Voice Trading** - Hindi, Tamil, Telugu, Bengali support
- 🔄 **Real-time Market Data** - Live stock prices via Kite Connect
- 🔄 **Portfolio Management** - Holdings and P&L
- 🔄 **Order Execution** - Buy/sell with risk checks

## 🔧 Troubleshooting

**Build Errors?**
- Check all secrets are set correctly
- Ensure Kite Connect API keys are valid

**Voice Not Working?**
- Allow microphone permissions in browser
- Check HTTPS connection (required for WebRTC)

**Trading Errors?**
- Verify Kite Connect account is active
- Check API rate limits

## 📞 Support

- Check console logs for errors
- Verify environment variables in Secrets
- Test with paper trading first

Ready to trade with voice commands! 🎙️📈
