# 🚀 Replit Deployment Guide - OpenAI Realtime Agents

**Deploy your voice AI application on Replit with this comprehensive guide**

---

## 🎯 Overview

This guide will help you deploy the OpenAI Realtime Agents application on Replit for cloud-based access with real-time voice capabilities.

### **What You'll Deploy**
- Next.js 15.3.3 application with voice AI capabilities
- OpenAI Realtime API integration with gpt-realtime model
- WebRTC audio streaming for low-latency communication
- Multi-language support (Hindi, English, Tamil, Telugu, Bengali)
- Agent orchestration with handoffs and tool execution

---

## 🚀 Quick Deploy Steps

### **Method 1: Direct GitHub Import (Recommended)**

1. **Create New Replit Project:**
   ```
   1. Go to https://replit.com
   2. Click "Create Repl"
   3. Select "Import from GitHub"
   4. Enter: https://github.com/sudhirig/openai-realtime-agents
   5. Choose "Node.js" as template
   ```

2. **Configure Environment:**
   - Go to Replit Secrets (🔒 icon in sidebar)
   - Add: `OPENAI_API_KEY` = `your_openai_api_key_here`

3. **Deploy:**
   - Click "Run" button or use `./startup.sh`
   - Enhanced startup includes health checks and auto-recovery
   - Application will start on assigned Replit URL
   - Test voice functionality in browser

---

## 🔧 Manual Setup (Alternative)

### **Step 1: Create Replit Project**
```bash
# In Replit Shell
git clone https://github.com/sudhirig/openai-realtime-agents.git
cd openai-realtime-agents
npm install
```

### **Step 2: Configure Replit Files**

**Create `.replit` file:**
```toml
run = "npm run dev"
entrypoint = "src/app/page.tsx"

[nix]
channel = "stable-23_11"

[deployment]
run = ["sh", "-c", "npm run build && npm run start"]

[env]
PATH = "/home/runner/$REPL_SLUG/.config/npm/node_global/bin:/home/runner/$REPL_SLUG/node_modules/.bin"
XDG_CONFIG_HOME = "/home/runner/$REPL_SLUG/.config"
npm_config_prefix = "/home/runner/$REPL_SLUG/.config/npm/node_global"

[[ports]]
localPort = 3000
externalPort = 80
```

**Create `replit.nix` file:**
```nix
{ pkgs }: {
  deps = [
    pkgs.nodejs-18_x
    pkgs.nodePackages.npm
    pkgs.nodePackages.typescript
  ];
  env = {
    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [];
  };
}
```

### **Step 3: Environment Configuration**
1. Open Secrets tab (🔒) in Replit sidebar
2. Add environment variables:
   - `OPENAI_API_KEY`: Your OpenAI API key

### **Step 4: Deploy**
```bash
# Build and start
npm run build
npm run start
```

---

## ⚙️ Configuration Details

### **Package.json Scripts**
The application uses these key scripts:
```json
{
  "scripts": {
    "dev": "next dev",
    "build": "next build", 
    "start": "next start",
    "replit:dev": "npm run dev"
  }
}
```

### **Dependencies Required**
```json
{
  "@openai/agents": "^0.0.5",
  "openai": "^4.77.3",
  "next": "15.3.3",
  "react": "^18.3.1",
  "typescript": "^5",
  "uuid": "^11.0.4",
  "zod": "^3.24.1"
}
```

### **Voice AI Configuration**
- **Model:** gpt-realtime (OpenAI's latest voice model)
- **Voice:** Alloy with 0.8 temperature
- **Audio:** Opus 48kHz with PCMU/PCMA 8kHz fallback
- **Turn Detection:** Server VAD (threshold 0.5, 300ms prefix, 500ms silence)

---

## 🔍 Testing Your Deployment

### **Verification Steps**
1. **Access Application:**
   ```
   https://your-repl-name.username.repl.co
   ```

2. **Test API Endpoints:**
   ```bash
   # Health check
   curl https://your-repl-name.username.repl.co/api/health
   
   # Session endpoint
   curl https://your-repl-name.username.repl.co/api/session
   ```

3. **Voice Functionality:**
   - Allow microphone permissions in browser
   - Click "Connect" button
   - Speak and verify real-time response
   - Test agent scenarios from dropdown

---

## 🚨 Troubleshooting

### **Common Issues**

**1. Environment Variable Not Found**
```bash
# Check if OPENAI_API_KEY is set
echo $OPENAI_API_KEY

# Solution: Add to Replit Secrets, restart application
```

**2. Microphone Not Working**
- Ensure HTTPS is enabled (Replit provides this automatically)
- Check browser permissions for microphone access
- Try different browsers (Chrome recommended)

**3. Build Errors**
```bash
# Clear cache and rebuild
rm -rf .next node_modules
npm install
npm run build
```

**4. Port Issues**
- Replit auto-assigns ports, no manual configuration needed
- If port conflicts, restart the Repl

### **Performance Optimization**
- Use Replit Autoscale Deployment for production
- Enable Always On for 24/7 availability
- Monitor resource usage in Replit dashboard

---

## 🌐 Production Deployment

### **Replit Autoscale Setup**
1. **Upgrade to Replit Core plan**
2. **Enable Autoscale Deployment:**
   ```
   1. Go to Deployments tab
   2. Click "Create Deployment"
   3. Select "Autoscale"
   4. Configure scaling settings
   ```

3. **Custom Domain (Optional):**
   - Add your custom domain in deployment settings
   - Configure DNS to point to Replit

### **Monitoring & Logs**
- Access logs via Replit Console
- Monitor performance in Deployments tab
- Set up alerts for downtime

---

## 💡 Advanced Features

### **Voice Trading Integration**
If integrating with Zerodha or other trading platforms:
1. Add trading API credentials to Secrets
2. Implement order confirmation dialogs
3. Add position size limits and risk controls
4. Enable audit logging for compliance

### **Multi-Agent Scenarios**
The application supports multiple agent patterns:
- **Chat Supervisor:** Hybrid realtime + GPT-4 for complex tasks
- **Sequential Handoffs:** Specialized agents for different domains
- **Custom Agents:** Create your own agent configurations

### **Security Best Practices**
- Rotate API keys regularly
- Use Replit Secrets for all sensitive data
- Enable HTTPS only (automatic on Replit)
- Implement rate limiting for production use

---

## 📞 Support

### **Resources**
- **GitHub Repository:** https://github.com/sudhirig/openai-realtime-agents
- **OpenAI Documentation:** https://platform.openai.com/docs/guides/realtime
- **Replit Docs:** https://docs.replit.com/

### **Common Commands**
```bash
# Development
npm run dev

# Production build
npm run build && npm start

# View logs
tail -f ~/.pm2/logs/

# Restart application
npm run replit:dev
```

---

**🎉 Your OpenAI Realtime Agents application is now ready for deployment on Replit!**

For detailed integration with trading platforms or custom configurations, refer to the archived planning documents in `docs/archive/`.
