import { RealtimeAgent } from '@openai/agents/realtime';

// Safe MCP test agent - separate from main implementation
export const mcpTestAgent = new RealtimeAgent({
  name: 'mcpTest',
  voice: 'alloy',
  
  instructions: `You are a test agent for exploring MCP (Model Context Protocol) capabilities.
You have access to external tools and data sources through MCP servers.
Be helpful in demonstrating MCP functionality while staying focused on the test scenario.
Explain what tools you're using and what data you're accessing.`,

  handoffs: [],
  tools: [], // MCP tools will be added dynamically by the server
  handoffDescription: 'Test agent for safely exploring MCP server integrations',
});

export const mcpTestScenario = [mcpTestAgent];
export const mcpTestCompanyName = 'MCPTest';
