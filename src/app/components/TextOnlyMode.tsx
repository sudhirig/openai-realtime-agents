"use client";
import React, { useState } from 'react';

interface TextOnlyModeProps {
  onSendMessage: (message: string) => void;
  isConnected: boolean;
}

export default function TextOnlyMode({}: TextOnlyModeProps) {
  const [message, setMessage] = useState('');
  const [responses, setResponses] = useState<Array<{role: string, content: string}>>([]);

  const handleSend = async () => {
    if (!message.trim()) return;
    
    const userMessage = { role: 'user', content: message };
    setResponses(prev => [...prev, userMessage]);
    
    try {
      // Call the chat supervisor directly via API
      const response = await fetch('/api/responses', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          model: 'gpt-4o-mini',
          input: [
            {
              type: 'message',
              role: 'system',
              content: 'You are a helpful customer service agent for NewTelco. Be concise and helpful.'
            },
            {
              type: 'message', 
              role: 'user',
              content: message
            }
          ]
        })
      });
      
      const data = await response.json();
      const assistantContent = data.output?.find((item: any) => 
        item.type === 'message' && item.role === 'assistant'
      )?.content?.find((c: any) => c.type === 'output_text')?.text || 'No response';
      
      const assistantMessage = { role: 'assistant', content: assistantContent };
      setResponses(prev => [...prev, assistantMessage]);
    } catch (error) {
      console.error('Text mode error:', error);
      setResponses(prev => [...prev, { role: 'assistant', content: 'Error: Could not get response' }]);
    }
    
    setMessage('');
  };

  return (
    <div className="p-4 bg-yellow-50 border border-yellow-200 rounded-lg">
      <h3 className="font-semibold text-yellow-800 mb-2">Text-Only Mode (WebRTC Fallback)</h3>
      
      <div className="mb-4 max-h-60 overflow-y-auto bg-white p-3 rounded border">
        {responses.map((msg, idx) => (
          <div key={idx} className={`mb-2 ${msg.role === 'user' ? 'text-blue-600' : 'text-green-600'}`}>
            <strong>{msg.role}:</strong> {msg.content}
          </div>
        ))}
      </div>
      
      <div className="flex gap-2">
        <input
          type="text"
          value={message}
          onChange={(e) => setMessage(e.target.value)}
          onKeyPress={(e) => e.key === 'Enter' && handleSend()}
          placeholder="Type your message..."
          className="flex-1 p-2 border border-gray-300 rounded"
        />
        <button
          onClick={handleSend}
          disabled={!message.trim()}
          className="px-4 py-2 bg-blue-500 text-white rounded disabled:bg-gray-300"
        >
          Send
        </button>
      </div>
    </div>
  );
}
