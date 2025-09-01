# 🎙️ Complete Replit Integration Prompt

**Copy this entire prompt and paste it into Replit AI in your Zerodha app:**

---

⚠️ CRITICAL: SAFE IMPLEMENTATION REQUIRED

IMPORTANT: I need a PHASED IMPLEMENTATION PLAN and TODO LIST first. Do NOT start coding immediately.

SAFETY REQUIREMENTS:
- Analyze existing Zerodha codebase thoroughly before any changes
- Create detailed implementation plan without disturbing working components  
- Implement in isolated phases to prevent breaking existing functionality
- Provide rollback strategy for each phase

## Task: Import OpenAI Realtime Voice Agent into Zerodha App

I need you to create a new folder called `openairealtime` in my existing Zerodha Replit app and import the complete voice trading agent from this GitHub repository: https://github.com/sudhirig/openai-realtime-agents

### Folder Structure to Create:
```
zerodha-app/
├── existing-zerodha-files/    # Keep unchanged
└── openairealtime/            # NEW FOLDER - Create this
    ├── src/
    │   └── app/
    │       ├── components/
    │       ├── hooks/
    │       ├── api/
    │       ├── agentConfigs/
    │       └── lib/
    ├── package.json
    ├── .env.example
    ├── .replit
    ├── replit.nix
    └── README.md
```

### What to Import:
- Clone/download ALL files from: https://github.com/sudhirig/openai-realtime-agents
- Place everything inside the `openairealtime/` folder
- Preserve exact folder structure from repository
- Do NOT modify any existing Zerodha files

## 🎯 FIRST STEP: PLANNING ONLY

Before any implementation, create a detailed planning document:

### 1. Analyze existing Zerodha codebase:
- Review current file structure and architecture
- Identify existing components that might conflict
- Check current dependencies and potential conflicts
- Analyze database schema and API endpoints
- Review authentication and session management
- Check React/Next.js versions and compatibility

### 2. Create detailed implementation plan:
- Phase-by-phase implementation strategy (5 phases minimum)
- Code-level analysis of integration points
- Potential error scenarios and prevention
- Rollback procedures for each phase
- Testing strategy for each component
- Context provider integration strategy

### 3. Generate comprehensive TODO list:
- Detailed tasks for each implementation phase
- Dependencies between tasks
- Risk assessment for each task (LOW/MEDIUM/HIGH)
- Estimated time and complexity
- Success criteria for each phase

## OUTPUT REQUIRED: 
Create a detailed markdown document called `ZERODHA_VOICE_INTEGRATION_PLAN.md` with:
- Complete codebase analysis
- Line-by-line integration plan
- Safety measures and rollback strategies
- Phased implementation roadmap
- Comprehensive TODO list with risk levels

**DO NOT START CODING** until this planning document is complete and reviewed.

## 📁 Key Repository Files to Reference:

**Main Documentation:**
- ZERODHA_VOICE_INTEGRATION_COMPLETE.md - Complete integration guide
- README.md - Project overview and setup instructions

**Core Voice Components:**
- src/app/App.tsx - Main voice agent orchestrator (573 lines)
- src/app/hooks/useRealtimeSession.ts - Core voice session logic (246 lines)
- src/app/components/Transcript.tsx - Chat UI component (240 lines)
- src/app/components/BottomToolbar.tsx - Voice controls (158 lines)
- src/app/contexts/TranscriptContext.tsx - Chat state management (136 lines)
- src/app/contexts/EventContext.tsx - Event logging

**API Integration:**
- src/app/api/session/route.ts - OpenAI API integration
- src/app/api/health/route.ts - Health checks

**Configuration:**
- .replit & replit.nix - Replit configuration files
- package.json - Dependencies and scripts
- src/app/types.ts - TypeScript interfaces (149 lines)

**Agent Configuration:**
- src/app/agentConfigs/customRealtime.ts - Trading agent config
- src/app/agentConfigs/guardrails.ts - Safety rules

## 🤖 Models & Technology:

**AI Models:**
- Primary: `gpt-realtime` - OpenAI's latest realtime voice model (Aug 2025)
- Transcription: `whisper-1` - Speech-to-text processing
- Voice: Alloy with 0.8 temperature for natural conversations
- Audio: Opus (48 kHz) with PCMU/PCMA (8 kHz) fallback for phone integration

**Core Dependencies to Install:**
```json
{
  "@openai/agents": "^0.0.5",    // OpenAI Realtime SDK
  "openai": "^4.77.3",           // OpenAI API client  
  "uuid": "^11.0.4",             // Session management
  "zod": "^3.24.1"               // Schema validation
}
```

**Framework Requirements:**
- Next.js 15+ (app router)
- React 18+ or 19
- TypeScript support
- WebRTC audio support

## 🔑 Environment Configuration:

**Required Environment Variables:**
```bash
OPENAI_API_KEY=your_openai_api_key_here
```
*Add this to Replit Secrets tab*

## 🎙️ Voice Trading Features:

**Supported Commands:**
- English: "Buy 100 shares of Reliance at market price"
- Hindi: "रिलायंस के 100 शेयर मार्केट प्राइस पर खरीदें"
- Tamil: "ரிலையன்ஸ் 100 பங்குகளை சந்தை விலையில் வாங்கவும்"
- Telugu: "రిలయన్స్ 100 షేర్లను మార్కెట్ ప్రైస్‌లో కొనండి"

**Portfolio Management:**
- "मेरा पोर्टफोलियो दिखाओ" (Show my portfolio)
- "आज का P&L क्या है?" (What's today's P&L?)
- "Stop loss लगाओ 500 पर" (Set stop loss at 500)

## 🛡️ Safety Features:
- Voice confirmation required for all trades
- Position limits and risk management
- Session timeouts and authentication
- Audit trail for all voice commands
- Built-in guardrails and content moderation

## 📖 Additional Resources:
- Browse complete repository: https://github.com/sudhirig/openai-realtime-agents/tree/main
- Review existing Replit configuration in .replit file
- Check component interfaces in src/app/types.ts
- Reference integration guide in ZERODHA_VOICE_INTEGRATION_COMPLETE.md

## 🚨 Critical Integration Issues to Address:

**Known Issues (document solutions in your plan):**
1. Component interface mismatches in ARIAVoiceChat.tsx
2. Missing 'session' return value in useRealtimeSession hook
3. Context provider dependencies (TranscriptProvider, EventProvider)
4. API route dependencies (/api/session endpoint)
5. TypeScript interface alignments

**Repository URL:** https://github.com/sudhirig/openai-realtime-agents

Start with creating the comprehensive planning document first. Do not begin any coding or file creation until the plan is complete and approved.
