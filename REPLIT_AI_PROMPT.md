# 🤖 Replit AI Deployment Prompt

**Copy and paste this complete prompt into Replit AI to deploy OpenAI Realtime Agents**

---

## 📋 REPLIT AI PROMPT (Copy-Paste Ready)

```
🚀 DEPLOY OPENAI REALTIME AGENTS APPLICATION

I need to deploy the OpenAI Realtime Agents voice AI application in this Replit environment.

GITHUB REPOSITORY: https://github.com/sudhirig/openai-realtime-agents

TASK: Set up complete Next.js voice AI application with the following features:
- Real-time voice interaction using OpenAI gpt-realtime model
- WebRTC audio streaming for low-latency communication
- Multi-language support (Hindi, English, Tamil, Telugu, Bengali)
- Agent orchestration with handoffs and tool execution
- Voice activity detection and transcription

DEPLOYMENT REQUIREMENTS:

1. IMPORT PROJECT:
   - Clone from GitHub repository above
   - Set up as Next.js project with TypeScript
   - Install all required dependencies

2. REQUIRED DEPENDENCIES:
   - @openai/agents: ^0.0.5
   - openai: ^4.77.3
   - next: 15.3.3
   - react: ^18.3.1
   - typescript: ^5
   - uuid: ^11.0.4
   - zod: ^3.24.1

3. ENVIRONMENT SETUP:
   - Configure OPENAI_API_KEY in Replit Secrets
   - Set up .replit configuration file
   - Configure replit.nix for Node.js environment
   - Set up proper port configuration

4. FILE STRUCTURE TO MAINTAIN:
   src/app/
   ├── App.tsx (main orchestrator)
   ├── components/ (UI components)
   ├── hooks/ (custom React hooks)
   ├── contexts/ (React contexts)
   ├── api/ (Next.js API routes)
   ├── agentConfigs/ (AI agent configurations)
   └── types.ts (TypeScript definitions)

5. KEY CONFIGURATIONS:
   - Voice AI using gpt-realtime model
   - Alloy voice with 0.8 temperature
   - Server VAD turn detection (0.5 threshold, 300ms prefix, 500ms silence)
   - Whisper-1 transcription model
   - Opus audio codec (48kHz) with PCMU/PCMA fallback

6. REPLIT-SPECIFIC SETUP:
   - Create .replit file with proper run commands
   - Set up replit.nix with Node.js dependencies
   - Configure port mapping for web access
   - Enable HTTPS for microphone access

7. TESTING REQUIREMENTS:
   - Verify API endpoints (/api/health, /api/session)
   - Test voice functionality with microphone permissions
   - Validate agent scenario switching
   - Check real-time audio streaming

IMPORTANT NOTES:
- This is a production-ready voice AI application
- Requires valid OpenAI API key with Realtime API access
- Uses WebRTC for real-time audio communication
- Supports multiple agent patterns (Chat Supervisor, Sequential Handoffs)
- Includes built-in guardrails and content moderation

EXPECTED OUTCOME:
- Fully functional voice AI application accessible via Replit URL
- Real-time voice interaction with AI agents
- Multi-language voice command support
- Agent orchestration and tool execution capabilities

Please proceed with the deployment setup. I have the OpenAI API key ready to add to Secrets.
```

---

## 🎯 How to Use This Prompt

### **Step 1: Copy the Prompt**
- Select and copy the entire prompt above (between the triple backticks)

### **Step 2: Open Replit AI**
1. Go to https://replit.com
2. Create a new Repl or open existing one
3. Click the AI assistant icon
4. Paste the complete prompt

### **Step 3: Follow AI Instructions**
- The AI will guide you through the setup process
- Add your `OPENAI_API_KEY` when prompted
- Follow any additional configuration steps

### **Step 4: Verify Deployment**
- Test the application URL provided by Replit
- Allow microphone permissions
- Test voice functionality

---

## 🔧 Manual Steps (If Needed)

If Replit AI needs assistance with specific configurations:

### **Environment Variables**
```bash
# Add to Replit Secrets:
OPENAI_API_KEY=your_openai_api_key_here
```

### **.replit Configuration**
```toml
run = "npm run dev"
entrypoint = "src/app/page.tsx"

[nix]
channel = "stable-23_11"

[deployment]
run = ["sh", "-c", "npm run build && npm run start"]

[[ports]]
localPort = 3000
externalPort = 80
```

### **replit.nix Configuration**
```nix
{ pkgs }: {
  deps = [
    pkgs.nodejs-18_x
    pkgs.nodePackages.npm
    pkgs.nodePackages.typescript
  ];
}
```

---

## ✅ Success Indicators

Your deployment is successful when:
- [ ] Application loads at Replit URL
- [ ] API health check returns 200 OK
- [ ] Session endpoint returns ephemeral token
- [ ] Microphone permissions granted
- [ ] Voice interaction works in real-time
- [ ] Agent scenarios can be switched
- [ ] Audio transcription displays correctly

---

**🎉 Your OpenAI Realtime Agents application will be ready for voice interaction!**
