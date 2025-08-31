import { NextResponse } from "next/server";

export async function GET() {
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
          instructions: "You are a test agent for exploring MCP (Model Context Protocol) capabilities. You have access to external tools and data sources through MCP servers. Be helpful in demonstrating MCP functionality while staying focused on the test scenario. Explain what tools you're using and what data you're accessing.",
          voice: "alloy",
          temperature: 0.8,
          max_response_output_tokens: 4096,
          turn_detection: {
            type: "server_vad",
            threshold: 0.5,
            prefix_padding_ms: 300,
            silence_duration_ms: 500
          },
          input_audio_transcription: {
            model: "whisper-1"
          },
          tools: [
            {
              type: "mcp",
              server_label: "time",
              server_url: "https://mcp-time-server.example.com",
              require_approval: "never"
            }
          ]
        }),
      }
    );
    const data = await response.json();
    return NextResponse.json(data);
  } catch (error) {
    console.error("Error in /session-mcp:", error);
    return NextResponse.json(
      { error: "Internal Server Error" },
      { status: 500 }
    );
  }
}
