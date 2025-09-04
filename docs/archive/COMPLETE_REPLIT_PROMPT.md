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

## Task: Integrate OpenAI Realtime Voice Agent into Zerodha Vite App

⚠️ COMPATIBILITY UPDATE: Your Zerodha app uses Vite + React 19, but the voice agent uses Next.js + React 18. We need to extract and adapt the core voice components for Vite compatibility.

### Integration Structure (NO separate folder):
```
zerodha-app/src/
├── components/
│   └── voice/                 # NEW - Voice components
│       ├── VoiceChat.tsx
│       ├── Transcript.tsx
│       ├── VoiceControls.tsx
│       └── BottomToolbar.tsx
├── hooks/
│   └── useVoiceSession.ts     # NEW - Vite-compatible voice hook
├── services/
│   └── voice-api.ts           # NEW - Direct OpenAI API service
├── types/
│   └── voice.ts               # NEW - Voice type definitions
└── contexts/
    ├── VoiceContext.tsx       # NEW - Voice state management
    └── TranscriptContext.tsx  # NEW - Chat transcript state
```

### What to Extract from Repository:
- **Core Logic:** `src/app/hooks/useRealtimeSession.ts` → Adapt for Vite
- **Components:** `src/app/components/` → Remove Next.js dependencies
- **Types:** `src/app/types.ts` → Copy type definitions
- **Agent Config:** `src/app/agentConfigs/` → Trading agent configuration
- **Skip:** Next.js API routes, .replit files, package.json (incompatible)

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

**Dependencies to Add (use YOUR existing versions):**
```json
{
  "@openai/agents": "^0.0.17",   // Use YOUR newer version (not 0.0.5)
  "openai": "^5.12.2",           // Use YOUR newer version (not 4.77.3)
  "uuid": "^11.0.4",             // ADD this missing dependency
  "zod": "^3.24.1"               // Schema validation
}
```

**Framework Compatibility:**
- ✅ Vite + React 19 (your current setup)
- ✅ TypeScript support
- ✅ WebRTC audio support
- ❌ Skip Next.js specific features (API routes, etc.)

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

## 🚨 Critical Vite Compatibility Issues to Address:

**Known Issues (document solutions in your plan):**
1. **Next.js API Routes:** Convert `/api/session` to Vite API endpoint or direct service
2. **useRealtimeSession Hook:** Remove Next.js dependencies, adapt for React 19
3. **Component Interfaces:** Update for newer OpenAI SDK versions (0.0.17 vs 0.0.5)
4. **Context Providers:** Ensure React 19 compatibility
5. **Model Compatibility:** Verify `gpt-realtime` works with OpenAI SDK 5.12.2
6. **WebRTC Audio:** Test audio streaming in Vite environment

**Repository URL:** https://github.com/sudhirig/openai-realtime-agents

Start with creating the comprehensive planning document first. Do not begin any coding or file creation until the plan is complete and approved.
