# 🤖 IMPROVED REPLIT AI DEPLOYMENT PROMPT

**Copy this EXACT prompt into Replit AI for fastest deployment:**

---

## DIRECT DEPLOYMENT REQUEST

I need to deploy the OpenAI Realtime Agents voice AI application. 

**CRITICAL: Execute these commands directly, DO NOT show code blocks:**

```bash
# 1. Environment Check
echo "Checking OPENAI_API_KEY..." && [ -n "$OPENAI_API_KEY" ] && echo "✅ API Key found" || echo "❌ Add OPENAI_API_KEY to Secrets tab"

# 2. Clean Install  
rm -rf .next node_modules package-lock.json && npm install --prefer-offline --no-audit

# 3. Build Application
npm run build

# 4. Start Server
npm run start
```

**REPLIT SECRETS SETUP:**
- Add `OPENAI_API_KEY` to 🔒 Secrets tab (NOT Environment Variables)
- Use your actual OpenAI API key with Realtime API access

**VERIFICATION:**
After deployment, test: `/api/health` and `/api/session` endpoints

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
